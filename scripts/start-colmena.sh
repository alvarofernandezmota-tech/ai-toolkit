#!/bin/bash
# start-colmena.sh — Arranque completo Colmena (bulletproof WSL)
# Uso: bash scripts/start-colmena.sh
# Uso (solo proxy): bash scripts/start-colmena.sh --solo-proxy
#
# Layout tmux:
#  ┌────────────────────┬─────────────────────┐
#  │                    │  LOGS LiteLLM       │
#  │    OPENCODE        ├─────────────────────┤
#  │                    │  BASH LIBRE         │
#  └────────────────────┴─────────────────────┘
#
# Navegar paneles: Ctrl+B luego flecha
# Salir sin cerrar: Ctrl+B D
# Volver: tmux attach -t colmena

set -e
DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG="$DIR/litellm-config.yaml"
PUERTO=8000
SESSION="colmena"

export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:$PATH"

# ─── Buscar litellm ──────────────────────────────────────────────────
LITELLM=""
for C in "$DIR/.venv/bin/litellm" "$HOME/projects/thdora/.venv/bin/litellm"; do
  [ -f "$C" ] && LITELLM="$C" && break
done
[ -z "$LITELLM" ] && command -v litellm &>/dev/null && LITELLM="litellm"
if [ -z "$LITELLM" ]; then
  echo "❌ No se encuentra litellm. Instala: pip install 'litellm[proxy]'"
  exit 1
fi
echo "✅ litellm: $LITELLM"

# ─── Buscar opencode ─────────────────────────────────────────────────
OPENCODE=""
for C in "$HOME/.npm-global/bin/opencode" "$HOME/.local/bin/opencode" "/usr/local/bin/opencode"; do
  [ -f "$C" ] && OPENCODE="$C" && break
done
[ -z "$OPENCODE" ] && command -v opencode &>/dev/null && OPENCODE="opencode"
if [ -z "$OPENCODE" ]; then
  echo "⚠️  opencode no encontrado — reinstalando..."
  npm install -g opencode-ai --prefix "$HOME/.npm-global"
  OPENCODE="$HOME/.npm-global/bin/opencode"
fi
echo "✅ opencode: $OPENCODE"

# ─── Limpiar puerto y procesos ───────────────────────────────────────
echo "🧹 Limpiando puerto $PUERTO..."
pkill -9 -f litellm 2>/dev/null || true
lsof -ti :$PUERTO | xargs kill -9 2>/dev/null || true
sleep 1
echo "✅ Puerto $PUERTO libre"

# ─── Modo --solo-proxy ───────────────────────────────────────────────
if [ "$1" = "--solo-proxy" ]; then
  "$LITELLM" --config "$CONFIG" --port $PUERTO 2>&1 | tee /tmp/litellm.log
  exit 0
fi

# ─── Ya dentro de tmux: solo proxy ───────────────────────────────────
if [ -n "$TMUX" ]; then
  echo "⚠️  Ya estás en tmux. Arrancando solo proxy..."
  "$LITELLM" --config "$CONFIG" --port $PUERTO 2>&1 | tee /tmp/litellm.log
  exit 0
fi

# ─── Verificar tmux instalado ────────────────────────────────────────
if ! command -v tmux &>/dev/null; then
  echo "❌ tmux no instalado: sudo apt install tmux -y"
  exit 1
fi

# ─── FIX WSL: arrancar servidor tmux explicitamente ──────────────────
tmux start-server 2>/dev/null || true
sleep 1

# ─── Matar sesión anterior si existe ─────────────────────────────────
tmux kill-session -t $SESSION 2>/dev/null || true
sleep 1

# ─── Crear sesión con reintentos (fix WSL) ───────────────────────────
INTENTO=0
SESSION_OK=false
while [ $INTENTO -lt 3 ]; do
  tmux new-session -d -s $SESSION -x 220 -y 50 2>/dev/null && SESSION_OK=true && break
  echo "⚠️  Intento $((INTENTO+1)) fallido, reintentando..."
  tmux start-server 2>/dev/null || true
  sleep 2
  INTENTO=$((INTENTO+1))
done

# ─── FALLBACK: sin tmux ──────────────────────────────────────────────
if [ "$SESSION_OK" = false ]; then
  echo ""
  echo "⚠️  tmux no disponible — modo fallback (LiteLLM background + OpenCode foreground)"
  echo "ℹ️  Logs LiteLLM en: /tmp/litellm.log"
  echo ""
  nohup "$LITELLM" --config "$CONFIG" --port $PUERTO > /tmp/litellm.log 2>&1 &
  LITELLM_PID=$!
  echo "✅ LiteLLM arrancado en background (PID $LITELLM_PID)"
  echo "👁️  Esperando LiteLLM..."
  for i in $(seq 1 20); do
    curl -s http://localhost:$PUERTO/health/liveliness &>/dev/null && echo "✅ LiteLLM listo en :$PUERTO" && break
    echo -n '.'; sleep 1
  done
  echo ""
  cd "$DIR" && "$OPENCODE"
  exit 0
fi

# ─── Configurar 3 paneles ────────────────────────────────────────────
tmux rename-window -t $SESSION:0 'colmena'

# Derecha arriba: LiteLLM logs
tmux split-window -t $SESSION:0 -h
tmux send-keys -t $SESSION:0.1 "cd $DIR && '$LITELLM' --config '$CONFIG' --port $PUERTO 2>&1 | tee /tmp/litellm.log" Enter

# Derecha abajo: bash libre + health check
tmux split-window -t $SESSION:0.1 -v
tmux send-keys -t $SESSION:0.2 "cd $DIR" Enter
tmux send-keys -t $SESSION:0.2 "echo '👁️ Esperando LiteLLM...' && for i in \$(seq 1 20); do curl -s http://localhost:$PUERTO/health/liveliness &>/dev/null && echo '✅ LiteLLM listo en :$PUERTO' && break; echo -n '.'; sleep 1; done" Enter

# Izquierda: OpenCode (espera 12s a LiteLLM)
tmux send-keys -t $SESSION:0.0 "cd $DIR && sleep 12 && '$OPENCODE'" Enter
tmux select-pane -t $SESSION:0.0

# ─── Verificar paneles activos ───────────────────────────────────────
PANELES=$(tmux list-panes -t $SESSION:0 2>/dev/null | wc -l)
echo ""
echo "✅ Sesión '$SESSION' lista con $PANELES paneles"
echo "ℹ️  Ctrl+B D para salir sin cerrar | tmux attach -t $SESSION para volver"
echo ""

tmux attach-session -t $SESSION

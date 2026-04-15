#!/bin/bash
# start-colmena.sh — Arranque completo con tmux
# Uso: bash scripts/start-colmena.sh
# Uso (solo proxy, sin tmux): bash scripts/start-colmena.sh --solo-proxy
#
# Layout tmux:
#  ┌────────────────────┬─────────────────────┐
#  │                    │  LOGS LiteLLM       │
#  │    OPENCODE        ├─────────────────────┤
#  │                    │  BASH LIBRE         │
#  └────────────────────┴─────────────────────┘
#
# Navegar entre paneles: Ctrl+B luego flecha
# Salir de tmux: Ctrl+B D, luego: tmux attach -t colmena
#
# PROBLEMA CONOCIDO: Si sale [exited] inmediatamente, es porque
# estás dentro de tmux. El script lo detecta y arranca solo el proxy.

DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG="$DIR/litellm-config.yaml"
PUERTO=8000
SESSION="colmena"

# ─── Buscar litellm (propio repo → thdora → global) ──────────────────
LITELLM=""
for CANDIDATE in \
  "$DIR/.venv/bin/litellm" \
  "$HOME/projects/thdora/.venv/bin/litellm"; do
  if [ -f "$CANDIDATE" ]; then
    LITELLM="$CANDIDATE"
    break
  fi
done
if [ -z "$LITELLM" ] && command -v litellm &>/dev/null; then
  LITELLM="litellm"
fi
if [ -z "$LITELLM" ]; then
  echo "❌ No se encuentra litellm."
  echo "   Instala con: pip install 'litellm[proxy]'"
  exit 1
fi
echo "✅ litellm encontrado: $LITELLM"

# ─── Verificar al menos una key gratuita ─────────────────────────────
if [ -z "$GOOGLE_GENERATIVE_AI_API_KEY" ] && [ -z "$GROQ_API_KEY" ] && \
   [ -z "$CEREBRAS_API_KEY" ] && [ -z "$OPENROUTER_API_KEY" ]; then
  echo "⚠️  ADVERTENCIA: No hay keys de modelos gratuitos en el entorno."
  echo "   Añade al menos una en ~/.bashrc y haz: source ~/.bashrc"
fi

# ─── Limpieza agresiva ───────────────────────────────────────────────
echo "🧹 Limpiando puerto $PUERTO y procesos litellm..."
pkill -9 -f litellm 2>/dev/null || true
lsof -ti :$PUERTO | xargs kill -9 2>/dev/null || true
sleep 2
echo "✅ Puerto $PUERTO libre"

# ─── Modo --solo-proxy ───────────────────────────────────────────────
if [ "$1" = "--solo-proxy" ]; then
  echo "✅ Arrancando LiteLLM en puerto $PUERTO..."
  "$LITELLM" --config "$CONFIG" --port $PUERTO 2>&1 | tee /tmp/litellm.log
  exit 0
fi

# ─── Detectar si ya estamos dentro de tmux ───────────────────────────
if [ -n "$TMUX" ]; then
  echo ""
  echo "⚠️  Ya estás dentro de tmux — no puedo crear sesión nueva."
  echo "   Arrancando solo el proxy (usa Ctrl+B % para abrir OpenCode en otro panel):"
  echo ""
  "$LITELLM" --config "$CONFIG" --port $PUERTO 2>&1 | tee /tmp/litellm.log
  exit 0
fi

# ─── Comprobar tmux instalado ────────────────────────────────────────
if ! command -v tmux &>/dev/null; then
  echo "❌ tmux no instalado. Ejecuta: sudo apt install tmux -y"
  exit 1
fi

# ─── Matar sesión anterior ───────────────────────────────────────────
tmux kill-session -t $SESSION 2>/dev/null || true

# ─── Crear sesión tmux ───────────────────────────────────────────────
tmux new-session -d -s $SESSION -x 220 -y 50
tmux rename-window -t $SESSION:0 'colmena'

# Panel derecha arriba: Logs LiteLLM
tmux split-window -t $SESSION:0 -h
tmux send-keys -t $SESSION:0.1 "cd $DIR && '$LITELLM' --config '$CONFIG' --port $PUERTO 2>&1 | tee /tmp/litellm.log" Enter

# Panel derecha abajo: Bash libre + health check
tmux split-window -t $SESSION:0.1 -v
tmux send-keys -t $SESSION:0.2 "cd $DIR" Enter
tmux send-keys -t $SESSION:0.2 "echo '👀 Esperando LiteLLM...' && for i in \$(seq 1 20); do curl -s http://localhost:$PUERTO/health/liveliness &>/dev/null && echo '✅ LiteLLM listo en :$PUERTO' && break; echo -n '.'; sleep 1; done" Enter

# Panel izquierdo: OpenCode (espera 10s a LiteLLM)
tmux send-keys -t $SESSION:0.0 "cd $DIR && sleep 10 && opencode" Enter
tmux select-pane -t $SESSION:0.0

# ─── Adjuntar ────────────────────────────────────────────────────────
echo "✅ Sesión '$SESSION' creada. Adjuntando..."
tmux attach-session -t $SESSION

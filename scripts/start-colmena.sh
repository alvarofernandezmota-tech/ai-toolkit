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

DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG="$DIR/litellm-config.yaml"
PUERTO=8000
SESSION="colmena"

# ─── Localizar litellm en PATH o venvs comunes ───────────────────────────────
# FIX E1: no dependemos del venv de thdora
find_litellm() {
  # 1. En PATH
  if command -v litellm &>/dev/null; then
    echo "$(command -v litellm)"
    return
  fi
  # 2. pip install --user
  if [ -f "$HOME/.local/bin/litellm" ]; then
    echo "$HOME/.local/bin/litellm"
    return
  fi
  # 3. venvs conocidos (ai-toolkit primero, luego thdora como fallback)
  for venv_path in \
    "$HOME/ai-toolkit/.venv/bin/litellm" \
    "$HOME/projects/ai-toolkit/.venv/bin/litellm" \
    "$HOME/projects/thdora/.venv/bin/litellm" \
    "$HOME/thdora/.venv/bin/litellm"; do
    if [ -f "$venv_path" ]; then
      echo "$venv_path"
      return
    fi
  done
  echo ""
}

LITELLM=$(find_litellm)

if [ -z "$LITELLM" ]; then
  echo "❌ litellm no encontrado."
  echo "   Instala con: pip install litellm"
  echo "   O dentro del venv: pip install 'litellm[proxy]'"
  exit 1
fi
echo "✅ litellm encontrado: $LITELLM"

# ─── LIMPIEZA AGRESIVA ───────────────────────────────────────────────────────
echo "🧹 Limpiando puerto $PUERTO y procesos litellm..."
pkill -9 -f litellm 2>/dev/null || true
lsof -ti :$PUERTO | xargs kill -9 2>/dev/null || true
sleep 2
echo "✅ Puerto $PUERTO libre"

# ─── Modo --solo-proxy (sin tmux) ───────────────────────────────────────────
if [ "${1:-}" = "--solo-proxy" ]; then
  echo "✅ Arrancando LiteLLM en puerto $PUERTO..."
  "$LITELLM" --config "$CONFIG" --port $PUERTO
  exit 0
fi

# ─── Comprobar tmux instalado ────────────────────────────────────────────────
if ! command -v tmux &>/dev/null; then
  echo "❌ tmux no instalado. Ejecuta: sudo apt install tmux -y"
  echo "   O arranca sin tmux: bash scripts/start-colmena.sh --solo-proxy"
  exit 1
fi

# ─── Matar sesión anterior si existe ─────────────────────────────────────────
tmux kill-session -t $SESSION 2>/dev/null || true

# ─── Crear sesión tmux ───────────────────────────────────────────────────────
tmux new-session -d -s $SESSION -x 220 -y 50
tmux rename-window -t $SESSION:0 'colmena'

# Panel 1 (derecha arriba): Logs LiteLLM
tmux split-window -t $SESSION:0 -h
tmux send-keys -t $SESSION:0.1 "cd $DIR && '$LITELLM' --config '$CONFIG' --port $PUERTO" Enter

# Panel 2 (derecha abajo): Bash libre + health check automático
tmux split-window -t $SESSION:0.1 -v
tmux send-keys -t $SESSION:0.2 "cd $DIR" Enter
tmux send-keys -t $SESSION:0.2 "echo '👀 Espera ~8s a que LiteLLM arranque...' && for i in \$(seq 1 20); do curl -s http://localhost:$PUERTO/health &>/dev/null && bash scripts/health-check.sh && break; echo -n '.'; sleep 1; done" Enter

# Panel 0 (izquierda): OpenCode (espera a que LiteLLM esté listo)
tmux send-keys -t $SESSION:0.0 "cd $DIR && sleep 10 && opencode" Enter

# Foco en OpenCode
tmux select-pane -t $SESSION:0.0

# ─── Adjuntar ────────────────────────────────────────────────────────────────
if [ -n "${TMUX:-}" ]; then
  echo ""
  echo "✅ Sesión '$SESSION' creada en background."
  echo "👉 Adjunta con: tmux attach -t $SESSION"
else
  tmux attach-session -t $SESSION
fi

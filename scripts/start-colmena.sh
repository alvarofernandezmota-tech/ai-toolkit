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
# Salir de tmux: Ctrl+B D (detach), luego: tmux attach -t colmena

# NOTA: NO usar set -e — causa que el script muera si tmux attach falla
DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG="$DIR/litellm-config.yaml"
PUERTO=8000
SESSION="colmena"

# ─── LIMPIEZA AGRESIVA ───────────────────────────────────────────────────
# Matar SIEMPRE todo lo que ocupe el puerto 8000, venga de donde venga
echo "🧹 Limpiando puerto $PUERTO y procesos litellm..."
pkill -9 -f litellm 2>/dev/null || true
lsof -ti :$PUERTO | xargs kill -9 2>/dev/null || true
sleep 2
echo "✅ Puerto $PUERTO libre"

# ─── Modo --solo-proxy (sin tmux) ───────────────────────────────────
if [ "$1" = "--solo-proxy" ]; then
  echo "✅ Arrancando LiteLLM..."
  litellm --config "$CONFIG" --port $PUERTO
  exit 0
fi

# ─── Comprobar tmux instalado ──────────────────────────────────
if ! command -v tmux &>/dev/null; then
  echo "❌ tmux no instalado. Ejecuta: sudo apt install tmux -y"
  exit 1
fi

# ─── Matar sesión colmena anterior si existe ──────────────────────────
tmux kill-session -t $SESSION 2>/dev/null || true

# ─── Crear sesión tmux ────────────────────────────────────────────
tmux new-session -d -s $SESSION -x 220 -y 50
tmux rename-window -t $SESSION:0 'colmena'

# Panel 1 (derecha arriba): Logs LiteLLM
tmux split-window -t $SESSION:0 -h
tmux send-keys -t $SESSION:0.1 "cd $DIR && litellm --config '$CONFIG' --port $PUERTO" Enter

# Panel 2 (derecha abajo): Bash libre
tmux split-window -t $SESSION:0.1 -v
tmux send-keys -t $SESSION:0.2 "cd $DIR && echo '👀 Bash libre. Espera ~8s hasta que LiteLLM arranque, luego Ctrl+B ← para OpenCode'" Enter
tmux send-keys -t $SESSION:0.2 "for i in \$(seq 1 15); do curl -s http://localhost:$PUERTO/health/liveliness &>/dev/null && echo '✅ LiteLLM listo' && break; echo -n '.'; sleep 1; done" Enter

# Panel 0 (izquierda): OpenCode
tmux send-keys -t $SESSION:0.0 "cd $DIR && sleep 9 && opencode" Enter

# Foco en OpenCode
tmux select-pane -t $SESSION:0.0

# ─── Adjuntar ───────────────────────────────────────────────────────────────
if [ -n "$TMUX" ]; then
  echo ""
  echo "✅ Sesión '$SESSION' creada en background."
  echo "👉 Ahora: Ctrl+B D para salir de esta sesión y luego:"
  echo "   tmux attach -t $SESSION"
else
  tmux attach-session -t $SESSION
fi

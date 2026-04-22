#!/bin/bash
# start-colmena.sh — Arranque completo con tmux
# Uso: bash scripts/start-colmena.sh
# Uso (solo proxy, sin tmux): bash scripts/start-colmena.sh --solo-proxy
# Uso (Claude Code con Ollama GRATIS): bash scripts/start-colmena.sh --claude-local
# Uso (Claude Code en thdora toda la noche): bash scripts/start-colmena.sh --claude-thdora
#
# Layout tmux (modo normal):
#  ┌────────────────────┬─────────────────────┐
#  │                    │  LOGS LiteLLM       │
#  │    CLAUDE CODE     ├─────────────────────┤
#  │    (Ollama local)  │  BASH LIBRE         │
#  └────────────────────┴─────────────────────┘
#
# Navegar entre paneles: Ctrl+B luego flecha

DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG="$DIR/litellm-config.yaml"
PUERTO=8000
SESSION="colmena"

# ─── Variables Claude Code + Ollama (GRATIS) ─────────────────────────────────
export ANTHROPIC_BASE_URL="http://localhost:11434"
export ANTHROPIC_AUTH_TOKEN="ollama"
export ANTHROPIC_API_KEY=""
MODELO_LOCAL="qwen2.5-coder:14b"

# ─── Modo --claude-local (Claude Code en ai-toolkit con Ollama) ──────────────
if [ "${1:-}" = "--claude-local" ]; then
  echo ""
  echo "🦙 Arrancando Claude Code con Ollama local..."
  echo "   Modelo: $MODELO_LOCAL"
  echo "   Base URL: $ANTHROPIC_BASE_URL"
  echo ""
  if ! pgrep -x ollama &>/dev/null; then
    echo "⚠️  Ollama no está corriendo. Arrancando..."
    ollama serve &>/dev/null &
    sleep 3
  fi
  cd "$DIR"
  exec claude --model "$MODELO_LOCAL"
fi

# ─── Modo --claude-thdora (Claude Code en THDORA toda la noche) ──────────────
if [ "${1:-}" = "--claude-thdora" ]; then
  THDORA_DIR="$HOME/projects/thdora"
  if [ ! -d "$THDORA_DIR" ]; then
    echo "❌ No encontrado el repo thdora en $THDORA_DIR"
    echo "   Ajusta la variable THDORA_DIR en este script si está en otra ruta"
    exit 1
  fi
  echo ""
  echo "🦙 Modo THDORA — Claude Code + Ollama local en sesión tmux"
  echo "   Modelo: $MODELO_LOCAL"
  echo "   Repo:   $THDORA_DIR"
  echo ""

  # Arrancar Ollama si no está corriendo
  if ! pgrep -x ollama &>/dev/null; then
    echo "⚠️  Arrancando Ollama..."
    ollama serve &>/dev/null &
    sleep 3
  fi

  # Matar sesión anterior
  tmux kill-session -t thdora 2>/dev/null || true

  # Crear sesión tmux dedicada a thdora
  tmux new-session -d -s thdora -x 220 -y 50
  tmux rename-window -t thdora:0 'claude-thdora'

  # Panel derecho: logs de ollama
  tmux split-window -t thdora:0 -h
  tmux send-keys -t thdora:0.1 "echo '🟢 Ollama logs:' && ollama serve 2>&1 | tail -f" Enter

  # Panel izquierdo: Claude Code en thdora
  tmux send-keys -t thdora:0.0 "cd $THDORA_DIR && claude --model $MODELO_LOCAL" Enter
  tmux select-pane -t thdora:0.0

  echo ""
  echo "✅ Sesión 'thdora' arrancada."
  echo "   Adjunta con: tmux attach -t thdora"
  echo "   Sal sin matar la sesión: Ctrl+B, luego D"
  echo ""

  if [ -n "${TMUX:-}" ]; then
    echo "👉 Ya estás en tmux. Adjunta con: tmux attach -t thdora"
  else
    tmux attach-session -t thdora
  fi
  exit 0
fi

# ─── Localizar litellm en PATH o venvs comunes ───────────────────────────────
find_litellm() {
  if command -v litellm &>/dev/null; then
    echo "$(command -v litellm)"
    return
  fi
  if [ -f "$HOME/.local/bin/litellm" ]; then
    echo "$HOME/.local/bin/litellm"
    return
  fi
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

# Panel 0 (izquierda): Claude Code con Ollama (gratis)
tmux send-keys -t $SESSION:0.0 "cd $DIR && sleep 10 && claude --model $MODELO_LOCAL" Enter
tmux select-pane -t $SESSION:0.0

# ─── Adjuntar ────────────────────────────────────────────────────────────────
if [ -n "${TMUX:-}" ]; then
  echo ""
  echo "✅ Sesión '$SESSION' creada en background."
  echo "👉 Adjunta con: tmux attach -t $SESSION"
else
  tmux attach-session -t $SESSION
fi

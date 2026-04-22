#!/bin/bash
# start-colmena.sh — Arranque completo con tmux
#
# MODOS DISPONIBLES:
#   bash scripts/start-colmena.sh                  # colmena completa: LiteLLM + Claude Code Ollama
#   bash scripts/start-colmena.sh --solo-proxy      # solo LiteLLM proxy
#   bash scripts/start-colmena.sh --claude-local    # Claude Code con Ollama (qwen3:8b, 6GB VRAM)
#   bash scripts/start-colmena.sh --claude-thdora   # Claude Code en thdora toda la noche
#   bash scripts/start-colmena.sh --opencode        # OpenCode con OpenRouter (GRATIS, recomendado)
#   bash scripts/start-colmena.sh --groq            # Claude Code via LiteLLM + Groq (GRATIS, rápido)
#   bash scripts/start-colmena.sh --colmena-full    # 3 paneles: Claude Code + OpenCode + bash
#
# REQUISITOS POR MODO:
#   --claude-local:  Ollama corriendo, modelo qwen3:8b descargado
#   --opencode:      OPENROUTER_API_KEY en ~/.bashrc
#   --groq:          GROQ_API_KEY en ~/.bashrc + litellm instalado
#   --colmena-full:  OPENROUTER_API_KEY + Ollama + litellm
#
# Layout tmux (colmena-full):
#  ┌────────────────────┬─────────────────────┐
#  │                    │  OPENCODE           │
#  │  CLAUDE CODE       │  (llama-3.3-70b     │
#  │  (qwen3:8b local)  │   OpenRouter free)  │
#  │                    ├─────────────────────┤
#  │                    │  BASH LIBRE         │
#  └────────────────────┴─────────────────────┘
#
# Navegar entre paneles: Ctrl+B luego flecha
# Salir sin matar sesión: Ctrl+B D

DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG="$DIR/litellm-config.yaml"
PUERTO=8000
SESSION="colmena"

# ─── Variables Claude Code + Ollama ──────────────────────────────────────────
export ANTHROPIC_BASE_URL="http://localhost:11434"
export ANTHROPIC_AUTH_TOKEN="ollama"
export ANTHROPIC_API_KEY=""
MODELO_LOCAL="qwen3:8b"   # 14B se cuelga con 6GB VRAM → usamos 8B

# ─── Modo --opencode (OpenCode + OpenRouter GRATIS) ──────────────────────────
if [ "${1:-}" = "--opencode" ]; then
  if [ -z "${OPENROUTER_API_KEY:-}" ]; then
    echo "❌ OPENROUTER_API_KEY no está definida."
    echo "   Añade a ~/.bashrc: export OPENROUTER_API_KEY=\"sk-or-v1-...\""
    exit 1
  fi
  echo ""
  echo "🌐 Arrancando OpenCode con OpenRouter (GRATIS)..."
  echo "   Modelo: meta-llama/llama-3.3-70b-instruct:free"
  echo ""
  cd "$DIR"
  exec env OPENAI_API_KEY="$OPENROUTER_API_KEY" \
           OPENAI_BASE_URL="https://openrouter.ai/api/v1" \
           opencode
fi

# ─── Modo --groq (Claude Code via LiteLLM + Groq GRATIS) ────────────────────
if [ "${1:-}" = "--groq" ]; then
  if [ -z "${GROQ_API_KEY:-}" ]; then
    echo "❌ GROQ_API_KEY no está definida."
    echo "   Regístrate gratis en https://console.groq.com"
    echo "   Añade a ~/.bashrc: export GROQ_API_KEY=\"gsk_...\""
    exit 1
  fi
  echo ""
  echo "⚡ Modo GROQ — Claude Code via LiteLLM + Groq (GRATIS)"
  echo "   Modelo: llama-3.3-70b-versatile (Groq)"
  echo ""

  # Arrancar LiteLLM apuntando a Groq
  GROQ_API_KEY="$GROQ_API_KEY" litellm \
    --model groq/llama-3.3-70b-versatile \
    --port 8000 \
    --drop_params \
    &
  LITELLM_PID=$!
  echo "   LiteLLM arrancando (PID $LITELLM_PID)..."
  sleep 5

  # Claude Code apuntando a LiteLLM
  export ANTHROPIC_BASE_URL="http://localhost:8000"
  export ANTHROPIC_AUTH_TOKEN="$GROQ_API_KEY"
  unset ANTHROPIC_API_KEY
  cd "$DIR"
  exec claude --model groq/llama-3.3-70b-versatile
fi

# ─── Modo --colmena-full (3 paneles: Claude Code + OpenCode + bash) ──────────
if [ "${1:-}" = "--colmena-full" ]; then
  if [ -z "${OPENROUTER_API_KEY:-}" ]; then
    echo "❌ OPENROUTER_API_KEY necesaria para el panel OpenCode"
    exit 1
  fi

  tmux kill-session -t colmena-full 2>/dev/null || true
  tmux new-session -d -s colmena-full -x 240 -y 55
  tmux rename-window -t colmena-full:0 'colmena'

  # Panel derecha arriba: OpenCode
  tmux split-window -t colmena-full:0 -h
  tmux send-keys -t colmena-full:0.1 "cd $DIR && OPENAI_API_KEY='$OPENROUTER_API_KEY' OPENAI_BASE_URL='https://openrouter.ai/api/v1' opencode" Enter

  # Panel derecha abajo: bash libre
  tmux split-window -t colmena-full:0.1 -v
  tmux send-keys -t colmena-full:0.2 "cd $DIR && echo '🐝 Bash libre — usa para git log, ollama ps, etc.'" Enter

  # Panel izquierda: Claude Code con Ollama
  if pgrep -x ollama &>/dev/null; then
    tmux send-keys -t colmena-full:0.0 "cd $DIR && unset ANTHROPIC_API_KEY && export ANTHROPIC_BASE_URL=http://localhost:11434 && export ANTHROPIC_AUTH_TOKEN=ollama && claude --model $MODELO_LOCAL" Enter
  else
    tmux send-keys -t colmena-full:0.0 "echo '⚠️  Ollama no está corriendo. Arranca con: ollama serve'" Enter
  fi

  tmux select-pane -t colmena-full:0.0

  echo ""
  echo "✅ Colmena completa arrancada (3 paneles)"
  echo "   Claude Code (izq): qwen3:8b via Ollama"
  echo "   OpenCode (der-arr): llama-3.3-70b via OpenRouter"
  echo "   Bash (der-abj):    libre"
  echo ""
  echo "   Adjunta: tmux attach -t colmena-full"
  echo "   Salir sin matar: Ctrl+B D"

  if [ -z "${TMUX:-}" ]; then
    tmux attach-session -t colmena-full
  fi
  exit 0
fi

# ─── Modo --claude-local (Claude Code en ai-toolkit con Ollama) ──────────────
if [ "${1:-}" = "--claude-local" ]; then
  echo ""
  echo "🦙 Arrancando Claude Code con Ollama local..."
  echo "   Modelo: $MODELO_LOCAL (qwen3:8b — cabe en 6GB VRAM)"
  echo "   Base URL: $ANTHROPIC_BASE_URL"
  echo "   ⚠️  NOTA: Si se cuelga, usa --opencode o --groq en su lugar"
  echo ""
  if ! pgrep -x ollama &>/dev/null; then
    echo "⚠️  Ollama no está corriendo. Arrancando..."
    ollama serve &>/dev/null &
    sleep 3
  fi
  cd "$DIR"
  unset ANTHROPIC_API_KEY
  exec claude --model "$MODELO_LOCAL"
fi

# ─── Modo --claude-thdora (Claude Code en THDORA toda la noche) ──────────────
if [ "${1:-}" = "--claude-thdora" ]; then
  THDORA_DIR="$HOME/projects/thdora"
  if [ ! -d "$THDORA_DIR" ]; then
    echo "❌ No encontrado el repo thdora en $THDORA_DIR"
    exit 1
  fi
  echo ""
  echo "🦙 Modo THDORA — Claude Code + Ollama local en sesión tmux"
  echo "   Modelo: $MODELO_LOCAL"
  echo "   Repo:   $THDORA_DIR"
  echo ""

  if ! pgrep -x ollama &>/dev/null; then
    echo "⚠️  Arrancando Ollama..."
    ollama serve &>/dev/null &
    sleep 3
  fi

  tmux kill-session -t thdora 2>/dev/null || true
  tmux new-session -d -s thdora -x 220 -y 50
  tmux rename-window -t thdora:0 'claude-thdora'

  tmux split-window -t thdora:0 -h
  tmux send-keys -t thdora:0.1 "echo '🟢 Ollama logs:' && ollama serve 2>&1 | tail -f" Enter
  tmux send-keys -t thdora:0.0 "cd $THDORA_DIR && unset ANTHROPIC_API_KEY && claude --model $MODELO_LOCAL" Enter
  tmux select-pane -t thdora:0.0

  echo "✅ Sesión 'thdora' arrancada. Adjunta: tmux attach -t thdora"

  if [ -z "${TMUX:-}" ]; then
    tmux attach-session -t thdora
  fi
  exit 0
fi

# ─── Localizar litellm ───────────────────────────────────────────────────────
find_litellm() {
  command -v litellm 2>/dev/null && return
  for p in \
    "$HOME/.local/bin/litellm" \
    "$HOME/ai-toolkit/.venv/bin/litellm" \
    "$HOME/projects/ai-toolkit/.venv/bin/litellm" \
    "$HOME/projects/thdora/.venv/bin/litellm" \
    "$HOME/thdora/.venv/bin/litellm"; do
    [ -f "$p" ] && echo "$p" && return
  done
}

LITELLM=$(find_litellm)

if [ -z "$LITELLM" ]; then
  echo "❌ litellm no encontrado. Instala: pip install 'litellm[proxy]'"
  exit 1
fi
echo "✅ litellm encontrado: $LITELLM"

# ─── LIMPIEZA ────────────────────────────────────────────────────────────────
echo "🧹 Limpiando puerto $PUERTO y procesos litellm..."
pkill -9 -f litellm 2>/dev/null || true
lsof -ti :$PUERTO | xargs kill -9 2>/dev/null || true
sleep 2
echo "✅ Puerto $PUERTO libre"

# ─── Modo --solo-proxy ───────────────────────────────────────────────────────
if [ "${1:-}" = "--solo-proxy" ]; then
  exec "$LITELLM" --config "$CONFIG" --port $PUERTO
fi

# ─── Colmena normal (tmux 3 paneles con LiteLLM) ────────────────────────────
if ! command -v tmux &>/dev/null; then
  echo "❌ tmux no instalado: sudo apt install tmux -y"
  exit 1
fi

tmux kill-session -t $SESSION 2>/dev/null || true
tmux new-session -d -s $SESSION -x 220 -y 50
tmux rename-window -t $SESSION:0 'colmena'

tmux split-window -t $SESSION:0 -h
tmux send-keys -t $SESSION:0.1 "cd $DIR && '$LITELLM' --config '$CONFIG' --port $PUERTO" Enter

tmux split-window -t $SESSION:0.1 -v
tmux send-keys -t $SESSION:0.2 "cd $DIR" Enter
tmux send-keys -t $SESSION:0.2 "echo '👀 Espera ~8s...' && for i in \$(seq 1 20); do curl -s http://localhost:$PUERTO/health &>/dev/null && bash scripts/health-check.sh && break; echo -n '.'; sleep 1; done" Enter

tmux send-keys -t $SESSION:0.0 "cd $DIR && sleep 10 && unset ANTHROPIC_API_KEY && claude --model $MODELO_LOCAL" Enter
tmux select-pane -t $SESSION:0.0

if [ -n "${TMUX:-}" ]; then
  echo "✅ Sesión '$SESSION' creada. Adjunta: tmux attach -t $SESSION"
else
  tmux attach-session -t $SESSION
fi

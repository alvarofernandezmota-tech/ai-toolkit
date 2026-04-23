#!/bin/bash
# start-colmena.sh — Arranque del ecosistema AI
#
# ═══════════════════════════════════════════════════════════════════
# ORDENADOR GRANDE — OpenCode + LiteLLM proxy
# ═══════════════════════════════════════════════════════════════════
#   bash scripts/start-colmena.sh --colmena-full    ← PRINCIPAL (3 paneles)
#   bash scripts/start-colmena.sh --solo-proxy      # solo LiteLLM proxy
#   bash scripts/start-colmena.sh --opencode        # solo OpenCode
#
# Layout --colmena-full:
#  ┌────────────────────┬─────────────────────┐
#  │                    │  LiteLLM proxy      │
#  │  OpenCode          │  logs/status        │
#  │  (izquierda)       ├─────────────────────┤
#  │                    │  bash libre         │
#  └────────────────────┴─────────────────────┘
#
# ═══════════════════════════════════════════════════════════════════
# ACER (vía SSH) — Claude Code + OpenRouter
# ═══════════════════════════════════════════════════════════════════
#   bash scripts/start-colmena.sh --claude-acer     ← PRINCIPAL ACER (2 paneles)
#   bash scripts/start-colmena.sh --claude-thdora   # Claude Code en thdora
#
# Layout --claude-acer:
#  ┌────────────────────┬─────────────────────┐
#  │                    │                     │
#  │  Claude Code       │  bash libre         │
#  │  (izquierda)       │  (git, curl, etc.)  │
#  │                    │                     │
#  └────────────────────┴─────────────────────┘
#
# ═══════════════════════════════════════════════════════════════════
# OTROS MODOS
# ═══════════════════════════════════════════════════════════════════
#   bash scripts/start-colmena.sh --claude-local    # Claude Code con Ollama local
#   bash scripts/start-colmena.sh --groq            # Claude Code via Groq directo
#
# Navegar entre paneles: Ctrl+B luego flecha
# Salir sin matar sesión: Ctrl+B D

DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG="$DIR/litellm-config.yaml"
PUERTO=8000
SESSION="colmena"

MODELO_LOCAL="qwen3:8b"   # 14B no cabe en 6GB VRAM → solo 8B

# ═══════════════════════════════════════════════════════════════════
# ORDENADOR GRANDE — OpenCode
# ═══════════════════════════════════════════════════════════════════

# ─── Modo --colmena-full (PRINCIPAL ordenador grande) ────────────────────────
if [ "${1:-}" = "--colmena-full" ]; then
  if [ -z "${OPENROUTER_API_KEY:-}" ]; then
    echo "❌ OPENROUTER_API_KEY no definida en ~/.bashrc"
    exit 1
  fi

  tmux kill-session -t colmena-full 2>/dev/null || true
  tmux new-session -d -s colmena-full -x 240 -y 55
  tmux rename-window -t colmena-full:0 'colmena'

  # Panel derecha arriba: LiteLLM proxy
  tmux split-window -t colmena-full:0 -h
  tmux send-keys -t colmena-full:0.1 "cd $DIR && echo '🔀 Arrancando LiteLLM proxy...' && litellm --config '$CONFIG' --port $PUERTO" Enter

  # Panel derecha abajo: bash libre
  tmux split-window -t colmena-full:0.1 -v
  tmux send-keys -t colmena-full:0.2 "cd $DIR && echo '👀 Espera ~8s a que LiteLLM arranque...' && for i in \$(seq 1 20); do curl -s http://localhost:$PUERTO/health &>/dev/null && bash scripts/health-check.sh && break; echo -n '.'; sleep 1; done" Enter

  # Panel izquierda: OpenCode vía LiteLLM proxy
  tmux send-keys -t colmena-full:0.0 "cd $DIR && sleep 10 && opencode" Enter
  tmux select-pane -t colmena-full:0.0

  echo ""
  echo "✅ Colmena completa arrancada (3 paneles)"
  echo "   OpenCode   (izq):      vía LiteLLM proxy :8000"
  echo "   LiteLLM    (der-arr):  proxy logs/status"
  echo "   Bash libre (der-abj):  git, curl, etc."
  echo ""
  echo "   Adjunta: tmux attach -t colmena-full"
  echo "   Salir sin matar: Ctrl+B D"

  if [ -z "${TMUX:-}" ]; then
    tmux attach-session -t colmena-full
  fi
  exit 0
fi

# ─── Modo --opencode (OpenCode solo, sin proxy) ──────────────────────────────
if [ "${1:-}" = "--opencode" ]; then
  if [ -z "${OPENROUTER_API_KEY:-}" ]; then
    echo "❌ OPENROUTER_API_KEY no está definida."
    echo "   Añade a ~/.bashrc: export OPENROUTER_API_KEY=\"sk-or-v1-...\""
    exit 1
  fi
  echo ""
  echo "🌐 Arrancando OpenCode con LiteLLM proxy..."
  echo ""
  cd "$DIR"
  exec opencode
fi

# ═══════════════════════════════════════════════════════════════════
# ACER — Claude Code
# ═══════════════════════════════════════════════════════════════════

# ─── Modo --claude-acer (PRINCIPAL Acer vía SSH) ─────────────────────────────
if [ "${1:-}" = "--claude-acer" ]; then
  if [ -z "${OPENROUTER_API_KEY:-}" ]; then
    echo "❌ OPENROUTER_API_KEY no definida."
    echo "   Añade a ~/.bashrc: export OPENROUTER_API_KEY=\"sk-or-v1-...\""
    exit 1
  fi

  tmux kill-session -t claude-acer 2>/dev/null || true
  tmux new-session -d -s claude-acer -x 220 -y 50
  tmux rename-window -t claude-acer:0 'claude-acer'

  # Panel derecha: bash libre
  tmux split-window -t claude-acer:0 -h
  tmux send-keys -t claude-acer:0.1 "cd $DIR && echo '🐝 Bash libre — git, curl, ls, etc.'" Enter

  # Panel izquierda: Claude Code vía OpenRouter
  tmux send-keys -t claude-acer:0.0 "cd $DIR && unset ANTHROPIC_API_KEY && unset ANTHROPIC_AUTH_TOKEN && export ANTHROPIC_BASE_URL=https://openrouter.ai/api/v1 && export ANTHROPIC_API_KEY=\$OPENROUTER_API_KEY && claude" Enter
  tmux select-pane -t claude-acer:0.0

  echo ""
  echo "✅ Claude Code arrancado (2 paneles)"
  echo "   Claude Code (izq): vía OpenRouter"
  echo "   Bash libre  (der): git, curl, etc."
  echo ""
  echo "   Adjunta: tmux attach -t claude-acer"
  echo "   Salir sin matar: Ctrl+B D"

  if [ -z "${TMUX:-}" ]; then
    tmux attach-session -t claude-acer
  fi
  exit 0
fi

# ─── Modo --groq (Claude Code via Groq directo) ──────────────────────────────
if [ "${1:-}" = "--groq" ]; then
  if [ -z "${GROQ_API_KEY:-}" ]; then
    echo "❌ GROQ_API_KEY no definida."
    echo "   Regístrate gratis en https://console.groq.com"
    exit 1
  fi
  echo ""
  echo "⚡ Modo GROQ — Claude Code via LiteLLM + Groq (GRATIS)"
  echo ""

  GROQ_API_KEY="$GROQ_API_KEY" litellm \
    --model groq/llama-3.3-70b-versatile \
    --port 8000 \
    --drop_params \
    &
  sleep 5

  unset ANTHROPIC_API_KEY
  export ANTHROPIC_BASE_URL="http://localhost:8000"
  export ANTHROPIC_AUTH_TOKEN="$GROQ_API_KEY"
  cd "$DIR"
  exec claude --model groq/llama-3.3-70b-versatile
fi

# ─── Modo --claude-local (Claude Code con Ollama local) ──────────────────────
if [ "${1:-}" = "--claude-local" ]; then
  echo ""
  echo "🦙 Arrancando Claude Code con Ollama local..."
  echo "   Modelo: $MODELO_LOCAL (qwen3:8b — cabe en 6GB VRAM)"
  echo ""
  if ! pgrep -x ollama &>/dev/null; then
    echo "⚠️  Ollama no está corriendo. Arrancando..."
    ollama serve &>/dev/null &
    sleep 3
  fi
  cd "$DIR"
  unset ANTHROPIC_API_KEY
  export ANTHROPIC_BASE_URL="http://localhost:11434"
  export ANTHROPIC_AUTH_TOKEN="ollama"
  exec claude --model "$MODELO_LOCAL"
fi

# ─── Modo --claude-thdora (Claude Code en THDORA) ────────────────────────────
if [ "${1:-}" = "--claude-thdora" ]; then
  THDORA_DIR="$HOME/projects/thdora"
  if [ ! -d "$THDORA_DIR" ]; then
    echo "❌ No encontrado el repo thdora en $THDORA_DIR"
    exit 1
  fi
  echo ""
  echo "🦙 Modo THDORA — Claude Code + OpenRouter"
  echo "   Repo: $THDORA_DIR"
  echo ""

  tmux kill-session -t thdora 2>/dev/null || true
  tmux new-session -d -s thdora -x 220 -y 50
  tmux rename-window -t thdora:0 'claude-thdora'

  tmux split-window -t thdora:0 -h
  tmux send-keys -t thdora:0.1 "cd $THDORA_DIR && echo '🐝 Bash libre THDORA'" Enter
  tmux send-keys -t thdora:0.0 "cd $THDORA_DIR && unset ANTHROPIC_API_KEY && unset ANTHROPIC_AUTH_TOKEN && export ANTHROPIC_BASE_URL=https://openrouter.ai/api/v1 && export ANTHROPIC_API_KEY=\$OPENROUTER_API_KEY && claude" Enter
  tmux select-pane -t thdora:0.0

  echo "✅ Sesión 'thdora' arrancada. Adjunta: tmux attach -t thdora"

  if [ -z "${TMUX:-}" ]; then
    tmux attach-session -t thdora
  fi
  exit 0
fi

# ═══════════════════════════════════════════════════════════════════
# MODO POR DEFECTO — colmena normal con LiteLLM
# ═══════════════════════════════════════════════════════════════════

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

echo "🧹 Limpiando puerto $PUERTO..."
pkill -9 -f litellm 2>/dev/null || true
lsof -ti :$PUERTO | xargs kill -9 2>/dev/null || true
sleep 2

if [ "${1:-}" = "--solo-proxy" ]; then
  exec "$LITELLM" --config "$CONFIG" --port $PUERTO
fi

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

tmux send-keys -t $SESSION:0.0 "cd $DIR && sleep 10 && opencode" Enter
tmux select-pane -t $SESSION:0.0

if [ -n "${TMUX:-}" ]; then
  echo "✅ Sesión '$SESSION' creada. Adjunta: tmux attach -t $SESSION"
else
  tmux attach-session -t $SESSION
fi

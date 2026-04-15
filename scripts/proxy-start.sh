#!/usr/bin/env bash
set -e

CONFIG="$(cd "$(dirname "$0")/.." && pwd)/litellm-config.yaml"
PORT=4000
LOG="/tmp/litellm.log"

# ─── MENÚ ───────────────────────────────────────────────────────────────────
clear
echo ""
echo "  ╔══════════════════════════════════════╗"
echo "  ║        AI-TOOLKIT  LAUNCHER          ║"
echo "  ╠══════════════════════════════════════╣"
echo "  ║  1) OpenCode  → OpenRouter (rápido) ║"
echo "  ║  2) Aider     → Groq (rápido)       ║"
echo "  ║  3) Modo proxy LiteLLM (completo)   ║"
echo "  ╚══════════════════════════════════════╝"
echo ""
read -rp "  Elige [1-3]: " OPCION
echo ""

case "$OPCION" in
  1)
    echo "==> Lanzando OpenCode directo a OpenRouter..."
    if ! command -v opencode &>/dev/null; then
      echo "    Instalando opencode..."
      npm install -g opencode-ai
    fi
    OPENAI_API_KEY="$OPENROUTER_API_KEY" \
    OPENAI_BASE_URL="https://openrouter.ai/api/v1" \
    opencode
    ;;
  2)
    echo "==> Lanzando Aider directo a Groq..."
    if ! command -v aider &>/dev/null; then
      pip install aider-chat
    fi
    GROQ_API_KEY="$GROQ_API_KEY" aider --model groq/llama-3.3-70b-versatile
    ;;
  3)
    echo "==> Arrancando LiteLLM proxy en :$PORT ..."
    pkill -f litellm 2>/dev/null || true
    sleep 1
    nohup litellm --config "$CONFIG" --port $PORT > "$LOG" 2>&1 &
    LITELLM_PID=$!
    echo -n "    Esperando"
    for i in $(seq 1 30); do
      if curl -s http://localhost:$PORT/health > /dev/null 2>&1; then
        echo " OK!"
        break
      fi
      echo -n "."
      sleep 1
    done
    echo ""
    export OPENAI_API_KEY="fake-key"
    export OPENAI_BASE_URL="http://localhost:$PORT"
    opencode
    echo "==> Cerrando LiteLLM..."
    kill $LITELLM_PID 2>/dev/null || true
    ;;
  *)
    echo "Opción no válida."
    exit 1
    ;;
esac

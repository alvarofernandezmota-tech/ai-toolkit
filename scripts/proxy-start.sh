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
echo "  ║  1) OpenCode   (recomendado)         ║"
echo "  ║  2) Aider      (rápido, CLI)         ║"
echo "  ║  3) Claude Code (requiere login)     ║"
echo "  ╚══════════════════════════════════════╝"
echo ""
read -rp "  Elige [1-3]: " OPCION
echo ""

# ─── PROXY ──────────────────────────────────────────────────────────────────
pkill -f litellm 2>/dev/null || true
sleep 1

echo "==> Arrancando LiteLLM proxy en :$PORT ..."
nohup litellm --config "$CONFIG" --port $PORT > "$LOG" 2>&1 &
LITELLM_PID=$!

for i in $(seq 1 15); do
  curl -s http://localhost:$PORT/health > /dev/null 2>&1 && echo "    Proxy OK" && break
  sleep 1
done

export OPENAI_API_KEY="fake-key"
export OPENAI_BASE_URL="http://localhost:$PORT"
export ANTHROPIC_API_KEY="fake-key"
export ANTHROPIC_BASE_URL="http://localhost:$PORT"

# ─── LANZAR HERRAMIENTA ─────────────────────────────────────────────────────
case "$OPCION" in
  1)
    echo "==> Lanzando OpenCode..."
    if ! command -v opencode &>/dev/null; then
      echo "    Instalando opencode..."
      npm install -g opencode-ai
    fi
    opencode
    ;;
  2)
    echo "==> Lanzando Aider con Groq..."
    if ! command -v aider &>/dev/null; then
      echo "    Instalando aider..."
      pip install aider-chat
    fi
    GROQ_API_KEY="$GROQ_API_KEY" aider --model groq/llama-3.3-70b-versatile
    ;;
  3)
    echo "==> Lanzando Claude Code (necesita login)..."
    rm -f ~/.claude/auth.json 2>/dev/null || true
    if command -v expect &>/dev/null; then
      expect -c '
        spawn claude --dangerously-skip-permissions
        expect "By proceeding"
        send "\r"
        interact
      '
    else
      echo ">>> Cuando aparezca el WARNING pulsa Enter <<<"
      claude --dangerously-skip-permissions
    fi
    ;;
  *)
    echo "Opción no válida. Saliendo."
    kill $LITELLM_PID 2>/dev/null || true
    exit 1
    ;;
esac

echo "==> Cerrando LiteLLM..."
kill $LITELLM_PID 2>/dev/null || true

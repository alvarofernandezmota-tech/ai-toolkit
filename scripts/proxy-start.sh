#!/usr/bin/env bash
# =============================================================================
# CLAUDE CODE GRATIS — LiteLLM intercepta y redirige a Groq/Cerebras/Gemini
# Uso: bash scripts/proxy-start.sh
# =============================================================================

set -e

CONFIG="$(dirname "$0")/../litellm-config.yaml"
PORT=4000

# Matar instancias anteriores
pkill -f 'litellm' 2>/dev/null || true
pkill -f 'claude' 2>/dev/null || true
rm -rf ~/.claude/ 2>/dev/null || true
sleep 1

echo "🚀 Arrancando LiteLLM proxy en :$PORT..."
litellm --config "$CONFIG" --port $PORT &
LITELLM_PID=$!

echo "⏳ Esperando arranque..."
sleep 5

echo "🤖 Lanzando Claude Code..."
ANTHROPIC_API_KEY="fake-key" \
ANTHROPIC_BASE_URL="http://localhost:$PORT" \
claude

kill $LITELLM_PID 2>/dev/null || true
echo "🛑 Listo."

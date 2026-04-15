#!/usr/bin/env bash
# =============================================================================
# PROXY START — LiteLLM + Claude Code
# Camufla Claude Code con modelos gratuitos via LiteLLM
# Uso: bash scripts/proxy-start.sh
# =============================================================================

set -e

CONFIG="$(dirname "$0")/../litellm-config.yaml"
PORT=4000

echo "🔑 Verificando keys..."
[ -z "$CEREBRAS_API_KEY" ] && echo "⚠️  CEREBRAS_API_KEY no configurada"
[ -z "$GROQ_API_KEY" ]     && echo "⚠️  GROQ_API_KEY no configurada"
[ -z "$OPENROUTER_API_KEY" ] && echo "⚠️  OPENROUTER_API_KEY no configurada"
[ -z "$GEMINI_API_KEY" ]   && echo "⚠️  GEMINI_API_KEY no configurada"

# Matar instancias anteriores
pkill -f 'litellm' 2>/dev/null || true
sleep 1

echo "🚀 Arrancando LiteLLM proxy en puerto $PORT..."
litellm --config "$CONFIG" --port $PORT &
LITELLM_PID=$!
echo "   PID: $LITELLM_PID"

echo "⏳ Esperando que arranque..."
sleep 5

echo "🤖 Lanzando Claude Code → proxy..."
ANTHROPIC_API_KEY="fake-key" \
ANTHROPIC_BASE_URL="http://localhost:$PORT" \
claude

# Limpiar al salir
kill $LITELLM_PID 2>/dev/null || true
echo "🛑 Proxy detenido."

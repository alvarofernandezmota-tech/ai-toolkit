#!/usr/bin/env bash
# =============================================================================
# CLAUDE CODE GRATIS — OpenRouter directo (método principal)
# Uso: bash scripts/proxy-start.sh
# =============================================================================

# Limpiar sesión corrupta si existe
rm -rf ~/.claude/ 2>/dev/null || true

# Matar instancias anteriores
pkill -f 'litellm' 2>/dev/null || true
pkill -f 'claude' 2>/dev/null || true
sleep 1

echo "🚀 Arrancando Claude Code → OpenRouter (gratis)..."

ANTHROPIC_API_KEY="${OPENROUTER_API_KEY}" \
ANTHROPIC_BASE_URL="https://openrouter.ai/api/v1" \
claude

# Si falla OpenRouter, fallback a LiteLLM con todas las APIs
if [ $? -ne 0 ]; then
  echo "⚠️  OpenRouter falló, intentando LiteLLM con fallbacks..."
  CONFIG="$(dirname "$0")/../litellm-config.yaml"
  litellm --config "$CONFIG" --port 4000 &
  LITELLM_PID=$!
  sleep 5
  ANTHROPIC_API_KEY="fake-key" \
  ANTHROPIC_BASE_URL="http://localhost:4000" \
  claude
  kill $LITELLM_PID 2>/dev/null || true
fi

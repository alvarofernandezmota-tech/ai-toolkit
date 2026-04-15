#!/bin/bash
# start-colmena.sh — Arrancar LiteLLM colmena + OpenCode
# Uso: bash scripts/start-colmena.sh

set -e

cd ~/projects/ai-toolkit

echo "📥 Actualizando repo..."
git pull

echo "🔄 Verificando si LiteLLM ya corre..."
if curl -s http://localhost:4000/health > /dev/null 2>&1; then
  echo "✅ LiteLLM ya está corriendo en puerto 4000"
else
  echo "🐝 Arrancando LiteLLM colmena en background..."
  litellm --config litellm-config.yaml --port 4000 &
  sleep 4
  echo "✅ LiteLLM corriendo (PID: $!)"
fi

echo "🚀 Abriendo OpenCode..."
opencode

#!/bin/bash
# 🤖 agente.sh — Arranca un agente en una repo específica
# Uso: bash ~/ai-toolkit/scripts/agente.sh thdora
#      bash ~/ai-toolkit/scripts/agente.sh ai-toolkit
#      bash ~/ai-toolkit/scripts/agente.sh personal

set -e

REPO="$1"

if [ -z "$REPO" ]; then
  echo "Uso: bash agente.sh <repo>"
  echo "Repos: thdora | ai-toolkit | personal"
  exit 1
fi

# Mapear nombre a ruta
case "$REPO" in
  thdora)
    REPO_PATH="$HOME/thdora"
    CONTEXT_FILE="$HOME/ai-toolkit/agentes/agente-thdora.md"
    ;;
  ai-toolkit)
    REPO_PATH="$HOME/ai-toolkit"
    CONTEXT_FILE="$HOME/ai-toolkit/agentes/agente-ai-toolkit.md"
    ;;
  personal)
    REPO_PATH="$HOME/personal"
    CONTEXT_FILE="$HOME/ai-toolkit/agentes/agente-personal.md"
    ;;
  *)
    echo "❌ Repo desconocida: $REPO"
    echo "Repos válidas: thdora | ai-toolkit | personal"
    exit 1
    ;;
esac

# Verificar que la repo existe
if [ ! -d "$REPO_PATH" ]; then
  echo "❌ No encontré la repo en: $REPO_PATH"
  echo "   Clona la repo primero: git clone git@github.com:alvarofernandezmota-tech/$REPO.git ~/"$REPO""
  exit 1
fi

# Verificar API key
if [ -z "$OPENROUTER_API_KEY" ]; then
  echo "❌ OPENROUTER_API_KEY no está definida"
  exit 1
fi

echo ""
echo "🤖 Agente: $REPO"
echo "📁 Repo: $REPO_PATH"
echo "📋 Contexto: $CONTEXT_FILE"
echo ""
echo "💡 Tip: pega el contenido de $CONTEXT_FILE como primer mensaje"
echo ""

# Moverse a la repo y arrancar OpenCode
cd "$REPO_PATH"

OPENAI_API_KEY="$OPENROUTER_API_KEY" \
OPENAI_BASE_URL="https://openrouter.ai/api/v1" \
opencode

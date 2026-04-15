#!/bin/bash
# 🧠 cerebro.sh — Arranca el Cerebro orquestador
# Uso: bash scripts/cerebro.sh

set -e

echo ""
echo "🧠 CEREBRO — Orquestador Multi-Repo"
echo "======================================"
echo ""

# Verificar que estamos en ai-toolkit
if [ ! -f "CEREBRO.md" ]; then
  echo "❌ Error: ejecuta este script desde ~/ai-toolkit/"
  exit 1
fi

# Verificar variable de entorno
if [ -z "$OPENROUTER_API_KEY" ]; then
  echo "❌ Error: OPENROUTER_API_KEY no está definida"
  echo "   Añádela a tu .bashrc o .zshrc:"
  echo "   export OPENROUTER_API_KEY=tu_key"
  exit 1
fi

echo "✅ Contexto: $(pwd)"
echo "✅ API Key: detectada"
echo ""
echo "📋 Repos disponibles:"
echo "   ~/thdora/      → bot Telegram personal"
echo "   ~/ai-toolkit/  → herramientas (AQUÍ)"
echo "   ~/personal/    → memoria y diarios"
echo ""
echo "📚 Lee CEREBRO.md para entender el protocolo"
echo ""
echo "🚀 Arrancando OpenCode con modelo thinking..."
echo ""

# Arrancar OpenCode con modelo de razonamiento
OPENAI_API_KEY="$OPENROUTER_API_KEY" \
OPENAI_BASE_URL="https://openrouter.ai/api/v1" \
opencode

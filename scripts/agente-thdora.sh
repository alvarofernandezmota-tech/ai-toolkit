#!/bin/bash
# ============================================================
# agente-thdora.sh — Lanza OpenCode apuntando a THDORA
# Uso: bash scripts/agente-thdora.sh
# ============================================================

set -e

REPO_URL="https://github.com/alvarofernandezmota-tech/thdora"
REPO_NAME="thdora"
STACK="Python 3.13 + FastAPI 0.115 + python-telegram-bot v22 + SQLite + Groq"
VERSION="v4.1.0"

echo "🤖 Agente THDORA"
echo "📦 Repo: $REPO_URL"
echo "🔧 Stack: $STACK"
echo "📌 Versión: $VERSION"
echo ""
echo "Abre OpenCode y pega el contexto de agentes/agente-thdora.md"
echo ""

# Verificar que LiteLLM está corriendo
if curl -s http://localhost:8000/health/liveliness &>/dev/null; then
    echo "✅ LiteLLM activo en :8000"
else
    echo "⚠️  LiteLLM no responde — arranca primero con: bash scripts/start-colmena.sh"
    exit 1
fi

cd ~/projects/ai-toolkit
opencode

#!/bin/bash
# ============================================================
# agente-personal.sh — Lanza OpenCode apuntando a repo personal
# Uso: bash scripts/agente-personal.sh
# ============================================================

set -e

REPO_URL="https://github.com/alvarofernandezmota-tech/personal"
REPO_NAME="personal"
DESC="Sistema de vida: tracking diario, formación, curiosidad, proyectos"

echo "🤖 Agente Personal"
echo "📦 Repo: $REPO_URL"
echo "📋 Descripción: $DESC"
echo ""
echo "Abre OpenCode y pega el contexto de agentes/agente-personal-repo.md"
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

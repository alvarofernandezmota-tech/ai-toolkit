#!/bin/bash
# ============================================================
# agente-personal.sh — Lanza OpenCode apuntando al repo personal
# Uso: bash scripts/agente-personal.sh
# ============================================================

set -e

REPO_URL="https://github.com/alvarofernandezmota-tech/personal"

echo "🤖 Agente Personal"
echo "📦 Repo: $REPO_URL"
echo ""

# Verificar LiteLLM
if ! curl -s http://localhost:8000/health/liveliness &>/dev/null; then
    echo "⚠️  LiteLLM no responde en :8000"
    echo "   Arranca primero: bash scripts/start-colmena.sh"
    exit 1
fi
echo "✅ LiteLLM activo en :8000"
echo ""

# Construir prompt de arranque
PROMPT="Eres el agente del repo personal de Álvaro Fernández Mota.
Repo: $REPO_URL

Al arrancar, lee en este orden:
1. AGENTE.md
2. CONTEXT-PERPLEXITY.md
3. 01_traking_diario/TRACKING-MAESTRO.md
4. El archivo de semana más reciente en 01_traking_diario/semanas/
5. CHANGELOG.md

Luego espera instrucciones. PROHIBIDO tocar 02_formacion/.
Commits semánticos siempre."

echo "📋 Prompt de arranque listo."
echo "Abre OpenCode, pega el prompt de agentes/agente-personal-repo.md"
echo ""
echo "$PROMPT"
echo ""

cd ~/projects/ai-toolkit
opencode

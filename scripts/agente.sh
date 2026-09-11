#!/bin/bash
# 🤖 agente.sh — Arranca un agente en una repo específica
# Uso: bash ~/ai-toolkit/scripts/agente.sh thdora
#      bash ~/ai-toolkit/scripts/agente.sh ai-toolkit
#      bash ~/ai-toolkit/scripts/agente.sh personal

# La raiz del repo, deducida de donde vive este script. Antes esto era una
# ruta fija y habia dos distintas -~/ai-toolkit y ~/projects/ai-toolkit-, asi
# que segun que script lanzaras buscaba el repo en un sitio o en otro.
RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

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
    # thdora ya no existe en la cuenta (comprobado el 2026-09-10). Se deja el
    # caso porque su ficha de agente sigue siendo util, pero la ruta hay que
    # darla: THDORA_PATH=/ruta bash scripts/agente.sh thdora
    REPO_PATH="${THDORA_PATH:-}"
    CONTEXT_FILE="$RAIZ/agentes/agente-thdora.md"
    ;;
  ai-toolkit)
    REPO_PATH="$RAIZ"
    CONTEXT_FILE="$RAIZ/agentes/agente-ai-toolkit.md"
    ;;
  personal)
    # El repo "personal" se retiro; hoy su papel lo hace midgaror, que es
    # privado. Ruta por variable: PERSONAL_PATH=/ruta bash scripts/agente.sh personal
    REPO_PATH="${PERSONAL_PATH:-}"
    CONTEXT_FILE="$RAIZ/agentes/agente-personal.md"
    ;;
  *)
    echo "❌ Repo desconocida: $REPO"
    echo "Repos válidas: thdora | ai-toolkit | personal"
    exit 1
    ;;
esac

# Las rutas de thdora y personal salen de variable porque esos repos ya no
# estan en la cuenta. Sin ella, mejor fallar aqui que a mitad del agente.
if [ -z "${REPO_PATH:-}" ] || [ ! -d "$REPO_PATH" ]; then
  echo "❌ No hay ruta valida para '$REPO'."
  echo "   Dala por variable, p.ej.: THDORA_PATH=/ruta bash $0 $REPO"
  exit 1
fi

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

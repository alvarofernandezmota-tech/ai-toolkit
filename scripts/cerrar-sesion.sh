#!/usr/bin/env bash
# cerrar-sesion.sh — Cierre de sesión ordenado para ai-toolkit
# Creado según AGENTS.md — Álvaro / ai-toolkit

set -euo pipefail

REPO_DIR="${REPO_DIR:-/home/alvaro/projects/ai-toolkit}"

echo "🔴 Iniciando cierre de sesión ordenado..."

# 1. Ir al directorio del repo
cd "$REPO_DIR"

# 2. Estado git antes de cerrar
echo ""
echo "📋 Estado git actual:"
git status
echo ""
git log --oneline -3

# 3. Si hay cambios sin commitear, avisamos
if ! git diff --quiet || ! git diff --cached --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
  echo ""
  echo "⚠️  HAY CAMBIOS SIN COMMITEAR. Haz commit antes de cerrar:"
  echo "   git add -A && git commit -m 'wip: cambios pendientes al cerrar sesión' && git push origin main"
  exit 1
fi

# 4. Actualizar CHANGELOG si existe
if [ -f "$REPO_DIR/CHANGELOG.md" ]; then
  FECHA=$(date '+%Y-%m-%d %H:%M')
  echo "" >> "$REPO_DIR/CHANGELOG.md"
  echo "## Sesión cerrada: $FECHA" >> "$REPO_DIR/CHANGELOG.md"
  echo "- Cierre ordenado via cerrar-sesion.sh" >> "$REPO_DIR/CHANGELOG.md"
  git add CHANGELOG.md
  git commit -m "docs(diario): registro de cierre de sesión $FECHA"
  git push origin main
  echo "✅ CHANGELOG actualizado y pusheado."
fi

# 5. Confirmar estado limpio
echo ""
echo "✅ Sesión cerrada correctamente."
echo "   Último commit: $(git log --oneline -1)"
echo "   Repo: $REPO_DIR"
echo ""
echo "👋 Hasta la próxima, Álvaro."

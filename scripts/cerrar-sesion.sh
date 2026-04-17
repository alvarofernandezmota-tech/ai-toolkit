#!/bin/bash
# cerrar-sesion.sh — Cierre automático de sesión con commit semántico
# Uso: bash scripts/cerrar-sesion.sh "descripción opcional"

set -e

DESC=${1:-"cierre de sesión automático"}
FECHA=$(date +%Y-%m-%d)
HORA=$(date +%H:%M)

echo "🔒 Cerrando sesión $FECHA $HORA..."

# Ir a la raíz del repo
cd "$(git rev-parse --show-toplevel)"

# Ver qué hay pendiente
echo "\n📊 Estado actual:"
git status --short

# Añadir todo
git add -A

# Si no hay nada que commitear, salir
if git diff --cached --quiet; then
  echo "✅ Nada que commitear. Repo limpio."
  exit 0
fi

# Commit semántico con fecha
git commit -m "chore: $FECHA $HORA — $DESC"

# Push
git push origin main

echo "\n✅ Sesión cerrada y subida a GitHub."
echo "🔗 https://github.com/alvarofernandezmota-tech/ai-toolkit"

#!/bin/bash
# Herramienta: git-commit-push.sh
# Uso: bash herramientas/git-commit-push.sh "feat(agentes): mensaje"
# Hace git add -A + commit semántico + push a main

set -e

MENSAJE="${1:-'chore: update'}"
REPO_DIR="${2:-$(git rev-parse --show-toplevel 2>/dev/null || echo $PWD)}"

cd "$REPO_DIR"

if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo "❌ No es un repositorio git: $REPO_DIR"
  exit 1
fi

git add -A

if git diff --cached --quiet; then
  echo "⚠️  Nada que commitear en $REPO_DIR"
  exit 0
fi

git commit -m "$MENSAJE"
git push origin main

echo "✅ Commit y push OK: $MENSAJE"

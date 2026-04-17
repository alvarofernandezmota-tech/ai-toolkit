#!/bin/bash
# ==============================================================
# git-commit-push.sh
# Propósito: hacer git add . + commit semántico + push en una sola llamada
# Uso:      ./herramientas/git-commit-push.sh "tipo(scope): mensaje"
# Ejemplo:  ./herramientas/git-commit-push.sh "feat(agentes): añade orquestador.md"
# Códigos:  0 = éxito | 1 = error
# ==============================================================

set -e

MENSAJE="$1"

# --- Validaciones ---
if [ -z "$MENSAJE" ]; then
  echo "❌ ERROR: Debes pasar un mensaje de commit como primer parámetro."
  echo "   Uso: $0 \"tipo(scope): descripción\""
  echo "   Tipos válidos: feat | fix | docs | refactor | chore | test | style"
  exit 1
fi

# Validación de formato semántico (soft — avisa pero no bloquea)
if ! echo "$MENSAJE" | grep -qE '^(feat|fix|docs|refactor|chore|test|style|perf)(\([a-z0-9_-]+\))?: .+'; then
  echo "⚠️  AVISO: El mensaje no sigue el formato Conventional Commits."
  echo "   Formato esperado: tipo(scope): descripción"
  echo "   Continuando de todas formas..."
fi

# --- Comprobación de repo git ---
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo "❌ ERROR: No estás dentro de un repositorio git."
  exit 1
fi

# --- Ejecución ---
echo "📦 Haciendo git add ..."
git add .

echo "📝 Commiteando: '$MENSAJE'"
git commit -m "$MENSAJE"

BRANCH=$(git symbolic-ref --short HEAD)
echo "🚀 Push a origin/$BRANCH..."
git push origin "$BRANCH"

echo "✅ Listo. Commit pushed: '$MENSAJE' → $BRANCH"

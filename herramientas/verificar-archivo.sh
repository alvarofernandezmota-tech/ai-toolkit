#!/bin/bash
# ==============================================================
# verificar-archivo.sh
# Propósito: comprobar que un archivo existe en disco
# Uso:      ./herramientas/verificar-archivo.sh <ruta/al/archivo>
# Ejemplo:  ./herramientas/verificar-archivo.sh agentes/orquestador.md
# Salida:   ✅ OK: <ruta>  |  ❌ ERROR: no existe <ruta>
# Códigos:  0 = existe | 1 = no existe
# ==============================================================

set -e

RUTA="$1"

# --- Validación ---
if [ -z "$RUTA" ]; then
  echo "❌ ERROR: Debes pasar la ruta del archivo como parámetro."
  echo "   Uso: $0 <ruta/al/archivo>"
  exit 1
fi

# --- Resolución de ruta relativa a raíz del repo si existe git ---
if git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
  REPO_ROOT=$(git rev-parse --show-toplevel)
  # Si la ruta no es absoluta, buscar desde la raíz del repo
  if [[ "$RUTA" != /* ]]; then
    RUTA_ABSOLUTA="$REPO_ROOT/$RUTA"
  else
    RUTA_ABSOLUTA="$RUTA"
  fi
else
  RUTA_ABSOLUTA="$RUTA"
fi

# --- Verificación ---
if [ -f "$RUTA_ABSOLUTA" ]; then
  echo "✅ OK: $RUTA"
  exit 0
elif [ -d "$RUTA_ABSOLUTA" ]; then
  echo "ℹ️  DIRECTORIO: $RUTA (es una carpeta, no un archivo)"
  exit 0
else
  echo "❌ ERROR: no existe $RUTA"
  exit 1
fi

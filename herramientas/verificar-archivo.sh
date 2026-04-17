#!/bin/bash
# Herramienta: verificar-archivo.sh
# Uso: bash herramientas/verificar-archivo.sh ruta/al/archivo.md
# Comprueba que el archivo existe y no está vacío

ARCHIVO="${1}"

if [ -z "$ARCHIVO" ]; then
  echo "❌ Uso: bash herramientas/verificar-archivo.sh <ruta>"
  exit 1
fi

if [ ! -f "$ARCHIVO" ]; then
  echo "❌ No existe: $ARCHIVO"
  exit 1
fi

if [ ! -s "$ARCHIVO" ]; then
  echo "⚠️  Existe pero está vacío: $ARCHIVO"
  exit 1
fi

TAMANO=$(wc -c < "$ARCHIVO")
echo "✅ OK: $ARCHIVO ($TAMANIO bytes)"

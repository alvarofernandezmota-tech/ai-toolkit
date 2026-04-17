#!/bin/bash
# Herramienta: crear-ficha-agente.sh
# Uso: bash herramientas/crear-ficha-agente.sh nombre-agente "Descripción" "capacidad1, capacidad2"
# Genera agentes/<nombre-agente>.md con estructura estándar

set -e

NOMBRE="${1}"
DESCRIPCION="${2:-'Agente sin descripción'}"
CAPACIDADES="${3:-'por definir'}"

if [ -z "$NOMBRE" ]; then
  echo "❌ Uso: bash herramientas/crear-ficha-agente.sh <nombre> <descripcion> [capacidades]"
  exit 1
fi

REPO_DIR="$(git rev-parse --show-toplevel 2>/dev/null || echo $PWD)"
FICHA="$REPO_DIR/agentes/${NOMBRE}.md"

if [ -f "$FICHA" ]; then
  echo "⚠️  Ya existe: $FICHA"
  exit 0
fi

FECHA=$(date +%Y-%m-%d)

cat > "$FICHA" << EOF
# Agente: ${NOMBRE}

> Creado: ${FECHA}

## Qué hace
${DESCRIPCION}

## Modelos recomendados
- groq-fallback (Llama 3.3 70B) — planificación y tool calls
- qwen2.5-coder:14b — generación de código puro

## Capacidades
${CAPACIDADES}

## Inputs
- por definir

## Output
- por definir

## Script asociado
\`scripts/${NOMBRE}.sh\`
EOF

echo "✅ Ficha creada: $FICHA"

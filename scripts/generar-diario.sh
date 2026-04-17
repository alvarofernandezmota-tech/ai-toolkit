#!/bin/bash
# generar-diario.sh — Crea la entrada del diario del día actual
# Uso: ./scripts/generar-diario.sh

FECHA=$(date +%Y-%m-%d)
mkdir -p diario
FICHERO="diario/${FECHA}.md"

if [ -f "$FICHERO" ]; then
  echo "📋 Ya existe: $FICHERO"
  exit 0
fi

cat > "$FICHERO" << EOF
# 📅 Diario ${FECHA}

## Objetivos del día
- 

## Tareas completadas
- 

## Bloqueantes / problemas
- 

## Notas

EOF

chmod +x scripts/generar-diario.sh 2>/dev/null || true
echo "✅ Creado: $FICHERO"

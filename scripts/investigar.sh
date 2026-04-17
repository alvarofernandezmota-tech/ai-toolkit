#!/bin/bash
# investigar.sh — Búsqueda automática y guardado en investigacion/
# Uso: bash scripts/investigar.sh "tema a investigar"
# Requiere: PERPLEXITY_API_KEY en el entorno o .env

set -e

TEMA=${1:-"estado del arte agentes IA"}
FECHA=$(date +%Y-%m-%d)
SLUG=$(echo "$TEMA" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-')
FICHERO="investigacion/$FECHA-$SLUG.md"

echo "🔍 Investigando: $TEMA"
echo "📁 Guardando en: $FICHERO"

# Crear directorio si no existe
mkdir -p investigacion

# Si no hay API key, crear plantilla manual
if [ -z "$PERPLEXITY_API_KEY" ]; then
  echo "⚠️  PERPLEXITY_API_KEY no encontrada. Creando plantilla manual..."
  cat > "$FICHERO" << EOF
# Investigación: $TEMA

> Fecha: $FECHA
> Fuente: Manual (sin API key)

## Pregunta
$TEMA

## Hallazgos

<!-- Añade aquí los hallazgos -->

## Fuentes

<!-- Añade aquí las fuentes -->

## Conclusiones

<!-- Añade aquí las conclusiones -->
EOF
  echo "✅ Plantilla creada: $FICHERO"
  exit 0
fi

# Con API key — llamar a Perplexity
RESPUESTA=$(curl -s https://api.perplexity.ai/chat/completions \
  -H "Authorization: Bearer $PERPLEXITY_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"sonar\",
    \"messages\": [{
      \"role\": \"user\",
      \"content\": \"Investiga en detalle: $TEMA. Dame hallazgos clave, estado del arte actual, y conclusiones prácticas. Incluye fuentes.\"
    }]
  }")

# Extraer contenido
CONTENIDO=$(echo "$RESPUESTA" | python3 -c "import sys,json; print(json.load(sys.stdin)['choices'][0]['message']['content'])" 2>/dev/null || echo "Error procesando respuesta")

# Guardar
cat > "$FICHERO" << EOF
# Investigación: $TEMA

> Fecha: $FECHA
> Fuente: Perplexity Sonar API

$CONTENIDO
EOF

echo "✅ Investigación guardada: $FICHERO"

# Commit automático
git add "$FICHERO"
git commit -m "research: $FECHA — $TEMA"
git push origin main

echo "🔗 Subido a GitHub"

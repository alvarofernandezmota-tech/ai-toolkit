#!/bin/bash
# ==============================================================
# crear-ficha-agente.sh
# Propósito: generar una ficha .md en agentes/ con plantilla estándar
# Uso:      ./herramientas/crear-ficha-agente.sh <nombre> <"descripcion">
# Ejemplo:  ./herramientas/crear-ficha-agente.sh revisor-codigo "Revisa PRs y sugiere mejoras"
# Códigos:  0 = éxito | 1 = error
# ==============================================================

set -e

NOMBRE="$1"
DESCRIPCION="$2"
FECHA=$(date +"%Y-%m-%d")

# --- Validaciones ---
if [ -z "$NOMBRE" ]; then
  echo "❌ ERROR: Debes pasar el nombre del agente como primer parámetro."
  echo "   Uso: $0 <nombre> <\"descripcion\">"
  exit 1
fi

if [ -z "$DESCRIPCION" ]; then
  echo "❌ ERROR: Debes pasar la descripción del agente como segundo parámetro."
  echo "   Uso: $0 <nombre> <\"descripcion\">"
  exit 1
fi

# Normalizar nombre: minúsculas, espacios por guiones
NOMBRE_NORM=$(echo "$NOMBRE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

# Resolver ruta relativa a la raíz del repo
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
DEST="$REPO_ROOT/agentes/${NOMBRE_NORM}.md"

# --- Comprobación: no sobreescribir ---
if [ -f "$DEST" ]; then
  echo "⚠️  AVISO: Ya existe $DEST. No se sobreescribirá."
  echo "   Elimina el archivo manualmente si quieres regenerarlo."
  exit 1
fi

# --- Crear carpeta si no existe ---
mkdir -p "$REPO_ROOT/agentes"

# --- Escribir plantilla ---
cat > "$DEST" << EOF
# 🤖 Agente: ${NOMBRE_NORM}

> ${DESCRIPCION}

---

## Propósito

<!-- Describe en 2-3 frases qué hace este agente y cuándo se usa -->

---

## Entradas

| Parámetro | Tipo | Descripción |
|---|---|---|
| - | - | - |

---

## Salidas

| Salida | Tipo | Descripción |
|---|---|---|
| - | - | - |

---

## Prompt base

\`\`\`
<!-- Pega aquí el prompt o instrucciones del agente -->
\`\`\`

---

## Herramientas / dependencias

- [ ] LLM: <!-- modelo usado -->
- [ ] Scripts: <!-- scripts que invoca -->
- [ ] APIs: <!-- si consume APIs externas -->

---

## Ejemplos de uso

\`\`\`bash
# Ejemplo 1
\`\`\`

---

## Estado

- [ ] Diseñado
- [ ] Probado manualmente
- [ ] Integrado en flujo

---

_Ficha creada: ${FECHA} | Parte del Sistema Colmena — ai-toolkit_
EOF

echo "✅ Ficha creada: $DEST"

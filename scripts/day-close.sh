#!/bin/bash
# =============================================================================
# day-close.sh — Cierre del día con logros y prioridad mañana
# Ejecutar al terminar la jornada de trabajo
#
# Uso:
#   bash scripts/day-close.sh
#
# Hace:
#   - Pregunta 3 logros del día
#   - Pregunta un error o aprendizaje
#   - Pregunta la prioridad de mañana
#   - Lo guarda en diario/YYYY-MM-DD.md
#   - Hace commit automático del diario
# =============================================================================

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.."; pwd)"
DIARIO_DIR="$REPO_DIR/diario"
HOY=$(date '+%Y-%m-%d')
ARCHIVO_DIARIO="$DIARIO_DIR/${HOY}.md"

echo ""
echo -e "${BOLD}${CYAN}  ╔══════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}  ║  🌙 Day Close — $(date '+%d %B %Y, %H:%M')${NC}"
echo -e "${BOLD}${CYAN}  ╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${DIM}Tómate 2 minutos. Esto construye tu memoria.${NC}"
echo ""

# ─── 3 logros del día ─────────────────────────────────────────────────────────
echo -e "${BOLD}  ✅ 3 cosas de las que estás orgulloso hoy:${NC}"
read -rp "  1. " LOGRO1
read -rp "  2. " LOGRO2
read -rp "  3. " LOGRO3

echo ""

# ─── Error o aprendizaje ──────────────────────────────────────────────────────
echo -e "${BOLD}  🔁 Un error o aprendizaje a recordar:${NC}"
read -rp "  → " ERROR

echo ""

# ─── Prioridad mañana ─────────────────────────────────────────────────────────
echo -e "${BOLD}  🎯 Prioridad número 1 de mañana:${NC}"
read -rp "  → " PRIORIDAD

echo ""

# ─── Guardar en diario ────────────────────────────────────────────────────────
mkdir -p "$DIARIO_DIR"

if [ -f "$ARCHIVO_DIARIO" ]; then
  # Añadir al final del diario existente
  cat >> "$ARCHIVO_DIARIO" << EOF

---

## 🌙 Cierre del día — $(date '+%H:%M')

### ✅ Logros
1. $LOGRO1
2. $LOGRO2
3. $LOGRO3

### 🔁 Error / Aprendizaje
$ERROR

### 🎯 Prioridad mañana
$PRIORIDAD

_Registrado: $(date '+%Y-%m-%d %H:%M')_
EOF
  echo -e "  ${GREEN}✓${NC} Añadido al diario existente: $ARCHIVO_DIARIO"
else
  # Crear nuevo diario del día
  cat > "$ARCHIVO_DIARIO" << EOF
# Diario — $HOY

---

## 🌙 Cierre del día — $(date '+%H:%M')

### ✅ Logros
1. $LOGRO1
2. $LOGRO2
3. $LOGRO3

### 🔁 Error / Aprendizaje
$ERROR

### 🎯 Prioridad mañana
$PRIORIDAD

_Registrado: $(date '+%Y-%m-%d %H:%M')_
EOF
  echo -e "  ${GREEN}✓${NC} Diario creado: $ARCHIVO_DIARIO"
fi

# ─── Commit automático ────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}  💾 Guardando en git...${NC}"

cd "$REPO_DIR"

if git diff --quiet && git diff --staged --quiet; then
  echo -e "  ${DIM}Sin cambios que commitear${NC}"
else
  git add "$ARCHIVO_DIARIO" 2>/dev/null || true
  git add context/ projects/ areas/ 2>/dev/null || true
  git commit -m "diario: cierre del día $HOY

- $LOGRO1
- $LOGRO2
→ mañana: $PRIORIDAD" 2>/dev/null && \
  echo -e "  ${GREEN}✓${NC} Commit guardado" || \
  echo -e "  ${YELLOW}⚠${NC} No se pudo hacer commit (puede que ya esté limpio)"
fi

echo ""
echo -e "  ${GREEN}${BOLD}Bien hecho. Hasta mañana. 🌙${NC}"
echo -e "  ${DIM}Mañana empieza con: bash scripts/morning.sh${NC}"
echo ""

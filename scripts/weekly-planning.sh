#!/bin/bash
# =============================================================================
# weekly-planning.sh — Plan de semana desde diarios y ROADMAP
# Ejecutar cada lunes por la mañana
#
# Uso:
#   bash scripts/weekly-planning.sh
#
# Genera:
#   - Resumen de la semana anterior (desde diarios)
#   - Tareas pendientes priorizadas por urgencia
#   - Propuesta de distribución por días
#   - Guarda en diario/YYYY-WXX-weekly.md
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
ROADMAP="$REPO_DIR/ROADMAP.md"
CONTEXT_DIR="$REPO_DIR/context"

WEEK_NUM=$(date '+%V')
YEAR=$(date '+%Y')
OUTPUT="$DIARIO_DIR/${YEAR}-W${WEEK_NUM}-weekly.md"

echo ""
echo -e "${BOLD}${CYAN}  ╔══════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}  ║  📅 Weekly Planning — Semana $WEEK_NUM / $YEAR  ║${NC}"
echo -e "${BOLD}${CYAN}  ╚══════════════════════════════════════════╝${NC}"
echo ""

# ─── Recopilar diarios de la última semana ────────────────────────────────────
echo -e "${BOLD}  📓 Diarios de la semana pasada:${NC}"
SEMANA_PASADA=$(date -d '7 days ago' '+%Y-%m-%d' 2>/dev/null || date -v-7d '+%Y-%m-%d' 2>/dev/null || echo "")
DIARIOS_SEMANA=$()
if [ -n "$SEMANA_PASADA" ] && [ -d "$DIARIO_DIR" ]; then
  while IFS= read -r f; do
    NOMBRE=$(basename "$f" .md)
    if [[ "$NOMBRE" > "$SEMANA_PASADA" ]] || [[ "$NOMBRE" == "$SEMANA_PASADA" ]]; then
      echo -e "  ${GREEN}✓${NC} $NOMBRE"
      DIARIOS_SEMANA+=("$f")
    fi
  done < <(find "$DIARIO_DIR" -name '*.md' ! -name '*weekly*' | sort)
fi

if [ ${#DIARIOS_SEMANA[@]} -eq 0 ]; then
  echo -e "  ${DIM}Sin diarios esta semana todavía${NC}"
fi

echo ""

# ─── Pendientes por prioridad ─────────────────────────────────────────────────
echo -e "${BOLD}  🎯 Pendientes por prioridad:${NC}"

echo -e "  ${BOLD}🔴 Urgente:${NC}"
IN_SECTION=false
SECTION_FOUND=false
while IFS= read -r line; do
  if echo "$line" | grep -q "Urgente"; then IN_SECTION=true; SECTION_FOUND=true; fi
  if $SECTION_FOUND && ! $IN_SECTION && echo "$line" | grep -q "^## "; then break; fi
  if echo "$line" | grep -q "^## " && ! echo "$line" | grep -q "Urgente"; then IN_SECTION=false; fi
  if $IN_SECTION && echo "$line" | grep -q "^- \[ \]"; then
    echo -e "    • ${line#- [ ] }"
  fi
done < "$ROADMAP"

echo -e "  ${BOLD}🟡 Alta prioridad:${NC}"
IN_SECTION=false
SECTION_FOUND=false
while IFS= read -r line; do
  if echo "$line" | grep -q "Alta prioridad"; then IN_SECTION=true; SECTION_FOUND=true; fi
  if $SECTION_FOUND && ! $IN_SECTION && echo "$line" | grep -q "^## "; then break; fi
  if echo "$line" | grep -q "^## " && ! echo "$line" | grep -q "Alta prioridad"; then IN_SECTION=false; fi
  if $IN_SECTION && echo "$line" | grep -q "^- \[ \]"; then
    echo -e "    • ${line#- [ ] }"
  fi
done < "$ROADMAP"

echo ""

# ─── Generar archivo weekly ───────────────────────────────────────────────────
echo -e "${BOLD}  📝 Generando plan en: $OUTPUT${NC}"

cat > "$OUTPUT" << WEEKLY
# Weekly Planning — Semana $WEEK_NUM / $YEAR

> Generado: $(date '+%Y-%m-%d %H:%M')
> Ejecutar cada lunes. Revisar con morning.sh cada día.

---

## 🎯 Foco de la semana

<!-- Escribe aquí el objetivo principal de la semana -->

---

## 🔴 Urgente esta semana

WEEKLY

# Añadir items urgentes
IN_SECTION=false
while IFS= read -r line; do
  if echo "$line" | grep -q "Urgente"; then IN_SECTION=true; fi
  if echo "$line" | grep -q "^## " && ! echo "$line" | grep -q "Urgente"; then IN_SECTION=false; fi
  if $IN_SECTION && echo "$line" | grep -q "^- \[ \]"; then
    echo "$line" >> "$OUTPUT"
  fi
done < "$ROADMAP"

cat >> "$OUTPUT" << WEEKLY2

## 🟡 Alta prioridad

WEEKLY2

IN_SECTION=false
while IFS= read -r line; do
  if echo "$line" | grep -q "Alta prioridad"; then IN_SECTION=true; fi
  if echo "$line" | grep -q "^## " && ! echo "$line" | grep -q "Alta prioridad"; then IN_SECTION=false; fi
  if $IN_SECTION && echo "$line" | grep -q "^- \[ \]"; then
    echo "$line" >> "$OUTPUT"
  fi
done < "$ROADMAP"

cat >> "$OUTPUT" << WEEKLY3

## 📅 Distribución por días

| Día | Tarea principal | Estimado |
|---|---|---|
| Lunes | | |
| Martes | | |
| Miércoles | | |
| Jueves | | |
| Viernes | | |

## 📓 Resumen semana anterior

<!-- Qué se completó, qué bloqueó, qué aprendiste -->

---

_Generado por scripts/weekly-planning.sh_
WEEKLY3

echo -e "  ${GREEN}✓${NC} Plan guardado en $OUTPUT"
echo ""
echo -e "  ${DIM}Edita el archivo para añadir el foco y distribución por días${NC}"
echo -e "  ${DIM}Cada mañana: bash scripts/morning.sh${NC}"
echo ""

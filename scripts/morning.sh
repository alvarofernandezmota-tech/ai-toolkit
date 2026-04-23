#!/bin/bash
# =============================================================================
# morning.sh — Contexto del día en 30 segundos
# Léelo al inicio de cada sesión de trabajo
#
# Uso:
#   bash scripts/morning.sh
#
# Muestra:
#   - Estado del ecosistema (servicios, keys)
#   - Última entrada del diario
#   - Tareas pendientes urgentes del ROADMAP
#   - Rama activa de repos principales
# =============================================================================

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.."; pwd)"
DIARIO_DIR="$REPO_DIR/diario"
ROADMAP="$REPO_DIR/ROADMAP.md"

echo ""
echo -e "${BOLD}${CYAN}  ╔══════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}  ║  🌅 Morning — $(date '+%A %d %B %Y %H:%M')${NC}"
echo -e "${BOLD}${CYAN}  ╚══════════════════════════════════════════╝${NC}"
echo ""

# ─── 1. Servicios ─────────────────────────────────────────────────────────────
echo -e "${BOLD}  📡 Servicios${NC}"

# LiteLLM
LITE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 2 \
  -H "Authorization: Bearer sk-litellm-local" \
  http://localhost:8000/health 2>/dev/null || echo "000")
if [[ "$LITE" == "200" ]]; then
  echo -e "  ${GREEN}✓${NC} LiteLLM proxy :8000 — operativo"
else
  echo -e "  ${YELLOW}⚠${NC} LiteLLM proxy :8000 — no está corriendo"
  echo -e "    ${DIM}→ bash scripts/start-colmena.sh${NC}"
fi

# Ollama
OLLAMA=$(curl -s -o /dev/null -w "%{http_code}" --max-time 2 \
  http://localhost:11434 2>/dev/null || echo "000")
if [[ "$OLLAMA" == "200" ]]; then
  echo -e "  ${GREEN}✓${NC} Ollama :11434 — operativo"
else
  echo -e "  ${YELLOW}⚠${NC} Ollama — no está corriendo → ollama serve"
fi

echo ""

# ─── 2. Último diario ─────────────────────────────────────────────────────────
echo -e "${BOLD}  📓 Última sesión documentada${NC}"
ULTIMO_DIARIO=$(ls "$DIARIO_DIR"/*.md 2>/dev/null | sort -r | head -1)
if [ -n "$ULTIMO_DIARIO" ]; then
  NOMBRE=$(basename "$ULTIMO_DIARIO")
  echo -e "  ${CYAN}→ $NOMBRE${NC}"
  # Mostrar primeras líneas relevantes
  grep -m 5 '^##\|^- \|^\*\*' "$ULTIMO_DIARIO" 2>/dev/null | head -5 | \
    while IFS= read -r line; do echo -e "  ${DIM}$line${NC}"; done || true
else
  echo -e "  ${DIM}Sin diarios todavía${NC}"
fi

echo ""

# ─── 3. Pendientes urgentes del ROADMAP ───────────────────────────────────────
echo -e "${BOLD}  🔴 Urgente (ROADMAP)${NC}"
if [ -f "$ROADMAP" ]; then
  # Extraer items bajo la sección Urgente
  IN_URGENTE=false
  while IFS= read -r line; do
    if echo "$line" | grep -q "Urgente"; then
      IN_URGENTE=true
    elif echo "$line" | grep -q "^## "; then
      IN_URGENTE=false
    fi
    if $IN_URGENTE && echo "$line" | grep -q "^- \[ \]"; then
      echo -e "  ${RED}•${NC} ${line#- [ ] }"
    fi
  done < "$ROADMAP"
fi

echo ""

# ─── 4. Rama activa repos ─────────────────────────────────────────────────────
echo -e "${BOLD}  🌿 Repos${NC}"

for repo_path in "$HOME/ai-toolkit" "$HOME/thdora" "$HOME/personal"; do
  if [ -d "$repo_path/.git" ]; then
    REPO_NAME=$(basename "$repo_path")
    BRANCH=$(git -C "$repo_path" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "?")
    COMMITS_AHEAD=$(git -C "$repo_path" rev-list --count @{u}..HEAD 2>/dev/null || echo "0")
    if [[ "$COMMITS_AHEAD" -gt 0 ]]; then
      echo -e "  ${GREEN}✓${NC} $REPO_NAME → ${CYAN}$BRANCH${NC} ${YELLOW}($COMMITS_AHEAD commit(s) por pushear)${NC}"
    else
      echo -e "  ${GREEN}✓${NC} $REPO_NAME → ${CYAN}$BRANCH${NC}"
    fi
  fi
done

echo ""
echo -e "  ${DIM}→ Para diagnóstico completo: bash scripts/health-check.sh${NC}"
echo -e "  ${DIM}→ Para arrancar todo: bash scripts/start-colmena.sh${NC}"
echo ""

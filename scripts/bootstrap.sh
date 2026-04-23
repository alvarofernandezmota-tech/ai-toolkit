#!/bin/bash
# =============================================================================
# bootstrap.sh — Estado completo del ecosistema en 30 segundos
# Ejecutar al inicio de cada sesión para orientarse rápido
#
# Uso:
#   bash scripts/bootstrap.sh
#
# Muestra:
#   - Servicios corriendo (LiteLLM, Ollama)
#   - Keys disponibles (sin revelar valores)
#   - Rama activa de cada repo
#   - Últimas 3 tareas pendientes del ROADMAP
#   - Comando de arranque recomendado
# =============================================================================

set -uo pipefail

# ─── Colores ─────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

ok()   { echo -e "${GREEN}✓${NC} $*"; }
warn() { echo -e "${YELLOW}⚠${NC}  $*"; }
fail() { echo -e "${RED}✗${NC} $*"; }
info() { echo -e "${DIM}  $*${NC}"; }

# ─── Header ────────────────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}${CYAN}╔═════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║   🧠  ai-toolkit bootstrap — $(date '+%Y-%m-%d %H:%M')    ║${NC}"
echo -e "${BOLD}${CYAN}╚═════════════════════════════════════════════╝${NC}"
echo ""

# ─── 1. SERVICIOS ─────────────────────────────────────────────────────────────
echo -e "${BOLD}  📡 Servicios${NC}"

# LiteLLM proxy
LITELLM_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
  --max-time 2 \
  -H "Authorization: Bearer sk-litellm-local" \
  http://localhost:8000/health 2>/dev/null || echo "000")

if [[ "$LITELLM_STATUS" == "200" ]]; then
  MODEL_COUNT=$(curl -s -H "Authorization: Bearer sk-litellm-local" \
    http://localhost:8000/v1/models 2>/dev/null | \
    python3 -c "import sys,json; d=json.load(sys.stdin); print(len(d.get('data',[])))" 2>/dev/null || echo "?")
  ok "LiteLLM proxy :8000  —  ${MODEL_COUNT} modelos"
elif [[ "$LITELLM_STATUS" == "000" ]]; then
  warn "LiteLLM proxy :8000  —  NO está corriendo"
else
  warn "LiteLLM proxy :8000  —  HTTP $LITELLM_STATUS"
fi

# Ollama
OLLAMA_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
  --max-time 2 http://localhost:11434 2>/dev/null || echo "000")

if [[ "$OLLAMA_STATUS" == "200" ]]; then
  OLLAMA_MODELS=$(curl -s http://localhost:11434/api/tags 2>/dev/null | \
    python3 -c "import sys,json; d=json.load(sys.stdin); names=[m['name'] for m in d.get('models',[])]; print(', '.join(names) if names else 'ninguno')" 2>/dev/null || echo "?")
  ok "Ollama :11434  —  $OLLAMA_MODELS"
elif [[ "$OLLAMA_STATUS" == "000" ]]; then
  warn "Ollama :11434  —  NO está corriendo  (ollama serve &)"
else
  warn "Ollama :11434  —  HTTP $OLLAMA_STATUS"
fi

# Uvicorn / THDORA
THDORA_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
  --max-time 2 http://localhost:8001 2>/dev/null || echo "000")
if [[ "$THDORA_STATUS" == "200" || "$THDORA_STATUS" == "404" ]]; then
  ok "THDORA :8001  —  corriendo"
elif [[ "$THDORA_STATUS" == "000" ]]; then
  info "THDORA :8001  —  no iniciado (normal si no trabajas en thdora)"
fi

echo ""

# ─── 2. KEYS ──────────────────────────────────────────────────────────────────
echo -e "${BOLD}  🔑 Keys de entorno${NC}"

check_key() {
  local label="$1"
  local val="$2"
  local hint="$3"
  if [ -n "$val" ]; then
    ok "$label  —  definida"
  else
    warn "$label  —  NO definida  ($hint)"
  fi
}

check_key "OPENROUTER_API_KEY" "${OPENROUTER_API_KEY:-}"   "obligatoria para Claude Code"
check_key "GROQ_API_KEY"       "${GROQ_API_KEY:-}"         "console.groq.com/keys"
check_key "DEEPSEEK_API_KEY"   "${DEEPSEEK_API_KEY:-}"     "platform.deepseek.com"
check_key "GEMINI_API_KEY"     "${GOOGLE_GENERATIVE_AI_API_KEY:-}" "aistudio.google.com"
check_key "CEREBRAS_API_KEY"   "${CEREBRAS_API_KEY:-}"     "cloud.cerebras.ai"

echo ""

# ─── 3. REPOS ──────────────────────────────────────────────────────────────────
echo -e "${BOLD}  📁 Repos${NC}"

show_repo() {
  local label="$1"
  local path="$2"
  if [ -d "$path/.git" ]; then
    local branch
    branch=$(git -C "$path" branch --show-current 2>/dev/null || echo "?")
    local dirty
    dirty=$(git -C "$path" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    local last
    last=$(git -C "$path" log -1 --format="%s" 2>/dev/null | cut -c1-50 || echo "?")
    if [ "$dirty" -gt 0 ]; then
      warn "$label  [$branch]  —  ${dirty} cambio(s) sin commit  —  \"$last\""
    else
      ok "$label  [$branch]  —  limpio  —  \"$last\""
    fi
  else
    info "$label  —  no encontrado en $path"
  fi
}

show_repo "ai-toolkit" "$HOME/projects/ai-toolkit"
show_repo "thdora"     "$HOME/projects/thdora"

echo ""

# ─── 4. PENDIENTES (desde ROADMAP) ───────────────────────────────────────────
echo -e "${BOLD}  🟥 Urgente (ROADMAP)${NC}"

ROADMAP="$HOME/projects/ai-toolkit/ROADMAP.md"
if [ -f "$ROADMAP" ]; then
  grep -A 20 '## .*Urgente' "$ROADMAP" | grep '\- \[ \]' | head -5 | while IFS= read -r line; do
    task=$(echo "$line" | sed 's/.*\[ \] //')
    echo -e "  ${RED}●${NC}  $task"
  done
else
  info "ROADMAP.md no encontrado"
fi

echo ""

# ─── 5. COMANDO RECOMENDADO ───────────────────────────────────────────────────
echo -e "${BOLD}  ▶ Arranque rápido${NC}"
echo ""

if [[ "$LITELLM_STATUS" == "200" ]]; then
  info "Proxy ya corriendo. Lanza OpenCode directamente:"
  echo -e "      ${BOLD}opencode${NC}"
else
  info "Arrancar todo:"
  echo -e "      ${BOLD}bash scripts/start-colmena.sh --colmena-full${NC}"
fi

if [ -n "${OPENROUTER_API_KEY:-}" ]; then
  echo ""
  info "Claude Code (desde Acer vía SSH):"
  echo -e "      ${BOLD}bash scripts/start-colmena.sh --claude-acer${NC}"
fi

echo ""
echo -e "  ${DIM}Diagnóstico completo: bash scripts/health-check.sh${NC}"
echo -e "  ${DIM}Diagnóstico con chat real: bash scripts/health-check.sh --full${NC}"
echo ""

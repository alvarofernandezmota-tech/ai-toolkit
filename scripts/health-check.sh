#!/bin/bash
# =============================================================================
# health-check.sh — Diagnóstico de APIs antes de empezar sesión
# Testea todos los proveedores y muestra un semáforo claro
#
# Uso:
#   bash scripts/health-check.sh          # test rápido (solo ping)
#   bash scripts/health-check.sh --full   # test con respuesta real
#   bash scripts/health-check.sh --fix    # muestra comandos de arreglo
#
# Devuelve:
#   exit 0 → al menos 1 proveedor operativo
#   exit 1 → ningún proveedor disponible
# =============================================================================

set -euo pipefail

# ─── Colores ─────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

MODE="${1:-}"
TIMEOUT=6
FULL_TEST=false
SHOW_FIX=false
[[ "$MODE" == "--full" ]] && FULL_TEST=true
[[ "$MODE" == "--fix"  ]] && SHOW_FIX=true

# ─── Resultados globales ──────────────────────────────────────────────────────
declare -A STATUS
declare -A DETAIL
declare -A LATENCY
AVAILABLE=0
TOTAL=0

# ─── Helpers ─────────────────────────────────────────────────────────────────
icon() {
  case "$1" in
    ok)   echo -e "${GREEN}✓${NC}" ;;
    warn) echo -e "${YELLOW}⚠${NC}" ;;
    fail) echo -e "${RED}✗${NC}" ;;
    skip) echo -e "${DIM}~${NC}" ;;
  esac
}

ms_since() {
  local start="$1"
  local end
  end=$(date +%s%3N)
  echo $(( end - start ))
}

ping_api() {
  local url="$1"
  local auth_header="$2"
  local start
  start=$(date +%s%3N)
  local code
  code=$(curl -s -o /dev/null -w "%{http_code}" \
    --max-time "$TIMEOUT" \
    -H "$auth_header" \
    "$url" 2>/dev/null || echo "000")
  echo "$code|$(ms_since "$start")"
}

chat_api() {
  local url="$1"
  local auth_header="$2"
  local model="$3"
  local start
  start=$(date +%s%3N)
  local raw
  raw=$(curl -s --max-time 15 \
    -H "$auth_header" \
    -H "Content-Type: application/json" \
    -d "{\"model\":\"$model\",\"messages\":[{\"role\":\"user\",\"content\":\"Di solo: OK\"}],\"max_tokens\":5}" \
    "$url/chat/completions" 2>/dev/null)
  local code
  code=$(echo "$raw" | python3 -c "
import sys,json
try:
    d=json.load(sys.stdin)
    if 'choices' in d: print('200')
    elif 'error' in d: print(d.get('error',{}).get('code','err'))
    else: print('err')
except: print('err')
" 2>/dev/null || echo "err")
  echo "$code|$(ms_since "$start")"
}

# ─── Tests por proveedor ──────────────────────────────────────────────────────

test_cerebras() {
  local name="Cerebras"
  local key="${CEREBRAS_API_KEY:-}"
  TOTAL=$((TOTAL+1))
  if [ -z "$key" ]; then
    STATUS[$name]="skip"; DETAIL[$name]="CEREBRAS_API_KEY no definida"; return
  fi
  if $FULL_TEST; then
    local result
    result=$(chat_api "https://api.cerebras.ai/v1" "Authorization: Bearer $key" "gpt-oss-120b")
    local code="${result%%|*}"; local lat="${result##*|}"
    LATENCY[$name]="${lat}ms"
    if [[ "$code" == "200" ]]; then
      STATUS[$name]="ok"; DETAIL[$name]="gpt-oss-120b · ${lat}ms"; AVAILABLE=$((AVAILABLE+1))
    else
      STATUS[$name]="fail"; DETAIL[$name]="HTTP $code"
    fi
  else
    local result
    result=$(ping_api "https://api.cerebras.ai/v1/models" "Authorization: Bearer $key")
    local code="${result%%|*}"; local lat="${result##*|}"
    LATENCY[$name]="${lat}ms"
    if [[ "$code" == "200" ]]; then
      STATUS[$name]="ok"; DETAIL[$name]="key válida · ${lat}ms"; AVAILABLE=$((AVAILABLE+1))
    elif [[ "$code" == "401" ]]; then
      STATUS[$name]="fail"; DETAIL[$name]="key inválida o caducada"
    else
      STATUS[$name]="fail"; DETAIL[$name]="HTTP $code"
    fi
  fi
}

test_openrouter() {
  local name="OpenRouter"
  local key="${OPENROUTER_API_KEY:-}"
  TOTAL=$((TOTAL+1))
  if [ -z "$key" ]; then
    STATUS[$name]="skip"; DETAIL[$name]="OPENROUTER_API_KEY no definida"; return
  fi
  if $FULL_TEST; then
    local result
    result=$(chat_api "https://openrouter.ai/api/v1" "Authorization: Bearer $key" "meta-llama/llama-3.3-70b-instruct:free")
    local code="${result%%|*}"; local lat="${result##*|}"
    LATENCY[$name]="${lat}ms"
    if [[ "$code" == "200" ]]; then
      STATUS[$name]="ok"; DETAIL[$name]="llama-3.3-70b:free · ${lat}ms"; AVAILABLE=$((AVAILABLE+1))
    else
      STATUS[$name]="fail"; DETAIL[$name]="HTTP $code"
    fi
  else
    local result
    result=$(ping_api "https://openrouter.ai/api/v1/models" "Authorization: Bearer $key")
    local code="${result%%|*}"; local lat="${result##*|}"
    LATENCY[$name]="${lat}ms"
    if [[ "$code" == "200" ]]; then
      STATUS[$name]="ok"; DETAIL[$name]="key válida · ${lat}ms"; AVAILABLE=$((AVAILABLE+1))
    elif [[ "$code" == "401" ]]; then
      STATUS[$name]="fail"; DETAIL[$name]="key inválida"
    else
      STATUS[$name]="fail"; DETAIL[$name]="HTTP $code"
    fi
  fi
}

test_groq() {
  local name="Groq"
  local key="${GROQ_API_KEY:-}"
  TOTAL=$((TOTAL+1))
  if [ -z "$key" ]; then
    STATUS[$name]="skip"; DETAIL[$name]="GROQ_API_KEY no definida"; return
  fi
  if $FULL_TEST; then
    local result
    result=$(chat_api "https://api.groq.com/openai/v1" "Authorization: Bearer $key" "llama-3.3-70b-versatile")
    local code="${result%%|*}"; local lat="${result##*|}"
    LATENCY[$name]="${lat}ms"
    if [[ "$code" == "200" ]]; then
      STATUS[$name]="ok"; DETAIL[$name]="llama-3.3-70b · ${lat}ms"; AVAILABLE=$((AVAILABLE+1))
    elif [[ "$code" == "401" ]]; then
      STATUS[$name]="fail"; DETAIL[$name]="key caducada → renovar en console.groq.com"
    elif [[ "$code" == "429" ]]; then
      STATUS[$name]="warn"; DETAIL[$name]="rate limit — resetea a medianoche UTC"
    else
      STATUS[$name]="fail"; DETAIL[$name]="HTTP $code"
    fi
  else
    local result
    result=$(ping_api "https://api.groq.com/openai/v1/models" "Authorization: Bearer $key")
    local code="${result%%|*}"; local lat="${result##*|}"
    LATENCY[$name]="${lat}ms"
    if [[ "$code" == "200" ]]; then
      STATUS[$name]="ok"; DETAIL[$name]="key válida · ${lat}ms"; AVAILABLE=$((AVAILABLE+1))
    elif [[ "$code" == "401" ]]; then
      STATUS[$name]="fail"; DETAIL[$name]="key caducada → renovar en console.groq.com"
    else
      STATUS[$name]="fail"; DETAIL[$name]="HTTP $code"
    fi
  fi
}

test_gemini() {
  local name="Gemini"
  local key="${GOOGLE_GENERATIVE_AI_API_KEY:-}"
  TOTAL=$((TOTAL+1))
  if [ -z "$key" ]; then
    STATUS[$name]="skip"; DETAIL[$name]="GOOGLE_GENERATIVE_AI_API_KEY no definida"; return
  fi
  local result
  result=$(ping_api \
    "https://generativelanguage.googleapis.com/v1beta/models?key=$key" \
    "Content-Type: application/json")
  local code="${result%%|*}"; local lat="${result##*|}"
  LATENCY[$name]="${lat}ms"
  if [[ "$code" == "200" ]]; then
    STATUS[$name]="ok"; DETAIL[$name]="key válida · ${lat}ms"; AVAILABLE=$((AVAILABLE+1))
  elif [[ "$code" == "429" ]]; then
    STATUS[$name]="warn"; DETAIL[$name]="rate limit free tier — resetea medianoche PT"
  elif [[ "$code" == "400" || "$code" == "403" ]]; then
    STATUS[$name]="fail"; DETAIL[$name]="key inválida"
  else
    STATUS[$name]="fail"; DETAIL[$name]="HTTP $code"
  fi
}

test_deepseek() {
  local name="DeepSeek"
  local key="${DEEPSEEK_API_KEY:-}"
  TOTAL=$((TOTAL+1))
  if [ -z "$key" ]; then
    STATUS[$name]="skip"; DETAIL[$name]="DEEPSEEK_API_KEY no definida"; return
  fi
  local result
  result=$(ping_api "https://api.deepseek.com/v1/models" "Authorization: Bearer $key")
  local code="${result%%|*}"; local lat="${result##*|}"
  LATENCY[$name]="${lat}ms"
  if [[ "$code" == "200" ]]; then
    STATUS[$name]="ok"; DETAIL[$name]="key válida · ${lat}ms"; AVAILABLE=$((AVAILABLE+1))
  elif [[ "$code" == "401" ]]; then
    STATUS[$name]="fail"; DETAIL[$name]="key inválida → renovar en platform.deepseek.com"
  else
    STATUS[$name]="fail"; DETAIL[$name]="HTTP $code"
  fi
}

test_ollama() {
  local name="Ollama"
  TOTAL=$((TOTAL+1))
  local start
  start=$(date +%s%3N)
  local code
  code=$(curl -s -o /dev/null -w "%{http_code}" \
    --max-time 3 \
    "http://localhost:11434" 2>/dev/null || echo "000")
  local lat
  lat=$(ms_since "$start")
  LATENCY[$name]="${lat}ms"
  if [[ "$code" == "200" ]]; then
    local models
    models=$(curl -s http://localhost:11434/api/tags 2>/dev/null | \
      python3 -c "import sys,json; d=json.load(sys.stdin); print(len(d.get('models',[])))" 2>/dev/null || echo "?")
    STATUS[$name]="ok"
    DETAIL[$name]="${models} modelo(s) descargado(s) · ${lat}ms (local)"
    AVAILABLE=$((AVAILABLE+1))
  elif [[ "$code" == "000" ]]; then
    STATUS[$name]="warn"
    DETAIL[$name]="no está corriendo → ollama serve"
  else
    STATUS[$name]="fail"
    DETAIL[$name]="HTTP $code"
  fi
}

test_litellm() {
  local name="LiteLLM"
  TOTAL=$((TOTAL+1))
  local start
  start=$(date +%s%3N)
  # FIX: añadir header Authorization para evitar 401
  local code
  code=$(curl -s -o /dev/null -w "%{http_code}" \
    --max-time 3 \
    -H "Authorization: Bearer sk-litellm-local" \
    "http://localhost:8000/health" 2>/dev/null || echo "000")
  local lat
  lat=$(ms_since "$start")
  LATENCY[$name]="${lat}ms"
  if [[ "$code" == "200" ]]; then
    local model_count
    model_count=$(curl -s \
      -H "Authorization: Bearer sk-litellm-local" \
      http://localhost:8000/v1/models 2>/dev/null | \
      python3 -c "import sys,json; d=json.load(sys.stdin); print(len(d.get('data',[])))" 2>/dev/null || echo "?")
    STATUS[$name]="ok"
    DETAIL[$name]="${model_count} modelo(s) en proxy · ${lat}ms"
    AVAILABLE=$((AVAILABLE+1))
  elif [[ "$code" == "000" ]]; then
    STATUS[$name]="warn"
    DETAIL[$name]="proxy no está corriendo → bash scripts/start-colmena.sh"
  elif [[ "$code" == "401" ]]; then
    STATUS[$name]="fail"
    DETAIL[$name]="auth fallida — verificar LITELLM_MASTER_KEY en .env"
  else
    STATUS[$name]="fail"
    DETAIL[$name]="HTTP $code"
  fi
}

# ─── Display ──────────────────────────────────────────────────────────────────

print_header() {
  local mode_label="ping"
  $FULL_TEST && mode_label="chat real"
  echo ""
  echo -e "${BOLD}${CYAN}  ═══════════════════════════════════════════${NC}"
  echo -e "${BOLD}${CYAN}  🩺 Health Check — $(date '+%Y-%m-%d %H:%M') [${mode_label}]${NC}"
  echo -e "${BOLD}${CYAN}  ═══════════════════════════════════════════${NC}"
  echo ""
}

print_row() {
  local name="$1"
  local st="${STATUS[$name]:-skip}"
  local detail="${DETAIL[$name]:-}"
  printf "  %s  %-14s %s\n" "$(icon "$st")" "$name" "$detail"
}

print_summary() {
  echo ""
  echo -e "${BOLD}  ─────────────────────────────────────────────${NC}"
  if [ "$AVAILABLE" -eq 0 ]; then
    echo -e "  ${RED}${BOLD}Sin proveedores disponibles.${NC} Revisa tus keys."
  elif [ "$AVAILABLE" -lt 2 ]; then
    echo -e "  ${YELLOW}${BOLD}$AVAILABLE/$TOTAL operativo.${NC} Funciona pero sin redundancia."
  else
    echo -e "  ${GREEN}${BOLD}$AVAILABLE/$TOTAL operativos.${NC} ✓ Listo para trabajar."
  fi
  echo ""
}

print_fixes() {
  echo -e "${BOLD}  💊 Acciones de arreglo:${NC}"
  echo ""
  for name in "${!STATUS[@]}"; do
    if [[ "${STATUS[$name]}" == "fail" ]]; then
      case "$name" in
        Groq)
          echo -e "  ${RED}Groq:${NC} Renovar en https://console.groq.com/keys"
          echo "        export GROQ_API_KEY=\"nueva_key\" && source ~/.bashrc"
          ;;
        DeepSeek)
          echo -e "  ${RED}DeepSeek:${NC} Renovar en https://platform.deepseek.com"
          echo "        export DEEPSEEK_API_KEY=\"nueva_key\" && source ~/.bashrc"
          ;;
        Gemini)
          echo -e "  ${RED}Gemini:${NC} Verificar key en https://aistudio.google.com/apikey"
          echo "        export GOOGLE_GENERATIVE_AI_API_KEY=\"nueva_key\" && source ~/.bashrc"
          ;;
        Cerebras)
          echo -e "  ${RED}Cerebras:${NC} Verificar en https://cloud.cerebras.ai"
          echo "        export CEREBRAS_API_KEY=\"nueva_key\" && source ~/.bashrc"
          ;;
        OpenRouter)
          echo -e "  ${RED}OpenRouter:${NC} Verificar en https://openrouter.ai/keys"
          echo "        export OPENROUTER_API_KEY=\"nueva_key\" && source ~/.bashrc"
          ;;
        LiteLLM)
          echo -e "  ${RED}LiteLLM:${NC} Verificar LITELLM_MASTER_KEY en .env"
          echo "        grep LITELLM_MASTER_KEY .env"
          ;;
      esac
    elif [[ "${STATUS[$name]}" == "warn" ]]; then
      case "$name" in
        Ollama)
          echo -e "  ${YELLOW}Ollama:${NC} ollama serve &"
          ;;
        LiteLLM)
          echo -e "  ${YELLOW}LiteLLM:${NC} bash scripts/start-colmena.sh"
          ;;
        Groq|Gemini)
          echo -e "  ${YELLOW}$name:${NC} Rate limit — espera al reset (medianoche UTC/PT)"
          ;;
      esac
    fi
  done
  echo ""
}

# ─── Main ─────────────────────────────────────────────────────────────────────

main() {
  print_header

  echo -e "  ${DIM}Comprobando proveedores...${NC}"
  echo ""

  test_cerebras &
  test_openrouter &
  test_groq &
  test_gemini &
  test_deepseek &
  test_ollama &
  test_litellm &
  wait

  for name in "LiteLLM" "Cerebras" "OpenRouter" "Groq" "Gemini" "DeepSeek" "Ollama"; do
    print_row "$name"
  done

  print_summary

  if $SHOW_FIX; then
    print_fixes
  elif [ "$AVAILABLE" -lt "$TOTAL" ]; then
    local fails=0
    for st in "${STATUS[@]}"; do
      [[ "$st" == "fail" ]] && fails=$((fails+1))
    done
    if [ "$fails" -gt 0 ]; then
      echo -e "  ${DIM}→ Para ver cómo arreglar los fallos: bash scripts/health-check.sh --fix${NC}"
      echo ""
    fi
  fi

  if [ "$AVAILABLE" -eq 0 ]; then
    exit 1
  fi
  exit 0
}

main

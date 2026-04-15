#!/bin/bash

# =============================================================================
# opencode-rotate.sh — Lanza OpenCode con el mejor modelo gratuito disponible
# Rota entre APIs: Groq → Cerebras → OpenRouter
# IDs verificados en test real el 15-04-2026
# Uso: bash scripts/opencode-rotate.sh
# =============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

CONFIG_FILE="$HOME/.config/opencode/opencode.json"
LOG_FILE="$HOME/.config/opencode/rotate.log"

mkdir -p "$HOME/.config/opencode"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# --- Modelos verificados en test real ---
# Formato: "nombre_display|model_id_opencode|api_url_test|model_id_test|api_key_var|max_tokens_test"
# IDs distintos: OpenCode usa prefijo (groq/), curl no
MODELS=(
  "Llama 3.3 70B Versatile (Groq)|groq/llama-3.3-70b-versatile|https://api.groq.com/openai/v1|llama-3.3-70b-versatile|GROQ_API_KEY|5"
  "Llama 3.1 8B (Cerebras)|cerebras/llama3.1-8b|https://api.cerebras.ai/v1|llama3.1-8b|CEREBRAS_API_KEY|5"
  "Qwen QwQ 32B Thinking (Groq)|groq/qwen-qwq-32b|https://api.groq.com/openai/v1|qwen-qwq-32b|GROQ_API_KEY|10"
  "DeepSeek R1 (OpenRouter)|openrouter/deepseek/deepseek-r1:free|https://openrouter.ai/api/v1|deepseek/deepseek-r1:free|OPENROUTER_API_KEY|5"
  "Llama 4 Scout (OpenRouter)|openrouter/meta-llama/llama-4-scout:free|https://openrouter.ai/api/v1|meta-llama/llama-4-scout:free|OPENROUTER_API_KEY|5"
  "Llama 4 Maverick (OpenRouter)|openrouter/meta-llama/llama-4-maverick:free|https://openrouter.ai/api/v1|meta-llama/llama-4-maverick:free|OPENROUTER_API_KEY|5"
)

# --- Test rapido de conectividad ---
test_model() {
  local api_url="$1"
  local api_key="$2"
  local model_id="$3"
  local max_tokens="$4"

  local response
  response=$(curl -s -o /dev/null -w "%{http_code}" \
    --max-time 8 \
    -H "Authorization: Bearer $api_key" \
    -H "Content-Type: application/json" \
    -d "{\"model\":\"$model_id\",\"messages\":[{\"role\":\"user\",\"content\":\"hi\"}],\"max_tokens\":$max_tokens}" \
    "$api_url/chat/completions" 2>/dev/null)

  if [[ "$response" == "200" || "$response" == "201" ]]; then
    return 0
  fi
  return 1
}

# --- Escribir config de OpenCode ---
write_config() {
  local model_id="$1"
  cat > "$CONFIG_FILE" << EOF
{
  "\$schema": "https://opencode.ai/config.json",
  "model": "$model_id"
}
EOF
}

# --- Main ---
echo -e "\n${BOLD}${CYAN}Buscando el mejor modelo gratuito disponible...${NC}\n"

SELECTED_NAME=""
SELECTED_MODEL_OC=""
SELECTED_KEY=""
SELECTED_URL=""

for entry in "${MODELS[@]}"; do
  IFS='|' read -r name model_oc api_url model_test key_var max_tokens <<< "$entry"

  api_key="${!key_var}"

  if [ -z "$api_key" ]; then
    echo -e "  ${YELLOW}~${NC} $name — sin key ($key_var)"
    continue
  fi

  echo -n "  Probando $name... "

  if test_model "$api_url" "$api_key" "$model_test" "$max_tokens"; then
    echo -e "${GREEN}OK ✔${NC}"
    SELECTED_NAME="$name"
    SELECTED_MODEL_OC="$model_oc"
    SELECTED_KEY="$api_key"
    SELECTED_URL="$api_url"
    break
  else
    echo -e "${RED}no disponible${NC}"
    log "FAIL: $name ($model_test)"
  fi
done

if [ -z "$SELECTED_MODEL_OC" ]; then
  echo -e "\n${RED}ERROR: Ningun modelo disponible.${NC}"
  echo -e "Keys necesarias en ~/.bashrc: OPENROUTER_API_KEY, GROQ_API_KEY"
  exit 1
fi

echo -e "\n${GREEN}✓ Modelo seleccionado: ${BOLD}$SELECTED_NAME${NC}"
log "OK: $SELECTED_NAME ($SELECTED_MODEL_OC)"

# Escribir config para OpenCode
write_config "$SELECTED_MODEL_OC"

# Exportar variables
export OPENAI_API_KEY="$SELECTED_KEY"
export OPENAI_BASE_URL="$SELECTED_URL"

echo -e "\n${YELLOW}IMPORTANTE: escribe el prompt A MANO dentro de OpenCode${NC}"
echo -e "${YELLOW}No copies con Ctrl+V — usa el raton para pegar${NC}\n"
sleep 2

# Lanzar OpenCode
opencode

#!/bin/bash

# =============================================================================
# opencode-rotate.sh — Lanza OpenCode con el mejor modelo gratuito disponible
# Rota entre APIs: OpenRouter → Groq → Google AI → Cerebras
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

# --- Modelos en orden de preferencia (todos con thinking, todos gratuitos) ---
# Formato: "nombre_display|model_id|api_url|api_key_var"
MODELS=(
  "DeepSeek R1 (OpenRouter)|deepseek/deepseek-r1:free|https://openrouter.ai/api/v1|OPENROUTER_API_KEY"
  "Qwen3 32B Thinking (Groq)|groq/qwen-qwq-32b|https://api.groq.com/openai/v1|GROQ_API_KEY"
  "Gemini 2.5 Flash (Google)|google/gemini-2.5-flash-preview:free|https://openrouter.ai/api/v1|OPENROUTER_API_KEY"
  "Llama 4 Maverick (OpenRouter)|meta-llama/llama-4-maverick:free|https://openrouter.ai/api/v1|OPENROUTER_API_KEY"
  "Llama 3.3 70B (Cerebras)|cerebras/llama-3.3-70b|https://api.cerebras.ai/v1|CEREBRAS_API_KEY"
  "Llama 3.3 70B (Groq)|groq/llama-3.3-70b-versatile|https://api.groq.com/openai/v1|GROQ_API_KEY"
)

# --- Test rapido de conectividad a una API ---
test_model() {
  local api_url="$1"
  local api_key="$2"
  local model_id="$3"

  # Quitar prefijo groq/ o google/ para el test
  local clean_model=$(echo "$model_id" | sed 's|^groq/||;s|^google/||;s|^cerebras/||')

  local response
  response=$(curl -s -o /dev/null -w "%{http_code}" \
    --max-time 5 \
    -H "Authorization: Bearer $api_key" \
    -H "Content-Type: application/json" \
    -d "{\"model\":\"$clean_model\",\"messages\":[{\"role\":\"user\",\"content\":\"hi\"}],\"max_tokens\":1}" \
    "$api_url/chat/completions" 2>/dev/null)

  # 200 o 201 = OK, 400 = modelo existe pero params mal = tambien OK
  if [[ "$response" == "200" || "$response" == "201" || "$response" == "400" ]]; then
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
echo -e "\n${BOLD}${CYAN}Buscando el mejor modelo gratuito con thinking...${NC}\n"

SELECTED_NAME=""
SELECTED_MODEL=""
SELECTED_URL=""
SELECTED_KEY=""

for entry in "${MODELS[@]}"; do
  IFS='|' read -r name model_id api_url key_var <<< "$entry"

  # Obtener valor de la variable de entorno
  api_key="${!key_var}"

  if [ -z "$api_key" ]; then
    echo -e "  ${YELLOW}~${NC} $name — ${YELLOW}sin key ($key_var)${NC}"
    continue
  fi

  echo -n "  Probando $name... "

  if test_model "$api_url" "$api_key" "$model_id"; then
    echo -e "${GREEN}OK${NC}"
    SELECTED_NAME="$name"
    SELECTED_MODEL="$model_id"
    SELECTED_URL="$api_url"
    SELECTED_KEY="$api_key"
    break
  else
    echo -e "${RED}no disponible${NC}"
    log "FAIL: $name ($model_id)"
  fi
done

if [ -z "$SELECTED_MODEL" ]; then
  echo -e "\n${RED}ERROR: Ningun modelo disponible. Comprueba tus API keys.${NC}"
  echo -e "Keys necesarias: OPENROUTER_API_KEY, GROQ_API_KEY"
  exit 1
fi

echo -e "\n${GREEN}✓ Usando: ${BOLD}$SELECTED_NAME${NC}"
log "OK: $SELECTED_NAME ($SELECTED_MODEL)"

# Escribir config
write_config "$SELECTED_MODEL"

# Exportar variables para OpenCode
export OPENAI_API_KEY="$SELECTED_KEY"
export OPENAI_BASE_URL="$SELECTED_URL"

echo -e "${YELLOW}IMPORTANTE: escribe el prompt A MANO dentro de OpenCode${NC}"
echo -e "${YELLOW}No copies con el teclado — usa el raton para pegar${NC}\n"
sleep 2

# Lanzar OpenCode
opencode

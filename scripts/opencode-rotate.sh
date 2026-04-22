#!/bin/bash
# =============================================================================
# opencode-rotate.sh — Lanza OpenCode con el mejor modelo de coding disponible
# Prioridad: Devstral 2 → Qwen3 Coder → DeepSeek R1 → Llama 4 Maverick → Ollama local
# Sin LiteLLM — conexión directa a OpenRouter, fallback a Ollama
# Actualizado: 2026-04-22
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

# --- Modelos de coding agentic (orden por calidad para coding) ---
# Formato: "nombre_display|model_id_opencode|api_url_test|model_id_test|api_key_var|max_tokens_test"
MODELS=(
  "Devstral 2 (OpenRouter)|openrouter/mistralai/devstral-2:free|https://openrouter.ai/api/v1|mistralai/devstral-2:free|OPENROUTER_API_KEY|5"
  "Qwen3 Coder 480B (OpenRouter)|openrouter/qwen/qwen3-coder-480b:free|https://openrouter.ai/api/v1|qwen/qwen3-coder-480b:free|OPENROUTER_API_KEY|5"
  "DeepSeek R1 (OpenRouter)|openrouter/deepseek/deepseek-r1:free|https://openrouter.ai/api/v1|deepseek/deepseek-r1:free|OPENROUTER_API_KEY|5"
  "Llama 4 Maverick (OpenRouter)|openrouter/meta-llama/llama-4-maverick:free|https://openrouter.ai/api/v1|meta-llama/llama-4-maverick:free|OPENROUTER_API_KEY|5"
  "Llama 3.3 70B (Groq)|groq/llama-3.3-70b-versatile|https://api.groq.com/openai/v1|llama-3.3-70b-versatile|GROQ_API_KEY|5"
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

  [[ "$response" == "200" || "$response" == "201" ]]
}

# --- Escribir config de OpenCode ---
write_config() {
  local model_id="$1"
  local base_url="$2"
  local api_key="$3"
  cat > "$CONFIG_FILE" << EOF
{
  "\$schema": "https://opencode.ai/config.json",
  "model": "$model_id",
  "autosave": true,
  "keybinds": {
    "leader": "ctrl+x"
  }
}
EOF
  export OPENAI_API_KEY="$api_key"
  export OPENAI_BASE_URL="$base_url"
}

# --- Main ---
echo -e "\n${BOLD}${CYAN}Buscando el mejor modelo de coding disponible...${NC}\n"

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
    log "OK: $name ($model_oc)"
    echo -e "\n${GREEN}✓ Modelo seleccionado: ${BOLD}$name${NC}"
    write_config "$model_oc" "$api_url" "$api_key"
    echo -e "\n${CYAN}Arrancando OpenCode...${NC}\n"
    sleep 1
    opencode
    exit 0
  else
    echo -e "${RED}no disponible${NC}"
    log "FAIL: $name ($model_test)"
  fi
done

# --- Fallback: Ollama local ---
echo -e "\n${YELLOW}Probando fallback Ollama local...${NC}"
if curl -s http://localhost:11434/api/tags &>/dev/null; then
  echo -e "${GREEN}✓ Ollama disponible${NC}"
  log "OK: Ollama local fallback"
  cat > "$CONFIG_FILE" << EOF
{
  "\$schema": "https://opencode.ai/config.json",
  "model": "ollama/qwen2.5-coder:14b",
  "autosave": true
}
EOF
  export OPENAI_API_KEY="ollama"
  export OPENAI_BASE_URL="http://localhost:11434/v1"
  echo -e "\n${CYAN}Arrancando OpenCode con Ollama...${NC}\n"
  sleep 1
  opencode
  exit 0
fi

echo -e "\n${RED}ERROR: Ningún modelo disponible.${NC}"
echo -e "Keys necesarias en ~/.bashrc: OPENROUTER_API_KEY, GROQ_API_KEY"
echo -e "O arranca Ollama: ollama serve &"
log "ERROR: ningún modelo disponible"
exit 1

#!/usr/bin/env bash
# aider-rotate.sh — Lanza Aider con rotación de modelos
# Pool: Groq → SambaNova → Together AI → OpenRouter (fallback final)
# Uso: bash scripts/aider-rotate.sh [argumentos de aider]
# Ejemplo: bash scripts/aider-rotate.sh --no-auto-commits

set -euo pipefail

LOG="$HOME/.aider/rotate.log"
INDEX_FILE="$HOME/.aider/rotate-index"

# ─── Lista de modelos ordenada por preferencia ────────────────────────────────
# Formato: "PROVEEDOR|API_KEY_VAR|MODELO_AIDER|TEST_URL"
MODELS=(
  "groq|GROQ_API_KEY|groq/llama-3.3-70b-versatile|https://api.groq.com/openai/v1/models"
  "groq|GROQ_API_KEY|groq/llama-3.1-70b-versatile|https://api.groq.com/openai/v1/models"
  "groq|GROQ_API_KEY|groq/mixtral-8x7b-32768|https://api.groq.com/openai/v1/models"
  "sambanova|SAMBANOVA_API_KEY|sambanova/Llama-4-Maverick-17B-128E-Instruct|https://api.sambanova.ai/v1/models"
  "sambanova|SAMBANOVA_API_KEY|sambanova/DeepSeek-R1-0528|https://api.sambanova.ai/v1/models"
  "together|TOGETHER_API_KEY|together_ai/meta-llama/Llama-4-Maverick-17B-128E-Instruct-FP8|https://api.together.xyz/v1/models"
  "together|TOGETHER_API_KEY|together_ai/deepseek-ai/DeepSeek-R1|https://api.together.xyz/v1/models"
  "openrouter|OPENROUTER_API_KEY|openrouter/meta-llama/llama-4-scout:free|https://openrouter.ai/api/v1/models"
)

# ─── Funciones ────────────────────────────────────────────────────────────────

log() {
  mkdir -p "$(dirname "$LOG")"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG"
}

test_provider() {
  local key_var="$1"
  local test_url="$2"
  local api_key="${!key_var:-}"

  if [[ -z "$api_key" ]]; then
    return 1
  fi

  local http_code
  http_code=$(curl -s -o /dev/null -w "%{http_code}" \
    --max-time 5 \
    -H "Authorization: Bearer $api_key" \
    "$test_url" 2>/dev/null || echo "000")

  [[ "$http_code" == "200" ]]
}

get_last_index() {
  if [[ -f "$INDEX_FILE" ]]; then
    cat "$INDEX_FILE"
  else
    echo "0"
  fi
}

save_index() {
  mkdir -p "$(dirname "$INDEX_FILE")"
  echo "$1" > "$INDEX_FILE"
}

# ─── Lógica principal ─────────────────────────────────────────────────────────

main() {
  log "🔄 Iniciando rotación de modelos Aider..."
  log "   Pool: Groq → SambaNova → Together → OpenRouter"

  local total=${#MODELS[@]}
  local last_index
  last_index=$(get_last_index)
  local start_index=$(( (last_index + 1) % total ))

  for (( i = 0; i < total; i++ )); do
    local index=$(( (start_index + i) % total ))
    local entry="${MODELS[$index]}"
    local provider key_var model test_url
    IFS='|' read -r provider key_var model test_url <<< "$entry"

    log "🧪 Probando [$((index+1))/$total]: $model"

    if test_provider "$key_var" "$test_url"; then
      save_index "$index"
      log "✅ Modelo activo: $model"
      log "🚀 Lanzando Aider con: $model"
      exec aider --model "$model" "$@"
      return
    else
      log "❌ No disponible: $model (key: $key_var)"
    fi
  done

  # Fallback absoluto — OpenRouter siempre disponible con key
  log "⚠️  Todos los modelos fallaron. Usando fallback: openrouter/meta-llama/llama-4-scout:free"
  if [ -n "${OPENROUTER_API_KEY:-}" ]; then
    exec aider --model openrouter/meta-llama/llama-4-scout:free "$@"
  else
    log "💀 Sin keys disponibles. Abortando."
    echo -e "\n❌ No hay ninguna API key configurada. Añade al menos GROQ_API_KEY o OPENROUTER_API_KEY en ~/.bashrc"
    exit 1
  fi
}

main "$@"

#!/usr/bin/env bash
# aider-rotate.sh — Lanza Aider con rotación de modelos Groq y fallback automático
# Uso: bash scripts/aider-rotate.sh [argumentos de aider]
# Ejemplo: bash scripts/aider-rotate.sh --no-auto-commits

set -euo pipefail

LOG="$HOME/.aider/rotate.log"
INDEX_FILE="$HOME/.aider/rotate-index"

# ─── Lista de modelos ordenada por preferencia ────────────────────────────────
# Formato: "PROVEEDOR|API_KEY_VAR|MODELO_AIDER"
MODELS=(
  "groq|GROQ_API_KEY|groq/llama-3.3-70b-versatile"
  "groq|GROQ_API_KEY|groq/llama-3.1-70b-versatile"
  "groq|GROQ_API_KEY|groq/mixtral-8x7b-32768"
  "groq|GROQ_API_KEY|groq/gemma2-9b-it"
  "groq|GROQ_API_KEY|groq/llama3-70b-8192"
)

# ─── Funciones ────────────────────────────────────────────────────────────────

log() {
  mkdir -p "$(dirname "$LOG")"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG"
}

# Test rápido de conectividad a Groq
test_groq() {
  local key_var="$1"
  local api_key="${!key_var:-}"

  if [[ -z "$api_key" ]]; then
    return 1
  fi

  local http_code
  http_code=$(curl -s -o /dev/null -w "%{http_code}" \
    --max-time 5 \
    -H "Authorization: Bearer $api_key" \
    "https://api.groq.com/openai/v1/models" 2>/dev/null || echo "000")

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

  local total=${#MODELS[@]}
  local last_index
  last_index=$(get_last_index)
  local start_index=$(( (last_index + 1) % total ))

  for (( i = 0; i < total; i++ )); do
    local index=$(( (start_index + i) % total ))
    local entry="${MODELS[$index]}"
    local provider key_var model
    IFS='|' read -r provider key_var model <<< "$entry"

    log "🧪 Probando [$((index+1))/$total]: $model"

    if test_groq "$key_var"; then
      save_index "$index"
      log "✅ Modelo activo: $model"
      log "🚀 Lanzando Aider con: $model"
      exec aider --model "$model" "$@"
      return
    else
      log "❌ No disponible: $model (key: $key_var)"
    fi
  done

  # Fallback absoluto
  log "💀 Groq no disponible. Usando fallback: groq/llama-3.3-70b-versatile"
  exec aider --model groq/llama-3.3-70b-versatile "$@"
}

main "$@"

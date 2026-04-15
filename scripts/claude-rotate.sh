#!/usr/bin/env bash
# claude-rotate.sh — Lanza Claude Code con rotación de modelos y fallback automático
# Uso: bash scripts/claude-rotate.sh [argumentos de claude]
# Ejemplo: bash scripts/claude-rotate.sh --dangerously-skip-permissions

set -euo pipefail

SETTINGS="$HOME/.claude/settings.json"
LOG="$HOME/.claude/rotate.log"

# ─── Lista de modelos ordenada por preferencia ────────────────────────────────
# Formato: "BASE_URL|API_KEY_VAR|MODELO"
MODELS=(
  "https://openrouter.ai/api/v1|ANTHROPIC_API_KEY|deepseek/deepseek-r1:free"
  "https://openrouter.ai/api/v1|ANTHROPIC_API_KEY|qwen/qwen3-235b-a22b:free"
  "https://openrouter.ai/api/v1|ANTHROPIC_API_KEY|meta-llama/llama-4-maverick:free"
  "https://openrouter.ai/api/v1|ANTHROPIC_API_KEY|google/gemini-2.5-pro-exp-03-25:free"
  "https://openrouter.ai/api/v1|ANTHROPIC_API_KEY|openai/gpt-4o-mini:free"
  "https://openrouter.ai/api/v1|ANTHROPIC_API_KEY|meta-llama/llama-3.3-70b-instruct:free"
)

# ─── Funciones ────────────────────────────────────────────────────────────────

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG"
}

# Guarda el modelo en settings.json
set_model() {
  local base_url="$1"
  local model="$2"
  local key_var="$3"
  local api_key="${!key_var:-}"

  if [[ -z "$api_key" ]]; then
    log "⚠️  Variable $key_var no definida — saltando"
    return 1
  fi

  mkdir -p "$(dirname "$SETTINGS")"
  cat > "$SETTINGS" <<EOF
{
  "env": {
    "ANTHROPIC_BASE_URL": "$base_url",
    "ANTHROPIC_AUTH_TOKEN": "$api_key",
    "ANTHROPIC_API_KEY": "",
    "ANTHROPIC_MODEL": "$model"
  }
}
EOF
  log "✅ Modelo activo: $model"
}

# Test rápido de conectividad al endpoint
test_model() {
  local base_url="$1"
  local key_var="$2"
  local api_key="${!key_var:-}"

  if [[ -z "$api_key" ]]; then
    return 1
  fi

  local http_code
  http_code=$(curl -s -o /dev/null -w "%{http_code}" \
    --max-time 5 \
    -H "Authorization: Bearer $api_key" \
    -H "Content-Type: application/json" \
    "${base_url}/models" 2>/dev/null || echo "000")

  [[ "$http_code" == "200" ]]
}

# Obtiene el índice del último modelo usado
get_last_index() {
  local index_file="$HOME/.claude/rotate-index"
  if [[ -f "$index_file" ]]; then
    cat "$index_file"
  else
    echo "0"
  fi
}

# Guarda el índice del modelo actual
save_index() {
  echo "$1" > "$HOME/.claude/rotate-index"
}

# ─── Lógica principal ─────────────────────────────────────────────────────────

main() {
  log "🔄 Iniciando rotación de modelos..."

  local total=${#MODELS[@]}
  local last_index
  last_index=$(get_last_index)
  local start_index=$(( (last_index + 1) % total ))

  for (( i = 0; i < total; i++ )); do
    local index=$(( (start_index + i) % total ))
    local entry="${MODELS[$index]}"
    local base_url key_var model
    IFS='|' read -r base_url key_var model <<< "$entry"

    log "🧪 Probando [$((index+1))/$total]: $model"

    if test_model "$base_url" "$key_var"; then
      set_model "$base_url" "$model" "$key_var"
      save_index "$index"
      log "🚀 Lanzando Claude Code con: $model"
      exec claude "$@"
      return
    else
      log "❌ No disponible: $model"
    fi
  done

  # Fallback absoluto
  log "💀 Todos los modelos fallaron. Usando fallback: meta-llama/llama-3.3-70b-instruct:free"
  set_model "https://openrouter.ai/api/v1" "meta-llama/llama-3.3-70b-instruct:free" "ANTHROPIC_API_KEY"
  exec claude "$@"
}

main "$@"

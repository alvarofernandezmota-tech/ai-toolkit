#!/usr/bin/env bash
# claude-rotate.sh — Lanza Claude Code con modelos gratuitos mapeados por clase
# y rotación de keys de OpenRouter para evitar límites de rate
# Uso: cc [argumentos de claude]

set -euo pipefail

SETTINGS="$HOME/.claude/settings.json"
LOG="$HOME/.claude/rotate.log"
INDEX_FILE="$HOME/.claude/rotate-index"

# ─── Keys de OpenRouter ───────────────────────────────────────────────
# Añade más keys aquí — se rotan automáticamente
# Variables en ~/.bashrc: OPENROUTER_KEY_1, OPENROUTER_KEY_2...
KEYS=(
  "${OPENROUTER_KEY_1:-${ANTHROPIC_API_KEY:-}}"
  "${OPENROUTER_KEY_2:-}"
  "${OPENROUTER_KEY_3:-}"
)

# ─── Modelos por clase (con prefijo openrouter/) ───────────────────────
# Claude Code usa 3 clases: Opus (complejo), Sonnet (general), Haiku (rápido)
# Mapeamos cada clase a los mejores modelos gratuitos disponibles
OPUS_MODEL="openrouter/deepseek/deepseek-r1:free"        # Razonamiento profundo
SONNET_MODEL="openrouter/qwen/qwen3-235b-a22b:free"      # Código general
HAIKU_MODEL="openrouter/meta-llama/llama-3.3-70b-instruct:free"  # Completions rápidas

# ─── Funciones ─────────────────────────────────────────────────────

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG"
}

get_last_index() {
  [[ -f "$INDEX_FILE" ]] && cat "$INDEX_FILE" || echo "0"
}

save_index() {
  echo "$1" > "$INDEX_FILE"
}

test_key() {
  local key="$1"
  [[ -z "$key" ]] && return 1
  local code
  code=$(curl -s -o /dev/null -w "%{http_code}" \
    --max-time 5 \
    -H "Authorization: Bearer $key" \
    "https://openrouter.ai/api/v1/models" 2>/dev/null || echo "000")
  [[ "$code" == "200" ]]
}

write_settings() {
  local key="$1"
  mkdir -p "$(dirname "$SETTINGS")"
  cat > "$SETTINGS" <<EOF
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://openrouter.ai/api",
    "ANTHROPIC_AUTH_TOKEN": "$key",
    "ANTHROPIC_API_KEY": "",
    "ANTHROPIC_MODEL": "openrouter/free",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "$OPUS_MODEL",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "$SONNET_MODEL",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "$HAIKU_MODEL"
  }
}
EOF
}

# ─── Main ──────────────────────────────────────────────────────────────

main() {
  log "🔄 Iniciando Claude Code con rotación de keys..."
  log "   Opus   → $OPUS_MODEL"
  log "   Sonnet → $SONNET_MODEL"
  log "   Haiku  → $HAIKU_MODEL"

  local total=${#KEYS[@]}
  local last_index
  last_index=$(get_last_index)
  local start_index=$(( (last_index + 1) % total ))

  for (( i = 0; i < total; i++ )); do
    local idx=$(( (start_index + i) % total ))
    local key="${KEYS[$idx]}"

    [[ -z "$key" ]] && continue

    log "🧪 Probando key [$((idx+1))/$total]..."

    if test_key "$key"; then
      write_settings "$key"
      save_index "$idx"
      log "✅ Key activa [$((idx+1))/$total]"
      log "🚀 Lanzando Claude Code..."
      exec claude "$@"
      return
    else
      log "❌ Key [$((idx+1))/$total] no disponible"
    fi
  done

  # Fallback: usar la primera key disponible sin test
  local fallback_key="${KEYS[0]}"
  if [[ -n "$fallback_key" ]]; then
    log "⚠️  Todas las keys fallaron el test. Intentando igualmente con key 1..."
    write_settings "$fallback_key"
    exec claude "$@"
  else
    log "💀 No hay ninguna key configurada."
    log "   Añade en ~/.bashrc: export OPENROUTER_KEY_1=sk-or-v1-..."
    exit 1
  fi
}

main "$@"

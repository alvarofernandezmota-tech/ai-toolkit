#!/bin/bash
# =============================================================================
# generar-diario.sh — Genera una entrada de diario desde los commits del día
# Usa git log para recoger lo que se hizo y llama a la API para redactarlo
#
# Uso: bash scripts/generar-diario.sh [repo]
#   bash scripts/generar-diario.sh              # usa el directorio actual
#   bash scripts/generar-diario.sh thdora       # usa ~/thdora
#   bash scripts/generar-diario.sh ai-toolkit   # usa ~/ai-toolkit
#
# Output: docs/diario/YYYY-MM-DD-sesion.md en el repo ai-toolkit
# =============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ─── Config ──────────────────────────────────────────────────────────────────

TOOLKIT_PATH="$HOME/ai-toolkit"
DIARIO_DIR="$TOOLKIT_PATH/docs/diario"
HOY=$(date '+%Y-%m-%d')
HORA=$(date '+%H:%M')
OUTPUT_FILE="$DIARIO_DIR/$HOY-sesion.md"

# Repos a revisar si no se pasa argumento
REPOS_DEFAULT=(
  "$HOME/thdora"
  "$HOME/ai-toolkit"
  "$HOME/personal"
)

# ─── Funciones ───────────────────────────────────────────────────────────────

log() { echo -e "$1"; }
ok()  { echo -e "${GREEN}✓${NC} $1"; }
err() { echo -e "${RED}✗${NC} $1"; }

check_deps() {
  local ok=1
  if [ -z "$OPENROUTER_API_KEY" ] && [ -z "$GROQ_API_KEY" ]; then
    err "Necesitas OPENROUTER_API_KEY o GROQ_API_KEY en ~/.bashrc"
    ok=0
  fi
  if ! command -v curl &>/dev/null; then
    err "curl no instalado"
    ok=0
  fi
  if ! command -v python3 &>/dev/null; then
    err "python3 no instalado"
    ok=0
  fi
  [ $ok -eq 1 ]
}

# Recoge commits del día en un repo
get_commits() {
  local repo_path="$1"
  local repo_name
  repo_name=$(basename "$repo_path")

  if [ ! -d "$repo_path/.git" ]; then
    return
  fi

  local commits
  commits=$(cd "$repo_path" && git log \
    --since="$HOY 00:00:00" \
    --until="$HOY 23:59:59" \
    --pretty=format:"- %s (%an, %ar)" \
    2>/dev/null)

  if [ -n "$commits" ]; then
    echo ""
    echo "### Repo: $repo_name"
    echo "$commits"
  fi
}

# Recoge estado actual (archivos modificados sin commit)
get_dirty() {
  local repo_path="$1"
  if [ ! -d "$repo_path/.git" ]; then return; fi

  local dirty
  dirty=$(cd "$repo_path" && git status --short 2>/dev/null | head -10)
  if [ -n "$dirty" ]; then
    echo ""
    echo "**Sin commitear en $(basename "$repo_path"):**"
    echo '```'
    echo "$dirty"
    echo '```'
  fi
}

# Llama a la API para redactar el diario
call_api() {
  local prompt="$1"

  # Preferir Groq (más rápido) sobre OpenRouter
  if [ -n "$GROQ_API_KEY" ]; then
    local response
    response=$(curl -s -X POST "https://api.groq.com/openai/v1/chat/completions" \
      -H "Authorization: Bearer $GROQ_API_KEY" \
      -H "Content-Type: application/json" \
      -d "$(python3 -c "
import json, sys
payload = {
  'model': 'llama-3.3-70b-versatile',
  'max_tokens': 1500,
  'messages': [
    {
      'role': 'system',
      'content': '''Eres el asistente que redacta el diario técnico de Alvaro.
Dado un listado de commits y contexto de repos, genera una entrada de diario en Markdown.
Formato de la salida (sin bloques de codigo alrededor, solo el contenido):

## Logros
[lista de lo que se completó, en lenguaje natural, no solo copiar commits]

## Problemas encontrados
[si hay patrones en los commits que sugieran problemas, o None]

## Pendiente para mañana
[sugerencias basadas en el trabajo de hoy]

Tono: técnico pero personal, en español, primera persona.
Sé conciso. Máximo 400 palabras.'''
    },
    {
      'role': 'user',
      'content': $(echo "$prompt" | python3 -c "import sys,json; print(json.dumps(sys.stdin.read()))")
    }
  ]
}
print(json.dumps(payload))
")" 2>/dev/null)

    echo "$response" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data['choices'][0]['message']['content'])
except Exception as e:
    print(f'[Error parseando respuesta: {e}]')
"
    return
  fi

  # Fallback a OpenRouter
  if [ -n "$OPENROUTER_API_KEY" ]; then
    local response
    response=$(curl -s -X POST "https://openrouter.ai/api/v1/chat/completions" \
      -H "Authorization: Bearer $OPENROUTER_API_KEY" \
      -H "Content-Type: application/json" \
      -d "$(python3 -c "
import json
payload = {
  'model': 'meta-llama/llama-4-maverick:free',
  'max_tokens': 1500,
  'messages': [
    {
      'role': 'system',
      'content': 'Eres el asistente que redacta el diario tecnico de Alvaro. Dado commits de repos, genera entrada de diario en Markdown. Secciones: Logros, Problemas encontrados, Pendiente mañana. Tono tecnico personal en español, primera persona, max 400 palabras.'
    },
    {
      'role': 'user',
      'content': $(echo "$prompt" | python3 -c "import sys,json; print(json.dumps(sys.stdin.read()))")
    }
  ]
}
print(json.dumps(payload))
")" 2>/dev/null)

    echo "$response" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data['choices'][0]['message']['content'])
except Exception as e:
    print(f'[Error parseando respuesta: {e}]')
"
  fi
}

# ─── Main ─────────────────────────────────────────────────────────────────────

main() {
  echo ""
  log "${BOLD}${CYAN}📓 Generador de diario — $HOY${NC}"
  echo ""

  # Verificar dependencias
  if ! check_deps; then
    exit 1
  fi

  # Crear directorio de diarios si no existe
  mkdir -p "$DIARIO_DIR"

  # Determinar repos a revisar
  local repos=()
  if [ -n "$1" ]; then
    # Repo específica pasada como argumento
    case "$1" in
      thdora)     repos=("$HOME/thdora") ;;
      ai-toolkit) repos=("$HOME/ai-toolkit") ;;
      personal)   repos=("$HOME/personal") ;;
      *)
        if [ -d "$1/.git" ]; then
          repos=("$1")
        else
          err "Repo no reconocida: $1"
          exit 1
        fi
        ;;
    esac
  else
    # Todas las repos por defecto
    for r in "${REPOS_DEFAULT[@]}"; do
      [ -d "$r" ] && repos+=("$r")
    done
  fi

  # Recoger commits
  log "🔍 Buscando commits del día en ${#repos[@]} repo(s)..."
  local all_commits=""
  local has_commits=0

  for repo in "${repos[@]}"; do
    local repo_commits
    repo_commits=$(get_commits "$repo")
    if [ -n "$repo_commits" ]; then
      all_commits="$all_commits$repo_commits"
      has_commits=1
    fi
  done

  local dirty_status=""
  for repo in "${repos[@]}"; do
    dirty_status="$dirty_status$(get_dirty "$repo")"
  done

  if [ $has_commits -eq 0 ] && [ -z "$dirty_status" ]; then
    log "${YELLOW}⚠ No hay commits hoy ni cambios pendientes.${NC}"
    log "  ¿Empezaste algo pero no lo commiteaste aún?"
    echo ""
    read -rp "  Describe brevemente qué hiciste hoy (o pulsa Enter para salir): " manual_input
    if [ -z "$manual_input" ]; then
      log "Saliendo sin generar diario."
      exit 0
    fi
    all_commits="
### Trabajo manual (sin commits):
$manual_input"
    has_commits=1
  fi

  # Preparar prompt para la API
  local prompt="Fecha: $HOY $HORA CEST

Commits del día:
$all_commits"

  if [ -n "$dirty_status" ]; then
    prompt="$prompt

Cambios sin commitear:
$dirty_status"
  fi

  # Llamar a la API
  log "🤖 Generando diario con IA..."
  local diario_content
  diario_content=$(call_api "$prompt")

  if [ -z "$diario_content" ] || echo "$diario_content" | grep -q "Error parseando"; then
    err "No se pudo generar el diario con IA. Guardando datos crudos."
    diario_content="## Commits del día

$all_commits

$dirty_status"
  fi

  # Escribir el archivo
  cat > "$OUTPUT_FILE" << EOF
# 📓 Diario — $HOY

**Hora:** $HORA CEST
**Repos:** $(IFS=', '; echo "${repos[*]}" | sed "s|$HOME/||g")

---

$diario_content

---

## Commits crudos

$all_commits

$dirty_status

---

*Generado automáticamente por \`scripts/generar-diario.sh\` · $HOY $HORA*
EOF

  ok "Diario guardado en: $OUTPUT_FILE"
  echo ""

  # Preguntar si commitear
  read -rp "  ¿Commitear el diario en ai-toolkit? [s/N]: " commit_choice
  if [[ "$commit_choice" =~ ^[sS]$ ]]; then
    cd "$TOOLKIT_PATH"
    git add "$OUTPUT_FILE"
    git commit -m "diario: sesion $HOY"
    ok "Commit hecho: diario $HOY"
  fi

  echo ""
  log "${BOLD}Diario del día listo. ✓${NC}"
  echo ""
}

main "$@"

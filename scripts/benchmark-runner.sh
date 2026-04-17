#!/bin/bash
# =============================================================================
# benchmark-runner.sh — Rellena investigacion/comparativa-llms.md automáticamente
# Lanza el prompt estándar en cada modelo disponible, mide latencia y calidad
# y actualiza la tabla de resultados usando el propio modelo como juez
#
# Uso:
#   bash scripts/benchmark-runner.sh              # todos los modelos disponibles
#   bash scripts/benchmark-runner.sh cerebras     # solo un modelo
#   bash scripts/benchmark-runner.sh --list       # ver modelos configurados
#   bash scripts/benchmark-runner.sh --dry-run    # solo muestra qué haría
# =============================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

TOOLKIT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
COMPARATIVA_FILE="$TOOLKIT_ROOT/investigacion/comparativa-llms.md"
RESULTS_DIR="$TOOLKIT_ROOT/investigacion/benchmark-results"
TIMEOUT=90
DRY_RUN=false
SINGLE_MODEL=""

# ─── Prompt estándar de benchmark (igual al de comparativa-llms.md) ──────────
BENCHMARK_PROMPT='Refactoriza la siguiente función Python para que sea más eficiente, añade manejo de errores y escribe tests unitarios con pytest.

def calcular_promedio(numeros):
    total = 0
    for n in numeros:
        total = total + n
    return total / len(numeros)'

# ─── Prompt para el juez IA ───────────────────────────────────────────────────
JUDGE_SYSTEM='Eres un evaluador técnico experto en Python. Evalúa la siguiente respuesta de un LLM con puntuaciones del 1 al 5.
Responde SOLO con un JSON válido con este formato exacto, sin texto adicional:
{"calidad_codigo": X, "tests": X, "manejo_errores": X, "seguir_instrucciones": X, "comentario": "una línea"}
Criterios:
- calidad_codigo: ¿Es pythonico, limpio, eficiente?
- tests: ¿Tests completos con edge cases (lista vacía, no numérico)?
- manejo_errores: ¿Maneja TypeError, ZeroDivisionError, etc.?
- seguir_instrucciones: ¿Hizo lo que se pedía (refactor + errores + tests)?
Sé estricto. 5 solo si es casi perfecto.'

# ─── Configuración de modelos ─────────────────────────────────────────────────
# Formato: "display_name|api_url|model_id|key_var"
declare -A MODELS
MODELS["cerebras"]="Cerebras gpt-oss-120b|https://api.cerebras.ai/v1|gpt-oss-120b|CEREBRAS_API_KEY"
MODELS["openrouter-maverick"]="OpenRouter llama-4-maverick|https://openrouter.ai/api/v1|meta-llama/llama-4-maverick|OPENROUTER_API_KEY"
MODELS["openrouter-qwen"]="OpenRouter Qwen3 235B|https://openrouter.ai/api/v1|qwen/qwen3-235b-a22b:free|OPENROUTER_API_KEY"
MODELS["openrouter-r1"]="OpenRouter DeepSeek R1|https://openrouter.ai/api/v1|deepseek/deepseek-r1:free|OPENROUTER_API_KEY"
MODELS["groq"]="Groq llama-3.3-70b|https://api.groq.com/openai/v1|llama-3.3-70b-versatile|GROQ_API_KEY"
MODELS["gemini-flash"]="Gemini 2.0 Flash|https://generativelanguage.googleapis.com/v1beta/openai|gemini-2.0-flash|GOOGLE_GENERATIVE_AI_API_KEY"
MODELS["ollama"]="Ollama gemma3:4b|http://localhost:11434/v1|gemma3:4b|OLLAMA_FAKE"
MODELS["litellm"]="LiteLLM principal|http://localhost:8000/v1|principal|LITELLM_FAKE"

# ─── Funciones ────────────────────────────────────────────────────────────────

get_key() {
  local key_var="$1"
  case "$key_var" in
    OLLAMA_FAKE)   echo "ollama" ;;
    LITELLM_FAKE)  echo "sk-litellm-local" ;;
    *)             echo "${!key_var:-}" ;;
  esac
}

call_model_benchmark() {
  local api_url="$1"
  local model_id="$2"
  local api_key="$3"
  local outfile="$4"

  local escaped_prompt
  escaped_prompt=$(python3 -c "import json; print(json.dumps('''$BENCHMARK_PROMPT'''))" 2>/dev/null \
    || python3 -c "import json; print(json.dumps(open('/dev/stdin').read()))" <<< "$BENCHMARK_PROMPT")

  local payload="{\"model\":\"$model_id\",\"max_tokens\":1200,\"temperature\":0.3,\"messages\":[{\"role\":\"user\",\"content\":$escaped_prompt}]}"

  curl -s --max-time "$TIMEOUT" \
    -H "Authorization: Bearer $api_key" \
    -H "Content-Type: application/json" \
    -d "$payload" \
    "$api_url/chat/completions" > "$outfile" 2>/dev/null || echo '{"error":"timeout"}' > "$outfile"
}

extract_response() {
  local file="$1"
  python3 -c "
import sys, json
try:
    d = json.load(open('$file'))
    if 'choices' in d and d['choices']:
        print(d['choices'][0]['message']['content'])
    elif 'error' in d:
        err = d['error']
        msg = err.get('message', str(err)) if isinstance(err, dict) else str(err)
        print(f'ERROR: {msg}')
    else:
        print('ERROR: respuesta vacía')
except Exception as e:
    print(f'ERROR: {e}')
" 2>/dev/null
}

judge_response() {
  local response="$1"
  local judge_url judge_model judge_key

  if [ -n "${CEREBRAS_API_KEY:-}" ]; then
    judge_url="https://api.cerebras.ai/v1"
    judge_model="gpt-oss-120b"
    judge_key="$CEREBRAS_API_KEY"
  elif [ -n "${OPENROUTER_API_KEY:-}" ]; then
    judge_url="https://openrouter.ai/api/v1"
    judge_model="meta-llama/llama-4-maverick"
    judge_key="$OPENROUTER_API_KEY"
  else
    echo '{"calidad_codigo":0,"tests":0,"manejo_errores":0,"seguir_instrucciones":0,"comentario":"no hay juez disponible"}'
    return
  fi

  local escaped_response
  escaped_response=$(python3 -c "import json,sys; print(json.dumps(sys.stdin.read()))" <<< "$response" 2>/dev/null || echo '""')

  local escaped_system
  escaped_system=$(python3 -c "import json; print(json.dumps('''$JUDGE_SYSTEM'''))" 2>/dev/null || echo '""')

  local payload="{\"model\":\"$judge_model\",\"max_tokens\":200,\"temperature\":0,\"messages\":[{\"role\":\"system\",\"content\":$escaped_system},{\"role\":\"user\",\"content\":$escaped_response}]}"

  local raw
  raw=$(curl -s --max-time 30 \
    -H "Authorization: Bearer $judge_key" \
    -H "Content-Type: application/json" \
    -d "$payload" \
    "$judge_url/chat/completions" 2>/dev/null || echo '{}')

  python3 -c "
import sys, json, re
try:
    d = json.loads('''$raw''')
    text = d['choices'][0]['message']['content']
    m = re.search(r'\\{.*\\}', text, re.DOTALL)
    if m:
        result = json.loads(m.group())
        print(json.dumps(result))
    else:
        print('{\"calidad_codigo\":0,\"tests\":0,\"manejo_errores\":0,\"seguir_instrucciones\":0,\"comentario\":\"parse error\"}')
except Exception as e:
    print('{\"calidad_codigo\":0,\"tests\":0,\"manejo_errores\":0,\"seguir_instrucciones\":0,\"comentario\":\"judge error\"}')
" 2>/dev/null
}

stars() {
  local score="$1"
  python3 -c "
s = int($score)
print('⭐' * s + '☆' * (5-s) if 0 < s <= 5 else '—')
" 2>/dev/null || echo "—"
}

update_comparativa() {
  local key="$1"
  local display_name="$2"
  local scores_json="$3"
  local latency_s="$4"
  local response_snippet="$5"

  python3 << PYEOF
import json, re

with open('$COMPARATIVA_FILE', 'r') as f:
    content = f.read()

scores = json.loads('''$scores_json''')
c = scores.get('calidad_codigo', 0)
t = scores.get('tests', 0)
e = scores.get('manejo_errores', 0)
i = scores.get('seguir_instrucciones', 0)
total = c + t + e + i + 3
comentario = scores.get('comentario', '')

stars = lambda s: '⭐' * int(s) + '☆' * (5 - int(s))

row_pattern = rf'(\\| {re.escape("$key")}[^|]*\\|[^|]*\\|[^|]*\\|[^|]*\\|[^|]*\\|[^|]*\\| /25 \\|)'
new_row = f'| $key | {stars(c)} | {stars(t)} | {stars(e)} | ⭐⭐⭐ | {stars(i)} | {total}/25 |'

updated = re.sub(row_pattern, new_row, content)

if updated == content:
    print(f"INFO: no se encontró fila exacta para '$key' en la tabla — añadir manualmente si hace falta")

with open('$COMPARATIVA_FILE', 'w') as f:
    f.write(updated)

print(f"Puntuación: código={c} tests={t} errores={e} instrucciones={i} total={total}/25")
print(f"Comentario: {comentario}")
PYEOF
}

run_benchmark() {
  local key="$1"
  local config="${MODELS[$key]}"
  IFS='|' read -r display_name api_url model_id key_var <<< "$config"
  local api_key
  api_key=$(get_key "$key_var")

  if [ -z "$api_key" ]; then
    echo -e "  ${YELLOW}~${NC} $display_name — key no configurada, saltando"
    return
  fi

  echo -e "\n${BOLD}  ► Benchmarking: $display_name${NC}"

  if $DRY_RUN; then
    echo -e "  ${DIM}[dry-run] llamaría a $api_url con modelo $model_id${NC}"
    return
  fi

  local tmpfile
  tmpfile=$(mktemp "$TMPDIR/bench_${key}_XXXXXX.json")
  local start
  start=$(date +%s%3N)

  echo -ne "  ${DIM}Generando respuesta...${NC}"
  call_model_benchmark "$api_url" "$model_id" "$api_key" "$tmpfile"
  local elapsed=$(( $(date +%s%3N) - start ))
  local elapsed_s
  elapsed_s=$(python3 -c "print(f'{$elapsed/1000:.1f}s')" 2>/dev/null || echo "${elapsed}ms")
  echo -e "\r  ✓ Respuesta en ${elapsed_s}                    "

  local response
  response=$(extract_response "$tmpfile")

  if echo "$response" | grep -q "^ERROR:"; then
    echo -e "  ${RED}✗ $response${NC}"
    rm -f "$tmpfile"
    return
  fi

  mkdir -p "$RESULTS_DIR"
  local result_file="$RESULTS_DIR/$(date '+%Y-%m-%d')-${key}.md"
  cat > "$result_file" << EOF
# Benchmark — $display_name — $(date '+%Y-%m-%d %H:%M')

**Prompt:** calcular_promedio refactor + errores + tests
**Latencia:** ${elapsed_s}

## Respuesta

$response

---
*Generado por benchmark-runner.sh*
EOF

  echo -ne "  ${DIM}Puntuando con juez IA...${NC}"
  local scores_json
  scores_json=$(judge_response "$response")
  echo -e "\r  ✓ Puntuación calculada                      "

  local c t e i total comentario
  c=$(echo "$scores_json" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('calidad_codigo',0))" 2>/dev/null || echo 0)
  t=$(echo "$scores_json" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('tests',0))" 2>/dev/null || echo 0)
  e=$(echo "$scores_json" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('manejo_errores',0))" 2>/dev/null || echo 0)
  i=$(echo "$scores_json" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('seguir_instrucciones',0))" 2>/dev/null || echo 0)
  comentario=$(echo "$scores_json" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('comentario',''))" 2>/dev/null || echo "")
  total=$(( c + t + e + i ))

  echo ""
  echo -e "  ${GREEN}Resultados para $display_name:${NC}"
  printf "  %-22s %s\n" "Calidad código:"   "$(stars $c) ($c/5)"
  printf "  %-22s %s\n" "Tests:"            "$(stars $t) ($t/5)"
  printf "  %-22s %s\n" "Manejo errores:"   "$(stars $e) ($e/5)"
  printf "  %-22s %s\n" "Sigue instruc.:"   "$(stars $i) ($i/5)"
  printf "  %-22s %s\n" "Total:"            "${total}/20 (+ velocidad aparte)"
  printf "  %-22s %s\n" "Latencia:"         "$elapsed_s"
  printf "  %-22s %s\n" "Comentario juez:"  "$comentario"

  echo ""
  echo -ne "  ${DIM}Actualizando comparativa-llms.md...${NC}"
  update_comparativa "$key" "$display_name" "$scores_json" "$elapsed_s" "${response:0:100}" 2>/dev/null || true
  echo -e "\r  ✓ comparativa-llms.md actualizado           "

  rm -f "$tmpfile"
}

# ─── Main ─────────────────────────────────────────────────────────────────────

main() {
  case "${1:-}" in
    --list)
      echo ""
      echo "Modelos configurados:"
      for key in "${!MODELS[@]}"; do
        local config="${MODELS[$key]}"
        local display_name="${config%%|*}"
        echo "  $key → $display_name"
      done | sort
      echo ""
      exit 0
      ;;
    --dry-run)
      DRY_RUN=true
      echo -e "${YELLOW}[dry-run mode]${NC}"
      ;;
    --help|-h)
      echo "Uso: bash scripts/benchmark-runner.sh [modelo|--list|--dry-run]"
      exit 0
      ;;
    "")
      ;;
    *)
      SINGLE_MODEL="$1"
      ;;
  esac

  echo ""
  echo -e "${BOLD}${CYAN}  ═══════════════════════════════════════════════${NC}"
  echo -e "${BOLD}${CYAN}  📊 Benchmark Runner — $(date '+%Y-%m-%d %H:%M')${NC}"
  echo -e "${BOLD}${CYAN}  ═══════════════════════════════════════════════${NC}"
  echo ""
  echo -e "  Prompt: calcular_promedio (refactor + errores + pytest)"
  echo -e "  Output: investigacion/comparativa-llms.md"
  echo ""

  if [ -n "$SINGLE_MODEL" ]; then
    if [ -z "${MODELS[$SINGLE_MODEL]:-}" ]; then
      echo -e "${RED}✗ Modelo no reconocido: '$SINGLE_MODEL'${NC}"
      echo "  Usa --list para ver modelos disponibles"
      exit 1
    fi
    run_benchmark "$SINGLE_MODEL"
  else
    for key in cerebras openrouter-maverick openrouter-qwen openrouter-r1 groq gemini-flash ollama litellm; do
      [ -n "${MODELS[$key]:-}" ] && run_benchmark "$key"
    done
  fi

  echo ""
  echo -e "${BOLD}  ─────────────────────────────────────────────────${NC}"
  echo -e "  ${GREEN}✓ Benchmark completado.${NC}"
  echo -e "  Resultados individuales en: investigacion/benchmark-results/"
  echo -e "  Tabla actualizada en:       investigacion/comparativa-llms.md"
  echo ""
}

main "$@"

#!/bin/bash
# =============================================================================
# ai-menu.sh — Menú interactivo de agentes IA
# Incluye: health-check, ensemble, benchmark, generar-diario, OpenCode, Aider, Claude Code
# Uso: bash scripts/ai-menu.sh
# =============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ─── Setup de keys ──────────────────────────────────────────────────────────────────────
setup_keys() {
  if [ -n "$OPENROUTER_API_KEY" ]; then
    export OPENAI_API_KEY="$OPENROUTER_API_KEY"
    export OPENAI_BASE_URL="https://openrouter.ai/api/v1"
    export ANTHROPIC_API_KEY="$OPENROUTER_API_KEY"
    export ANTHROPIC_BASE_URL="https://openrouter.ai/api/v1"
  fi
}

# ─── Estado de keys (una línea por key) ───────────────────────────────────────────
key_status() {
  local name="$1"
  local var="$2"
  local val="${!var:-}"
  if [ -n "$val" ]; then
    echo -e "  ${GREEN}✓${NC} $name"
  else
    echo -e "  ${DIM}~${NC} $name ${DIM}(no definida)${NC}"
  fi
}

# ─── Menú principal ───────────────────────────────────────────────────────────────────
show_menu() {
  clear
  echo ""
  echo -e "${BOLD}${CYAN}  ╔══════════════════════════════════════════╗${NC}"
  echo -e "${BOLD}${CYAN}  ║         AI-TOOLKIT  v2 — MENÚ           ║${NC}"
  echo -e "${BOLD}${CYAN}  ╚══════════════════════════════════════════╝${NC}"
  echo ""

  echo -e "  ${BOLD}🩺 Diagnóstico${NC}"
  echo -e "  ${GREEN}1)${NC} Health check     — estado de todas las APIs"
  echo -e "  ${GREEN}2)${NC} Health check     — con llamada real (--full)"
  echo ""

  echo -e "  ${BOLD}🤖 Agentes de coding${NC}"
  echo -e "  ${GREEN}3)${NC} OpenCode         — rotación automática de modelos"
  echo -e "  ${GREEN}4)${NC} Claude Code      — claude-3.5-sonnet via OpenRouter"
  echo -e "  ${GREEN}5)${NC} Aider            — fixes rápidos con Groq"
  echo ""

  echo -e "  ${BOLD}🔀 Comparación de modelos${NC}"
  echo -e "  ${GREEN}6)${NC} Ensemble         — mismo prompt → varios modelos"
  echo -e "  ${GREEN}7)${NC} Benchmark        — rellena comparativa-llms.md"
  echo -e "  ${GREEN}8)${NC} Benchmark        — solo un modelo (elige cuál)"
  echo ""

  echo -e "  ${BOLD}📓 Documentación automática${NC}"
  echo -e "  ${GREEN}9)${NC} Generar diario   — entrada desde commits del día"
  echo -e " ${GREEN}10)${NC} Generar diario   — repo específica"
  echo ""

  echo -e "  ${BOLD}🏠 Modelos locales${NC}"
  echo -e " ${GREEN}11)${NC} Ollama status    — ver modelos descargados"
  echo -e " ${GREEN}12)${NC} Ollama serve     — arrancar servidor local"
  echo ""

  echo -e "  ${YELLOW}q)${NC}  Salir"
  echo ""

  echo -e "  ${BOLD}APIs activas:${NC}"
  key_status "Cerebras  " "CEREBRAS_API_KEY"
  key_status "OpenRouter" "OPENROUTER_API_KEY"
  key_status "Groq      " "GROQ_API_KEY"
  key_status "Gemini    " "GOOGLE_GENERATIVE_AI_API_KEY"
  key_status "DeepSeek  " "DEEPSEEK_API_KEY"
  echo ""
  echo -n "  Elige [1-12 o q]: "
}

# ─── Acciones ─────────────────────────────────────────────────────────────────────
run_health_check() {
  local mode="${1:-}"
  echo ""
  bash "$SCRIPT_DIR/health-check.sh" $mode
  echo ""
  read -rp "  [Enter para volver al menú]"
}

run_opencode() {
  if [ -f "$SCRIPT_DIR/opencode-rotate.sh" ]; then
    bash "$SCRIPT_DIR/opencode-rotate.sh"
  else
    echo -e "${RED}✗ opencode-rotate.sh no encontrado${NC}"
    read -rp "[Enter]"
  fi
}

run_claude_code() {
  echo -e "\n${GREEN}Lanzando Claude Code...${NC}\n"
  sleep 1
  claude --model anthropic/claude-3.5-sonnet
}

run_aider() {
  if [ -f "$SCRIPT_DIR/aider-rotate.sh" ]; then
    bash "$SCRIPT_DIR/aider-rotate.sh"
  else
    echo -e "\n${GREEN}Lanzando Aider...${NC}\n"
    if [ -n "$GROQ_API_KEY" ]; then
      aider --model groq/llama-3.3-70b-versatile
    else
      aider --model openrouter/meta-llama/llama-4-maverick:free
    fi
  fi
}

run_ensemble() {
  echo ""
  echo -n "  Prompt para ensemble (o Enter para modo interactivo): "
  read -r prompt
  echo ""
  if [ -n "$prompt" ]; then
    bash "$SCRIPT_DIR/ensemble.sh" "$prompt"
  else
    bash "$SCRIPT_DIR/ensemble.sh"
  fi
  echo ""
  read -rp "  [Enter para volver]"
}

run_benchmark_all() {
  echo ""
  echo -e "  ${YELLOW}Esto puede tardar varios minutos. ¿Continuar? [s/N]${NC}"
  read -r confirm
  if [[ "$confirm" =~ ^[sS]$ ]]; then
    bash "$SCRIPT_DIR/benchmark-runner.sh"
  fi
  echo ""
  read -rp "  [Enter para volver]"
}

run_benchmark_one() {
  echo ""
  bash "$SCRIPT_DIR/benchmark-runner.sh" --list
  echo ""
  echo -n "  ¿Qué modelo quieres benchmarkear? "
  read -r modelo
  if [ -n "$modelo" ]; then
    bash "$SCRIPT_DIR/benchmark-runner.sh" "$modelo"
  fi
  echo ""
  read -rp "  [Enter para volver]"
}

run_diario() {
  local repo="${1:-}"
  echo ""
  if [ -n "$repo" ]; then
    echo -n "  Repo (thdora/ai-toolkit/personal): "
    read -r repo
    bash "$SCRIPT_DIR/generar-diario.sh" "$repo"
  else
    bash "$SCRIPT_DIR/generar-diario.sh"
  fi
  echo ""
  read -rp "  [Enter para volver]"
}

run_ollama_status() {
  echo ""
  if command -v ollama &>/dev/null; then
    echo -e "  ${GREEN}✓ Ollama instalado${NC}"
    echo ""
    ollama list 2>/dev/null || echo "  (no hay modelos descargados)"
    echo ""
    if curl -s http://localhost:11434 &>/dev/null; then
      echo -e "  ${GREEN}✓ ollama serve: corriendo en localhost:11434${NC}"
    else
      echo -e "  ${YELLOW}~ ollama serve: NO está corriendo${NC}"
      echo -e "  ${DIM}  Lanzar: ollama serve &${NC}"
    fi
  else
    echo -e "  ${YELLOW}~ Ollama no instalado${NC}"
    echo -e "  ${DIM}  Instalar: curl -fsSL https://ollama.ai/install.sh | sh${NC}"
  fi
  echo ""
  read -rp "  [Enter para volver]"
}

run_ollama_serve() {
  echo ""
  if command -v ollama &>/dev/null; then
    echo -e "  Arrancando ollama serve en background..."
    ollama serve &
    sleep 2
    echo -e "  ${GREEN}✓ Ollama corriendo en localhost:11434${NC}"
  else
    echo -e "  ${RED}✗ Ollama no instalado${NC}"
  fi
  echo ""
  read -rp "  [Enter para volver]"
}

# ─── Main loop ───────────────────────────────────────────────────────────────────

setup_keys

while true; do
  show_menu
  read -r choice
  case "$choice" in
    1)  run_health_check "" ;;
    2)  run_health_check "--full" ;;
    3)  run_opencode; break ;;
    4)  run_claude_code; break ;;
    5)  run_aider; break ;;
    6)  run_ensemble ;;
    7)  run_benchmark_all ;;
    8)  run_benchmark_one ;;
    9)  run_diario "" ;;
    10) run_diario "specific" ;;
    11) run_ollama_status ;;
    12) run_ollama_serve ;;
    q|Q) echo -e "\n${YELLOW}Hasta luego.${NC}\n"; exit 0 ;;
    *)  echo -e "\n  ${RED}Opción no válida.${NC}"; sleep 1 ;;
  esac
done

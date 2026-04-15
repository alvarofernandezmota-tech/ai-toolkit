#!/bin/bash

# =============================================================================
# ai-menu.sh — Menu interactivo para lanzar agentes IA
# Uso: bash scripts/ai-menu.sh
# =============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Modelo por defecto para OpenCode (gratuito, verificado)
OPENCODE_MODEL="openrouter/deepseek/deepseek-r1:free"

# --- Verificar keys ---
check_keys() {
  if [ -z "$OPENROUTER_API_KEY" ] && [ -z "$OPENAI_API_KEY" ]; then
    echo -e "${RED}ERROR: No hay OPENROUTER_API_KEY exportada.${NC}"
    echo -e "Ejecuta: ${YELLOW}source ~/.bashrc${NC}"
    exit 1
  fi
  if [ -n "$OPENROUTER_API_KEY" ]; then
    export OPENAI_API_KEY="$OPENROUTER_API_KEY"
    export OPENAI_BASE_URL="https://openrouter.ai/api/v1"
    export ANTHROPIC_API_KEY="$OPENROUTER_API_KEY"
    export ANTHROPIC_BASE_URL="https://openrouter.ai/api/v1"
  fi
}

# --- Menu principal ---
show_menu() {
  clear
  echo -e "${BOLD}${CYAN}"
  echo "  ╔═══════════════════════════════════════╗"
  echo "  ║         AI TOOLKIT — MENU             ║"
  echo "  ╚═══════════════════════════════════════╝${NC}"
  echo ""
  echo -e "  ${BOLD}Agentes disponibles:${NC}"
  echo ""
  echo -e "  ${GREEN}1)${NC} Claude Code     — agente coding principal"
  echo -e "     Modelo: claude-3.5-sonnet via OpenRouter"
  echo ""
  echo -e "  ${GREEN}2)${NC} OpenCode        — agente open source (investigacion + docs)"
  echo -e "     Modelo: ${YELLOW}deepseek-r1:free${NC} (forzado via --model flag)"
  echo ""
  echo -e "  ${GREEN}3)${NC} Aider           — edicion rapida de archivos"
  echo -e "     Modelo: rotacion automatica (Groq + OpenRouter)"
  echo ""
  echo -e "  ${GREEN}4)${NC} Claude Code (rotacion) — 6 modelos con fallback"
  echo -e "     Script: scripts/claude-rotate.sh"
  echo ""
  echo -e "  ${YELLOW}q)${NC} Salir"
  echo ""
  echo -e "  ${BOLD}Keys activas:${NC}"
  if [ -n "$OPENROUTER_API_KEY" ]; then
    echo -e "  ${GREEN}✓${NC} OPENROUTER_API_KEY"
  else
    echo -e "  ${RED}✗${NC} OPENROUTER_API_KEY (no encontrada)"
  fi
  if [ -n "$GROQ_API_KEY" ]; then
    echo -e "  ${GREEN}✓${NC} GROQ_API_KEY"
  else
    echo -e "  ${YELLOW}~${NC} GROQ_API_KEY (opcional para Aider)"
  fi
  echo ""
  echo -n "  Elige [1-4 o q]: "
}

# --- Lanzar agentes ---
launch_claude_code() {
  echo -e "\n${GREEN}Lanzando Claude Code...${NC}"
  echo -e "${YELLOW}Tip: escribe el prompt directamente dentro de Claude Code${NC}\n"
  sleep 1
  claude --model anthropic/claude-3.5-sonnet
}

launch_opencode() {
  echo -e "\n${GREEN}Lanzando OpenCode con ${OPENCODE_MODEL}...${NC}"
  echo -e "${YELLOW}IMPORTANTE: escribe el prompt A MANO dentro de OpenCode${NC}"
  echo -e "${YELLOW}No copies con Ctrl+V desde fuera — usa el raton para pegar${NC}"
  echo -e "${YELLOW}Para continuar sesion anterior: opencode -s <session-id>${NC}\n"
  sleep 2
  # Flag --model fuerza el modelo e ignora opencode.json
  opencode --model "$OPENCODE_MODEL"
}

launch_aider() {
  if [ -f "scripts/aider-rotate.sh" ]; then
    echo -e "\n${GREEN}Lanzando Aider con rotacion de modelos...${NC}\n"
    sleep 1
    bash scripts/aider-rotate.sh
  else
    echo -e "\n${GREEN}Lanzando Aider...${NC}\n"
    sleep 1
    if [ -n "$GROQ_API_KEY" ]; then
      aider --model groq/llama-3.3-70b-versatile
    else
      aider --model openrouter/deepseek/deepseek-r1:free
    fi
  fi
}

launch_claude_rotate() {
  if [ -f "scripts/claude-rotate.sh" ]; then
    echo -e "\n${GREEN}Lanzando Claude Code con rotacion de modelos...${NC}\n"
    sleep 1
    bash scripts/claude-rotate.sh
  else
    echo -e "${RED}Error: scripts/claude-rotate.sh no encontrado${NC}"
    exit 1
  fi
}

# --- Main ---
check_keys

while true; do
  show_menu
  read -r choice
  case $choice in
    1) launch_claude_code; break ;;
    2) launch_opencode; break ;;
    3) launch_aider; break ;;
    4) launch_claude_rotate; break ;;
    q|Q) echo -e "\n${YELLOW}Hasta luego.${NC}\n"; exit 0 ;;
    *) echo -e "\n${RED}Opcion no valida. Pulsa Enter e intenta de nuevo.${NC}"; read -r ;;
  esac
done

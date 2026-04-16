#!/bin/bash

# =============================================================================
# ai-menu.sh — Menu interactivo para lanzar agentes IA
# Arquitectura Colmena: OpenCode → LiteLLM proxy :8000
#   Groq → SambaNova → Together → OpenRouter → Gemini → Cerebras
# Uso: bash scripts/ai-menu.sh
# =============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# --- Verificar y exportar keys ---
check_keys() {
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
  echo -e "  ${GREEN}2)${NC} OpenCode        — agente open source vía LiteLLM proxy"
  echo -e "     Cadena: ${YELLOW}Groq → SambaNova → Together → OpenRouter → Gemini → Cerebras${NC}"
  echo ""
  echo -e "  ${GREEN}3)${NC} Aider           — edición rápida de archivos"
  echo -e "     Rotación: ${YELLOW}Groq → SambaNova → Together → OpenRouter${NC}"
  echo ""
  echo -e "  ${GREEN}4)${NC} Claude Code (rotación) — 6 modelos con fallback"
  echo -e "     Script: scripts/claude-rotate.sh"
  echo ""
  echo -e "  ${GREEN}5)${NC} Solo proxy      — arrancar solo LiteLLM en :8000"
  echo -e "     Script: scripts/start-colmena.sh --solo-proxy"
  echo ""
  echo -e "  ${YELLOW}q)${NC} Salir"
  echo ""
  echo -e "  ${BOLD}Keys activas:${NC}"
  [ -n "$GROQ_API_KEY" ]         && echo -e "  ${GREEN}✓${NC} GROQ_API_KEY"         || echo -e "  ${RED}✗${NC} GROQ_API_KEY"
  [ -n "$SAMBANOVA_API_KEY" ]    && echo -e "  ${GREEN}✓${NC} SAMBANOVA_API_KEY"    || echo -e "  ${YELLOW}~${NC} SAMBANOVA_API_KEY"
  [ -n "$TOGETHER_API_KEY" ]     && echo -e "  ${GREEN}✓${NC} TOGETHER_API_KEY"     || echo -e "  ${YELLOW}~${NC} TOGETHER_API_KEY"
  [ -n "$OPENROUTER_API_KEY" ]   && echo -e "  ${GREEN}✓${NC} OPENROUTER_API_KEY"   || echo -e "  ${YELLOW}~${NC} OPENROUTER_API_KEY"
  [ -n "$CEREBRAS_API_KEY" ]     && echo -e "  ${GREEN}✓${NC} CEREBRAS_API_KEY"     || echo -e "  ${YELLOW}~${NC} CEREBRAS_API_KEY"
  [ -n "$GOOGLE_GENERATIVE_AI_API_KEY" ] && echo -e "  ${GREEN}✓${NC} GOOGLE_GENERATIVE_AI_API_KEY" || echo -e "  ${YELLOW}~${NC} GOOGLE_GENERATIVE_AI_API_KEY"
  echo ""
  echo -n "  Elige [1-5 o q]: "
}

# --- Lanzar agentes ---
launch_claude_code() {
  echo -e "\n${GREEN}Lanzando Claude Code...${NC}\n"
  sleep 1
  claude --model anthropic/claude-3.5-sonnet
}

launch_opencode() {
  echo -e "\n${GREEN}Lanzando OpenCode vía LiteLLM proxy...${NC}"
  echo -e "  Arrancando Colmena (proxy + OpenCode)...\n"
  sleep 1
  if [ -f "scripts/start-colmena.sh" ]; then
    bash scripts/start-colmena.sh
  else
    echo -e "${RED}Error: scripts/start-colmena.sh no encontrado. Haz git pull.${NC}"
    exit 1
  fi
}

launch_aider() {
  if [ -f "scripts/aider-rotate.sh" ]; then
    echo -e "\n${GREEN}Lanzando Aider con rotación...${NC}\n"
    sleep 1
    bash scripts/aider-rotate.sh
  else
    echo -e "\n${GREEN}Lanzando Aider (fallback directo)...${NC}\n"
    sleep 1
    if [ -n "$GROQ_API_KEY" ]; then
      aider --model groq/llama-3.3-70b-versatile
    else
      aider --model openrouter/meta-llama/llama-4-scout:free
    fi
  fi
}

launch_claude_rotate() {
  if [ -f "scripts/claude-rotate.sh" ]; then
    echo -e "\n${GREEN}Lanzando Claude Code con rotación...${NC}\n"
    sleep 1
    bash scripts/claude-rotate.sh
  else
    echo -e "${RED}Error: scripts/claude-rotate.sh no encontrado${NC}"
    exit 1
  fi
}

launch_solo_proxy() {
  echo -e "\n${GREEN}Arrancando solo LiteLLM proxy en :8000...${NC}\n"
  sleep 1
  if [ -f "scripts/start-colmena.sh" ]; then
    bash scripts/start-colmena.sh --solo-proxy
  else
    echo -e "${RED}Error: scripts/start-colmena.sh no encontrado${NC}"
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
    5) launch_solo_proxy; break ;;
    q|Q) echo -e "\n${YELLOW}Hasta luego.${NC}\n"; exit 0 ;;
    *) echo -e "\n${RED}Opción no válida.${NC}"; read -r ;;
  esac
done

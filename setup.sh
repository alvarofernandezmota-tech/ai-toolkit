#!/usr/bin/env bash
# =============================================================================
# ECOSISTEMA PERSONAL DE AGENTES IA
# Instalador completo para Ubuntu / WSL2
# Uso: bash <(curl -fsSL https://raw.githubusercontent.com/alvarofernandezmota-tech/ai-toolkit/main/setup.sh)
#
# Agentes disponibles (todos gratis):
#   Claude Code  → agente principal, escanea repos, commits autónomos
#   Aider        → fixes rápidos día a día
#   n8n          → orquestador 24/7
#
# Modelos gratuitos (via OpenRouter):
#   devstral-2:free      → mejor coding open source (SWE-bench #1)
#   deepseek/r1:free     → thinking profundo, arquitectura
#   qwen/qwen3-coder:free → coding complejo multi-fichero
#   groq/llama-3.3-70b   → NLP rápido (THDORA)
# =============================================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

ok()   { echo -e "${GREEN}✓${NC} $1"; }
info() { echo -e "${BLUE}→${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }
err()  { echo -e "${RED}✗${NC} $1"; exit 1; }

echo ""
echo -e "${BLUE}╔══════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   🤖  ECOSISTEMA DE AGENTES IA               ║${NC}"
echo -e "${BLUE}║   Setup completo para Ubuntu / WSL2          ║${NC}"
echo -e "${BLUE}║   Agente principal: Claude Code              ║${NC}"
echo -e "${BLUE}║   Coste total: 0€/mes                        ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════╝${NC}"
echo ""

echo "¿Qué quieres instalar?"
echo ""
echo "  1) Todo (recomendado primera vez)"
echo "  2) Solo agentes de código (Claude Code + Aider + Node.js)"
echo "  3) Solo THDORA (bot + API)"
echo "  4) Solo Docker + n8n"
echo "  5) Solo dependencias base (Python, git, curl)"
echo ""
read -rp "Elige [1-5]: " OPCION
OPCION=${OPCION:-1}

# =============================================================================
# FUNCIONES
# =============================================================================

instalar_base() {
  echo ""
  info "Instalando dependencias base del sistema..."
  sudo apt-get update -qq
  sudo apt-get install -y -qq \
    curl wget git unzip build-essential \
    software-properties-common ca-certificates \
    gnupg lsb-release
  ok "Dependencias base instaladas"
}

instalar_python() {
  echo ""
  info "Configurando Python 3.11+..."
  PY_VER=$(python3 --version 2>/dev/null | awk '{print $2}' | cut -d. -f2)
  if [ -z "$PY_VER" ] || [ "$PY_VER" -lt 11 ]; then
    sudo add-apt-repository -y ppa:deadsnakes/ppa -qq
    sudo apt-get update -qq
    sudo apt-get install -y -qq python3.11 python3.11-venv python3.11-dev
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1
  fi
  curl -sS https://bootstrap.pypa.io/get-pip.py | python3
  ok "Python $(python3 --version) listo"
}

instalar_nodejs() {
  echo ""
  info "Instalando Node.js via nvm (sin sudo)..."
  if ! command -v nvm &>/dev/null; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  fi
  nvm install --lts
  nvm use --lts
  ok "Node.js $(node --version) listo"
}

instalar_claude_code() {
  echo ""
  info "Instalando Claude Code (agente principal)..."

  # Método oficial recomendado por Anthropic
  if command -v claude &>/dev/null; then
    ok "Claude Code ya está instalado: $(claude --version 2>/dev/null || echo 'ok')"
  else
    # Intentar con curl primero (método oficial)
    if curl -fsSL https://claude.ai/install.sh | sh 2>/dev/null; then
      ok "Claude Code instalado via curl"
    else
      # Fallback: npm global
      npm install -g @anthropic-ai/claude-code --silent
      ok "Claude Code instalado via npm"
    fi
  fi
}

instalar_aider() {
  echo ""
  info "Instalando Aider (fixes rápidos)..."
  pip install -q aider-chat
  ok "Aider instalado"
}

instalar_herramientas_codigo() {
  instalar_nodejs
  instalar_claude_code
  instalar_aider

  # Utilidades Python
  pip install -q duckduckgo-search
  ok "DuckDuckGo Search instalado"

  pip install -q crewai 2>/dev/null || warn "CrewAI: instala manualmente si falla (requiere Python 3.12)"
}

instalar_thdora() {
  echo ""
  info "Configurando THDORA..."
  THDORA_DIR="$HOME/projects/thdora"

  if [ ! -d "$THDORA_DIR" ]; then
    mkdir -p "$HOME/projects"
    git clone https://github.com/alvarofernandezmota-tech/thdora.git "$THDORA_DIR"
    ok "THDORA clonado en $THDORA_DIR"
  else
    git -C "$THDORA_DIR" pull origin main
    ok "THDORA actualizado"
  fi

  if [ ! -d "$THDORA_DIR/.venv" ]; then
    python3 -m venv "$THDORA_DIR/.venv"
    ok "Entorno virtual creado"
  fi

  "$THDORA_DIR/.venv/bin/pip" install -q -r "$THDORA_DIR/requirements.txt"
  ok "Dependencias de THDORA instaladas"

  if [ ! -f "$THDORA_DIR/.env" ]; then
    cp "$THDORA_DIR/.env.example" "$THDORA_DIR/.env" 2>/dev/null || touch "$THDORA_DIR/.env"
    warn "Edita tu .env en $THDORA_DIR/.env con tus keys"
  else
    ok ".env ya existe"
  fi
}

instalar_docker_n8n() {
  echo ""
  info "Instalando Docker..."

  if ! command -v docker &>/dev/null; then
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
      sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -qq
    sudo apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo usermod -aG docker "$USER"
    ok "Docker instalado"
    warn "Reinicia la terminal o ejecuta: newgrp docker"
  else
    ok "Docker ya instalado: $(docker --version)"
  fi

  info "Arrancando n8n..."
  if docker ps -a --format '{{.Names}}' | grep -q '^n8n$'; then
    docker start n8n 2>/dev/null || true
    ok "n8n arrancado"
  else
    docker run -d \
      --name n8n \
      --restart unless-stopped \
      -p 5678:5678 \
      -v "$HOME/.n8n":/root/.n8n \
      n8nio/n8n
    ok "n8n arrancado"
  fi
  echo -e "${GREEN}n8n disponible en: http://localhost:5678${NC}"
}

configurar_env_global() {
  echo ""
  info "Configurando variables de entorno y aliases en ~/.bashrc..."

  BASHRC="$HOME/.bashrc"

  if ! grep -q '# ECOSISTEMA IA' "$BASHRC"; then
    cat >> "$BASHRC" << 'EOF'

# ================================================================
# ECOSISTEMA IA — añadido por setup.sh de ai-toolkit
# ================================================================

# --- KEYS (descomenta y rellena con tus valores) ---
# export GROQ_API_KEY=gsk_xxx          # console.groq.com — gratis
# export ANTHROPIC_BASE_URL=https://openrouter.ai/api/v1
# export ANTHROPIC_API_KEY=sk-or-xxx   # openrouter.ai — gratis
# export TAVILY_API_KEY=tvly-xxx       # tavily.com — gratis 1000/mes

# --- NVM (Node.js sin sudo) ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# --- NAVEGACIÓN ---
alias thdora='cd ~/projects/thdora'
alias toolkit='cd ~/projects/ai-toolkit'

# --- CLAUDE CODE con modelos gratuitos ---
# Agente principal: escanea repo entero, autónomo, commits
alias claude-code='claude --model openrouter/mistralai/devstral-2:free'
alias claude-think='claude --model openrouter/deepseek/deepseek-r1:free'
alias claude-coder='claude --model openrouter/qwen/qwq-32b:free'

# Claude Code apuntado a repos concretos
alias cc-thdora='cd ~/projects/thdora && claude --model openrouter/mistralai/devstral-2:free'
alias cc-toolkit='cd ~/projects/ai-toolkit && claude --model openrouter/mistralai/devstral-2:free'

# --- AIDER con modelos gratuitos (fixes rápidos) ---
alias aider-fast='aider --model groq/llama-3.3-70b-versatile'
alias aider-think='aider --model groq/qwen-qwq-32b'
alias aider-thdora='cd ~/projects/thdora && aider --model groq/llama-3.3-70b-versatile'

# --- UTILIDADES ---
alias logs-thdora='tail -f ~/projects/thdora/logs/*.log 2>/dev/null || echo "No hay logs todavía"'
# ================================================================
EOF
    ok "Variables y aliases añadidos a ~/.bashrc"
    warn "Edita ~/.bashrc y descomenta las líneas con tus keys reales"
  else
    ok "Variables ya configuradas en ~/.bashrc"
  fi
}

instalar_ai_toolkit() {
  echo ""
  info "Clonando ai-toolkit..."
  TOOLKIT_DIR="$HOME/projects/ai-toolkit"
  if [ ! -d "$TOOLKIT_DIR" ]; then
    mkdir -p "$HOME/projects"
    git clone https://github.com/alvarofernandezmota-tech/ai-toolkit.git "$TOOLKIT_DIR"
    ok "ai-toolkit clonado en $TOOLKIT_DIR"
  else
    git -C "$TOOLKIT_DIR" pull origin main
    ok "ai-toolkit actualizado"
  fi
}

resumen_final() {
  echo ""
  echo -e "${GREEN}╔══════════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║   ✅  INSTALACIÓN COMPLETA — 0€/mes                  ║${NC}"
  echo -e "${GREEN}╚══════════════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "${YELLOW}Próximos pasos:${NC}"
  echo ""
  echo "  1. Añade tus keys en ~/.bashrc:"
  echo "     nano ~/.bashrc"
  echo "     → descomenta GROQ_API_KEY y ANTHROPIC_API_KEY"
  echo ""
  echo "  2. Recarga:"
  echo "     source ~/.bashrc"
  echo ""
  echo "  3. Arranca Claude Code en THDORA (primer agente):"
  echo "     cc-thdora"
  echo ""
  echo "  4. Fixes rápidos con Aider:"
  echo "     aider-thdora"
  echo ""
  echo -e "${BLUE}Modelos gratuitos disponibles:${NC}"
  echo "   claude-code  → Devstral 2 (coding, SWE-bench #1)"
  echo "   claude-think → DeepSeek R1 (thinking, arquitectura)"
  echo "   claude-coder → Qwen3 Coder (coding complejo)"
  echo "   aider-fast   → Llama 3.3 70B en Groq (velocidad)"
  echo ""
  echo -e "${BLUE}Docs: ~/projects/ai-toolkit/ECOSISTEMA.md${NC}"
  echo ""
}

# =============================================================================
# EJECUCIÓN
# =============================================================================

case $OPCION in
  1)
    instalar_base
    instalar_python
    instalar_herramientas_codigo
    instalar_thdora
    instalar_docker_n8n
    instalar_ai_toolkit
    configurar_env_global
    resumen_final
    ;;
  2)
    instalar_base
    instalar_python
    instalar_herramientas_codigo
    instalar_ai_toolkit
    configurar_env_global
    resumen_final
    ;;
  3)
    instalar_base
    instalar_python
    instalar_thdora
    configurar_env_global
    resumen_final
    ;;
  4)
    instalar_base
    instalar_docker_n8n
    resumen_final
    ;;
  5)
    instalar_base
    instalar_python
    ok "Base lista"
    ;;
  *)
    err "Opción no válida. Elige entre 1 y 5."
    ;;
esac

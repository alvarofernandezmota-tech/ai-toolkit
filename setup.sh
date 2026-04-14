#!/usr/bin/env bash
# =============================================================================
# ECOSISTEMA PERSONAL DE AGENTES IA
# Instalador completo para Ubuntu / WSL2
# Uso: bash <(curl -fsSL https://raw.githubusercontent.com/alvarofernandezmota-tech/ai-toolkit/main/setup.sh)
# =============================================================================

set -e  # salir si algo falla

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # sin color

ok()   { echo -e "${GREEN}✓${NC} $1"; }
info() { echo -e "${BLUE}→${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }
err()  { echo -e "${RED}✗${NC} $1"; exit 1; }

echo ""
echo -e "${BLUE}╔══════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   🤖  ECOSISTEMA DE AGENTES IA               ║${NC}"
echo -e "${BLUE}║   Setup completo para Ubuntu / WSL2          ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════╝${NC}"
echo ""

# =============================================================================
# MENÚ DE INSTALACIÓN
# =============================================================================
echo "¿Qué quieres instalar?"
echo ""
echo "  1) Todo (recomendado primera vez)"
echo "  2) Solo herramientas de código (Aider + Node.js + Claude Code)"
echo "  3) Solo THDORA (bot + API)"
echo "  4) Solo Docker + n8n"
echo "  5) Solo dependencias base (Python, git, curl)"
echo ""
read -rp "Elige [1-5]: " OPCION
OPCION=${OPCION:-1}

# =============================================================================
# FUNCIONES DE INSTALACIÓN
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

  # Añadir repositorio deadsnakes si Python < 3.11
  PY_VER=$(python3 --version 2>/dev/null | awk '{print $2}' | cut -d. -f2)
  if [ -z "$PY_VER" ] || [ "$PY_VER" -lt 11 ]; then
    sudo add-apt-repository -y ppa:deadsnakes/ppa -qq
    sudo apt-get update -qq
    sudo apt-get install -y -qq python3.11 python3.11-venv python3.11-dev
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1
  fi

  # pip
  curl -sS https://bootstrap.pypa.io/get-pip.py | python3
  ok "Python $(python3 --version) listo"
}

instalar_herramientas_codigo() {
  echo ""
  info "Instalando herramientas de código IA..."

  # Aider
  pip install -q aider-chat
  ok "Aider instalado: $(aider --version 2>/dev/null || echo 'ok')"

  # duckduckgo-search (búsqueda web para THDORA)
  pip install -q duckduckgo-search
  ok "DuckDuckGo Search instalado"

  # Node.js 20 (para Claude Code)
  if ! command -v node &>/dev/null; then
    info "Instalando Node.js 20..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - -qq
    sudo apt-get install -y -qq nodejs
  fi
  ok "Node.js $(node --version) listo"

  # Claude Code
  npm install -g @anthropic-ai/claude-code --silent
  ok "Claude Code instalado"

  # CrewAI (multi-agente, para más adelante)
  pip install -q crewai 2>/dev/null || warn "CrewAI requiere Python 3.12, instálalo manualmente si falla"
  ok "CrewAI instalado"
}

instalar_thdora() {
  echo ""
  info "Configurando THDORA..."

  THDORA_DIR="$HOME/projects/thdora"

  if [ ! -d "$THDORA_DIR" ]; then
    info "Clonando THDORA..."
    mkdir -p "$HOME/projects"
    git clone https://github.com/alvarofernandezmota-tech/thdora.git "$THDORA_DIR"
    ok "THDORA clonado en $THDORA_DIR"
  else
    info "THDORA ya existe, haciendo pull..."
    git -C "$THDORA_DIR" pull origin main
    ok "THDORA actualizado"
  fi

  # Crear .venv si no existe
  if [ ! -d "$THDORA_DIR/.venv" ]; then
    python3 -m venv "$THDORA_DIR/.venv"
    ok "Entorno virtual creado"
  fi

  # Instalar dependencias
  "$THDORA_DIR/.venv/bin/pip" install -q -r "$THDORA_DIR/requirements.txt"
  ok "Dependencias de THDORA instaladas"

  # Crear .env si no existe
  if [ ! -f "$THDORA_DIR/.env" ]; then
    cp "$THDORA_DIR/.env.example" "$THDORA_DIR/.env"
    warn "Crea tu .env en $THDORA_DIR/.env con tus keys"
    warn "Campos necesarios: TELEGRAM_TOKEN, GROQ_API_KEY"
  else
    ok ".env ya existe"
  fi

  echo ""
  echo -e "${YELLOW}Para arrancar THDORA:${NC}"
  echo "  cd $THDORA_DIR"
  echo "  make run-api   # en una terminal"
  echo "  make run-bot   # en otra terminal"
}

instalar_docker_n8n() {
  echo ""
  info "Instalando Docker..."

  if ! command -v docker &>/dev/null; then
    # Instalar Docker oficial
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
    ok "Docker ya está instalado: $(docker --version)"
  fi

  # Arrancar n8n
  info "Arrancando n8n..."
  if docker ps -a --format '{{.Names}}' | grep -q '^n8n$'; then
    docker start n8n 2>/dev/null || true
    ok "n8n ya existía, arrancado"
  else
    docker run -d \
      --name n8n \
      --restart unless-stopped \
      -p 5678:5678 \
      -v "$HOME/.n8n":/root/.n8n \
      n8nio/n8n
    ok "n8n arrancado"
  fi

  echo ""
  echo -e "${GREEN}n8n disponible en: http://localhost:5678${NC}"
}

configurar_env_global() {
  echo ""
  info "Configurando variables de entorno en ~/.bashrc..."

  BASHRC="$HOME/.bashrc"

  # Añadir bloque solo si no existe
  if ! grep -q '# ECOSISTEMA IA' "$BASHRC"; then
    cat >> "$BASHRC" << 'EOF'

# ECOSISTEMA IA — añadido por setup.sh
# Groq (ya lo tienes de THDORA, cópialo aquí)
# export GROQ_API_KEY=tu_key_de_groq

# OpenRouter (consigue key gratis en openrouter.ai)
# export ANTHROPIC_BASE_URL=https://openrouter.ai/api/v1
# export ANTHROPIC_API_KEY=tu_key_de_openrouter

# Tavily búsqueda web (gratis en tavily.com)
# export TAVILY_API_KEY=tu_key_de_tavily

# Alias útiles
alias thdora='cd ~/projects/thdora'
alias toolkit='cd ~/projects/ai-toolkit'
alias logs='tail -f ~/projects/thdora/logs/*.log 2>/dev/null || echo "No hay logs todavía"'
alias aider-thdora='cd ~/projects/thdora && aider --model groq/llama-3.3-70b-versatile'
EOF
    ok "Variables y alias añadidos a ~/.bashrc"
    warn "Descomenta las líneas con tus keys reales en ~/.bashrc"
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
  echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║   ✅  INSTALACIÓN COMPLETA                   ║${NC}"
  echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "${YELLOW}Próximos pasos:${NC}"
  echo ""
  echo "  1. Edita ~/.bashrc y añade tus keys:"
  echo "     nano ~/.bashrc"
  echo ""
  echo "  2. Recarga la terminal:"
  echo "     source ~/.bashrc"
  echo ""
  echo "  3. Arranca THDORA:"
  echo "     thdora   # alias para ir al directorio"
  echo "     make run-api & make run-bot"
  echo ""
  echo "  4. Usa Aider en THDORA:"
  echo "     aider-thdora   # alias directo"
  echo ""
  echo "  5. n8n ya corre en: http://localhost:5678"
  echo ""
  echo -e "${BLUE}Docs completas: ~/projects/ai-toolkit/ECOSISTEMA.md${NC}"
  echo ""
}

# =============================================================================
# EJECUCIÓN SEGÚN OPCIÓN
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

#!/usr/bin/env bash
# =============================================================================
# ECOSISTEMA PERSONAL DE AGENTES IA - Bootstrap Setup
# Arquitectura Colmena: OpenCode → LiteLLM proxy :8000
#   Groq → SambaNova → Together → OpenRouter → Gemini → Cerebras
# =============================================================================

set -e

echo "🚀 Starting ecosystem setup..."

# Install base dependencies
echo "📦 Installing base dependencies..."
sudo apt-get update -qq
sudo apt-get install -y -qq curl wget git unzip build-essential tmux

# Configure Python 3.11+
echo "🐍 Configuring Python 3.11+..."
if ! command -v python3.11 &> /dev/null; then
    sudo add-apt-repository -y ppa:deadsnakes/ppa -qq
    sudo apt-get install -y -qq python3.11 python3.11-venv python3.11-dev
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1
fi
curl -sS https://bootstrap.pypa.io/get-pip.py | python3 -q

# Install LiteLLM proxy
echo "🔀 Installing LiteLLM proxy..."
if ! command -v litellm &> /dev/null; then
    pip install -q 'litellm[proxy]'
    echo "LiteLLM instalado: $(litellm --version)"
else
    echo "LiteLLM ya instalado: $(litellm --version)"
fi

# Install Node.js 20 via NVM
echo "⚙️ Installing Node.js 20..."
export NVM_DIR="$HOME/.nvm"
if ! command -v nvm &> /dev/null; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    . "$NVM_DIR/nvm.sh"
fi
nvm install --lts
nvm use --lts

# Install Claude Code
echo "🔮 Installing Claude Code..."
if command -v claude &> /dev/null; then
    echo "Claude Code already installed: $(claude --version)"
else
    npm install -g @anthropic-ai/claude-code -q
    echo "Claude Code installed: $(claude --version)"
fi

# Install OpenCode
echo "🧠 Installing OpenCode..."
if command -v opencode &> /dev/null; then
    echo "OpenCode already installed: $(opencode --version)"
else
    npm install -g opencode-ai -q
    echo "OpenCode installed: $(opencode --version)"
fi

# Install Aider
echo "🧰 Installing Aider..."
pip install -q aider-chat

# Setup environment variables and aliases
echo "🔧 Configuring environment variables and aliases..."
BASHRC="$HOME/.bashrc"

if ! grep -q '# ECOSISTEMA IA — Added by setup.sh' "$BASHRC"; then
    cat >> "$BASHRC" << 'EOF'

# ================================================================
# ECOSISTEMA IA — Added by setup.sh
# ================================================================

# --- KEYS (fill in your real keys) ---
export GROQ_API_KEY="gsk_xxx"                     # console.groq.com — gratis 6000 req/día
export SAMBANOVA_API_KEY="xxx"                     # cloud.sambanova.ai — gratis
export TOGETHER_API_KEY="xxx"                      # api.together.xyz — $1 crédito gratis
export OPENROUTER_API_KEY="sk-or-xxx"             # openrouter.ai — fallback gratis
export CEREBRAS_API_KEY="xxx"                      # cloud.cerebras.ai — límite diario
export GOOGLE_GENERATIVE_AI_API_KEY="AIza_xxx"    # aistudio.google.com — 1500 req/día
# export ANTHROPIC_API_KEY="sk-ant-xxx"           # anthropic.com — de pago
# export OPENAI_API_KEY="sk-xxx"                  # openai.com — de pago
# export MISTRAL_API_KEY="xxx"                    # mistral.ai — de pago

# --- NVM (Node.js without sudo) ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# --- NAVIGATION ---
alias thdora='cd ~/projects/thdora'
alias toolkit='cd ~/projects/ai-toolkit'

# --- LITELLM PROXY ---
alias colmena='cd ~/projects/ai-toolkit && bash scripts/start-colmena.sh'
alias proxy='cd ~/projects/ai-toolkit && bash scripts/start-colmena.sh --solo-proxy'
alias menu='cd ~/projects/ai-toolkit && bash scripts/ai-menu.sh'

# --- OPENCODE (siempre vía proxy) ---
alias oc='opencode'
alias ocp='opencode --model litellm/principal'

# --- CLAUDE CODE with free models ---
alias claude-free='claude --model openrouter/meta-llama/llama-4-scout:free'
alias claude-think='claude --model openrouter/deepseek/deepseek-r1:free'

# --- AIDER with free models ---
alias aider-fast='aider --model groq/llama-3.3-70b-versatile'
alias aider-samba='aider --model sambanova/Llama-4-Maverick-17B-128E-Instruct'
alias aider-together='aider --model together_ai/meta-llama/Llama-4-Maverick-17B-128E-Instruct-FP8'
alias aider-free='aider --model openrouter/meta-llama/llama-4-scout:free'

EOF
    echo "✅ Configuración añadida a ~/.bashrc"
    echo "⚠️  Edita ~/.bashrc y añade tus API keys reales en la sección KEYS"
else
    echo "✅ Configuración de entorno ya presente en ~/.bashrc"
fi

# Reload bashrc
source "$BASHRC" 2>/dev/null || true

echo ""
echo "✅ Setup completo. Pasos siguientes:"
echo "   1. Edita ~/.bashrc y añade tus API keys reales"
echo "   2. source ~/.bashrc"
echo "   3. cd ~/projects/ai-toolkit && bash scripts/start-colmena.sh"
echo "   4. O lanza el menú: bash scripts/ai-menu.sh"

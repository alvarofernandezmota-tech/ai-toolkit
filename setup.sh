#!/usr/bin/env bash
# =============================================================================
# ECOSISTEMA PERSONAL DE AGENTES IA - Bootstrap Setup
# =============================================================================

set -e

echo "🚀 Starting ecosystem setup..."

# Install base dependencies
echo "📦 Installing base dependencies..."
sudo apt-get update -qq
sudo apt-get install -y -qq curl wget git unzip build-essential

# Configure Python 3.11+
echo "🐍 Configuring Python 3.11+..."
if ! command -v python3.11 &> /dev/null; then
    sudo add-apt-repository -y ppa:deadsnakes/ppa -qq
    sudo apt-get install -y -qq python3.11 python3.11-venv python3.11-dev
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1
fi
curl -sS https://bootstrap.pypa.io/get-pip.py | python3 -q

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

# Install Aider
echo "🧰 Installing Aider..."
pip install -q aider-chat

# Setup environment variables and aliases
echo "🔧 Configuring environment variables and aliases..."
BASHRC="$HOME/.bashrc"

# Add ecosystem configuration to ~/.bashrc if not already present
if ! grep -q '# ================================================================' "$BASHRC"; then
    cat >> "$BASHRC" << 'EOF'

# ================================================================
# ECOSISTEMA IA — Added by setup.sh
# ================================================================

# --- KEYS (fill in your real keys) ---
export GROQ_API_KEY=gsk_xxx          # console.groq.com
# export ANTHROPIC_BASE_URL=https://openrouter.ai/api/v1
# export ANTHROPIC_API_KEY=sk-or-xxx   # openrouter.ai

# --- NVM (Node.js without sudo) ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# --- NAVIGATION ---
alias thdora='cd ~/projects/thdora'
alias toolkit='cd ~/projects/ai-toolkit'

# --- CLAUDE CODE with free models ---
alias claude='claude --model openrouter/free'
alias claude-code='claude --model openrouter/free'
alias claude-think='claude --model openrouter/deepseek/deepseek-r1:free'
alias claude-coder='claude --model openrouter/qwen/qwq-32b:free'

# --- AIDER with free models ---
alias aider-fast='aider --model groq/llama-3.3-70b-versatile'
alias aider-think='aider --model groq/qwen-qwq-32b'
alias aider-thdora='cd ~/projects/thdora && aider --model groq/llama-3.3-70b-versatile'

EOF
    echo "Configuration added to ~/.bashrc"
    warn "Edit ~/.bashrc and uncomment/add your keys in the KEYS section"
else
    echo "Environment configuration already present in ~/.bashrc"
fi

# Reload bashrc to apply changes
source "$BASHRC"

echo "✅ Setup complete! Remember to:"
echo "   1. Add your API keys to ~/.bashrc"
echo "   2. Source ~/.bashrc or restart terminal"
echo "   3. Test with 'claude --version' and 'aider --version'"
#!/bin/bash
# check-colmena.sh — Diagnóstico del ecosistema Colmena
# Uso: bash scripts/check-colmena.sh
# Comprueba que todos los componentes están listos antes de arrancar

export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:$PATH"
DIR="$(cd "$(dirname "$0")/.." && pwd)"
PUERTO=8000
SESSION="colmena"
ERRORS=0

echo ""
echo "🔍 CHECK COLMENA — Diagnóstico del ecosistema"
echo "================================================"
echo ""

# ─── tmux ────────────────────────────────────────────────────────────
if command -v tmux &>/dev/null; then
  TMUX_VER=$(tmux -V)
  echo "✅ tmux: $TMUX_VER"
else
  echo "❌ tmux: NO instalado — sudo apt install tmux -y"
  ERRORS=$((ERRORS+1))
fi

# ─── litellm ─────────────────────────────────────────────────────────
LITELLM=""
for C in "$DIR/.venv/bin/litellm" "$HOME/projects/thdora/.venv/bin/litellm"; do
  [ -f "$C" ] && LITELLM="$C" && break
done
[ -z "$LITELLM" ] && command -v litellm &>/dev/null && LITELLM="litellm"
if [ -n "$LITELLM" ]; then
  LITELLM_VER=$("$LITELLM" --version 2>/dev/null || echo "desconocida")
  echo "✅ litellm: $LITELLM_VER ($LITELLM)"
else
  echo "❌ litellm: NO encontrado — pip install 'litellm[proxy]'"
  ERRORS=$((ERRORS+1))
fi

# ─── opencode ────────────────────────────────────────────────────────
OPENCODE=""
for C in "$HOME/.npm-global/bin/opencode" "$HOME/.local/bin/opencode" "/usr/local/bin/opencode"; do
  [ -f "$C" ] && OPENCODE="$C" && break
done
[ -z "$OPENCODE" ] && command -v opencode &>/dev/null && OPENCODE="opencode"
if [ -n "$OPENCODE" ]; then
  echo "✅ opencode: encontrado ($OPENCODE)"
else
  echo "❌ opencode: NO encontrado — npm install -g opencode-ai"
  ERRORS=$((ERRORS+1))
fi

# ─── Puerto 8000 ─────────────────────────────────────────────────────
USO=$(lsof -ti :$PUERTO 2>/dev/null)
if [ -z "$USO" ]; then
  echo "✅ Puerto $PUERTO: libre"
else
  PROC=$(ps -p $USO -o comm= 2>/dev/null || echo "desconocido")
  echo "⚠️  Puerto $PUERTO: EN USO por '$PROC' (PID $USO)"
fi

# ─── Sesión tmux colmena ─────────────────────────────────────────────
if tmux has-session -t $SESSION 2>/dev/null; then
  PANELES=$(tmux list-panes -t $SESSION:0 2>/dev/null | wc -l)
  echo "✅ tmux sesión '$SESSION': ACTIVA ($PANELES paneles)"
else
  echo "ℹ️  tmux sesión '$SESSION': no activa (normal si no has arrancado)"
fi

# ─── LiteLLM respondiendo ────────────────────────────────────────────
if curl -s http://localhost:$PUERTO/health/liveliness &>/dev/null; then
  echo "✅ LiteLLM :$PUERTO: RESPONDIENDO"
else
  echo "ℹ️  LiteLLM :$PUERTO: no responde (normal si no has arrancado)"
fi

# ─── Variables de entorno ─────────────────────────────────────────────
echo ""
echo "🔑 Variables de entorno:"
[ -n "$GROQ_API_KEY" ]       && echo "✅ GROQ_API_KEY: presente"       || echo "❌ GROQ_API_KEY: ausente"
[ -n "$SAMBANOVA_API_KEY" ]  && echo "✅ SAMBANOVA_API_KEY: presente"  || echo "⚠️  SAMBANOVA_API_KEY: ausente (opcional)"
[ -n "$TOGETHER_API_KEY" ]   && echo "✅ TOGETHER_API_KEY: presente"   || echo "⚠️  TOGETHER_API_KEY: ausente (opcional)"
[ -n "$OPENROUTER_API_KEY" ] && echo "✅ OPENROUTER_API_KEY: presente" || echo "⚠️  OPENROUTER_API_KEY: ausente (opcional)"
[ -n "$CEREBRAS_API_KEY" ]   && echo "✅ CEREBRAS_API_KEY: presente"   || echo "⚠️  CEREBRAS_API_KEY: ausente (opcional)"

# ─── Resumen ─────────────────────────────────────────────────────────
echo ""
echo "================================================"
if [ $ERRORS -eq 0 ]; then
  echo "✅ TODO OK — listo para: bash scripts/start-colmena.sh"
else
  echo "❌ $ERRORS error(es) críticos — resuélvelos antes de arrancar"
fi
echo ""

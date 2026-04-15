#!/usr/bin/env bash
set -e

CONFIG="$(cd "$(dirname "$0")/.." && pwd)/litellm-config.yaml"
PORT=4000
LOG="/tmp/litellm.log"

# Matar instancias anteriores
pkill -f litellm 2>/dev/null || true
pkill -f claude  2>/dev/null || true
rm -f ~/.claude/auth.json 2>/dev/null || true
sleep 1

echo "==> Arrancando LiteLLM en segundo plano (log: $LOG)"
nohup litellm --config "$CONFIG" --port $PORT > "$LOG" 2>&1 &
LITELLM_PID=$!
echo "    PID: $LITELLM_PID"

echo "==> Esperando que arranque el proxy..."
for i in $(seq 1 15); do
  if curl -s http://localhost:$PORT/health > /dev/null 2>&1; then
    echo "    Proxy OK en :$PORT"
    break
  fi
  sleep 1
done

echo "==> Lanzando Claude Code (bypass mode)..."
export ANTHROPIC_API_KEY="fake-key"
export ANTHROPIC_BASE_URL="http://localhost:$PORT"

# Acepta el warning de bypass automaticamente via expect si esta disponible
if command -v expect &>/dev/null; then
  expect -c '
    spawn claude --dangerously-skip-permissions
    expect "By proceeding"
    send "\r"
    interact
  '
else
  # Sin expect: lanza y el usuario acepta manualmente
  echo ""
  echo ">>> Cuando aparezca el WARNING pulsa Enter para aceptar <<<"
  echo ""
  claude --dangerously-skip-permissions
fi

echo "==> Cerrando LiteLLM..."
kill $LITELLM_PID 2>/dev/null || true

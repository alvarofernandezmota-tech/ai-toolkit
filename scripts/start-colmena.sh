#!/bin/bash
# start-colmena.sh — Arranque limpio de LiteLLM + OpenCode
# Uso: bash scripts/start-colmena.sh
# Uso (solo proxy): bash scripts/start-colmena.sh --solo-proxy
#
# PROBLEMA RESUELTO: si hay un litellm arrancado desde otro proyecto (ej: thdora)
# pkill -f litellm no basta porque el proceso pertenece a otro venv.
# Este script mata TODOS los procesos litellm por PID antes de arrancar.

set -e
CONFIG="$(cd "$(dirname "$0")/.." && pwd)/litellm-config.yaml"
PUERTO=8000

echo "🧹 Matando TODOS los procesos litellm activos..."
# Mata por nombre de binario (cualquier venv, cualquier proyecto)
pkill -f litellm 2>/dev/null || true
sleep 1

# Comprobación extra: si el puerto sigue ocupado, matar el proceso que lo usa
if lsof -ti :$PUERTO &>/dev/null; then
  echo "⚠️  Puerto $PUERTO ocupado. Matando proceso..."
  lsof -ti :$PUERTO | xargs kill -9 2>/dev/null || true
  sleep 1
fi

echo "✅ LiteLLM limpio. Arrancando con config: $CONFIG"
litellm --config "$CONFIG" --port $PUERTO &
LITELLM_PID=$!
echo "🔧 PID: $LITELLM_PID"

# Esperar a que arranque
for i in $(seq 1 15); do
  if curl -s http://localhost:$PUERTO/health/liveliness &>/dev/null; then
    echo "✅ LiteLLM listo en http://localhost:$PUERTO"
    break
  fi
  echo -n "."
  sleep 1
done
echo ""

# Abrir OpenCode salvo que se pase --solo-proxy
if [ "$1" != "--solo-proxy" ]; then
  echo "🚀 Abriendo OpenCode..."
  opencode
fi

#!/usr/bin/env bash
# sync_brain.sh — Pipeline de sincronización Git-first para yggdrasil-dew
# Cron recomendado: 0 4 * * * /bin/bash /home/alvaro/services/ai-stack/sync_brain.sh >> /var/log/sync_brain.log 2>&1
# Autor: Álvaro Fernández Mota · 16 junio 2026
# Doc: ai-toolkit/docs/ARQUITECTURA-PIPELINE.md
set -euo pipefail

# ─────────────────────────────────────────────
# CONFIGURACIÓN — ajustar antes de usar
# ─────────────────────────────────────────────
REPO_PATH="/home/alvaro/yggdrasil-dew"
API_URL="http://localhost:3000/api/v1"
API_KEY="${OPEN_WEBUI_API_KEY:-TU_API_KEY_AQUI}"   # exportar como variable de entorno
KNOWLEDGE_ID="${OPEN_WEBUI_KNOWLEDGE_ID:-yggdrasil-dew-uuid}" # ID de la knowledge base en Open WebUI
LOG_PREFIX="[sync_brain $(date '+%Y-%m-%d %H:%M:%S')]"

# ─────────────────────────────────────────────
# PASO 1 — Sincronizar repositorio Git
# ─────────────────────────────────────────────
echo "$LOG_PREFIX Iniciando sincronización de yggdrasil-dew..."
cd "$REPO_PATH"

git fetch origin
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse @{u})

if [ "$LOCAL" != "$REMOTE" ] || [ "${1:-}" == "--force" ]; then
    git reset --hard origin/main
    echo "$LOG_PREFIX Repositorio actualizado a $(git rev-parse --short HEAD)."

    # ─────────────────────────────────────────
    # PASO 2 — Notificar reindexación a Open WebUI
    # Solo reindexar carpeta diarios/ para minimizar impacto CPU
    # ─────────────────────────────────────────
    echo "$LOG_PREFIX Notificando reindexación RAG a Open WebUI..."
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
        -X POST "$API_URL/knowledge/$KNOWLEDGE_ID/sync" \
        -H "Authorization: Bearer $API_KEY" \
        -H "Content-Type: application/json" \
        -d '{"path": "/data/knowledge/yggdrasil-dew/diarios"}')

    if [ "$HTTP_STATUS" -eq 200 ] || [ "$HTTP_STATUS" -eq 201 ]; then
        echo "$LOG_PREFIX Reindexación RAG confirmada (HTTP $HTTP_STATUS)."
    else
        echo "$LOG_PREFIX WARN: Open WebUI respondió HTTP $HTTP_STATUS. Verificar manualmente."
        exit 1
    fi
else
    echo "$LOG_PREFIX Repositorio ya al día ($(git rev-parse --short HEAD)). Sin procesamiento adicional."
fi

echo "$LOG_PREFIX Sincronización completada."

# ARQUITECTURA-PIPELINE.md

> Documento de referencia para la fase de ingeniería fina del ecosistema.
> Generado: 16 junio 2026 · Sesión Claude + investigación Gemini/Grok/Perplexity
> Ver contexto completo: [yggdrasil-dew/ECOSISTEMA.md](https://github.com/alvarofernandezmota-tech/yggdrasil-dew/blob/main/ECOSISTEMA.md)

---

## 7. PIPELINE DE SINCRONIZACIÓN AUTOMÁTICA (Git-first)

### Objetivo
yggdrasil-dew es la única fuente de verdad. Open WebUI está montado en modo lectura sola (`ro`). Este pipeline mantiene el repo local de Madre sincronizado y notifica al motor RAG de Open WebUI sin intervención manual.

### Script
```
Ruta en Madre: /home/alvaro/services/ai-stack/sync_brain.sh
Ruta en repo:  ai-toolkit/scripts/sync_brain.sh
```

El script:
1. `git fetch origin` — detecta cambios remotos sin afectar working tree.
2. Compara `HEAD` local vs remoto — **no hace nada si ya está al día** (0 CPU).
3. Si hay cambios: `git reset --hard origin/main` — actualización limpia, sin conflictos.
4. Llama a la API interna de Open WebUI para reindexar solo `diarios/` — evita reindexar el vault completo en cada sync.
5. Valida HTTP response — loguea error si Open WebUI no responde correctamente.

### Variables de entorno necesarias en Madre
```bash
export OPEN_WEBUI_API_KEY="tu_api_key"         # Ajustes > Cuenta > Claves API
export OPEN_WEBUI_KNOWLEDGE_ID="uuid-del-kb"   # ID de la knowledge base yggdrasil-dew
```
Guardar en `/home/alvaro/.env.ai-stack` y sourcear desde `.bashrc` o en el cron.

### Cron en Madre (04:00 AM — horas de baja actividad)
```bash
# crontab -e
0 4 * * * /bin/bash /home/alvaro/services/ai-stack/sync_brain.sh >> /var/log/sync_brain.log 2>&1
```

> ⚠️ **Por qué 04:00 y no otra hora:** protege la disponibilidad de thdora durante horas de uso activo. La reindexación RAG puede saturar CPU durante 1-3 min en CPU-only.

---

## 8. CONFIGURACIÓN opencode.json (Acer/varopc)

Integración bidireccional del agente de terminal OpenCode con el vault yggdrasil-dew via LiteLLM proxy.

```json
{
  "agent_name": "OpenCode-Orchestrator",
  "llm_provider": "openai",
  "api_base": "http://localhost:8000/v1",
  "model": "ollama/deepseek-r1:14b",
  "temperature": 0.0,
  "max_tokens": 4096,
  "workspace_paths": [
    "/home/alvaro/proyectos/yggdrasil-dew",
    "/home/alvaro/proyectos/thdora",
    "/home/alvaro/proyectos/ai-toolkit"
  ],
  "rag_enabled": true,
  "rag_context_window": 8192,
  "system_prompt": "Eres el orquestador técnico de Álvaro Fernández Mota. Tienes acceso de solo lectura al espacio yggdrasil-dew. Automatiza operaciones de sistemas bajo principios 100% open-source. Sé conciso y directo."
}
```

> **Nota:** Este JSON es la versión objetivo/planificada. El `opencode.json` actual en raíz tiene la config real operativa. Actualizar cuando Open WebUI + RAG estén levantados en Madre.

### Modelos disponibles en LiteLLM proxy (:8000)
| Modelo | Uso recomendado |
|--------|----------------|
| `ollama/deepseek-r1:14b` | Razonamiento complejo, arquitectura |
| `ollama/qwen2.5-coder:14b` | Código, refactoring |
| `ollama/qwen3:8b` | Tareas rápidas, contexto corto |

---

## 9. HARDENING Y SEGURIDAD — UFW + Tailscale

### Reglas UFW en Madre

Bloquear acceso público a servicios internos, permitir solo desde interfaz Tailscale:

```bash
# Denegar acceso externo directo a Open WebUI y Ollama
sudo ufw deny 3000/tcp
sudo ufw deny 11434/tcp

# Permitir solo desde interfaz Tailscale
sudo ufw allow in on tailscale0 to any port 3000 proto tcp comment 'Open WebUI — solo Tailscale'
sudo ufw allow in on tailscale0 to any port 11434 proto tcp comment 'Ollama — solo Tailscale'

# Aplicar
sudo ufw enable
sudo ufw status verbose
```

### Estado actual UFW
| Máquina | UFW | Estado |
|---------|-----|--------|
| Acer | ✅ | Activo |
| Madre | ⏳ | Pendiente — PRÓXIMA TAREA |

> ⚠️ **Riesgo activo:** Madre no tiene UFW activo. Ollama en puerto 11434 y cualquier futuro Open WebUI en 3000 estarían expuestos en la red local. Aplicar UFW antes de levantar Open WebUI.

---

## 10. ARQUITECTURA DE DATOS FINAL (Flujo de Contexto)

```
[ Acer/varopc (Arch Linux) ]
    │ Edición Markdown pura + Git Push
    │ OpenCode (deepseek-r1:14b / qwen2.5-coder:14b via LiteLLM)
    │
    ▼
[ GitHub — yggdrasil-dew ] ◄──── Telegram /diario (thdora → GitHub Contents API)
    │
    │ Git Pull automatizado (sync_brain.sh · cron 04:00)
    │
    ▼
[ Madre — Ubuntu Server CPU-only ]
    │
    ├──► [ thdora · FastAPI · Docker ]
    │         Bot Telegram TOKI · GroqBackend + OllamaBackend
    │
    └──► [ Open WebUI · Docker ]
              │ Volumen: yggdrasil-dew/diarios/ (read-only)
              │ RAG: ChromaDB interno
              ▼
         [ Ollama · llama3.2:3b · CPU ]
              RAG semántico sobre diarios + ECOSISTEMA.md
```

### Principios del flujo
- **Git-first:** GitHub es el bus de comunicación entre todos los nodos.
- **CPU-only:** Inferencia en nube (Groq free tier) para tiempo real. Ollama local para RAG batch.
- **0€:** Solo free tiers y servicios self-hosted.
- **Sin formatos propietarios:** Todo Markdown puro — sin binarios en el historial Git.
- **Aislamiento:** thdora y Open WebUI en Docker separados, con política de CPU Docker si hace falta.

---

## Tareas pendientes de implementación

| Tarea | Repo | Prioridad | Estado |
|-------|------|-----------|--------|
| Aplicar UFW en Madre (reglas Tailscale) | — (Madre) | 🔴 Alta | ⏳ |
| Levantar Open WebUI en Docker en Madre | ai-toolkit | 🔴 Alta | ⏳ |
| Configurar Knowledge Base yggdrasil-dew en Open WebUI | — | 🔴 Alta | ⏳ |
| Desplegar sync_brain.sh en Madre + cron 04:00 | ai-toolkit | 🟡 Media | ⏳ |
| Actualizar opencode.json con workspace_paths reales | ai-toolkit | 🟡 Media | ⏳ |
| Handler `/diario` en thdora → GitHub Contents API | thdora | 🟡 Media | ⏳ |

---

_Ver también: [ARQUITECTURA.md](../ARQUITECTURA.md) · [CEREBRO.md](../CEREBRO.md)_
_Última actualización: 16 junio 2026 — 19:53 CEST_

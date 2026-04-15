# 🗺️ Roadmap — Ecosistema de Agentes IA

> Registro de todo lo que hay que construir, en orden de prioridad.
> Actualizado: 15 abril 2026 (sesión tarde).

---

## ✅ Completado

| Logro | Fecha |
|---|---|
| Estructura base del repo | 14-04-2026 |
| Claude Code + OpenRouter funcionando | 15-04-2026 |
| OpenCode + DeepSeek R1 funcionando | 15-04-2026 |
| Scripts rotación modelos con fallback | 15-04-2026 |
| `ai-menu.sh` — menú interactivo de agentes | 15-04-2026 |
| README público para la comunidad (EN) | 15-04-2026 |
| `INICIO-AQUI.md` — brujula personal | 15-04-2026 |
| `docs/VISION-SISTEMA.md` — norte del sistema | 15-04-2026 |
| `agentes/PENDIENTES.md` — lista viva de agentes | 15-04-2026 |
| `guias/opencode-deepseek.md` — guia personal | 15-04-2026 |

---

## 🔧 Esta semana (15-20 abril 2026)

### Capa 2 — Menú inteligente
- [ ] `scripts/ai-menu.sh` muestra estado de APIs (rate limit restante)
- [ ] Rotación automática si un modelo está caído
- [ ] Muestra última sesión de OpenCode para continuar

### Capa 3 — Primer agente real
- [ ] `scripts/generar-diario.sh` — genera docs/diario/ con git log + OpenRouter API
- [ ] Probar con OpenCode como constructor: darle PENDIENTES y que construya
- [ ] Primer uso real de Claude Code sobre THDORA (bugs en `agentes/thdora-primera-sesion.md`)

---

## 📅 Abril 2026 — Sistema base

- [ ] Agente de documentación automática de sesión (`scripts/generar-diario.sh`)
- [ ] Agente de investigación web (`scripts/investigar.sh`)
- [ ] Agente revisor de código probado en THDORA
- [ ] `prompts/` — prompts que funcionan bien guardados para reutilizar
- [ ] Alias en `.bashrc`: `aitoolkit` lanza el menú desde cualquier directorio

---

## 📅 Mayo 2026 — n8n + automatizaciones

- [ ] Docker instalado en WSL
- [ ] n8n arrancando en localhost:5678
- [ ] Workflow 1: Brief diario 08:00 → Telegram
- [ ] Workflow 2: Alerta hábitos 22:00 → Telegram
- [ ] Workflow 3: Diario automático 23:00 → commit en repo
- [ ] Workflow 4: Resumen semanal lunes → Telegram
- [ ] Endpoints THDORA API para n8n

---

## 📅 Junio 2026 — Búsqueda web en THDORA

- [ ] `pip install duckduckgo-search`
- [ ] `src/core/web_search.py` en THDORA
- [ ] Intent `busqueda_web` en NLP router
- [ ] Tests para web_search.py
- [ ] Key Tavily si DuckDuckGo no es suficiente

---

## 📅 Verano 2026 — Voz con Whisper

- [ ] Handler mensajes de audio en aiogram
- [ ] Transcripción con Groq Whisper API
- [ ] Conectar transcripción con NLP existente

---

## 📅 Otoño 2026 — Multi-agente CrewAI

- [ ] `pip install crewai crewai-tools`
- [ ] Agente revisor de código (DeepSeek R1)
- [ ] Agente escritor de tests (Qwen3 Coder)
- [ ] Agente generador de docs (Llama 3.3)
- [ ] Integración: trigger desde n8n cuando hay PR nuevo

---

## 🏁 Ecosistema completo (Fin 2026)

Cuando todo esté montado, esto pasa solo cada día:

```
08:00  → Brief del día llega por Telegram
día    → THDORA responde en lenguaje natural
día    → Claude Code + OpenCode disponibles en terminal
22:00  → Alerta hábitos si quedan pendientes
23:00  → Diario del día se escribe solo en GitHub
lunes  → Resumen de la semana llega por Telegram
```

**Consumo total: <1% CPU, ~370 MB RAM, 0€/mes.**

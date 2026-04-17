# 🗺️ Roadmap — Ecosistema de Agentes IA

> Registro de todo lo que hay que construir, en orden de prioridad.
> Actualizado: 17 abril 2026.

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
| **OpenCode + LiteLLM proxy multi-modelo** | 15-04-2026 |
| **18 modelos en LiteLLM config** | 15-04-2026 |
| **Fichas comparativa 14 LLMs** | 15-04-2026 |
| **Diario de sesiones estructurado** | 15-04-2026 |
| **Dependencias documentadas por capa** | 15-04-2026 |
| **Script arranque rápido: LiteLLM + OpenCode en una sola línea** | 15-04-2026 |
| **`docs/errores-frecuentes.md` — 5 errores reales documentados** | 15-04-2026 |
| **Hardware real documentado (GTX 1060 6GB + Acer Aspire)** | 17-04-2026 |
| **`guias/modelos-por-hardware.md` — modelos óptimos por hardware** | 17-04-2026 |
| **`ARQUITECTURA-SERVIDOR.md` — actualizada con hardware real** | 17-04-2026 |
| **`agentes/orquestador.md` — arquitectura orquestador definida** | 17-04-2026 |

---

## 🔧 Esta semana (17-20 abril 2026)

### 🤖 Orquestador LLM local — EN PROGRESO
- [x] Arquitectura definida en `agentes/orquestador.md`
- [x] Modelos óptimos documentados en `guias/modelos-por-hardware.md`
- [ ] `ollama pull qwen3:4b` — modelo router
- [ ] `ollama pull qwen2.5-coder:7b-instruct-q4_K_M` — modelo worker
- [ ] Actualizar `litellm-config.yaml` con modelos locales Ollama
- [ ] Probar orquestador real: prompt → router → worker → respuesta

### Capa 2 — Menú inteligente
- [ ] Integrar `opencode-rotate.sh` al menú principal (`ai-menu.sh`)
- [ ] `scripts/ai-menu.sh` muestra estado de APIs (rate limit restante)
- [ ] Rotación automática si un modelo está caído
- [ ] Muestra última sesión de OpenCode para continuar

### Experimento comparativa LLMs
- [ ] Lanzar prompt estándar en cada modelo y rellenar `investigacion/comparativa-llms.md`
- [ ] Documentar resultados reales con puntuaciones
- [ ] Actualizar ranking de `principal` con el mejor modelo verificado
- [ ] Probar Groq, Cerebras, DeepSeek, OpenRouter en orden

### Capa 3 — Primer agente real
- [ ] `scripts/generar-diario.sh` — genera docs/diario/ con git log + API
- [ ] Probar con OpenCode como constructor: darle PENDIENTES y que construya
- [ ] Primer uso real de Claude Code sobre THDORA

---

## 📅 Abril 2026 — Sistema base

- [ ] Agente de documentación automática de sesión (`scripts/generar-diario.sh`)
- [ ] Agente de investigación web (`scripts/investigar.sh`)
- [ ] Agente revisor de código probado en THDORA
- [ ] `prompts/` — prompts que funcionan bien guardados para reutilizar
- [ ] Alias en `.bashrc`: `aitoolkit` lanza el menú desde cualquier directorio
- [ ] tmux config guardada en repo para reproducir setup de terminales
- [ ] Investigar arquitectura ensemble (múltiples LLMs en paralelo)
- [ ] Añadir Ollama al proxy para modelos 100% locales

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
- [ ] Arquitectura ensemble: misma tarea → varios LLMs → fusionar respuestas

---

## 🏁 Ecosistema completo (Fin 2026)

Cuando todo esté montado, esto pasa solo cada día:

```
08:00  → Brief del día llega por Telegram
día    → THDORA responde en lenguaje natural
día    → OpenCode disponible en terminal con 18 LLMs vía LiteLLM
22:00  → Alerta hábitos si quedan pendientes
23:00  → Diario del día se escribe solo en GitHub
lunes  → Resumen de la semana llega por Telegram
```

**Consumo total: <1% CPU, ~370 MB RAM, coste mínimo.**

---

_Actualizado: 17 abril 2026 — sesión tarde — hardware documentado + orquestador iniciado — por Perplexity AI MCP_

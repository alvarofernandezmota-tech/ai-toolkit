# 🗺️ Roadmap — Ecosistema de Agentes IA

> Registro de todo lo que hay que construir, en orden de prioridad.
> Actualizado: 17 abril 2026 tarde.

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
| **`opencode.json` default → `ollama/qwen2.5-coder:14b` (sin cuota)** | 17-04-2026 |
| **`AGENTS.md` enriquecido con contexto real + reglas computer-mode** | 17-04-2026 |
| **Sistema Colmena funcional end-to-end (3 paneles tmux)** | 17-04-2026 |

---

## 🔧 Próximos pasos inmediatos

### 🤖 Core del agente — PRIORITARIO
- [ ] Probar OpenCode con `AGENTS.md` nuevo — dar tarea real y verificar que commitea
- [ ] `INICIO-AQUI.md` actualizado con instrucciones computer-mode
- [ ] `scripts/cerrar-sesion.sh` — genera diario automático + commit al cerrar
- [ ] Probar modo computer: "construye X" → OpenCode ejecuta solo

### Orquestador LLM local
- [ ] `ollama pull qwen3:4b` — modelo router ligero
- [ ] Actualizar `litellm-config.yaml` con modelos locales confirmados
- [ ] Probar orquestador real: prompt → router → worker → respuesta

### Capa 2 — Menú inteligente
- [ ] `scripts/ai-menu.sh` muestra estado de APIs (rate limit restante)
- [ ] Rotación automática si un modelo está caído

### Experimento comparativa LLMs
- [ ] Lanzar prompt estándar en cada modelo
- [ ] Documentar resultados en `investigacion/comparativa-llms.md`

### Capa 3 — Primer agente real
- [ ] `scripts/generar-diario.sh` — genera diario con git log + API
- [ ] Primer uso real de OpenCode sobre THDORA

---

## 📅 Abril 2026 — Sistema base

- [ ] Agente de documentación automática (`scripts/generar-diario.sh`)
- [ ] Agente de investigación web (`scripts/investigar.sh`)
- [ ] Agente revisor de código probado en THDORA
- [ ] `prompts/` — prompts que funcionan bien
- [ ] Alias en `.bashrc`: `aitoolkit` lanza el menú
- [ ] tmux config guardada en repo
- [ ] Arquitectura ensemble (múltiples LLMs en paralelo)

---

## 📅 Mayo 2026 — n8n + automatizaciones

- [ ] Docker instalado en WSL
- [ ] n8n en localhost:5678
- [ ] Workflow 1: Brief diario 08:00 → Telegram
- [ ] Workflow 2: Alerta hábitos 22:00 → Telegram
- [ ] Workflow 3: Diario automático 23:00 → commit en repo
- [ ] Endpoints THDORA API para n8n

---

## 📅 Junio 2026 — Búsqueda web en THDORA

- [ ] `pip install duckduckgo-search`
- [ ] `src/core/web_search.py` en THDORA
- [ ] Intent `busqueda_web` en NLP router

---

## 📅 Verano 2026 — Voz con Whisper

- [ ] Transcripción con Groq Whisper API
- [ ] Conectar con NLP existente

---

## 📅 Otoño 2026 — Multi-agente CrewAI

- [ ] Agente revisor código (DeepSeek R1)
- [ ] Agente escritor tests (Qwen3 Coder)
- [ ] Agente generador docs (Llama 3.3)
- [ ] Integración desde n8n cuando hay PR nuevo

---

## 🏁 Ecosistema completo (Fin 2026)

```
08:00  → Brief del día llega por Telegram
día    → THDORA responde en lenguaje natural
día    → OpenCode disponible con 18 LLMs vía LiteLLM
22:00  → Alerta hábitos si quedan pendientes
23:00  → Diario del día se escribe solo en GitHub
lunes  → Resumen de la semana llega por Telegram
```

**Consumo total: <1% CPU, ~370 MB RAM, coste mínimo.**

---

_Actualizado: 17 abril 2026 tarde — sistema Colmena funcional + AGENTS.md enriquecido_

# 🗺️ Roadmap — Ecosistema de Agentes IA

> Registro de todo lo que hay que construir, en orden de prioridad.
> Actualizado: 17 abril 2026 noche.

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
| **`agentes/agente-creador-agentes.md` creado** | 17-04-2026 |
| **`herramientas/` operativa — 3 scripts reutilizables** | 17-04-2026 |
| **`ARQUITECTURA.md` — mapa maestro documentado** | 17-04-2026 |
| **`start-colmena.sh` bulletproof WSL + fallback sin tmux** | 17-04-2026 |
| **`check-colmena.sh` — diagnóstico completo del ecosistema** | 17-04-2026 |

---

## 🔧 Próximos pasos inmediatos

### 🤖 Validar lo construido
- [ ] `git pull` + `bash scripts/check-colmena.sh` — verificar todo OK
- [ ] `bash scripts/start-colmena.sh` — arrancar con 3 paneles sin errores
- [ ] Probar `bash herramientas/crear-ficha-agente.sh agente-test "prueba" "testing"`
- [ ] **Probar agente-creador-agentes end-to-end** en OpenCode computer-mode

### 🏗️ Completar scripts por agente
- [ ] `scripts/agente-creador-agentes.sh` — lanza OpenCode con tarea de crear agente
- [ ] `scripts/agente-git-commits.sh` — wrapper commits semánticos automáticos
- [ ] `scripts/agente-investigacion.sh` — lanza investigación con Perplexity

### Orquestador LLM local
- [ ] `ollama pull qwen3:4b` — modelo router ligero
- [ ] Probar orquestador real: prompt → router → worker → respuesta

### Capa 2 — Menú inteligente
- [ ] `scripts/ai-menu.sh` muestra estado de APIs (rate limit restante)
- [ ] Rotación automática si un modelo está caído

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

_Actualizado: 17 abril 2026 noche — start-colmena bulletproof WSL + check-colmena + herramientas operativas_

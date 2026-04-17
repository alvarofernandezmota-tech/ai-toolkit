# 🗺️ Roadmap — Ecosistema de Agentes IA

Registro de todo lo que hay que construir, en orden de prioridad.

> Actualizado: 17 abril 2026.

---

## ✅ Completado

| Logro | Fecha |
|---|---|
| Estructura base del repo | 14-04-2026 |
| Claude Code + OpenRouter funcionando | 15-04-2026 |
| OpenCode + DeepSeek R1 funcionando | 15-04-2026 |
| Scripts rotación modelos con fallback | 15-04-2026 |
| ai-menu.sh — menú interactivo de agentes | 15-04-2026 |
| README público para la comunidad (EN) | 15-04-2026 |
| INICIO-AQUI.md — brujula personal | 15-04-2026 |
| docs/VISION-SISTEMA.md — norte del sistema | 15-04-2026 |
| agentes/PENDIENTES.md — lista viva de agentes | 15-04-2026 |
| guias/opencode-deepseek.md — guia personal | 15-04-2026 |
| OpenCode + LiteLLM proxy multi-modelo | 15-04-2026 |
| 18 modelos en LiteLLM config | 15-04-2026 |
| Fichas comparativa 14 LLMs | 15-04-2026 |
| Diario de sesiones estructurado | 15-04-2026 |
| Dependencias documentadas por capa | 15-04-2026 |
| Script arranque rápido: LiteLLM + OpenCode | 15-04-2026 |
| docs/errores-frecuentes.md — 5 errores reales | 15-04-2026 |
| scripts/generar-diario.sh — diario automático desde git log | 17-04-2026 |
| Ollama integrado en LiteLLM — modelos 100% locales | 17-04-2026 |
| guias/opencode-ollama.md — guía modelos locales | 17-04-2026 |

---

## 🔧 Esta semana (15-20 abril 2026)

### Capa 2 — Menú inteligente

- [ ] Integrar opencode-rotate.sh al menú principal (ai-menu.sh) — mostrar estado APIs
- [ ] ai-menu.sh muestra rate limit restante de cada API
- [ ] Rotación automática si un modelo está caído
- [ ] Muestra última sesión de OpenCode para continuar

### Experimento comparativa LLMs

- [ ] Lanzar prompt estándar en cada modelo → rellenar investigacion/comparativa-llms.md
- [ ] Documentar resultados reales con puntuaciones
- [ ] Actualizar ranking de principal con el mejor modelo verificado

### Keys pendientes de renovar

- [ ] Renovar GROQ_API_KEY → console.groq.com/keys
- [ ] Renovar DEEPSEEK_API_KEY → platform.deepseek.com

### Capa 3 — Primer agente real

- [ ] Probar generar-diario.sh en sesión real y ajustar si hace falta
- [ ] Primer uso real de Claude Code sobre THDORA (bugs en agentes/thdora-primera-sesion.md)

---

## 📅 Abril 2026 — Sistema base

- [ ] Agente revisor de código probado en THDORA
- [ ] prompts/ — prompts que funcionan bien guardados para reutilizar
- [ ] Alias en .bashrc: `aitoolkit` lanza el menú desde cualquier directorio
- [ ] tmux config guardada en repo para reproducir setup de terminales
- [ ] Investigar arquitectura ensemble (múltiples LLMs en paralelo)
- [x] Añadir Ollama al proxy para modelos 100% locales ✅ 17-04-2026

---

## 📅 Mayo 2026 — n8n + automatizaciones

- [ ] Docker instalado en WSL
- [ ] n8n arrancando en localhost:5678
- [ ] Workflow 1: Brief diario 08:00 → Telegram
- [ ] Workflow 2: Alerta hábitos 22:00 → Telegram
- [ ] Workflow 3: Diario automático 23:00 → commit en repo (usar generar-diario.sh como base)
- [ ] Workflow 4: Resumen semanal lunes → Telegram
- [ ] Endpoints THDORA API para n8n

---

## 📅 Junio 2026 — Búsqueda web en THDORA

- [ ] pip install duckduckgo-search
- [ ] src/core/web_search.py en THDORA
- [ ] Intent busqueda_web en NLP router
- [ ] Tests para web_search.py
- [ ] Key Tavily si DuckDuckGo no es suficiente

---

## 📅 Verano 2026 — Voz con Whisper + mem0

- [ ] Handler mensajes de audio en aiogram
- [ ] Transcripción con Groq Whisper API
- [ ] Conectar transcripción con NLP existente
- [ ] mem0 integrado en THDORA (memoria persistente entre sesiones)

---

## 📅 Otoño 2026 — Multi-agente CrewAI

- [ ] pip install crewai crewai-tools
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
día    → OpenCode disponible en terminal con LiteLLM + Ollama
22:00  → Alerta hábitos si quedan pendientes
23:00  → generar-diario.sh → commit automático en ai-toolkit
lunes  → Resumen de la semana llega por Telegram
```

Consumo total: <1% CPU, ~370 MB RAM (+ Ollama si está activo), coste mínimo.

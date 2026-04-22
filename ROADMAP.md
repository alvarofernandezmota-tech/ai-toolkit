# 🗺️ Roadmap — Ecosistema de Agentes IA

Registro de todo lo que hay que construir, en orden de prioridad.

> Actualizado: **22 abril 2026**.

---

## ✅ Completado

| Logro | Fecha |
|---|---|
| Estructura base del repo | 14-04-2026 |
| Claude Code + OpenRouter funcionando | 15-04-2026 |
| OpenCode + DeepSeek R1 funcionando | 15-04-2026 |
| Scripts rotación modelos con fallback | 15-04-2026 |
| README público para la comunidad (EN) | 15-04-2026 |
| INICIO-AQUI.md — brújula personal | 15-04-2026 |
| docs/VISION-SISTEMA.md | 15-04-2026 |
| agentes/PENDIENTES.md — lista viva | 15-04-2026 |
| guias/opencode-deepseek.md | 15-04-2026 |
| OpenCode + LiteLLM proxy multi-modelo | 15-04-2026 |
| 18 modelos en LiteLLM config | 15-04-2026 |
| Fichas comparativa 14 LLMs | 15-04-2026 |
| Diario de sesiones estructurado | 15-04-2026 |
| Dependencias documentadas por capa | 15-04-2026 |
| Script arranque rápido: LiteLLM + OpenCode | 15-04-2026 |
| docs/errores-frecuentes.md | 15-04-2026 |
| scripts/generar-diario.sh | 17-04-2026 |
| Ollama integrado en LiteLLM — modelos 100% locales | 17-04-2026 |
| guias/opencode-ollama.md | 17-04-2026 |
| health-check.sh — diagnóstico completo de proveedores | 17-04-2026 |
| benchmark-runner.sh — tests de rendimiento entre modelos | 17-04-2026 |
| opencode-rotate.sh — rotación de modelos | 17-04-2026 |
| Fix autosave opencode.json — schema válido | 18-04-2026 |
| opencode-rotate.sh integrado en ai-menu.sh | 18-04-2026 |
| Auditoría completa del repo (18 abril) | 18-04-2026 |
| CLAUDE.md actualizado con estado real del stack | 18-04-2026 |
| ECOSISTEMA.md actualizado con Ollama + Cerebras | 18-04-2026 |
| **Auditoría S16 — 10 errores identificados y corregidos** | 22-04-2026 |
| **ai-menu.sh — menú interactivo 12 opciones (rebuild completo)** | 22-04-2026 |
| **start-colmena.sh — fix E1, ya no depende de thdora** | 22-04-2026 |
| **INICIO-AQUI.md — actualizado al estado real 22 abril** | 22-04-2026 |
| **agentes/PENDIENTES.md — sincronizado con completados reales** | 22-04-2026 |
| **.gitignore — añadidas entradas .aider*, .claude/, logs** | 22-04-2026 |
| **CHANGELOG.md — sesión 22 abril documentada** | 22-04-2026 |
| **ROADMAP.md — este archivo, actualizado** | 22-04-2026 |

---

## 🔧 Próxima sesión — urgente

### Keys pendientes de renovar — BLOQUEA modelos

- [ ] Renovar GROQ_API_KEY → https://console.groq.com/keys
- [ ] Renovar DEEPSEEK_API_KEY → https://platform.deepseek.com
- [ ] Nueva GEMINI_API_KEY → https://aistudio.google.com/apikey

### Primer uso real de Claude Code en THDORA

- [ ] `cd ~/projects/thdora && claude --model anthropic/claude-3.5-sonnet`
- [ ] Atacar bug #1 de la lista en `agentes/thdora-primera-sesion.md`
- [ ] Estimación: 1-2 horas

### Benchmark real de modelos

- [ ] `bash scripts/benchmark-runner.sh` — script listo, falta ejecutarlo
- [ ] Rellenar `investigacion/comparativa-llms.md` con datos reales
- [ ] Tiempo estimado: ~20 minutos

### Documentación pendiente de esta sesión

- [ ] `docs/errores-frecuentes.md` — añadir errores E1-E10 encontrados hoy
- [ ] `ECOSISTEMA.md` — mencionar ai-menu.sh y fix colmena

---

## 📅 Abril 2026 — Sistema base

- [ ] Agente revisor de código probado en THDORA
- [ ] prompts/ — prompts que funcionan bien guardados para reutilizar
- [ ] Alias en .bashrc: `aitoolkit` lanza el menú desde cualquier directorio
- [ ] tmux config guardada en repo para reproducir setup de terminales
- [ ] Limpiar historial git — eliminar .env~ con git filter-repo

---

## 📅 Mayo 2026 — n8n + automatizaciones

- [ ] Docker instalado en WSL
- [ ] n8n arrancando en localhost:5678
- [ ] Workflow 1: Brief diario 08:00 → Telegram
- [ ] Workflow 2: Alerta hábitos 22:00 → Telegram
- [ ] Workflow 3: Diario automático 23:00 → commit en repo
- [ ] Workflow 4: Resumen semanal lunes → Telegram
- [ ] Endpoints THDORA API para n8n
- [ ] toki-bot repo público

---

## 📅 Junio 2026 — Búsqueda web en THDORA

- [ ] pip install duckduckgo-search
- [ ] src/core/web_search.py en THDORA
- [ ] Intent busqueda_web en NLP router
- [ ] Tests para web_search.py
- [ ] Key Tavily si DuckDuckGo no es suficiente
- [ ] Agente de investigación web automático (OpenCode + Tavily)

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

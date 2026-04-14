# 🗺️ Roadmap — Ecosistema de Agentes IA

> Registro de todo lo que hay que construir, en orden de prioridad. Actualizado: Abril 2026.

---

## Estado actual (Abril 2026)

| Bloque | Estado | Detalles |
|---|---|---|
| THDORA v0.14.0 | ✅ Producción | Citas + hábitos + NLP Toki |
| setup.sh instalador | ✅ Listo | 1 comando instala todo |
| Documentación base | ✅ Listo | ECOSISTEMA + setup/ + guias/ + agentes/ |
| Aider + Groq | 🔧 Esta semana | `pip install aider-chat` |
| Claude Code + OpenRouter | 🔧 Esta semana | Crear cuenta OpenRouter |

---

## Esta semana (14-20 Abril 2026)

- [ ] Crear cuenta OpenRouter → [openrouter.ai](https://openrouter.ai)
- [ ] Crear cuenta Tavily → [tavily.com](https://tavily.com)
- [ ] Ejecutar setup.sh → opción 1 (todo)
- [ ] Meter keys en `~/.bashrc` a mano
- [ ] `pip install aider-chat`
- [ ] Primer uso de Aider: fix issue #10 en THDORA
- [ ] `npm install -g @anthropic-ai/claude-code`
- [ ] Primer uso de Claude Code en THDORA
- [ ] Cerrar THDORA v4.1.0 con agentes IA

---

## Mayo 2026 — n8n + automatizaciones

- [ ] Docker instalado en WSL
- [ ] n8n arrancando en localhost:5678
- [ ] Workflow 1: Brief diario a las 08:00 → Telegram
- [ ] Workflow 2: Alerta hábitos a las 22:00 → Telegram
- [ ] Workflow 3: Diario automático a las 23:00 → commit
- [ ] Workflow 4: Resumen semanal los lunes → Telegram
- [ ] Endpoints de THDORA API para n8n (/citas/hoy, /habitos/hoy, /resumen/hoy)

---

## Junio 2026 — Búsqueda web en THDORA

- [ ] `pip install duckduckgo-search`
- [ ] Crear `src/core/web_search.py` en THDORA
- [ ] Añadir intent `busqueda_web` al NLP router
- [ ] Tests para web_search.py
- [ ] Key Tavily (si DuckDuckGo no es suficiente)
- [ ] Migrar a Tavily si hace falta

---

## Verano 2026 — Voz con Whisper

- [ ] Handler de mensajes de audio en aiogram
- [ ] Transcripción con Groq Whisper API
- [ ] Conectar transcripción con NLP existente
- [ ] Tests del flujo de voz

---

## Otoño 2026 — Multi-agente CrewAI

- [ ] `pip install crewai crewai-tools`
- [ ] Agente revisor de código (DeepSeek R1)
- [ ] Agente escritor de tests (Qwen3 Coder)
- [ ] Agente generador de docs (Llama 3.3)
- [ ] Integración: trigger desde n8n cuando hay PR nuevo
- [ ] Crew completo funcionando en THDORA

---

## Ecosistema completo (Fin 2026)

Cuando todo esté montado, esto pasa solo cada día:

```
08:00  → Brief del día llega por Telegram
día    → THDORA responde en lenguaje natural a todo
día    → Aider + Claude Code disponibles en terminal
22:00  → Alerta hábitos si quedan pendientes
22:00  → Brief de mañana llega por Telegram
23:00  → Diario del día se escribe solo en GitHub
lunes  → Resumen de la semana llega por Telegram
```

**Consumo total: <1% CPU, ~360 MB RAM, 0€/mes.**

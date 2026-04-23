# Proyecto: THDORA

> Sistema de gestión de citas + asistente IA personal
> Área: [[areas/ia-desarrollo.md]]
> Última actualización: 23 abril 2026

## Qué es

Bot Telegram personal en producción. FastAPI + python-telegram-bot + Ollama + SQLite.
NLP con LLMs — entiende lenguaje natural para gestionar citas y hábitos.
Coste: 0€/mes. Funciona 24/7.

## Estado actual

- Rama activa: `feature/ui-unificada`
- Feature en progreso: **F9.4** — UI unificada
- Issues abiertos: 10
- Agente asignado: Claude Code vía OpenRouter

## Próximos pasos

- [ ] Completar F9.4 — UI unificada
- [ ] Primera sesión real Claude Code: `bash scripts/start-colmena.sh --claude-thdora`
- [ ] Ejecutar `prompts/auditoria-claude-code.md` contra THDORA
- [ ] Cerrar los 10 issues con ayuda de Claude Code
- [ ] Añadir mem0 para memoria persistente del bot (Mayo 2026)

## Arquitectura

```
thdora/
├── main.py              — entrada principal
├── bot/                 — handlers Telegram
├── api/                 — endpoints FastAPI
├── core/                — lógica negocio
├── db/                  — SQLAlchemy + SQLite
├── nlp/                 — integración LLMs
└── tests/               — pytest
```

## Decisiones clave

- OpenRouter directo para Claude Code (sin proxy)
- LiteLLM proxy para OpenCode en desarrollo
- SQLite en producción (suficiente para escala actual)
- THDORA es la evolución de thea-ia

## Contexto adicional

- Ver `agentes/thdora-primera-sesion.md` para estado de la primera sesión
- Ver `ALVARO.md` para contexto del ecosistema completo

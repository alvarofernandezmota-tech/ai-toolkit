# 🤖 Agente — THDORA

> **Propósito:** Trabajar sobre el repo `thdora` — documentar sesiones,
> actualizar changelog, revisar código y proponer mejoras.

---

## 🎯 Tareas principales

| Tarea | Cuándo | Archivo |
|---|---|---|
| Diario de sesión | Al terminar de programar | `docs/diario/YYYY-MM-DD.md` |
| Actualizar CHANGELOG | Con feat/fix nuevos | `CHANGELOG.md` |
| Revisar COMO_PROCEDER | Cuando cambia el plan | `COMO_PROCEDER.md` |
| Actualizar ROADMAP | Al completar fases | `ROADMAP.md` |
| Revisar tests | Antes de cada release | `tests/` |

---

## 🔧 Cómo invocarlo

```bash
# Desde ai-toolkit
bash scripts/agente-thdora.sh
```

O en OpenCode:
```
Eres el agente de THDORA (Bot Telegram + FastAPI + SQLite).
Repo: https://github.com/alvarofernandezmota-tech/thdora
Stack: Python 3.13, FastAPI 0.115, python-telegram-bot v22, Groq/Llama3
Versión actual: v4.1.0 — última sesión: 14 abril 2026

Tarea: [DESCRIBE LA TAREA AQUÍ]
```

---

## 📋 Contexto técnico de THDORA

- **API REST** → `src/api/routers/` (appointments, habits, config)
- **Bot Telegram** → `src/bot/handlers/` (citas, habitos, nlp, semana)
- **NLP** → Groq Llama3, fallback a flujo guiado
- **Scheduler** → APScheduler, resumen diario + evening log
- **Tests** → `tests/unit/` — pytest sin dependencias externas
- **Docker** → `docker-compose.yml` separa API y Bot

---

## 🐛 Bugs conocidos (17 abril 2026)

- `date` no inyectado en `semana_raw` para citas futuras → **RESUELTO** commit `830c1a2`
- Pendiente: validar borrado de citas pasadas desde vista semanal

---

_Actualizado: 17 abril 2026 — por Perplexity AI MCP_

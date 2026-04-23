# CLAUDE.md — Contexto para Claude Code

> Este archivo lo lee Claude Code automáticamente al arrancar en este directorio.

---

## Las entidades del ecosistema

**En este ecosistema trabajan 4 entidades distintas. Claude Code eres TÚ:**

| Entidad | Tipo | Rol |
|---|---|---|
| **Álvaro** | Humano | Director, decisiones, contexto |
| **Perplexity** | IA web con MCP GitHub | Planificación, diarios, commits tracking, auditorías |
| **Claude Code (tú)** | Agente CLI terminal | Ejecutas tareas autónomas, lees/escribes archivos, commits técnicos |
| **Claude IA** | Modelo lenguaje web | Razonamiento y código puntual sin acceso al repo |

**Dinámica:** Perplexity + Álvaro planifican y preparan prompts → tú ejecutas → Álvaro supervisa.

---

## Quién soy

Soy Álvaro Fernández. Ingeniero de software. Estoy construyendo un ecosistema de agentes IA para automatizar mi trabajo de desarrollo, con foco en el proyecto THDORA.

---

## Este repo: ai-toolkit

Es el **cerebro del ecosistema** — configuración, scripts, documentación y prompts para coordinar agentes IA (Claude Code, OpenCode, LiteLLM proxy).

**No es el código de THDORA.** El código de THDORA está en `~/projects/thdora`.

---

## Stack actual (2026-04-23)

| Herramienta | Modelo | Cómo arranca |
|---|---|---|
| Claude Code v2.1.117 | Via LiteLLM :8000 o Ollama local | `start-colmena.sh` |
| OpenCode | Devstral 2 via OpenRouter (principal) | `start-colmena.sh --opencode` |
| LiteLLM proxy | Puerto 8000, 18+ modelos | `start-colmena.sh --solo-proxy` |
| Ollama local | qwen3:8b (6GB VRAM — NO usar 14B) | `ollama serve` |

---

## Variables de entorno (en ~/.bashrc)

```bash
export OPENROUTER_API_KEY="sk-or-v1-..."
unset ANTHROPIC_API_KEY   # CRÍTICO: sin esto hay conflicto de auth
```

**IMPORTANTE**: No setear nunca `ANTHROPIC_API_KEY` y `ANTHROPIC_AUTH_TOKEN` a la vez — Claude Code falla con conflicto de auth.

---

## Cómo arrancar

```bash
cd ~/projects/ai-toolkit
source ~/.bashrc
bash scripts/start-colmena.sh --colmena-full   # recomendado
# Si Ollama no está activo: /model groq-fallback
```

---

## Proyecto principal: THDORA

- Ruta: `~/projects/thdora`
- Stack: Python 3.13 + FastAPI (puerto 8001) + SQLite + python-telegram-bot 21+
- Rama activa: `feature/ui-unificada` — tarea F9.4 en progreso
- Para trabajar en él: `bash scripts/start-colmena.sh --claude-thdora`
- Bugs documentados en: `agentes/thdora-primera-sesion.md`

---

## Cómo trabajo

- Prefiero **commits pequeños y frecuentes** con mensajes descriptivos
- Documenta cambios en `CHANGELOG.md` y `diario/`
- Si algo no funciona, documéntalo en `docs/errores-frecuentes.md`
- Consulta `ALVARO.md` para contexto sobre mis proyectos y decisiones
- Consulta `INICIO-AQUI.md` para el estado actual del stack
- Commits en inglés: `feat/fix/refactor/docs: descripción corta`

---

## Pendiente urgente

1. Arreglar `401 Unauthorized` en health-check de LiteLLM (quitar `master_key` del config)
2. Primera sesión real en THDORA con bugs documentados
3. Renovar keys: Groq, DeepSeek, Gemini
4. Ejecutar auditoría completa archivo a archivo (prompt preparado por Perplexity)

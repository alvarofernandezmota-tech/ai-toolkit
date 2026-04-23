# Álvaro Fernández Mota — Contexto maestro

> Lee esto al inicio de cada sesión. Actualizado: 23 abril 2026.

## Quién es

Desarrollador Python construyendo un ecosistema de IA personal en producción real.
Trabaja desde Madrid. Dos máquinas:
- **Ordenador grande** — GPU 6GB VRAM, Ollama local, OpenCode + LiteLLM proxy en :8000
- **Acer (portátil)** — accede al grande por SSH (:2222, IP: 10.202.77.228)

## Proyectos activos

| Proyecto | Estado | Repo |
|---|---|---|
| THDORA | ⚠️ Feature/ui-unificada, F9.4 en progreso | thdora |
| ai-toolkit | ✅ Infraestructura estable | ai-toolkit |
| personal | ✅ Tracking vida/finanzas | personal |

## Stack principal

- **Python** — FastAPI, python-telegram-bot, SQLAlchemy, pytest
- **IA** — OpenCode, Claude Code, LiteLLM proxy, Ollama
- **Infra** — Linux/WSL, tmux, Docker, SSH, GitHub
- **Modelos** — qwen3:8b (local), qwen3-coder:free, llama-3.3-70b:free (OpenRouter)

## Objetivos actuales

- [ ] Cerrar F9.4 en THDORA (UI unificada)
- [ ] Primera sesión Claude Code real en THDORA
- [ ] Renovar keys: Groq, DeepSeek, Gemini
- [ ] Ejecutar auditoría con prompts/auditoria-claude-code.md
- [ ] n8n para automatización (Mayo 2026)
- [ ] Post LinkedIn ecosistema IA

## Reglas del ecosistema

1. Solo modelos 8B o menos en Ollama (6GB VRAM)
2. OpenRouter es el proveedor nube principal
3. Claude Code → OpenRouter directo | OpenCode → LiteLLM proxy
4. El diario de sesiones es la memoria — cada sesión importante se documenta
5. THDORA y ai-toolkit son distintos pero se retroalimentan

## La frase

> Álvaro no usa IA. Álvaro ha construido un ecosistema de IA que trabaja para él.

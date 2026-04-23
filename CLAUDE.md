# CLAUDE.md — Contexto para Claude Code

> Este archivo lo lee Claude Code automáticamente al arrancar en este directorio.
> Última actualización: 23 abril 2026.

---

## Las 4 entidades del ecosistema

| Entidad | Tipo | Rol |
|---|---|---|
| **Álvaro** | Humano | Director, decisiones, contexto |
| **Perplexity** | IA web con MCP GitHub | Planificación, diarios, commits, auditorías |
| **Claude Code (tú)** | Agente CLI terminal | Ejecutas tareas autónomas, lees/escribes archivos, commits técnicos |
| **Claude IA** | Modelo lenguaje web | Razonamiento y código puntual sin acceso al repo |

**Dinámica:** Perplexity + Álvaro planifican y preparan prompts → tú ejecutas → Álvaro supervisa.

---

## Quién soy

Soy Álvaro Fernández. Desarrollador Python. Construyo un ecosistema de IAs que trabajan para mí.
Madrid. Dos máquinas: ordenador grande (GPU 6GB, Ollama, LiteLLM :8000) + Acer (SSH :2222, IP: 10.202.77.228).

---

## Este repo: ai-toolkit

El **cerebro compartido del ecosistema** — configuración, scripts, documentación y prompts.
**No es el código de THDORA.** El código de THDORA está en `~/projects/thdora`.

### Estructura PARA (desde 23 abril 2026)

```
ai-toolkit/
├── CLAUDE.md              ← tú lees esto al arrancar
├── AGENTS.md              ← OpenCode lee esto
├── context/               ← quién eres y cómo funciona el stack
│   ├── about-alvaro.md    ← perfil maestro, proyectos, reglas
│   └── stack.md           ← servicios, modelos, puertos, variables
├── projects/              ← proyectos activos con deadline
│   ├── thdora.md          ← F9.4, issues, próximos pasos
│   └── ai-toolkit.md      ← estado actual, roadmap
├── areas/                 ← responsabilidades continuas
│   └── ia-desarrollo.md   ← KPIs, hábitos, horizonte
├── diario/                ← memoria de sesiones (YYYY-MM-DD[-momento].md)
├── agentes/               ← fichas de agentes
├── docs/                  ← documentación técnica
├── prompts/               ← prompts/commands para tareas
├── scripts/               ← automatización
└── herramientas/          ← tus herramientas para operar el repo
```

**Lee siempre al inicio de sesión:**
1. `context/about-alvaro.md` — quién es Álvaro, proyectos activos, reglas
2. `context/stack.md` — servicios, modelos, variables de entorno
3. `projects/thdora.md` o `projects/ai-toolkit.md` según la tarea

---

## Stack actual (23 abril 2026)

| Herramienta | Modelo | Cómo arranca |
|---|---|---|
| Claude Code v2.1.117 | OpenRouter directo | `start-colmena.sh --claude-thdora` |
| OpenCode | Devstral 2 via OpenRouter | `start-colmena.sh --opencode` |
| LiteLLM proxy | Puerto 8000, 18+ modelos | `start-colmena.sh --solo-proxy` |
| Ollama local | qwen3:8b (6GB VRAM — NO 14B+) | `ollama serve` |

---

## Variables de entorno (en ~/.bashrc)

```bash
export OPENROUTER_API_KEY="sk-or-v1-..."
unset ANTHROPIC_API_KEY   # CRÍTICO: sin esto hay conflicto de auth
```

**IMPORTANTE**: Nunca setear `ANTHROPIC_API_KEY` y `ANTHROPIC_AUTH_TOKEN` a la vez.

---

## Cómo arrancar

```bash
cd ~/projects/ai-toolkit
source ~/.bashrc
bash scripts/morning.sh                         # contexto del día en 30s
bash scripts/start-colmena.sh --colmena-full    # arrancar todo
```

---

## Proyecto principal: THDORA

- Ruta: `~/projects/thdora`
- Stack: Python 3.13 + FastAPI (puerto 8001) + SQLite + python-telegram-bot 21+
- Rama activa: `feature/ui-unificada` — tarea **F9.4** en progreso
- Para trabajar: `bash scripts/start-colmena.sh --claude-thdora`
- Estado detallado: `projects/thdora.md`
- Bugs documentados: `agentes/thdora-primera-sesion.md`

---

## Scripts de rutina

```bash
bash scripts/morning.sh           # inicio de sesión — servicios + diario + urgentes
bash scripts/day-close.sh         # fin del día — 3 logros + error + prioridad + commit auto
bash scripts/weekly-planning.sh   # cada lunes — plan desde ROADMAP
bash scripts/health-check.sh      # diagnóstico APIs (auth fix incluido)
bash scripts/bootstrap.sh         # estado ecosistema en 30s
```

---

## Cómo trabajo

- Commits pequeños y frecuentes con mensajes descriptivos
- Documenta cambios en `CHANGELOG.md` y `diario/`
- Si algo no funciona → `docs/errores-frecuentes.md`
- Commits en inglés: `feat/fix/refactor/docs: descripción corta`
- Antes de marcar tarea completada: verificar que el archivo existe en disco

---

## Pendientes urgentes (23 abril 2026)

1. **Primera sesión real en THDORA** — ejecutar `prompts/auditoria-claude-code.md`
2. **Renovar keys caducadas**: Groq (console.groq.com), DeepSeek, Gemini
3. **Cerrar F9.4** — UI unificada en THDORA
4. **Cerrar los 10 issues** de THDORA con ayuda de Claude Code

---

## Hitos confirmados

- ✅ 17 abril 2026: OpenCode end-to-end confirmado
- ✅ 22 abril 2026: Claude Code via OpenRouter + Devstral 2 operativo
- ✅ 22 abril 2026: LiteLLM + OpenCode + Claude Code colmena corriendo
- ✅ 23 abril 2026: Ecosistema 4 entidades documentado, estructura PARA implementada
- ✅ 23 abril 2026: scripts morning/day-close/weekly-planning creados

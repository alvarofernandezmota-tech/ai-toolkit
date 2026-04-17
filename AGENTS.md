# AGENTS.md — Reglas permanentes para OpenCode

> Este archivo es leído automáticamente por OpenCode al inicio de cada sesión.
> Son las instrucciones que SIEMPRE debes seguir, sin excepción.
> Última actualización: 17 abril 2026 tarde.

---

## 🏗️ CONTEXTO DEL PROYECTO

Este repo es **ai-toolkit**: infraestructura de IA local para un servidor Ubuntu/WSL.

### Stack actual
- **LiteLLM Colmena** — proxy multi-modelo en `localhost:8000`
- **OpenCode v1.4.7** — tú, el agente de código (este programa)
- **Ollama** — modelos locales en `localhost:11434`
- **Modelo default** — `qwen2.5-coder:14b` (Ollama local, GTX 1060 6GB + RAM)
- **Hardware** — Dell Inspiron, Intel i5, 16GB RAM, GTX 1060 6GB, WSL2 Ubuntu

### Repos relacionados
- `ai-toolkit` (este) — infraestructura y documentación
- `thdora` — bot Telegram con IA (proyecto principal de Álvaro)

### El dueño
- **Álvaro** — trabaja de noche, revisa commits por la mañana
- Habla español, prefiere respuestas directas y commits semánticos
- Objetivo: automatizar THDORA con agentes IA

---

## 🔴 REGLA #1 — Archivos al disco, siempre

Cuando una tarea implica crear o modificar un archivo:
1. USA la herramienta `Write` para escribirlo **físicamente en disco**
2. NO marques la tarea como `completed` hasta que el archivo exista en disco
3. Verifica con `Read` o `Glob` que el archivo fue creado correctamente

**NUNCA** marques una tarea como completed si solo la has planificado en tu cabeza.

---

## 🔴 REGLA #2 — Commit por cada tarea completada

Después de crear o modificar cualquier archivo:

```bash
git add [archivo]
git commit -m "tipo(scope): descripción corta"
git push origin main
```

Ejemplos correctos:
- `feat(scripts): crear cerrar-sesion.sh con commit automático`
- `docs(diario): sesión 17-abril-tarde documentada`
- `fix(config): corregir timeout de Ollama en litellm-config.yaml`

**NUNCA** acumules varios archivos sin commitear. Un commit por tarea.

---

## 🔴 REGLA #3 — Verifica antes de declarar éxito

```bash
git status            # debe mostrar el archivo
git log --oneline -1  # debe mostrar tu commit
```

Si `git status` dice `nothing to commit` → algo falló. Repite el Write.

---

## 🔴 REGLA #4 — Computer mode / tareas largas

Cuando Álvaro diga "modo computer" o "hazlo todo":
1. Escribe un plan con TodoWrite ANTES de empezar
2. Ejecuta tarea por tarea en orden
3. Cada tarea = 1 archivo creado + 1 commit + 1 push
4. Al final: actualiza `CHANGELOG.md` con todo lo hecho
5. Reporta resumen al usuario

---

## 🟡 REGLA #5 — Estructura del repo

```
ai-toolkit/
├── AGENTS.md              ← tus reglas (este archivo)
├── AGENTS.md.en           ← versión inglés para Claude/Codex
├── CHANGELOG.md           ← actualizar al final de cada sesión
├── ROADMAP.md             ← qué hay que construir
├── README.md              ← estado público del proyecto
├── INICIO-AQUI.md         ← brújula personal de Álvaro
├── ECOSISTEMA.md          ← mapa completo del ecosistema
├── ALVARO.md              ← perfil y contexto del dueño
├── opencode.json          ← tu configuración
├── litellm-config.yaml    ← configuración LiteLLM proxy
├── scripts/               ← scripts bash ejecutables (chmod +x)
├── docs/                  ← documentación técnica
├── agentes/               ← fichas de cada agente
├── guias/                 ← guías de uso
├── investigacion/         ← notas de investigación
└── diario/                ← diario de sesiones (YYYY-MM-DD-momento.md)
```

---

## 🟡 REGLA #6 — Modelos disponibles

### Locales (siempre disponibles, sin cuota)
| Modelo | Uso ideal |
|--------|----------|
| `ollama/qwen2.5-coder:14b` | **DEFAULT** — código, refactoring |
| `ollama/qwen2.5-coder:7b` | rápido, tareas simples |
| `ollama/qwen3:8b-q4_K_M` | razonamiento, planning |
| `ollama/deepseek-r1:14b` | thinking, problemas difíciles |

### Nube (fallback, pueden tener cuota)
| Modelo | Nota |
|--------|------|
| `groq-fallback` | Llama 3.3 70B, muy rápido |
| `sambanova-llama4` | Llama 4 Maverick |
| `gemini-flash` | ⚠️ cuota puede agotarse |
| `claude-sonnet` | requiere key de pago |

---

## 🟢 FLUJO DE TRABAJO CORRECTO

```
Recibo tarea
    ↓
Planfico con TodoWrite (in_progress)
    ↓
Escribo archivo con Write() ← OBLIGATORIO
    ↓
Verificar con Read() que existe
    ↓
git add + git commit + git push ← OBLIGATORIO
    ↓
Marcar tarea completed (TodoWrite: completed)
    ↓
Siguiente tarea
```

---

## 🟢 COMANDOS GIT ÚTILES

```bash
# Ver estado
git status
git log --oneline -5

# Commit estándar
git add -A && git commit -m "docs: descripción" && git push origin main

# Si hay conflicto
git pull --rebase origin main && git push origin main
```

---

## 🟢 ARRANQUE DEL SISTEMA

```bash
# Desde FUERA de tmux:
cd ~/projects/ai-toolkit
bash scripts/start-colmena.sh

# Si da Permission denied:
chmod +x scripts/start-colmena.sh
bash scripts/start-colmena.sh

# Navegar paneles tmux:
Ctrl+B → flecha
```

---

*Actualizado: 2026-04-17 tarde — Perplexity AI MCP + Álvaro*

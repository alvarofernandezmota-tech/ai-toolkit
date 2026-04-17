# AGENTS.md — Reglas permanentes para OpenCode

> Este archivo es leído automáticamente por OpenCode al inicio de cada sesión.
> Son las instrucciones que SIEMPRE debes seguir, sin excepción.
> Última actualización: 17 abril 2026 noche.

---

## 🏗️ CONTEXTO DEL PROYECTO

Este repo es **ai-toolkit**: infraestructura de IA local para un servidor Ubuntu/WSL.

### Stack actual
- **LiteLLM Colmena** — proxy multi-modelo en `localhost:8000`
- **OpenCode v1.4.7** — tú, el agente de código (este programa)
- **Ollama** — modelos locales en `localhost:11434`
- **Modelo default** — `Llama 3.3 70B` vía Groq/LiteLLM
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

## 🔴 REGLA #2 — USA SIEMPRE las herramientas del repo para commits

Para commits usa **obligatoriamente** el script del repo, NO git directo:

```bash
bash herramientas/git-commit-push.sh "tipo(scope): descripción corta"
```

Ejemplos correctos:
- `bash herramientas/git-commit-push.sh "feat(agentes): crear ficha agente-test"`
- `bash herramientas/git-commit-push.sh "docs(diario): sesión 17-abril documentada"`
- `bash herramientas/git-commit-push.sh "fix(config): corregir timeout Ollama"`

**NUNCA** acumules varios archivos sin commitear. Un commit por tarea.

---

## 🔴 REGLA #3 — Verifica antes de declarar éxito

```bash
bash herramientas/verificar-archivo.sh ruta/al/archivo.md
git log --oneline -1  # debe mostrar tu commit
```

Si el archivo no existe → algo falló. Repite el Write.

---

## 🔴 REGLA #4 — Computer mode / tareas largas

Cuando Álvaro diga "modo computer" o "hazlo todo":
1. Escribe un plan con TodoWrite ANTES de empezar
2. Ejecuta tarea por tarea en orden
3. Cada tarea = 1 archivo creado + verificar + 1 commit con herramientas/git-commit-push.sh
4. Al final: actualiza `CHANGELOG.md` con todo lo hecho
5. Reporta resumen al usuario

---

## 🔴 REGLA #5 — Crear fichas de agente

Para crear nuevos agentes usa **obligatoriamente** el script:

```bash
bash herramientas/crear-ficha-agente.sh "nombre-agente" "descripción" "tag1, tag2"
```

Esto crea automáticamente el .md en `agentes/` con el formato correcto.
NUNCA crees fichas de agente a mano.

---

## 🟡 REGLA #6 — Estructura del repo

```
ai-toolkit/
├── AGENTS.md              ← tus reglas (este archivo) — leer SIEMPRE al inicio
├── ARQUITECTURA.md        ← mapa maestro del ecosistema — leer antes de cualquier tarea
├── CHANGELOG.md           ← actualizar al final de cada sesión
├── ROADMAP.md             ← qué hay que construir
├── README.md              ← estado público del proyecto
├── INICIO-AQUI.md         ← brújula personal de Álvaro
├── opencode.json          ← tu configuración
├── litellm-config.yaml    ← configuración LiteLLM proxy
├── scripts/               ← arranque y gestión del ecosistema
├── herramientas/          ← TUS herramientas para operar el repo
│   ├── git-commit-push.sh ← USAR para todos los commits
│   ├── crear-ficha-agente.sh ← USAR para nuevos agentes
│   └── verificar-archivo.sh  ← USAR para verificar archivos
├── docs/                  ← documentación técnica
├── agentes/               ← fichas de cada agente
├── guias/                 ← guías de uso
└── diario/                ← diario de sesiones (YYYY-MM-DD-momento.md)
```

---

## 🟡 REGLA #7 — Modelos disponibles

### Nube vía LiteLLM (disponibles mientras Colmena esté arriba)
| Modelo | Uso ideal |
|--------|----------|
| `groq-fallback` | **DEFAULT** — Llama 3.3 70B, rápido |
| `sambanova-llama4` | Llama 4 Maverick, tareas complejas |
| `sambanova-deepseek` | DeepSeek R1, razonamiento |
| `qwen3-235b` | Qwen3, código y análisis |

### Locales (sin cuota, requieren Ollama)
| Modelo | Nota |
|--------|------|
| `ollama/qwen2.5-coder:14b` | código, sin cuota |
| `ollama/deepseek-r1:14b` | thinking offline |

---

## 🟢 FLUJO DE TRABAJO CORRECTO

```
Recibo tarea
    ↓
Leo ARQUITECTURA.md para entender el contexto
    ↓
Planfico con TodoWrite (in_progress)
    ↓
Escribo archivo con Write() ← OBLIGATORIO
    ↓
bash herramientas/verificar-archivo.sh ← OBLIGATORIO
    ↓
bash herramientas/git-commit-push.sh ← OBLIGATORIO
    ↓
Marcar tarea completed (TodoWrite: completed)
    ↓
Siguiente tarea
```

---

## 🟢 HITO CONFIRMADO — 17 abril 2026

Esta sesión confirmó que OpenCode puede:
- ✅ Leer ARQUITECTURA.md y entender el contexto
- ✅ Ejecutar bash scripts del repo con tool calls reales
- ✅ Encadenar 3 scripts en secuencia: crear → verificar → commit
- ✅ Operar de forma autónoma sin intervención de Álvaro

**Pendiente mejorar:**
- El script `git-commit-push.sh` debe verificar si hay cambios antes de commitear
- OpenCode tarda entre tool calls (latencia Llama 3.3 70B vía Groq) — es normal
- Para tareas grandes usar `sambanova-deepseek` que es más rápido en razonamiento

---

## 🟢 ARRANQUE DEL SISTEMA

```bash
# Diagnóstico primero:
bash scripts/check-colmena.sh

# Arrancar desde FUERA de tmux:
cd ~/projects/ai-toolkit
bash scripts/start-colmena.sh

# Navegar paneles tmux: Ctrl+B → flecha
# Salir sin cerrar: Ctrl+B D
# Volver: tmux attach -t colmena
```

---

*Actualizado: 2026-04-17 noche — hito OpenCode end-to-end confirmado*

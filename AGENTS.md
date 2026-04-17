# AGENTS.md — Reglas permanentes para OpenCode

> Este archivo es leído automáticamente por OpenCode al inicio de cada sesión.
> Son las instrucciones que SIEMPRE debes seguir, sin excepción.

---

## 🔴 REGLA #1 — Archivos al disco, siempre

Cuando una tarea implica crear o modificar un archivo:
1. USA la herramienta `Write` para escribirlo **físicamente en disco**
2. NO marques la tarea como `completed` hasta que el archivo exista en disco
3. Verifica con `Read` o `Glob` que el archivo fue creado correctamente

**NUNCA** marques una tarea como completed si solo la has planificado en tu cabeza.

---

## 🔴 REGLA #2 — Commit por cada tarea completada

Después de crear o modificar cualquier archivo, ejecuta SIEMPRE:

```bash
git add [archivo]
git commit -m "tipo(scope): descripción corta"
git push origin main
```

Ejemplos de commits semánticos correctos:
- `feat(scripts): crear cerrar-sesion.sh con commit automático`
- `docs(auditoria): crear auditoria-repo.md con estado actual`
- `fix(config): corregir timeout de Ollama en litellm-config.yaml`

**NUNCA** acumules varios archivos sin commitear. Un commit por tarea.

---

## 🔴 REGLA #3 — Verifica antes de declarar éxito

Antes de decir que una tarea está terminada:
```bash
git status          # debe mostrar el archivo
git log --oneline -1  # debe mostrar tu commit
```

Si `git status` dice `nothing to commit` y acabas de crear un archivo → algo falló. Repite el Write.

---

## 🟡 REGLA #4 — Contexto del proyecto

Este repo es **ai-toolkit**: infraestructura de IA local para un servidor Ubuntu/WSL.

- **LiteLLM** corre en `localhost:8000` como proxy de modelos
- **OpenCode** (tú) usas LiteLLM como backend — modelo default: `gemini-flash`
- **Ollama** corre localmente con modelos: qwen3:8b, qwen2.5-coder:7b, qwen2.5-coder:14b
- **El dueño** es Álvaro — trabaja de noche, revisa commits por la mañana

---

## 🟡 REGLA #5 — Estructura del repo

```
ai-toolkit/
├── AGENTS.md              ← este archivo (tus reglas)
├── CHANGELOG.md           ← actualizar al final de cada sesión
├── README.md              ← estado real del proyecto
├── opencode.json          ← tu configuración
├── litellm-config.yaml    ← configuración LiteLLM
├── scripts/               ← scripts bash ejecutables
├── docs/                  ← documentación técnica
├── agentes/               ← fichas de cada agente
├── guias/                 ← guías de uso
├── investigacion/         ← notas de investigación
└── diario/                ← diario de sesiones (auto-generado)
```

---

## 🟢 FLUJO DE TRABAJO CORRECTO

```
Recibo tarea
    ↓
Planfico (TodoWrite: in_progress)
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
# Ver estado actual
git status
git log --oneline -5

# Commit estándar
git add -A && git commit -m "docs: descripción" && git push origin main

# Si hay conflicto con remote
git pull --rebase origin main && git push origin main
```

---

*Última actualización: 2026-04-17 — creado por Perplexity + Álvaro para educar a OpenCode*

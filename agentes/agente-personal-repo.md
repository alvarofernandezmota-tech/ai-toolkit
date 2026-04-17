# 🤖 Agente — Repo `personal`

> **Propósito:** Automatizar la gestión documental del repo `personal` de Álvaro.
> Actualiza diarios, tracking semanal, CONTEXT-PERPLEXITY y CHANGELOG.

---

## 🎯 Qué hace este agente

| Tarea | Frecuencia | Archivo objetivo |
|---|---|---|
| Actualizar `CONTEXT-PERPLEXITY.md` | Semanal (domingo) | raíz del repo |
| Crear entrada diaria en tracking | Diario | `01_traking_diario/01_diarios/` |
| Cerrar semana actual | Domingo | `semana-XX-2026.md` |
| Actualizar `CHANGELOG.md` | Con cada cambio relevante | raíz del repo |
| Crear plantilla semana siguiente | Domingo | `semana-XX-2026.md` |

---

## 🔧 Cómo invocarlo (OpenCode computer-mode)

```bash
cd ~/projects/ai-toolkit
opencode
```

Luego en el chat de OpenCode pega este prompt:

```
Use the Bash tool to run:
git clone https://github.com/alvarofernandezmota-tech/personal /tmp/personal-repo

Then update the file /tmp/personal-repo/CONTEXT-PERPLEXITY.md with:
- Fecha de hoy como última actualización
- Estado actual de la semana en curso
- Cualquier cambio relevante en proyectos

Then commit and push:
cd /tmp/personal-repo && git add -A && git commit -m "docs: actualizar CONTEXT-PERPLEXITY semana $(date +%V)" && git push
```

---

## 📋 Prompt base para actualizar CONTEXT-PERPLEXITY

Usa este prompt en cualquier IA con acceso al repo:

```
Eres el agente de documentación del repo personal de Álvaro Fernández Mota.

Tu tarea:
1. Leer el CONTEXT-PERPLEXITY.md actual
2. Actualizarlo con el estado real de hoy:
   - Fecha: [HOY]
   - Semana: [SEMANA ACTUAL]
   - Estado de THDORA: [versión actual]
   - Estado de ai-toolkit: [últimos logros]
   - Tareas pendientes priorizadas
3. Hacer commit con mensaje: "docs: actualizar CONTEXT-PERPLEXITY [fecha]"

Reglas:
- NO inventar datos — solo los que te confirme Álvaro
- Mantener el formato de tablas existente
- Actualizar la línea "Última actualización" al inicio
- Mantener el historial, no borrar secciones
```

---

## 📋 Prompt base para diario diario

```
Eres el agente de tracking diario del repo personal de Álvaro.

Tarea: crear la entrada del día [HOY] en:
01_traking_diario/01_diarios/trakingpersonal/2026/04-abril/[FECHA].md

Estructura de la entrada:
## [FECHA] — Día [N] de la semana

### ✅ Hecho hoy
- [lista de lo realizado]

### 🧠 Aprendido
- [insights del día]

### 📊 Hábitos
| Hábito | ✅/❌ |
|--------|------|
| Gym | ❌ |
| Lectura | ✅ |
| Código | ✅ |

### 🎯 Mañana
- [1-3 tareas clave]
```

---

## 🔗 Repos y archivos clave

| Recurso | Ruta |
|---|---|
| CONTEXT-PERPLEXITY | `CONTEXT-PERPLEXITY.md` |
| Diarios 2026 | `01_traking_diario/01_diarios/trakingpersonal/2026/` |
| Tracking maestro | `01_traking_diario/TRACKING-MAESTRO.md` |
| Portfolio | `docs/portfolio.md` |

---

## ⚙️ Script de automatización

Guardado en `scripts/agente-personal.sh` (pendiente crear):

```bash
#!/bin/bash
# Lanza OpenCode apuntando al repo personal
export OPENCODE_REPO="https://github.com/alvarofernandezmota-tech/personal"
cd ~/projects/ai-toolkit
opencode --model groq/llama-3.3-70b
```

---

_Creado: 17 abril 2026 — por Perplexity AI MCP_

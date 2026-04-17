# 🤖 Agente — Repo `personal`

> **Propósito:** Gestionar tracking diario, análisis, curiosidad, proyectos y perfil personal.
> El agente ANALIZA LA REPO EN CADA ARRANQUE — no trabaja con datos estáticos.

---

## 🚀 Orden de lectura al arrancar

Cuando arranca, el agente lee en este orden:

```
1. AGENTE.md                              → qué puede y no puede tocar
2. CONTEXT-PERPLEXITY.md                  → estado actual del ecosistema
3. 01_traking_diario/TRACKING-MAESTRO.md  → estado general del tracking
4. Archivo semana más reciente            → semana-XX-2026.md
5. CHANGELOG.md                           → últimos cambios del repo
```

Con esas 5 lecturas el agente tiene todo el contexto para trabajar.

---

## 📁 Estructura real del repo `personal`

```
personal/
├── AGENTE.md                    ← punto de entrada para cualquier IA
├── CONTEXT-PERPLEXITY.md        ← contexto maestro del ecosistema
├── CHANGELOG.md                 ← historial de cambios
├── README.md                    ← descripción del repo
├── AUDITORIA-COMPLETA-REPO.md   ← auditoría del repo
│
├── 00_sistema/                  ← protocolos y flujos de trabajo
├── 00_yo/                       ← perfil, valores, objetivos
├── 01_traking_diario/           ← tracking diario y semanal ← CORE
│   ├── TRACKING-MAESTRO.md
│   ├── 01_diarios/
│   │   └── trakingpersonal/2026/04-abril/
│   └── semanas/
│       └── semana-XX-2026.md    ← archivo de semana activo
├── 02_formacion/                ← PROHIBIDO al agente
├── 03_analisis/                 ← análisis de datos personales
├── 03_curiosidad/               ← notas y descubrimientos
├── 03_proyectos/                ← fichas de proyectos
└── docs/                        ← portfolio y documentación
```

---

## 🎯 Tareas que puede ejecutar

| Tarea | Archivo destino | Cuándo |
|---|---|---|
| Crear entrada diaria | `01_traking_diario/01_diarios/trakingpersonal/2026/MM-mes/YYYY-MM-DD.md` | Al terminar el día |
| Cerrar semana | `01_traking_diario/semanas/semana-XX-2026.md` | Domingo |
| Crear semana nueva | `01_traking_diario/semanas/semana-XX-2026.md` | Domingo |
| Actualizar CONTEXT-PERPLEXITY | `CONTEXT-PERPLEXITY.md` | Semanal |
| Generar análisis semanal | `03_analisis/analisis-semana-XX-2026.md` | Domingo |
| Añadir nota curiosidad | `03_curiosidad/` | Cuando hay algo relevante |
| Actualizar ficha proyecto | `03_proyectos/` | Cuando cambia estado |
| Actualizar perfil | `00_yo/` | Cuando cambia algo importante |
| Actualizar CHANGELOG | `CHANGELOG.md` | Con cada cambio relevante |

---

## 🔒 Prohibido

- `02_formacion/` — lo hace Álvaro en persona, aprendizaje intransferible

---

## 📋 Prompt base para invocar el agente

```
Eres el agente del repo personal de Álvaro Fernández Mota.
Repo: https://github.com/alvarofernandezmota-tech/personal

Al arrancar, lee en este orden:
1. AGENTE.md
2. CONTEXT-PERPLEXITY.md
3. 01_traking_diario/TRACKING-MAESTRO.md
4. El archivo de semana más reciente en 01_traking_diario/semanas/
5. CHANGELOG.md

Luego ejecuta la tarea: [DESCRIBE LA TAREA AQUÍ]

Reglas:
- NO toques 02_formacion/ bajo ningún concepto
- Commits semánticos siempre
- Si algo no está claro, deja una nota TODO: en el archivo
```

---

## ⚙️ Script de arranque

```bash
bash scripts/agente-personal.sh
```

---

_Actualizado: 17 abril 2026 con estructura real del repo — por Perplexity AI MCP_

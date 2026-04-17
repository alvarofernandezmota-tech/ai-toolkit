# 🤖 Agentes — Hoja de Ruta

> Estado: 2026-04-17 02:00 | Colmena 100% operativa ✅

## Stack confirmado esta sesión

| Capa | Tecnología | Estado |
|------|-----------|--------|
| Editor IA | OpenCode (opencode.ai) | ✅ Operativo |
| Router IA | LiteLLM Proxy (Colmena) :8000 | ✅ Operativo |
| Modelos locales | Ollama `qwen2.5-coder:14b`, `deepseek-r1:14b`, `qwen3:8b` | ✅ Operativo |
| APIs fallback | Groq, Sambanova, Together, OpenRouter, Cerebras | ⚠️ Límites free tier |
| APIs último recurso | Gemini Flash/Lite | ❌ Cuota agotada |

## Fixes aplicados para llegar aquí

### Fix 1 — Orden de modelos
Ollama movido al inicio del `model_list` bajo `principal` → local va siempre primero.

### Fix 2 — Timeout Ollama
`request_timeout: 15` → `120` → Ollama tiene tiempo de cargar el modelo en RAM.

### Fix 3 — start-colmena.sh (pendiente)
El script tiene un bug de parseo YAML. Usar comando directo hasta que se reescriba.

## Primera tarea real asignada (en curso)

OpenCode está ejecutando ahora mismo:
```
Crea scripts/generar-diario.sh:
- Brief diario en markdown con fecha de hoy
- Guardado en diario/YYYY-MM-DD.md
- Secciones: Fecha, Objetivos, Tareas pendientes, Notas
- Ejecutable (chmod +x)
```

## Próximas tareas para OpenCode

### Tarea 2 — Fix start-colmena.sh
```
Reescribe scripts/start-colmena.sh para que:
1. Lance LiteLLM con el comando correcto (no haga source del YAML)
2. Espere a que :8000 esté listo
3. Muestre estado de Ollama y LiteLLM
4. Sea idempotente (si ya corre, no relanzar)
```

### Tarea 3 — Health check
```
Crea scripts/health-check.sh que compruebe:
1. Ollama en :11434 (curl test con qwen2.5-coder:14b)
2. LiteLLM en :8000
3. Muestre estado verde/amarillo/rojo por proveedor
4. Salida limpia y legible
```

### Tarea 4 — Agente repo-setup
Cada repo del ecosistema necesita:
- `CLAUDE.md` / `opencode.md` con contexto del proyecto
- `.env.example` con variables necesarias
- `Makefile` con comandos estándar (`make dev`, `make test`, `make build`)
- GitHub Actions básico (lint + test)

```
Revisa REPOS-ECOSISTEMA.md y para cada repo:
1. Lee su README actual
2. Genera CLAUDE.md con contexto del proyecto
3. Crea Makefile con comandos estándar
4. Propón el .env.example necesario
Empezar por: ai-toolkit (este mismo repo)
```

## Arquitectura objetivo

```
┌─────────────────────────────────────────────┐
│              ECOSISTEMA REPOS               │
│  thdora/  ai-toolkit/  [otros repos]/       │
│     ↓           ↓            ↓             │
│  ┌──────────────────────────────────────┐   │
│  │     OpenCode (agentes)               │   │
│  │  agente-setup | agente-review        │   │
│  └──────────────┬───────────────────────┘   │
│                 ↓                           │
│  ┌──────────────────────────────────────┐   │
│  │   LiteLLM Colmena :8000              │   │
│  │   router inteligente                 │   │
│  └──────────────┬───────────────────────┘   │
│                 ↓                           │
│  ┌──────────────────────────────────────┐   │
│  │   Ollama LOCAL (sin límites) ✅       │   │
│  │   qwen2.5-coder:14b (código)         │   │
│  │   deepseek-r1:14b (razonamiento)     │   │
│  │   qwen3:8b (tareas rápidas)          │   │
│  └──────────────────────────────────────┘   │
│           ↓ (solo si falla local)           │
│  ┌──────────────────────────────────────┐   │
│  │   APIs nube (fallback) ⚠️            │   │
│  │   Groq → Sambanova → Together        │   │
│  └──────────────────────────────────────┘   │
└─────────────────────────────────────────────┘
```

# 🏗️ ARQUITECTURA — Mapa Maestro del Ecosistema

> Cómo está organizado este repo, qué hay en cada carpeta, cómo se conecta todo y cómo debe operar un agente nuevo.

---

## Visión general

Este repo es el **cerebro operativo** del ecosistema de agentes IA personal. No es sólo documentación: es la fuente de verdad sobre cómo funcionan, se conectan y evolucionan los agentes.

```
ai-toolkit/
├── README.md               ← Presentación pública del proyecto
├── INICIO-AQUI.md          ← Brújula personal: por dónde empezar cada sesión
├── ARQUITECTURA.md         ← Este archivo — mapa maestro
├── ROADMAP.md              ← Qué está hecho, qué queda, cuándo
├── CHANGELOG.md            ← Historial de cambios importantes
├── CEREBRO.md              ← Principios de diseño y filosofía del sistema
├── ECOSISTEMA.md           ← Mapa de todos los repos y cómo se conectan
├── AGENTS.md               ← Instrucciones para agentes que operen el repo (EN)
├── AGENTES.md              ← Ídem en español
├── ALVARO.md               ← Contexto personal: qué construye Álvaro y por qué
├── COMO-PROCEDEMOS.md      ← Reglas de trabajo en sesión (calidad, commits, etc.)
├── ESTRATEGIA.md           ← Dirección estratégica a largo plazo
├── ARQUITECTURA-SERVIDOR.md← Hardware real + stack técnico del servidor local
├── REPOS-ECOSISTEMA.md     ← Inventario de repos del ecosistema
├── agentes/                ← Fichas de cada agente definido
├── herramientas/           ← Scripts reutilizables (git, fichas, verificación)
├── scripts/                ← Scripts del sistema (arranque, menú, rotación LLM)
├── prompts/                ← Prompts probados y reutilizables
├── guias/                  ← Guías prácticas de herramientas (LiteLLM, OpenCode, etc.)
├── docs/                   ← Documentación técnica (visión, errores, dependencias)
├── investigacion/          ← Comparativas, experimentos, benchmarks
├── diario/                 ← Diario de sesiones (una entrada por día)
├── pruebas/                ← Pruebas de concepto, experimentos rápidos
├── opensource/             ← Proyectos de referencia analizados
├── setup/                  ← Scripts de instalación y configuración inicial
└── litellm-config.yaml     ← Config del proxy LiteLLM con 18 modelos
```

---

## 📂 Detalle por carpeta

### `agentes/`
Fichas Markdown de cada agente del sistema. Cada ficha define: propósito, entradas, salidas, prompt base y estado. Es el catálogo vivo del Sistema Colmena.

- Agente nuevo → usa `herramientas/crear-ficha-agente.sh`
- Fichero clave: `agentes/PENDIENTES.md` — lista de agentes por construir

### `herramientas/`
Scripts reutilizables de apoyo operativo. Cualquier agente o sesión puede invocarlos:
- `git-commit-push.sh` — flujo git completo con un comando
- `crear-ficha-agente.sh` — bootstrap de nuevas fichas
- `verificar-archivo.sh` — comprobación de existencia en disco

### `scripts/`
Scripts del sistema operativo del toolkit: arranque del stack LiteLLM+OpenCode, menú interactivo de agentes, rotación de modelos con fallback, generación de diarios.

### `prompts/`
Prompts probados en producción, organizados por caso de uso. Son la materia prima que los agentes consumen.

### `guias/`
Guías prácticas escritas en primera persona: cómo usar OpenCode, cómo configurar LiteLLM, modelos óptimos por hardware, etc.

### `docs/`
Documentación técnica formal: visión del sistema, errores frecuentes, dependencias por capa.

### `investigacion/`
Experimentos y comparativas: benchmarks de LLMs, pruebas de prompts, resultados de modelos locales.

### `diario/`
Registro cronológico de sesiones. Formato: `YYYY-MM-DD.md`. Generación automática planificada via `scripts/generar-diario.sh`.

### `pruebas/`
Sandbox para experimentos rápidos que no están listos para produccción.

---

## 🔗 Cómo se conecta todo

```
ALVARO.md + CEREBRO.md
        ↓
   ESTRATEGIA.md                    (dirección)
        ↓
    ROADMAP.md                      (qué construir)
        ↓
  agentes/*.md  +  prompts/          (qué hacen los agentes + con qué)
        ↓
  scripts/ + herramientas/           (cómo lo ejecutan)
        ↓
  litellm-config.yaml + opencode.json (sobre qué modelos corren)
        ↓
     diario/ + CHANGELOG.md          (qué pasó en cada sesión)
```

---

## 🤖 Guía para un agente nuevo

Si eres un agente IA operando este repo, sigue este orden:

1. **Lee primero**: `AGENTS.md` (o `AGENTES.md`) — contiene las reglas y contexto
2. **Ubicate**: `INICIO-AQUI.md` — estado actual del sistema
3. **Entiende la meta**: `ROADMAP.md` — qué queda por hacer
4. **Opera**: usa los scripts de `herramientas/` para cualquier acción repetitiva
5. **Documenta**: cada sesión debe dejar rastro en `diario/` y `CHANGELOG.md`
6. **Commitea**: commits semánticos siempre — usa `herramientas/git-commit-push.sh`

---

## 🛠️ Stack técnico base

| Capa | Tecnología | Config |
|---|---|---|
| Router LLM | LiteLLM proxy | `litellm-config.yaml` |
| Editor IA | OpenCode | `opencode.json` |
| Modelo local | Ollama + qwen2.5-coder:14b | automatico |
| Modelo cloud | DeepSeek R1, GPT-4o, Gemini | via API keys |
| Hardware | GTX 1060 6GB + Acer Aspire | `ARQUITECTURA-SERVIDOR.md` |
| Automatización | n8n (planificado Mayo 2026) | `ROADMAP.md` |

---

_Última actualización: 17 abril 2026 — Sistema Colmena funcional + herramientas/ operativa_

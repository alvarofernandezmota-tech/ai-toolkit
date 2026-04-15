# 🚀 Historia del Proyecto — De 0 a Arquitectura Colmena

> Cómo construimos un ecosistema de IA gratuito en un solo día.
> 15 de Abril de 2026.

---

## El punto de partida

Objetivo inicial: tener agentes de IA que trabajen sobre código de forma automática,
completamente gratis, sin pagar por APIs.

Herramienta elegida: **OpenCode** — un cliente de terminal para LLMs que puede leer
y editar ficheros de código de forma autónoma.

---

## Fase 1 — Primeros pasos (mañana)

### Lo que hicimos
- Instalamos OpenCode y lo conectamos a **DeepSeek V3-0324** vía OpenRouter (gratis)
- Creamos la estructura base de la repo: `prompts/`, `agentes/`, `investigacion/`, `scripts/`
- Generamos los primeros prompts de agentes:
  - `agente-revisor-codigo.md` — detecta bugs y deuda técnica
  - `agente-documentador.md` — genera README y docstrings
  - `agente-escalado.md` — propone refactors y tests
- Validamos el flujo completo: **tarea → OpenCode edita → commit → push → GitHub** ✅
- Descubrimos el **Compaction** — OpenCode comprime el contexto automáticamente cuando se llena

### Primer problema
DeepSeek V3 gratuito tiene solo 8.406 tokens de contexto. El repo ya los supera.

---

## Fase 2 — Búsqueda del modelo perfecto (tarde)

### El problema central
Necesitábamos un modelo gratuito con **contexto largo** (32K+ tokens) para leer repos enteros.

### Modelos probados uno a uno

**Groq — llama-3.3-70b-versatile**
```
Error: Request too large. Limit 12000, Requested 32475
```
Descartado para repos grandes. Solo para prompts cortos.

**Google AI — gemini-2.5-flash-preview-04-17**
```
Error: models/gemini-2.5-flash-preview-04-17 is not found for API version v1beta
```
Aprendizaje: los IDs de Gemini en OpenCode no coinciden con la documentación.
Necesitan verificación con `curl ListModels`.

**Google AI — variable de entorno incorrecta**
```
Error: Google Generative AI API key is missing
```
Aprendizaje crítico: OpenCode espera `GOOGLE_GENERATIVE_AI_API_KEY`, no `GOOGLE_API_KEY`.

**Google AI — gemini-2.0-flash**
```
Error: gemini is way too hot right now [retrying in 53s attempt #6]
```
A las 7pm todos los modelos gratuitos están saturados. Rate limits por todas partes.

**OpenRouter — qwen3-235b-a22b**
```
Error: This request requires more credits. You requested 32000 tokens, but can only afford 2109
```
Qwen3 235B no es gratuito para contexto largo.

**Cerebras — llama3.1-8b**
Funciona pero con 8K de contexto. Compacta en bucle cuando el repo es grande.
El modelo entiende las tareas pero se queda sin contexto rápidamente.

### La revelación
Todos los proveedores gratuitos tienen límites. **No hay un modelo perfecto único.**
La solución no es encontrar el modelo perfecto — es **usar todos a la vez**.

---

## Fase 3 — La idea de la Colmena

### El insight
En lugar de buscar un modelo que aguante todo, ¿y si usáramos todos los modelos en paralelo
como una colmena? Si uno tiene rate limit, el siguiente coge la tarea.

Esto ya existe: se llama **LLM routing con load balancing**.
La herramienta: **LiteLLM Proxy**.

### La arquitectura diseñada
```
OpenCode
    ↓
LiteLLM Proxy (localhost:4000)
    ↓
┌─────────────────────────────────────┐
│     Router least-busy              │
├────────┬────────┬────────┬───────┤
│ Google │  Groq  │Cerebras│OpenR  │
│ Gemini │llama33 │llama8b │DeepSeek│
│  1M    │  12K   │   8K   │  164K  │
└────────┴────────┴────────┴───────┘
```

---

## Fase 4 — Implementación

### Instalación LiteLLM
```bash
pip install litellm[proxy]
```

Problema en Windows: rutas demasiado largas (Long Paths no habilitado).
Solución: trabajar desde WSL/Ubuntu donde funciona sin problemas.

### Primer arranque
```
LiteLLM: Proxy initialized with Config, Set models:
    claude-sonnet-4-6  ← config viejo, había que hacer git pull
```

Lección: siempre `git pull` antes de arrancar.

### Segundo arranque (tras git pull)
```
LiteLLM: Proxy initialized with Config, Set models:
    principal   ← Google Gemini
    principal   ← Groq
    principal   ← Cerebras
    principal   ← OpenRouter
    gpt-4o      ← alias compatibilidad
    claude-sonnet ← alias compatibilidad
INFO: Uvicorn running on http://0.0.0.0:7090
```

**Éxito.** La colmena está viva.

### Problema tmux
Al intentar `Ctrl+B C` para nueva ventana, se cerró LiteLLM por accidente.
Solución definitiva: arrancar LiteLLM con `&` (background) y OpenCode en la misma terminal.

```bash
litellm --config litellm-config.yaml --port 4000 &
sleep 4
opencode
```

---

## Estado actual

### ✅ Conseguido
- Repo estructurada con prompts, agentes, scripts y documentación
- LiteLLM colmena funcionando con 4 modelos en pool
- Script de arranque `scripts/start-colmena.sh`
- Guía completa `guias/litellm-colmena.md`
- 13+ commits documentando todo el proceso

### ⏳ Pendiente
- Conectar OpenCode al proxy LiteLLM (puerto correcto en opencode.json)
- Verificar IDs exactos de Gemini con `curl ListModels`
- Crear scripts de agentes (`revisor.sh`, `documentador.sh`, `escalado.sh`)
- Probar agentes en repo real (THDORA)
- Añadir todo al menú principal del toolkit

---

## Aprendizajes del día

1. **No existe el modelo gratuito perfecto** — todos tienen límites
2. **La solución es la colmena** — muchos modelos cooperando
3. **LiteLLM es el pegamento** — conecta todo con una sola URL
4. **Siempre documentar en tiempo real** — los errores son tan valiosos como los éxitos
5. **WSL > Windows nativo** para herramientas de desarrollo Python
6. **El `&` es magia** — procesos en background resuelven el problema de terminales múltiples
7. **git pull antes de todo** — la repo es la fuente de verdad
8. **Las horas pico (7pm) saturan todos los modelos** — trabajar mañana temprano
9. **IDs de modelos varían** entre documentación y realidad — siempre verificar con curl
10. **Nunca keys en el repo** — solo variables de entorno

---

## Arquitectura final del toolkit

```
ai-toolkit/
├── INICIO-AQUI.md              ← punto de entrada
├── litellm-config.yaml         ← config colmena
├── prompts/
│   ├── sistema-base.md
│   ├── agente-revisor-codigo.md
│   ├── agente-documentador.md
│   └── agente-escalado.md
├── agentes/
│   ├── PENDIENTES.md
│   └── agente-resumen.md
├── scripts/
│   └── start-colmena.sh          ← arranque rápido
├── guias/
│   └── litellm-colmena.md        ← guía completa
└── investigacion/
    ├── modelos-gratuitos.md
    ├── apis-verificadas.md
    ├── problemas-encontrados.md
    ├── sesion-15-04-2026.md
    └── historia-del-proyecto.md   ← este archivo
```

# 🤖 Agentes — Hoja de Ruta

> Estado: 2026-04-17 | Infraestructura Colmena operativa con Ollama local

## ¿Qué son los agentes aquí?

Agentes = instancias de OpenCode corriendo en modo autónomo, cada una con un rol específico, usando la Colmena LiteLLM como cerebro. La idea es que los repos **se configuren y mantengan solos**.

## Stack actual confirmado

| Capa | Tecnología | Estado |
|------|-----------|--------|
| Editor IA | OpenCode (opencode.ai) | ✅ Operativo |
| Router IA | LiteLLM Proxy (Colmena) | ✅ Operativo |
| Modelos locales | Ollama (`qwen2.5-coder:14b`, `deepseek-r1:14b`, `qwen3:8b`) | ✅ Operativo |
| APIs fallback | Groq, Sambanova, Together, OpenRouter, Cerebras | ⚠️ Límites free tier |
| APIs último recurso | Gemini Flash/Lite | ❌ Cuota agotada |

## Fix aplicado hoy: timeout Ollama

**Problema**: `request_timeout: 15` en LiteLLM → Ollama tardaba ~30-60s en cargar modelo → timeout → caía a APIs de nube → 429 RateLimit en cadena.

**Solución**: `request_timeout: 120` → Ollama local siempre responde, sin tocar APIs.

**Confirmado**: `qwen2.5-coder:14b` respondió correctamente en prueba manual con curl.

## Próximos pasos: Agentes auto-configuradores

### Fase 1 — Agente repo-setup (siguiente)
Cada repo del ecosistema necesita:
- `CLAUDE.md` o `opencode.md` con contexto del proyecto
- `.env.example` con variables necesarias
- `Makefile` con comandos estándar (`make dev`, `make test`, `make build`)
- GitHub Actions básico (lint + test)

**Tarea para OpenCode**:
```
Revisa todos los repos en REPOS-ECOSISTEMA.md y para cada uno:
1. Lee su README actual
2. Genera un CLAUDE.md con contexto del proyecto
3. Crea un Makefile con comandos estándar
4. Propón el .env.example necesario
Empezar por: ai-toolkit (este mismo repo)
```

### Fase 2 — Agente mantenimiento
- Detecta cuando las APIs fallan (429/503)
- Actualiza automáticamente el estado en este fichero
- Propone rotación de modelos según disponibilidad

### Fase 3 — Agente onboarding repos nuevos
- Al crear repo nuevo → agente lee el código → genera documentación completa → configura CI/CD

## Tarea inmediata para OpenCode ahora mismo

```
Analiza el repo ai-toolkit completo y haz lo siguiente:

1. Lee REPOS-ECOSISTEMA.md y lista todos los repos del ecosistema
2. Para ESTE repo (ai-toolkit), actualiza README.md con:
   - Estado real de la colmena (qué funciona, qué no)
   - Instrucciones de arranque claras (setup.sh → start-colmena.sh → opencode)
   - Troubleshooting: timeout Ollama, 429 Groq, cuota Gemini
3. Crea scripts/health-check.sh que compruebe:
   - Ollama corriendo en :11434
   - LiteLLM corriendo en :8000
   - Cada modelo responde (curl test)
   - Muestra estado de APIs (verde/amarillo/rojo)
4. Commitea todo con mensaje descriptivo
```

## Arquitectura objetivo (visión)

```
┌─────────────────────────────────────────────┐
│              ECOSISTEMA REPOS                │
│  thdora/  ai-toolkit/  [otros repos]/        │
│     ↓           ↓            ↓              │
│  ┌──────────────────────────────────┐        │
│  │     OpenCode (agentes)           │        │
│  │  agente-setup | agente-review    │        │
│  └──────────────┬───────────────────┘        │
│                 ↓                            │
│  ┌──────────────────────────────────┐        │
│  │   LiteLLM Colmena :8000          │        │
│  │   router inteligente             │        │
│  └──────────────┬───────────────────┘        │
│                 ↓                            │
│  ┌──────────────────────────────────┐        │
│  │   Ollama LOCAL (sin límites)     │        │
│  │   qwen2.5-coder:14b (código)     │        │
│  │   deepseek-r1:14b (razonamiento) │        │
│  │   qwen3:8b (tareas rápidas)      │        │
│  └──────────────────────────────────┘        │
│           ↓ (solo si falla local)            │
│  ┌──────────────────────────────────┐        │
│  │   APIs nube (fallback)           │        │
│  │   Groq → Sambanova → Together    │        │
│  └──────────────────────────────────┘        │
└─────────────────────────────────────────────┘
```

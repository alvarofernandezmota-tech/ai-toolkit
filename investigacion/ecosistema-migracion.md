# 🗣️ Plan de migración del ecosistema

> Cómo vamos a migrar de herramientas actuales a herramientas mejores, y cómo procede el ecosistema.

---

## Principio de la migración

**No se rompe nada que funcione.** Cada migración se hace en paralelo, se prueba, y solo cuando está verificada se corta el fallback al sistema anterior.

```
[Sistema actual] → [Paralelo: nuevo sistema en pruebas] → [Nuevo sistema en producción] → [Deprecar antiguo]
```

---

## Migraciones pendientes

### 1. Modelos — Groq llama-3.3-70b → Devstral 2 para coding

**Estado:** ⏳ Pendiente de probar
**Prioridad:** Alta
**Cómo hacerlo:**

```bash
# Paso 1: probar en Aider con un task real
aider --model openrouter/mistralai/devstral-2:free

# Paso 2: si mejora la calidad de output, cambiar en .aider.conf.yml
model: openrouter/mistralai/devstral-2:free

# Paso 3: probar en Claude Code
export ANTHROPIC_BASE_URL=https://openrouter.ai/api/v1
claude --model openrouter/mistralai/devstral-2:free

# Paso 4: si todo bien, documentar en experimentos.md
```

**Fallback:** Si Devstral 2 tiene rate limits en OpenRouter `:free`, volver a `groq/llama-3.3-70b-versatile`.

---

### 2. NLP de THDORA — añadir mem0

**Estado:** ⏳ Pendiente (Verano 2026)
**Prioridad:** Media
**Rama:** `feature/mem0-memory`

**Cómo hacerlo:**

```bash
# Paso 1: crear rama
git checkout -b feature/mem0-memory

# Paso 2: instalar
pip install mem0ai chromadb sentence-transformers

# Paso 3: con Aider
aider-thdora
/add src/core/groq_router.py
> implementa mem0 con groq como llm y chroma como vector store local
> integra memory.search() antes de cada llamada a groq
> integra memory.add() después de cada respuesta

# Paso 4: probar una semana en rama
# Paso 5: merge a main si funciona bien
```

**Referencia:** [investigacion/mem0-memoria-persistente.md](mem0-memoria-persistente.md)

---

### 3. Automatizaciones — primer workflow n8n

**Estado:** ⏳ Pendiente (Mayo 2026)
**Prioridad:** Media

**Primer workflow: brief diario**

```
Trigger: Cron 08:00 cada día
  │
  ├── Leer citas del día (THDORA API o Google Calendar)
  ├── Leer hábitos pendientes (THDORA API)
  ├── Consultar a Groq: genera un brief motivador del día
  └── Enviar por Telegram a Alvaro
```

**Cómo hacerlo:**
1. Levantar n8n con Docker: `docker run -d -p 5678:5678 n8nio/n8n`
2. Crear el workflow en la UI de n8n
3. Exponer un endpoint de THDORA para que n8n pueda leer citas y hábitos
4. Documentar el workflow exportado en `workflows/n8n/brief-diario.json`

---

### 4. Extracción al repo público

**Estado:** ⏳ Pendiente (Mayo-Junio 2026)
**Prioridad:** Baja por ahora
**Referencia:** [ESTRATEGIA.md](../ESTRATEGIA.md) → Fase 2

---

## Orden de ejecución recomendado

```
Hoy (Abril 2026)
  └── 1. Probar Devstral 2 con Claude Code en THDORA (30 min)
      └── Documentar resultado en experimentos.md

Esta semana
  └── 2. Aider + Groq para primer fix real en THDORA
      └── Documentar resultado en experimentos.md

Mayo 2026
  └── 3. Primer workflow n8n: brief diario
  └── 4. Empezar feature/mem0-memory en rama separada

Junio 2026
  └── 5. Merge mem0 si funciona bien
  └── 6. Extraer partes genéricas al repo público

Verano 2026
  └── 7. Repo público con README listo para la comunidad
```

---

## Arquitectura objetivo (cuando todo esté migrado)

```
┌─────────────────────────────────────────────────────────┐
│                    ECOSISTEMA                           │
│                                                         │
│  [Telegram] ──► [THDORA / Toki]                          │
│                   │                                     │
│           ┌───────┴────────┐                           │
│           │              │                           │
│       [Groq NLP]    [mem0 memoria]                    │
│       [Devstral 2]  [SQLite local]                    │
│           │                                           │
│     ┌────┴────┐                                       │
│     │         │                                       │
│  [Citas]  [Hábitos]                                   │
│                                                         │
│  [n8n] ───► [Brief diario] ──► [Telegram]               │
│          └──► [Recordatorios]                            │
│          └──► [Automatizaciones]                          │
│                                                         │
│  [Aider / Claude Code] ──► [THDORA dev]                  │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

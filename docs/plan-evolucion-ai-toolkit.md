# Plan de Evolución ai-toolkit

> Generado: 23 abril 2026 — sesión Perplexity + Álvaro + Claude IA

---

## Contexto

Esta sesión analizamos el estado real del repo y definimos un plan concreto de evolución.
Input: auditoría estructural completa (30 ítems raíz) + análisis de Claude IA.

---

## 1. Limpieza

### AGENTS.md + AGENTES.md — fusionar
- **Acción:** Fusionar en un único `AGENTS.md` en inglés
- **Razón:** Claude Code lee mejor en inglés. El español va en CLAUDE.md para contexto tuyo.
- **Estado:** ✅ Completado (23 abril 2026)

### CLAUDE.md como índice maestro
- **Acción:** CLAUDE.md es el punto de entrada para Claude Code. Apunta a todos los demás archivos.
- **Razón:** Claude Code siempre lee CLAUDE.md primero. Ese archivo es el que manda.
- **Estado:** ✅ Completado (23 abril 2026) — sección "Las entidades del ecosistema" añadida

### MDs en raíz — reorganizar a docs/
- **Acción:** Mover archivos no esenciales a `docs/` con subcarpetas: `docs/arquitectura/`, `docs/guias/`, `docs/estrategia/`
- **Prioridad:** Media — hacerlo DESPUÉS de actualizar CLAUDE.md como índice
- **Estado:** ⏳ Pendiente

---

## 2. Fixes urgentes

### Fix 401 LiteLLM health-check
- **Problema:** El `master_key` en litellm-config.yaml requiere que todas las peticiones lleven `Authorization: Bearer sk-litellm-local`. El health-check no lo manda.
- **Fix (una línea en el script):**
  ```bash
  curl http://localhost:8000/health \
    -H "Authorization: Bearer sk-litellm-local"
  ```
- **Estado:** ⏳ Pendiente — incluido en prompt de auditoría para Claude Code

### Keys caducadas
- Groq key: renovar en https://console.groq.com
- DeepSeek key: renovar en https://platform.deepseek.com
- Gemini: verificar si rate limit se resetó en https://aistudio.google.com
- **Mientras tanto:** Usar `groq-fallback` o modelos OpenRouter gratuitos
- **Estado:** ⏳ Pendiente — requiere acción manual de Álvaro en portales

---

## 3. Nuevas capacidades — priorizadas

### 🔴 Alta prioridad

#### Auto-diario via git log
- **Qué es:** Script que genera entrada de diario automáticamente desde `git log`
- **Complejidad:** Media — Claude Code puede hacerlo en 20 minutos
- **Script existente:** `scripts/generar-diario.sh` — verificar si ya funciona o necesita mejoras
- **Estado:** ⏳ Pendiente

#### bootstrap.sh — estado del ecosistema en 30 segundos
- **Qué es:** Script que cualquier agente nuevo ejecuta al entrar al repo y en 30 segundos le da el estado completo: qué está corriendo, qué keys funcionan, en qué rama está cada repo, qué tareas hay pendientes.
- **Razón:** El contexto ahora está disperso en 15 archivos. Esto lo centraliza.
- **Complejidad:** Media
- **Estado:** ⏳ Pendiente

### 🟡 Media prioridad

#### Health-check mejorado con detección de keys caducadas
- **Qué es:** El script actual no distingue entre "LiteLLM caído" y "key caducada". Mejorarlo para que detecte el tipo de error.
- **Complejidad:** Media
- **Estado:** ⏳ Pendiente

### 🟢 Baja prioridad

#### Dashboard MD auto-actualizable
- **Decisión:** Descartado por ahora. Requiere cron/trigger. Mejor invertir en health-check.

#### Integración THDORA ↔ ai-toolkit
- **Qué es:** THDORA expone un endpoint /status y ai-toolkit lo consume
- **Decisión:** Para después de los fixes urgentes y S17. Complejo.
- **Estado:** ❌ Descartado para S17

---

## 4. Priorización — orden de ejecución

| # | Tarea | Complejidad | Claude Code solo | Estado |
|---|-------|-------------|-----------------|--------|
| 1 | Fix health-check (header auth) | Fácil | ✅ Sí | ⏳ |
| 2 | CLAUDE.md como índice maestro | Fácil | ✅ Sí | ✅ Hecho |
| 3 | Fusionar AGENTS.md + AGENTES.md | Fácil | ✅ Sí | ✅ Hecho |
| 4 | Mover MDs a docs/ + actualizar referencias | Media | ⚠️ Con revisión | ⏳ |
| 5 | Auto-diario via git log | Media | ✅ Sí | ⏳ |
| 6 | bootstrap.sh estado ecosistema | Media | ✅ Sí | ⏳ |
| 7 | Health-check detección keys caducadas | Media | ✅ Sí | ⏳ |
| 8 | Renovar keys Groq + DeepSeek | Fácil | ❌ No — acción manual | ⏳ |
| 9 | Integración THDORA ↔ ai-toolkit | Compleja | ⚠️ Con supervisión | ❌ S17 no |

---

## 5. Problema del modelo en Claude Code

Antes de ejecutar cualquier tarea en Claude Code, verificar qué modelos gratuitos están disponibles:

```bash
curl -s https://openrouter.ai/api/v1/models \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" | \
  python3 -c "import sys,json; [print(m['id']) for m in json.load(sys.stdin)['data'] if ':free' in m['id']]"
```

**Modelos recomendados para Claude Code (confirmados 23 abril 2026):**
- `qwen/qwen3-coder:free` — especializado en código, ideal
- `meta-llama/llama-3.3-70b-instruct:free` — más capaz en razonamiento
- `openai/gpt-oss-120b:free` — alternativa potente

---

_Generado por: Perplexity AI + Álvaro + Claude IA — 23 abril 2026, ~16:00 CEST_

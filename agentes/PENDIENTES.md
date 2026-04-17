# Agentes pendientes de construir

> Lista viva. Cada vez que decidas construir un agente, muévelo de aquí a su propio archivo en `agentes/`.

---

## ✅ Completados

- [x] Claude Code conectado a OpenRouter (14/04/2026)
- [x] OpenCode + DeepSeek R1 funcionando (15/04/2026)
- [x] Scripts de rotación de modelos con fallback (15/04/2026)
- [x] Estructura base del repo completa (14/04/2026)
- [x] **Agente OpenCode documentado** → `agentes/agente-opencode.md` (17/04/2026)
- [x] **Agente LiteLLM documentado** → `agentes/agente-litellm.md` (17/04/2026)
- [x] **Agente Ollama documentado** → `agentes/agente-ollama.md` (17/04/2026)
- [x] **Agente Investigación documentado** → `agentes/agente-investigacion.md` (17/04/2026)
- [x] **Agente Git Commits documentado** → `agentes/agente-git-commits.md` (17/04/2026)
- [x] Agente resumen de sesión → `agentes/agente-resumen.md`
- [x] `scripts/generar-diario.sh` generado por OpenCode (17/04/2026)

---

## 🔥 Prioritarios (próxima sesión)

### 1. Agente de coding real sobre THDORA
**Que hace:** Usa Claude Code para trabajar sobre el código real de THDORA, empezando por los bugs identificados.  
**Herramienta:** Claude Code + OpenRouter  
**Input:** Lista de bugs en `agentes/thdora-primera-sesion.md`  
**Como arrancarlo:**
```bash
cd ~/projects/THDORA
OPENAI_API_KEY="$OPENROUTER_API_KEY" \
OPENAI_BASE_URL="https://openrouter.ai/api/v1" \
claude --model anthropic/claude-3.5-sonnet
# Dentro de Claude Code: "Lee CLAUDE.md y luego ataca el primer bug de la lista"
```
**Estado:** 🔴 Pendiente  
**Estimación:** 1-2 horas primera sesión

---

### 2. `scripts/investigar.sh` — búsqueda automática
**Que hace:** Script que dado un tema busca con Perplexity/Tavily API y guarda en `investigacion/`.  
**Base:** Ya documentado en `agentes/agente-investigacion.md`  
**Estado:** 🔴 Pendiente construcción del script  
**Estimación:** 2-3 horas

---

### 3. `scripts/cerrar-sesion.sh` — commit automático de cierre
**Que hace:** Al final de cada sesión, hace `git add -A`, genera commit semántico y actualiza CHANGELOG.  
**Base:** Ya documentado en `agentes/agente-git-commits.md`  
**Estado:** 🔴 Pendiente construcción del script  
**Estimación:** 30 min

---

### 4. Agente revisor de código (THDORA)
**Archivo:** `agentes/agente-revisor-codigo.md` (borrador existe)  
**Estado:** 🟡 Borrador generado 15/04/2026. Necesita prueba real sobre código de THDORA.  
**Siguiente paso:** Probarlo con una sesión real.

---

## 🟡 En progreso

### RAG con nomic-embed-text + ChromaDB
**Que hace:** Embeddings locales sobre los docs del repo para búsqueda semántica.  
**Herramienta:** `nomic-embed-text` (ya instalado en Ollama) + ChromaDB  
**Estado:** 🟡 Modelo disponible, falta implementar el pipeline  
**Estimación:** 3-4 horas

---

## 🔵 Backlog (no urgente)

### Agente de n8n para automatización de tareas repetitivas
**Archivo:** `agentes/agente-n8n-automatizacion.md`  
**Cuando:** Cuando THDORA esté más estable y haya tareas repetitivas claras.

### Agente multiagente con CrewAI
**Archivo:** `agentes/agente-multiagente-crewai.md`  
**Cuando:** Cuando los agentes individuales ya funcionen bien.

### Agente de vida personal (hábitos, finanzas, salud)
**Archivo:** `agentes/thdora-agente-vida.md`  
**Cuando:** Cuando el ecosistema técnico esté sólido. Es el objetivo final.

### pre-commit hook anti-secrets
**Que hace:** Bloquea commits con `.env`, API keys o credenciales accidentales.  
**Cuando:** Próxima sesión de mantenimiento del repo.

# Agentes pendientes de construir

> Lista viva. Cada vez que decidas construir un agente, muevelo de aqui a su propio archivo en `agentes/`.

---

## 🔥 Prioritarios (proxima sesion)

### 1. Agente de coding real sobre THDORA
**Que hace:** Usa Claude Code para trabajar sobre el codigo real de THDORA, empezando por los bugs identificados.  
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
**Estimacion:** 1-2 horas primera sesion

---

### 2. Agente de investigacion web automatico
**Que hace:** Dado un tema, busca informacion actualizada, la resume y la guarda en `investigacion/`.  
**Herramienta:** OpenCode + DeepSeek R1 (ya funciona) o Groq + busqueda web  
**Input:** Prompt con el tema a investigar  
**Output:** Archivo MD en `investigacion/YYYY-MM-DD-tema.md`  
**Como construirlo:**
```bash
# Arrancar OpenCode
OPENAI_API_KEY="$OPENROUTER_API_KEY" \
OPENAI_BASE_URL="https://openrouter.ai/api/v1" \
opencode
# Prompt: "Crea un script Python que dado un tema busque informacion con 
# Perplexity/Tavily API y la guarde como MD en investigacion/"
```
**Estado:** 🔴 Pendiente  
**Estimacion:** 2-3 horas

---

### 3. Agente de documentacion automatica de sesion
**Que hace:** Al final de cada sesion, analiza los commits del dia y genera una entrada de diario automaticamente.  
**Herramienta:** Script Python + OpenRouter API directa  
**Input:** Output de `git log --since=today`  
**Output:** Archivo MD en `docs/diario/YYYY-MM-DD-sesion.md`  
**Como construirlo:**
```bash
# Construir con OpenCode
OPENAI_API_KEY="$OPENROUTER_API_KEY" \
OPENAI_BASE_URL="https://openrouter.ai/api/v1" \
opencode
# Prompt: "Crea scripts/generar-diario.sh que use git log para obtener los 
# commits de hoy, los pase a un modelo via OpenRouter API y genere un MD"
```
**Estado:** 🔴 Pendiente  
**Estimacion:** 1-2 horas

---

## 🟡 En progreso

### Agente resumen de sesion
**Archivo:** `agentes/agente-resumen.md`  
**Estado:** Borrador generado por OpenCode el 15/04/2026. Necesita revision y prueba real.  
**Siguiente paso:** Probarlo con una sesion real y ver si el output es util.

### Agente revisor de codigo
**Archivo:** `agentes/agente-revisor-codigo.md`  
**Estado:** Borrador generado por OpenCode el 15/04/2026. Necesita revision y prueba real.  
**Siguiente paso:** Probarlo sobre codigo real de THDORA.

---

## 🔵 En el backlog (no urgente)

### Agente de n8n para automatizacion de tareas repetitivas
**Archivo:** `agentes/agente-n8n-automatizacion.md`  
**Cuando:** Cuando THDORA este mas estable y haya tareas repetitivas claras.

### Agente multiagente con CrewAI
**Archivo:** `agentes/agente-multiagente-crewai.md`  
**Cuando:** Cuando los agentes individuales ya funcionen bien. CrewAI es la capa de orquestacion.

### Agente de vida personal (habitos, finanzas, salud)
**Archivo:** `agentes/thdora-agente-vida.md`  
**Cuando:** Cuando el ecosistema tecnico este solido. Es el objetivo final.

---

## ✅ Completados

- [x] Claude Code conectado a OpenRouter (14/04/2026)
- [x] OpenCode + DeepSeek R1 funcionando (15/04/2026)
- [x] Scripts de rotacion de modelos con fallback (15/04/2026)
- [x] Estructura base del repo completa (14/04/2026)

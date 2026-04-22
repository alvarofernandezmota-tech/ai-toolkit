# Agentes pendientes de construir

> Lista viva. Cada vez que decidas construir un agente, muévelo de aquí a su propio archivo en `agentes/`.
> Actualizado: 22 abril 2026

---

## 🔥 Prioritarios (próxima sesión)

### 1. Primer uso real de Claude Code en THDORA
**Qué hace:** Usa Claude Code para atacar los 4 bugs confirmados en producción.
**Herramienta:** Claude Code + OpenRouter
**Input:** Lista de bugs en `agentes/thdora-primera-sesion.md`
**Cómo arrancarlo:**
```bash
cd ~/projects/thdora
claude --model anthropic/claude-3.5-sonnet
# Dentro: "Lee CLAUDE.md y luego ataca el primer bug de la lista"
```
**Estado:** 🔴 Pendiente
**Estimación:** 1-2 horas primera sesión

---

### 2. Renovar keys caducadas
**Groq:** https://console.groq.com/keys → actualizar GROQ_API_KEY en ~/.bashrc
**DeepSeek:** https://platform.deepseek.com → actualizar DEEPSEEK_API_KEY en ~/.bashrc
**Estado:** 🔴 Pendiente (afecta a rotación de modelos)

---

### 3. Rellenar comparativa-llms.md con benchmark real
**Cómo:** `bash scripts/benchmark-runner.sh` — ya automatizado
**Estado:** 🔴 Pendiente (script listo, falta ejecutarlo)
**Tiempo:** ~20 minutos

---

## 🟡 En progreso

### Agente resumen de sesión
**Archivo:** `agentes/agente-resumen.md`
**Estado:** Borrador generado. Necesita prueba real con una sesión.
**Siguiente paso:** Usar `generar-diario.sh` como base y verificar output.

### Agente revisor de código
**Archivo:** `agentes/agente-revisor-codigo.md`
**Estado:** Borrador generado. Necesita prueba en código real de THDORA.

---

## 🔵 En el backlog (no urgente)

### Agente de investigación web automático
**Qué hace:** Dado un tema, busca info actualizada y la guarda en `investigacion/`.
**Herramienta:** OpenCode + DuckDuckGo o Tavily
**Cuando:** Junio 2026 (junto con búsqueda web en THDORA)

### Agente de n8n para automatización
**Archivo:** `agentes/agente-n8n-automatizacion.md`
**Cuando:** Mayo 2026 — después de montar n8n Docker

### Agente multiagente con CrewAI
**Archivo:** `agentes/agente-multiagente-crewai.md`
**Cuando:** Otoño 2026 — cuando los agentes individuales funcionen bien

### Integrar ensemble.sh en flujo de arquitectura
**Qué hace:** Antes de cada decisión técnica grande, lanzar ensemble con la pregunta
**Estado:** Script listo, falta convertirlo en hábito

### mem0 memoria persistente
**Cuando:** Verano 2026

### toki-bot repo público
**Cuando:** Mayo-Junio 2026

### Búsqueda web en THDORA
**Cuando:** Junio 2026

---

## ✅ Completados

- ✅ 2026-04-14 Claude Code conectado a OpenRouter
- ✅ 2026-04-15 OpenCode + DeepSeek R1 funcionando
- ✅ 2026-04-15 Scripts de rotación de modelos con fallback
- ✅ 2026-04-14 Estructura base del repo completa
- ✅ 2026-04-15 LiteLLM Colmena multi-modelo
- ✅ 2026-04-17 Ollama integrado en LiteLLM — modelos locales 100% offline
- ✅ 2026-04-17 `scripts/generar-diario.sh` — diario automático desde git log
- ✅ 2026-04-17 `scripts/health-check.sh` — diagnóstico de APIs en paralelo
- ✅ 2026-04-17 `scripts/ensemble.sh` — mismo prompt a varios modelos
- ✅ 2026-04-17 `scripts/benchmark-runner.sh` — rellena comparativa-llms.md
- ✅ 2026-04-22 `.gitignore` — .env y archivos sensibles excluidos (fix E8)
- ✅ 2026-04-22 `scripts/ai-menu.sh` — menú interactivo 12 opciones (fix E2)
- ✅ 2026-04-22 `scripts/start-colmena.sh` — fix E1, busca litellm sin depender de thdora
- ✅ 2026-04-22 `INICIO-AQUI.md` — actualizado con tabla de estado S16 (fix E5)
- ✅ 2026-04-22 Auditoría completa ai-toolkit — 10 errores encontrados y corregidos

# 🤖 Sistema de agentes de Álvaro

> El objetivo de este directorio: definir, configurar y documentar todos los agentes IA que trabajan para Álvaro. No herramientas manuales — agentes con roles claros, instrucciones precisas y resultados medibles.

---

## Visión del sistema de agentes

```
Álvaro da una orden de alto nivel
         ↓
El agente correcto la ejecuta
         ↓
Resultado aplicado al repo correspondiente
         ↓
Experimento documentado en investigacion/experimentos.md
```

No se trata de usar herramientas a mano. Se trata de **orquestar agentes** que trabajan en paralelo y se retroalimentan.

---

## Agentes actuales

### 🔧 Agente de código — Aider

**Herramienta:** [Aider](https://aider.chat) + Groq `llama-3.3-70b-versatile`
**Para qué:** Fixes rápidos, features pequeñas, tests, refactors de un fichero
**Velocidad:** Instantánea (Groq 750 tok/s)

```bash
# Activar en cualquier repo
cd ~/projects/cualquier-repo
aider --model groq/llama-3.3-70b-versatile

# Para tareas de razonamiento difícil
aider --model groq/qwen-qwq-32b
```

**Alias útil:**
```bash
alias aider-fast='aider --model groq/llama-3.3-70b-versatile'
alias aider-think='aider --model groq/qwen-qwq-32b'
```

---

### 🏗️ Agente de arquitectura — Claude Code

**Herramienta:** [Claude Code](https://claude.ai/code) + OpenRouter Devstral 2
**Para qué:** Refactorizaciones grandes, diseño de arquitectura, multi-fichero
**Contexto:** 256K tokens (puede leer repos enteros)

```bash
# Configurar OpenRouter como backend
export ANTHROPIC_BASE_URL=https://openrouter.ai/api/v1
export ANTHROPIC_API_KEY=sk-or-tu_key

# Lanzar con el mejor modelo de coding
claude --model openrouter/mistralai/devstral-2:free

# O con Qwen3 Coder
claude --model openrouter/qwen/qwen3-coder:free
```

---

### 🧠 Agente de investigación — DeepSeek R1

**Herramienta:** DeepSeek R1-0528 vía OpenRouter
**Para qué:** Investigar tecnologías, comparar opciones, tomar decisiones de arquitectura
**Thinking:** Sí, modo de razonamiento profundo

```bash
# En Aider para tareas de investigación
aider --model openrouter/deepseek/deepseek-r1-0528:free

# O directamente por API para preguntas complejas
curl https://openrouter.ai/api/v1/chat/completions \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  -d '{"model": "deepseek/deepseek-r1-0528:free", "messages": [{"role": "user", "content": "..."}]}'
```

---

### ⚙️ Agente de automatización — n8n

**Herramienta:** [n8n](https://n8n.io) self-hosted + Groq
**Para qué:** Workflows, briefs diarios, recordatorios, automatizaciones de repos
**Estado:** ⏳ Pendiente — Mayo 2026

**Workflows planeados:**
- Brief diario a las 08:00 por Telegram
- Notificación cuando un repo tiene issues sin responder
- Resumen semanal del ecosistema
- Auto-update de READMEs cuando cambian los benchmarks

---

### 🏆 Agente de portfolio — Claude Code + Qwen3

**Herramienta:** Claude Code + `openrouter/qwen/qwen3-235b-a22b:free`
**Para qué:** Mantener README actualizados, crear demos, documentar proyectos para que brillen en el portfolio

```bash
# Escanear un repo y mejorar su README para el portfolio
claude --model openrouter/qwen/qwen3-235b-a22b:free
> lee todos los ficheros de este repo y escribe un README.md que explique
> qué hace, por qué importa, qué tecnologías usa, cómo instalarlo
> con el formato de un proyecto de portfolio profesional
```

---

## Cómo orquestar múltiples agentes (CrewAI)

Para tareas complejas que requieren varios agentes en paralelo:

```python
# agents/crew_ejemplo.py
from crewai import Agent, Task, Crew
from langchain_groq import ChatGroq

llm = ChatGroq(model='llama-3.3-70b-versatile', api_key=os.getenv('GROQ_API_KEY'))

# Agente investigador
investigador = Agent(
    role='Investigador de tecnologías',
    goal='Investigar y comparar opciones técnicas con datos reales',
    llm=llm,
    verbose=True
)

# Agente desarrollador
desarrollador = Agent(
    role='Desarrollador Python senior',
    goal='Implementar la mejor solución encontrada por el investigador',
    llm=llm,
    verbose=True
)

# Agente documentador
documentador = Agent(
    role='Technical writer',
    goal='Documentar lo construido para el portfolio de Álvaro',
    llm=llm,
    verbose=True
)

# Tarea encadenada
tarea_investigar = Task(
    description='Investiga las mejores librerías Python para {objetivo}',
    agent=investigador
)

tarea_implementar = Task(
    description='Implementa la solución recomendada por el investigador',
    agent=desarrollador,
    context=[tarea_investigar]  # Usa el output del investigador
)

tarea_documentar = Task(
    description='Documenta el proyecto para el portfolio',
    agent=documentador,
    context=[tarea_implementar]
)

# Lanzar el equipo
crew = Crew(
    agents=[investigador, desarrollador, documentador],
    tasks=[tarea_investigar, tarea_implementar, tarea_documentar]
)

resultado = crew.kickoff(inputs={'objetivo': 'procesamiento de lenguaje natural'})
```

---

## Roadmap de agentes

| Agente | Estado | Fecha |
|---|---|---|
| Agente de código (Aider + Groq) | ✅ Operativo | Ahora |
| Agente de arquitectura (Claude Code) | ⏳ Configurando | Abril 2026 |
| Agente de investigación (R1) | ✅ Operativo | Ahora |
| Agente de automatización (n8n) | ⏳ Pendiente | Mayo 2026 |
| Agente de portfolio | ⏳ Pendiente | Mayo 2026 |
| OrquestAción multi-agente (CrewAI) | ⏳ Pendiente | Junio 2026 |

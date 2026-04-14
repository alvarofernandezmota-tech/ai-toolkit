# 🧠 Multi-agente CrewAI (Otoño 2026)

> CrewAI orquesta múltiples agentes IA especializados que trabajan en equipo. Para THDORA, el equipo sería: revisor de código + escritor de tests + generador de docs.

**Fecha objetivo: Otoño 2026. Aquí el diseño para no perderlo.**

---

## Concepto

```
Tú dices: "revisa el PR #15 de THDORA"
         ↓
Director coordina al equipo
         ↓
┌────────────────┬────────────────┬─────────────────┐
│  Code Reviewer │  Test Writer   │  Doc Generator  │
│  (DeepSeek R1) │  (Qwen3 Coder) │  (Llama 3.3)    │
│                │                │                 │
│ Revisa código  │ Escribe tests  │ Genera docs     │
│ detecta bugs   │ para el PR     │ y CHANGELOG     │
└────────────────┴────────────────┴─────────────────┘
         ↓
Resultado: comentarios en PR + tests creados + docs actualizadas
```

---

## Instalación

```bash
pip install crewai crewai-tools
```

---

## Código base del equipo THDORA

```python
import os
from crewai import Agent, Crew, Task, Process
from crewai_tools import GithubSearchTool, CodeInterpreterTool

# ─── AGENTES ───────────────────────────────────────────

revisor = Agent(
    role='Senior Code Reviewer',
    goal='Revisar el código de THDORA y encontrar bugs, problemas de seguridad y mejoras',
    backstory='Eres experto en Python, FastAPI y patrones de diseño. Has revisado miles de PRs.',
    model='groq/llama-3.3-70b-versatile',
    verbose=True
)

tester = Agent(
    role='QA Engineer',
    goal='Escribir tests unitarios completos para el código de THDORA',
    backstory='Eres experto en pytest y testing de APIs async con Python.',
    model='openrouter/qwen/qwen3-coder:free',
    verbose=True
)

docer = Agent(
    role='Technical Writer',
    goal='Generar documentación técnica clara y actualizar el CHANGELOG',
    backstory='Eres experto en documentar proyectos Python en español.',
    model='groq/llama-3.3-70b-versatile',
    verbose=True
)

# ─── TAREAS ────────────────────────────────────────────

tarea_revision = Task(
    description='Revisa el fichero {fichero} y genera un informe de: bugs encontrados, mejoras de código, problemas de seguridad.',
    expected_output='Lista de issues ordenados por prioridad con código de ejemplo para cada fix.',
    agent=revisor
)

tarea_tests = Task(
    description='Escribe tests unitarios con pytest para {fichero}. Cubre los happy paths y los edge cases del informe de revisión.',
    expected_output='Fichero de tests completo listo para ejecutar con pytest.',
    agent=tester
)

tarea_docs = Task(
    description='Actualiza el CHANGELOG.md con los cambios de esta sesión y añade docstrings a {fichero}.',
    expected_output='CHANGELOG.md actualizado y fichero con docstrings añadidos.',
    agent=docer
)

# ─── CREW ──────────────────────────────────────────────

crew = Crew(
    agents=[revisor, tester, docer],
    tasks=[tarea_revision, tarea_tests, tarea_docs],
    process=Process.sequential,   # uno tras otro
    verbose=True
)

# ─── EJECUTAR ──────────────────────────────────────────

resultado = crew.kickoff(inputs={
    'fichero': 'src/core/groq_router.py'
})
print(resultado)
```

---

## Casos de uso

| Caso | Agentes que actúan | Trigger |
|---|---|---|
| Revisar PR nuevo | Revisor + Tester | Manual o n8n cuando se crea PR |
| Preparar release | Los 3 agentes | Manual antes de cada versión |
| Detectar deuda técnica | Revisor solo | Mensual automático con n8n |
| Generar docs completas | Docer solo | Manual |

---

## Integración con n8n (automático)

Cuando n8n detecta un PR nuevo en GitHub:

```
GitHub trigger (PR creado) → n8n
        ↓
HTTP Request → endpoint local de CrewAI
        ↓
Crew revisa el PR automáticamente
        ↓
Resultado → comentario en el PR de GitHub
```

---

## Roadmap de implementación

```
Septiembre 2026
  └── pip install crewai + crew básico (revisor solo)

Octubre 2026
  └── Añadir tester + integración con pytest

Noviembre 2026
  └── Crew completo + trigger automático desde n8n
```

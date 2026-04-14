# 👤 Álvaro Fernández Mota — Perfil, skills y ecosistema

> Documento maestro de contexto. Todo lo que hay que saber sobre Álvaro, sus skills reales, su ecosistema y cómo esto se traduce en una búsqueda de trabajo diferencial.
> Última actualización: 14 abril 2026.

---

## 🧠 Quién es Álvaro y qué está construyendo

Álvaro es un desarrollador que ha construido **un ecosistema completo de IA personal** — no como ejercicio académico, sino en producción real, funcionando, con datos reales de su vida.

El ecosistema tiene tres capas que se retroalimentan:

```
┌────────────────────────────────────────────────────┐
│ CAPA 1: Vida real (THDORA)                           │
│ Bot Telegram personal en producción                 │
│ NLP con Groq — entiende lenguaje natural              │
│ Gestión de citas + hábitos con BBDD real             │
│ v0.14.0, funcionando 24/7, 0€/mes                    │
└────────────────────────────────────────────────────┘
           ↓ aprende y valida en vida real
┌────────────────────────────────────────────────────┐
│ CAPA 2: Sistema de agentes (ai-toolkit)              │
│ Agentes que gestionan y escalan todos sus repos      │
│ Laboratorio de investigación de LLMs verificada      │
│ Documentación de arquitecturas y experimentos        │
└────────────────────────────────────────────────────┘
           ↓ produce y muestra resultados reales
┌────────────────────────────────────────────────────┐
│ CAPA 3: Portfolio público                            │
│ Evidencia real de IA aplicada en producción          │
│ Diferenciador brutal en entrevistas de trabajo       │
│ Posicionamiento como experto en IA aplicada          │
└────────────────────────────────────────────────────┘
```

---

## 🛠️ Skills técnicos reales (evidenciados con proyectos)

### Python — nivel avanzado
- Bot de Telegram con `python-telegram-bot` (async, handlers, conversations)
- API REST con FastAPI (endpoints, modelos Pydantic, middleware)
- BBDD SQLite con SQLAlchemy y migraciones
- NLP: intent classification, entity extraction, context management
- Integración con APIs externas (Groq, OpenRouter, Google Calendar)
- Tests con pytest (unitarios, integración, mocking)
- Arquitectura hexagonal, separación de capas, clean code

### IA y LLMs — aplicada, no teórica
- Integración de LLMs en producción (Groq, OpenRouter)
- Prompting avanzado: system prompts, few-shot, contexto dinámico
- Selección de modelos por tarea (benchmarks reales, no marketing)
- Agentes con Aider y Claude Code para coding asistido
- Arquitectura RAG (fundamentos, implementación pendiente con mem0)
- Evaluación crítica de modelos: sabe qué modelo usar y cuándo

### Infraestructura y DevOps
- Linux/WSL administración
- Docker y Docker Compose
- GitHub Actions (CI/CD básico)
- Scripts bash de automatización
- Gestión de entornos virtuales Python
- n8n para orquestación de workflows (en roadmap Mayo 2026)

### Herramientas de desarrollo con IA
- **Aider** — agente de código en terminal con cualquier modelo
- **Claude Code** — agente que escanea repos enteros
- **Groq API** — inferencia a 750 tok/s, gratis
- **OpenRouter** — acceso a los mejores modelos gratuitos
- Conocimiento real de benchmarks: SWE-bench, LiveCodeBench, ArenaHard

---

## 🎯 Cómo se ve la búsqueda de trabajo

### El contexto del mercado en 2026

En 2026 el mercado de trabajo tech tiene tres niveles:

| Nivel | Perfil | Situación |
|---|---|---|
| ❌ Por debajo | No usa IA en su workflow | Compite en desventaja de velocidad |
| ⚠️ En el mercado | Usa ChatGPT / Copilot como herramienta | Está en el montón |
| ✅ Por encima | Ha construido sistemas de agentes propios | Perfil escaso, muy demandado |

**Álvaro está en el tercer nivel.** No es marketing — hay código en producción que lo prueba.

---

### Los tres argumentos de venta en entrevistas

#### 1. “Tengo un sistema de IA en producción real”
THDORA lleva meses en producción. No es un tutorial ni un proyecto de curso. Tiene usuarios reales (uno, él mismo, pero con datos reales), bugs reales resueltos, versiones reales, y arquitectura que ha evolucionado. Eso es más valioso que cualquier certificado.

#### 2. “Sé elegir el modelo correcto para cada tarea”
Mucha gente dice “sé usar LLMs”. Álvaro puede hablar de SWE-bench Verified, de por qué Devstral 2 (123B) bate a DeepSeek V3.2 (671B) en agentic coding, de por qué Groq es mejor que Ollama local para su caso de uso. Eso es criterio técnico real.

#### 3. “He construido agentes que trabajan para mí”
No usa herramientas IA a mano. Ha montado un ecosistema donde Aider, Claude Code y n8n trabajan en paralelo gestionando sus repos. Eso es exactamente lo que las empresas quieren construir y no saben cómo.

---

### Perfiles de trabajo que encajan perfectamente

| Puesto | Por qué encaja Álvaro |
|---|---|
| **AI Engineer / LLM Engineer** | Integración real de LLMs en producción, selección de modelos, prompting avanzado |
| **Python Backend + IA** | FastAPI + SQLAlchemy + integración LLM. Combo muy demandado en 2026 |
| **Automation Engineer** | n8n, agentes, workflows. Sabe construir sistemas que se ejecutan solos |
| **Developer Advocate / Technical** | Puede explicar IA aplicada con ejemplos reales propios. Muy escaso |
| **Full Stack con IA** | Si el frontend se añade (roadmap), perfil completo de producto con IA |

---

### Lo que hay que hacer para potenciar la búsqueda

#### Inmediato (esta semana)
- [ ] GitHub profile README que explique el ecosistema en 30 segundos
- [ ] THDORA repo con README que lo haga brillar (agente de portfolio)
- [ ] ai-toolkit README ya está bien → revisar que el link esté en el perfil de GitHub

#### Corto plazo (Mayo 2026)
- [ ] Post en LinkedIn explicando cómo funciona el ecosistema (con diagrama)
- [ ] Demo en vídeo corto (2-3 min) de THDORA funcionando en Telegram
- [ ] Repo público `toki-bot` con README y setup en 5 minutos

#### Medio plazo (Verano 2026)
- [ ] Artículo técnico en dev.to o Medium: “Cómo construir un asistente personal con Groq y Telegram por 0€”
- [ ] Contribución a un repo open source relevante (mem0, aider, CrewAI)
- [ ] Portfolio web que muestre el ecosistema visualmente

---

## 📦 Repos del ecosistema

| Repo | Visibilidad | Qué muestra |
|---|---|---|
| `thdora` | Privado | Python avanzado, arquitectura, LLMs en producción |
| `ai-toolkit` | Público | Criterio técnico, investigación verificada, sistema de agentes |
| `toki-bot` (futuro) | Público | Framework extraído de THDORA, para la comunidad |

---

## 💬 Contexto de conversaciones clave (14 abril 2026)

### Lo que se ha construido esta noche
- Documentación completa de modelos LLM verificada (Devstral 2, mem0, OpenClaw)
- Sistema de agentes definido con 5 agentes y código real
- Estrategia clara: THDORA privado → ai-toolkit público → toki-bot comunidad
- Registro de experimentos iniciado (con regla: solo lo probado de verdad)
- Este documento maestro de contexto

### Decisiones tomadas esta noche
1. THDORA y ai-toolkit son **cosas distintas** que se retroalimentan
2. ai-toolkit es el laboratorio y el motor del portfolio, no solo documentación
3. El sistema de agentes **gestiona los repos** — no hay que hacerlo todo a mano
4. La experimentación con IA **es portfolio** — cada experimento documentado es un activo
5. Todo el ecosistema junto es un **diferenciador brutal** para buscar trabajo

### Próximos pasos concretos (en orden)
1. **Mañana** — Probar Devstral 2 en Claude Code con THDORA (30 min)
2. **Esta semana** — Primer fix real con Aider + Groq en THDORA. Documentar resultado
3. **Mayo** — n8n brief diario + agente de portfolio actualizando READMEs
4. **Junio** — mem0 en THDORA + extracción al repo público
5. **Verano** — Artículo técnico + contribución open source + portfolio web

---

## ⚡ Una frase para recordar

> **Álvaro no usa IA. Álvaro ha construido un ecosistema de IA que trabaja para él.**
> Esa diferencia es exactamente lo que buscan las empresas en 2026 y casi nadie puede demostrar.

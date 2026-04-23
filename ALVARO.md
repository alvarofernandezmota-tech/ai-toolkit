# 👤 Álvaro Fernández Mota — Perfil, ecosistema y contexto maestro

> Documento maestro de contexto para todas las IAs del ecosistema.
> Lee esto antes de cualquier sesión. Última actualización: 23 abril 2026.

---

## 🧠 Quién es Álvaro

Desarrollador Python que está construyendo un ecosistema completo de IA personal — no como ejercicio académico, sino en producción real, funcionando, con datos reales de su vida.

Trabaja desde casa (Madrid) con dos máquinas que forman un solo ecosistema:
- **Ordenador grande** — GPU 6GB VRAM, Ollama local, OpenCode + LiteLLM proxy
- **Acer** — portátil ligero, accede al ordenador grande por SSH (:2222, IP: 10.202.77.228)

Las IAs no son herramientas aisladas — son un equipo que conoce sus proyectos, su forma de trabajar y sus decisiones pasadas, y que escala lo que él no puede hacer solo.

---

## 🗺️ Ecosistema de repos

### Repos principales

| Repo | Qué es | Estado |
|---|---|---|
| **thdora** | Sistema de gestión de citas + asistente IA. Bot Telegram + FastAPI + Ollama. 10 issues abiertos | ⚠️ Activo, issues pendientes |
| **ai-toolkit** | Infraestructura IA — OpenCode + Claude Code + LiteLLM + Ollama. La base de todo | ✅ Activo |
| **personal** | Vida personal — finanzas, gym, diario, ideas, tracking | ✅ Activo |
| **thea-ia** | El origen de todo el ecosistema THEA | Referencia |

### Repos secundarios

| Repo | Qué es |
|---|---|
| **AppointmentManager** | Gestor de citas (relacionado con THDORA) |
| **python-snippets** | Contenido Python para Instagram @alvarofernandezmota |
| **unix** | Apuntes SO II — formación personal |
| **ejerciciosbego** | Enseñando Python a alguien |
| **brunobailosolo** | Perfil de Bruno |

### Las 3 capas del ecosistema

```
┌────────────────────────────────────────────────────┐
│ CAPA 1: Infraestructura IA (ai-toolkit)             │
│ OpenCode + Claude Code + LiteLLM + Ollama           │
│ El cerebro compartido — CLAUDE.md, AGENTS.md        │
│ Diario de sesiones en diario/                       │
└────────────────────────────────────────────────────┘
           ↓ potencia y escala
┌────────────────────────────────────────────────────┐
│ CAPA 2: Producto principal (THDORA + thea-ia)       │
│ Bot Telegram personal en producción                 │
│ NLP con LLMs — entiende lenguaje natural            │
│ Gestión de citas + hábitos con BBDD real            │
│ 0€/mes, funcionando 24/7                            │
└────────────────────────────────────────────────────┘
           ↓ documenta y muestra
┌────────────────────────────────────────────────────┐
│ CAPA 3: Vida + formación (personal + unix)          │
│ Tracking personal, finanzas, diario                 │
│ Formación continua — SO, Python, sistemas           │
└────────────────────────────────────────────────────┘
```

---

## 🤖 Herramientas IA — cómo funciona el ecosistema

### OpenCode (ordenador grande)
- IDE con IA — ve archivos, edita, ejecuta comandos, hace commits
- Se conecta al **LiteLLM proxy** en `:8000`
- Modelos: Ollama local (qwen3:8b) → OpenRouter → resto de nube
- Usa `AGENTS.md` como contexto automático
- Ideal para: desarrollo activo, refactoring, proyectos largos

### Claude Code (Acer vía SSH)
- Agente de terminal — autónomo, tareas concretas
- Se conecta directamente a **OpenRouter** (sin proxy)
- Variable crítica: `OPENROUTER_API_KEY` en `~/.bashrc`, `unset ANTHROPIC_API_KEY`
- Usa `CLAUDE.md` como contexto automático
- Ideal para: tareas concretas, scripts, trabajar fuera de casa

### Modelos disponibles

| Modelo | Dónde | Coste | Mejor para |
|---|---|---|---|
| `qwen3:8b` | Ollama local | Gratis | Código rápido, chat |
| `qwen3-coder:free` | OpenRouter | Gratis | Código, lo mejor free |
| `llama-3.3-70b:free` | OpenRouter | Gratis | Chat general |
| `gpt-oss-120b:free` | OpenRouter | Gratis | Tareas complejas |
| `kimi-k2` | OpenRouter vía proxy | Gratis | Razonamiento MoE |

**Regla VRAM:** Solo modelos 8B o menos en Ollama local. Los 14B NO caben en 6GB.

### Contexto compartido entre herramientas
```
ai-toolkit/
├── CLAUDE.md       → contexto automático para Claude Code
├── AGENTS.md       → contexto automático para OpenCode
├── ALVARO.md       → este archivo — quién eres, tus proyectos
├── INICIO-AQUI.md  → arranque rápido por máquina
└── diario/         → memoria de sesiones (ambas herramientas la leen)
```

---

## 🛠️ Skills técnicos

### Python — nivel avanzado
- Bot Telegram con `python-telegram-bot` (async, handlers, conversations)
- API REST con FastAPI (endpoints, modelos Pydantic, middleware)
- BBDD SQLite con SQLAlchemy y migraciones
- NLP: intent classification, entity extraction, context management
- Integración con APIs externas (Groq, OpenRouter, Google Calendar)
- Tests con pytest (unitarios, integración, mocking)
- Arquitectura hexagonal, separación de capas, clean code

### IA y LLMs — aplicada, no teórica
- Integración de LLMs en producción (Groq, OpenRouter, Ollama)
- Prompting avanzado: system prompts, few-shot, contexto dinámico
- Selección de modelos por tarea (benchmarks reales, no marketing)
- Agentes con OpenCode y Claude Code para coding asistido
- Ecosistema multi-agente con LiteLLM proxy y fallbacks automáticos

### Infraestructura
- Linux/WSL administración
- Docker y Docker Compose
- tmux — sesiones multi-panel para desarrollo
- Scripts bash de automatización
- SSH entre máquinas, port forwarding
- GitHub Actions (CI/CD básico)

---

## 🎯 Objetivos actuales

### Inmediato (esta semana)
- [ ] OpenCode funcionando con LiteLLM proxy estable
- [ ] Claude Code en Acer con OpenRouter funcionando
- [ ] Primer uso real de ambas herramientas en THDORA
- [ ] Renovar keys: Groq (console.groq.com), Gemini (aistudio.google.com)

### Corto plazo (Mayo 2026)
- [ ] THDORA: cerrar los 10 issues abiertos con ayuda de IAs
- [ ] n8n para automatización de workflows
- [ ] GitHub profile README que explique el ecosistema
- [ ] Post LinkedIn con el ecosistema

### Medio plazo (Verano 2026)
- [ ] mem0 en THDORA
- [ ] Artículo técnico en dev.to/Medium
- [ ] Portfolio web visual del ecosistema

---

## 💡 Decisiones importantes tomadas

1. **OpenCode + Claude Code son un equipo**, no alternativas — cada uno tiene su rol
2. **El proxy LiteLLM** gestiona todos los modelos — Ollama primero, nube como fallback
3. **THDORA y ai-toolkit** son cosas distintas que se retroalimentan
4. **Solo modelos 8B o menos en Ollama** — 6GB VRAM es el límite real
5. **OpenRouter es el proveedor nube principal** — tiene los mejores modelos gratuitos
6. **El diario de sesiones** es la memoria del ecosistema — cada sesión importante se documenta
7. **thea-ia es el origen** — THDORA es la evolución en producción

---

## ⚡ La frase

> **Álvaro no usa IA. Álvaro ha construido un ecosistema de IA que trabaja para él.**
> Un solo cerebro compartido, dos máquinas, herramientas que se coordinan y escalan sus proyectos.

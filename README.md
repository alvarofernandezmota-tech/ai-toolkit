# 🤖 ai-toolkit

> Ecosistema personal de agentes IA — coding, investigación, automatización. Coste: $0/mes.

Stack probado y documentado para developers que quieren:
- Usar **Claude Code, OpenCode y Aider** con modelos gratuitos vía OpenRouter/Groq
- Correr **modelos locales** (Qwen2.5-Coder, DeepSeek-R1) con Ollama sin gastar APIs
- Construir agentes que trabajan en codebases reales y automatizan tareas
- Documentar todo para no perder trabajo entre sesiones

Todo lo que hay aquí está probado y corriendo en producción.

---

## 🚀 Quick start

```bash
git clone https://github.com/alvarofernandezmota-tech/ai-toolkit
cd ai-toolkit
git pull                              # SIEMPRE antes de arrancar
bash scripts/health-check.sh         # semáforo: qué proveedores funcionan
bash scripts/ai-menu.sh              # menú interactivo con todo el stack
```

Necesitas al menos una key gratuita:
- `OPENROUTER_API_KEY` → [openrouter.ai](https://openrouter.ai) (gratis — la más importante)
- `GROQ_API_KEY` → [console.groq.com](https://console.groq.com) (gratis — fallback rápido)
- `CEREBRAS_API_KEY` → [cloud.cerebras.ai](https://cloud.cerebras.ai) (gratis)
- `GOOGLE_GENERATIVE_AI_API_KEY` → [aistudio.google.com](https://aistudio.google.com) (gratis)

---

## 🏗️ El stack

```
PC (WSL Ubuntu)
 │
 ├── Claude Code                  ← agente principal — cd repo && claude
 │   └── OpenRouter (:443)            ANTHROPIC_BASE_URL=https://openrouter.ai/api/v1
 │       ├── claude-sonnet-4-5 (principal)
 │       └── devstral-2:free / llama-4-maverick:free (fallback)
 │
 ├── OpenCode                     ← agente TUI — bash scripts/opencode-rotate.sh
 │   ├── devstral-2:free (principal)
 │   ├── qwen3-coder-480b:free
 │   ├── deepseek-r1:free
 │   └── Ollama local (fallback sin internet)
 │
 ├── LiteLLM Colmena (:8000)      ← solo para benchmark/ensemble multi-modelo
 │   bash scripts/start-colmena.sh
 │
 └── Ollama local (:11434)        ← sin internet, sin coste
     ├── qwen2.5-coder:14b
     ├── deepseek-r1:14b
     └── nomic-embed-text
```

Coste nube: $0/mes. CPU idle: <1%. Para uso diario no necesitas LiteLLM.

---

## 📁 Estructura del repositorio

```
ai-toolkit/
├── CLAUDE.md                   ← instrucciones para Claude Code (leer al arrancar)
├── INICIO-AQUI.md              ← brújula personal — leer al empezar cada sesión
├── COMO-PROCEDEMOS.md          ← flujo de trabajo, reglas
├── CHANGELOG.md                ← historial: éxitos, errores, pendientes
├── ROADMAP.md                  ← qué viene, qué está en curso
├── README.md                   ← este archivo
│
├── scripts/                    ← scripts de arranque y utilidades
│   ├── ai-menu.sh              ← 🎮 menú interactivo 12 opciones — punto de entrada principal
│   ├── health-check.sh         ← 🩺 semáforo de APIs — 1º paso de cada sesión
│   ├── opencode-rotate.sh      ← OpenCode con rotación automática de modelos
│   ├── start-colmena.sh        ← arranque LiteLLM (solo para benchmark)
│   ├── ensemble.sh             ← mismo prompt a varios modelos en paralelo
│   ├── generar-diario.sh       ← genera entrada de diario desde git log + IA
│   └── benchmark-runner.sh     ← comparativa de modelos automática
│
├── guias/                      ← guías de setup paso a paso
├── docs/                       ← documentación técnica estable
├── agentes/                    ← agentes documentados y validados
├── prompts/                    ← prompts reutilizables
├── investigacion/              ← research verificado con fuentes
└── pruebas/                    ← laboratorio: todo lo que probamos
```

---

## 🩺 Health Check (antes de cada sesión)

```bash
bash scripts/health-check.sh          # ping rápido a todos los proveedores
bash scripts/health-check.sh --full   # test con llamada real de chat
bash scripts/health-check.sh --fix    # muestra comandos de arreglo
```

Semáforo:
- ✓ verde → proveedor operativo
- ⚠ amarillo → rate limit o servicio no levantado
- ✗ rojo → key inválida o caducada

---

## ☁️ Modelos nube gratuitos (via OpenRouter)

| Modelo | Uso principal | SWE-bench |
|--------|--------------|----------|
| `mistralai/devstral-2:free` | Coding agentic (principal OpenCode) | 72.2% |
| `anthropic/claude-sonnet-4-5` | Claude Code (via OpenRouter) | — |
| `qwen/qwen3-coder-480b:free` | Coding alternativa | top open-source |
| `deepseek/deepseek-r1:free` | Razonamiento / arquitectura | — |
| `meta-llama/llama-4-maverick:free` | Fallback general | — |
| `meta-llama/llama-3.3-70b-versatile` | Fallback rápido (Groq) | — |

---

## 🧠 Modelos locales (Ollama)

| Modelo | Tamaño | Uso |
|--------|--------|-----|
| `qwen2.5-coder:14b` | 9.0 GB | Código potente |
| `qwen2.5-coder:7b` | 4.7 GB | Código rápido |
| `deepseek-r1:14b` | 9.0 GB | Razonamiento profundo |
| `nomic-embed-text` | 274 MB | RAG / embeddings |

Ver guía completa: [`guias/opencode-ollama.md`](./guias/opencode-ollama.md)

---

## 🔥 Errores conocidos y soluciones

**Puerto 8000 ocupado:**
```bash
lsof -ti:8000 | xargs kill -9
```

**Ollama no responde:**
```bash
ollama serve &
```

**Claude Code — modelo no encontrado en OpenRouter:**
```bash
claude --model anthropic/claude-3.5-sonnet
# o con modelo gratuito:
claude --model openrouter/meta-llama/llama-4-maverick:free
```

**OpenRouter 401 (key inválida):**
```bash
# Rotar key en openrouter.ai/settings/keys
export OPENROUTER_API_KEY="nueva_key"
source ~/.bashrc
```

Ver diagnóstico completo: [`docs/errores-frecuentes.md`](./docs/errores-frecuentes.md)

---

## 🗺️ Próximos pasos

- [ ] Probar Claude Code sobre bugs THDORA (ver `agentes/thdora-primera-sesion.md`)
- [ ] Ejecutar `bash scripts/benchmark-runner.sh` con nuevos modelos
- [ ] Renovar key Groq si caduca → [console.groq.com/keys](https://console.groq.com/keys)

Ver roadmap completo: [`ROADMAP.md`](./ROADMAP.md)

---

## 🤝 Contribuir

Toolkit personal construido en público. Si algo funciona para ti, abre un PR. Si algo está roto, abre un issue.

---

*Construido y mantenido por [Álvaro Fernández Mota](https://github.com/alvarofernandezmota-tech) · Actualizado 22 abril 2026*

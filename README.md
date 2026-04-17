# 🤖 ai-toolkit

> Ecosistema personal de agentes IA — coding, investigación, automatización. Coste: $0/mes.

Stack probado y documentado para developers que quieren:
- Usar **OpenCode, Claude Code y Aider** con modelos gratuitos vía OpenRouter/Groq/Cerebras
- Correr **modelos locales** (Qwen3, DeepSeek, Qwen2.5-Coder) con Ollama sin gastar APIs
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
bash scripts/start-colmena.sh        # levanta LiteLLM + Ollama
opencode                              # agente de coding
```

Necesitas al menos una key gratuita:
- `GROQ_API_KEY` → [console.groq.com](https://console.groq.com) (gratis)
- `OPENROUTER_API_KEY` → [openrouter.ai](https://openrouter.ai) (gratis)
- `CEREBRAS_API_KEY` → [cloud.cerebras.ai](https://cloud.cerebras.ai) (gratis)
- `GOOGLE_GENERATIVE_AI_API_KEY` → [aistudio.google.com](https://aistudio.google.com) (gratis)

---

## 🏗️ El stack

```
PC grande (WSL Ubuntu + GTX 1060 6GB)
 │
 ├── LiteLLM Colmena (:8000)     ← proxy unificado para todos los proveedores
 │   ├── Cerebras (principal — verificado ✅)
 │   ├── OpenRouter (fallback — llama-4-maverick, qwen3-235b)
 │   ├── Google Gemini (fallback)
 │   ├── Groq (renovar key pendiente)
 │   └── DeepSeek (renovar key pendiente)
 │
 ├── Ollama local (:11434)        ← modelos sin internet, sin coste
 │   ├── qwen3:8b-q4_K_M         (5.2 GB — thinking general)
 │   ├── qwen2.5-coder:7b        (4.7 GB — código rápido)
 │   ├── qwen2.5-coder:14b       (9.0 GB — código potente)
 │   ├── deepseek-r1:14b         (9.0 GB — razonamiento profundo)
 │   └── nomic-embed-text        (274 MB — RAG/embeddings)
 │
 └── OpenCode                    ← agente de coding apuntando a todo lo anterior
```

Coste nube: $0/mes. CPU idle: <1%. RAM proxy: ~370 MB.

---

## 📁 Estructura del repositorio

```
ai-toolkit/
├── COMO-PROCEDEMOS.md          ← flujo de trabajo, reglas, cómo hacemos todo
├── CHANGELOG.md                ← historial: éxitos, errores, pendientes
├── ROADMAP.md                  ← qué viene, qué está en curso
├── README.md                   ← este archivo
│
├── scripts/                    ← scripts de arranque y utilidades
│   ├── health-check.sh         ← 🩺 semáforo de APIs (NUEVO) — úsalo al arrancar
│   ├── start-colmena.sh        ← arranque principal (tmux + LiteLLM + OpenCode)
│   ├── generar-diario.sh       ← genera entrada de diario desde git log + IA
│   ├── opencode-rotate.sh      ← rotar modelos en OpenCode
│   ├── claude-rotate.sh        ← rotar modelos en Claude Code
│   ├── check-colmena.sh        ← diagnóstico de la colmena
│   ├── benchmark-runner.sh     ← comparativa de modelos
│   └── ai-menu.sh              ← menú principal interactivo
│
├── guias/                      ← guías de setup paso a paso
│   ├── opencode-ollama.md      ← OpenCode con modelos locales vía Ollama (NUEVO)
│   ├── opencode-deepseek.md
│   ├── litellm-colmena.md
│   ├── modelos-thinking.md
│   └── modelos-por-hardware.md
│
├── docs/                       ← documentación técnica estable
│   ├── arranque-rapido.md
│   ├── troubleshooting-proveedores.md
│   └── dependencias.md
│
├── agentes/                    ← agentes documentados y validados
├── prompts/                    ← prompts reutilizables
├── investigacion/              ← research verificado con fuentes
├── pruebas/                    ← laboratorio: todo lo que probamos
│
└── opensource/                 ← preparado para publicar a la comunidad
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

## 🧪 Modelos locales (Ollama)

| Modelo | Tamaño | VRAM | Uso |
|--------|--------|------|-----|
| `qwen3:8b-q4_K_M` | 5.2 GB | Cabe entero | Chat + thinking general |
| `qwen2.5-coder:7b` | 4.7 GB | Cabe entero | Código rápido |
| `qwen2.5-coder:14b` | 9.0 GB | VRAM+RAM offload | Código potente |
| `deepseek-r1:14b` | 9.0 GB | VRAM+RAM offload | Razonamiento profundo |
| `nomic-embed-text` | 274 MB | Mínimo | RAG / embeddings |

Ver guía completa: [`guias/opencode-ollama.md`](./guias/opencode-ollama.md)

---

## ☁️ Modelos nube (via LiteLLM proxy)

| Alias | Modelo real | Proveedor | Estado |
|-------|-------------|----------|--------|
| `principal` | gpt-oss-120b (multi-fallback) | Cerebras | ✅ operativo |
| `llama-4-maverick` | llama-4-maverick | OpenRouter | ✅ operativo |
| `gemini-flash` | gemini-2.0-flash | Google | ✅ (rate limit a veces) |
| `qwen3-235b` | qwen3-235b-a22b | OpenRouter | ✅ operativo |
| `llama-groq` | llama-3.3-70b-versatile | Groq | ⚠ renovar key |
| `deepseek-r1` | deepseek-reasoner | DeepSeek | ⚠ renovar key |
| `local` | qwen3:8b (Ollama) | Local | ✅ sin coste |
| `ollama-coder` | qwen2.5-coder:14b (Ollama) | Local | ✅ sin coste |

---

## 🔥 Errores conocidos y soluciones

**git pull bloqueado por opencode.json local:**
```bash
git checkout -- opencode.json && git pull
```

**Puerto 8000 ocupado (uvicorn de otro proyecto):**
```bash
lsof -ti:8000 | xargs kill -9
```

**Ollama no responde:**
```bash
ollama serve &
```

**LiteLLM proxy no levanta:**
```bash
bash scripts/start-colmena.sh
```

Ver diagnóstico completo: [`docs/troubleshooting-proveedores.md`](./docs/troubleshooting-proveedores.md)

---

## 🗺️ Próximos pasos (ROADMAP)

- [ ] Renovar key Groq → [console.groq.com/keys](https://console.groq.com/keys)
- [ ] Renovar key DeepSeek → [platform.deepseek.com](https://platform.deepseek.com)
- [ ] Primer uso real de Claude Code sobre bugs THDORA
- [ ] Integrar `opencode-rotate.sh` en `ai-menu.sh`
- [ ] Sistema de diario automático con `generar-diario.sh`

Ver roadmap completo: [`ROADMAP.md`](./ROADMAP.md)

---

## 🤝 Contribuir

Toolkit personal construido en público. Si algo funciona para ti, abre un PR. Si algo está roto, abre un issue.

---

*Construido y mantenido por [Álvaro Fernández Mota](https://github.com/alvarofernandezmota-tech) · Abril 2026*

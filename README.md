# 🤖 ai-toolkit

> Ecosistema personal de agentes IA — coding, investigación, automatización. Coste: $0/mes.

Stack probado y documentado para developers que quieren:
- Usar **OpenCode, Claude Code y Aider** con modelos gratuitos vía OpenRouter/Groq
- Correr **modelos locales** (Qwen3, DeepSeek, Qwen2.5-Coder) con Ollama sin gastar APIs
- Construir agentes que trabajan en codebases reales y automatizan tareas
- Documentar todo para no perder trabajo entre sesiones

Todo lo que hay aquí está probado y corriendo en producción.

---

## 🚀 Quick start

```bash
git clone https://github.com/alvarofernandezmota-tech/ai-toolkit
cd ai-toolkit
git pull                          # SIEMPRE antes de arrancar
bash scripts/start-colmena.sh
```

Necesitas al menos una key gratuita:
- `GROQ_API_KEY` → [console.groq.com](https://console.groq.com) (gratis)
- `OPENROUTER_API_KEY` → [openrouter.ai](https://openrouter.ai) (gratis)
- `GOOGLE_GENERATIVE_AI_API_KEY` → [aistudio.google.com](https://aistudio.google.com) (gratis)

---

## 🏗️ El stack

```
PC grande (WSL Ubuntu + GTX 1060 6GB)
 │
 ├── LiteLLM Colmena (:8000)     ← proxy unificado para todos los proveedores
 │   ├── Google Gemini (gratis)
 │   ├── Groq / Cerebras (gratis, rápido)
 │   ├── OpenRouter (gratis)
 │   └── DeepSeek / Mistral / etc
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
├── COMO-PROCEDEMOS.md      ← flujo de trabajo, reglas, cómo hacemos todo
├── CHANGELOG.md            ← historial: éxitos, errores, pendientes
├── README.md               ← este archivo
│
├── scripts/                ← scripts de arranque y utilidades
│   ├── start-colmena.sh    ← arranque principal (tmux + LiteLLM + OpenCode)
│   ├── opencode-rotate.sh  ← rotar modelos
│   └── ...
│
├── docs/                   ← documentación técnica estable
│   ├── arranque-rapido.md
│   └── setup-servidor-ssh-wsl.md
│
├── pruebas/                ← laboratorio: todo lo que probamos (éxitos y errores)
│   ├── opencode/
│   ├── ollama/
│   ├── agentes/
│   └── modelos/
│
├── agentes/                ← agentes documentados y validados
├── guias/                  ← guías de setup paso a paso
├── prompts/                ← prompts reutilizables
├── investigacion/          ← research verificado con fuentes
│
└── opensource/             ← preparado para publicar a la comunidad
```

---

## 🧪 Modelos locales (Ollama)

| Modelo | Tamaño | VRAM | Uso |
|--------|--------|------|-----|
| `qwen3:8b-q4_K_M` | 5.2 GB | Cabe entero | Chat + thinking general |
| `qwen2.5-coder:7b` | 4.7 GB | Cabe entero | Código rápido |
| `qwen2.5-coder:14b` | 9.0 GB | VRAM+RAM offload | Código potente |
| `deepseek-r1:14b` | 9.0 GB | VRAM+RAM offload | Razonamiento profundo |
| `nomic-embed-text` | 274 MB | Mínimo | RAG / embeddings |

---

## ☁️ Modelos nube gratuitos

| Alias | Modelo real | Proveedor |
|-------|-------------|----------|
| `principal` | cerebras-3.3-70b (multi-fallback) | Cerebras/Groq |
| `gemini-pro` | gemini-2.5-pro-exp | Google |
| `gemini-flash` | gemini-2.0-flash | Google |
| `llama-4-maverick` | llama-4-maverick | Meta/OpenRouter |
| `qwen3-235b` | qwen3-235b-a22b | Alibaba/OpenRouter |
| `deepseek-r1` | deepseek-reasoner | DeepSeek |
| `codestral` | codestral-latest | Mistral |

---

## 🔥 Errores conocidos y soluciones

**Error openclaw al abrir terminal:**
```bash
mkdir -p ~/.openclaw/completions && touch ~/.openclaw/completions/openclaw.bash
```

**git pull bloqueado por opencode.json local:**
```bash
git checkout -- opencode.json && git pull
```

**OpenCode no abre solo en tmux:** lanzar desde fuera de tmux o abrir manualmente en panel izquierdo.

Ver más en [`pruebas/`](./pruebas/) con todos los errores documentados.

---

## 🤝 Contribuir

Toolkit personal construido en público. Si algo funciona para ti, abre un PR. Si algo está roto, abre un issue.

---

*Construido y mantenido por [Álvaro Fernández Mota](https://github.com/alvarofernandezmota-tech) · Abril 2026*

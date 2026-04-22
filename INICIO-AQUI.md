# 🧭 INICIO AQUÍ — La brújula del ecosistema

> Lee esto al principio de cada sesión. Tiene todo lo que necesitas para arrancar.
> Última actualización: 22 abril 2026

---

## ¿Qué es esto?

Este repo es el **cerebro del ecosistema**. Aquí se documenta todo lo que se construye, se prueba y se aprende. El objetivo es tener agentes de IA trabajando en paralelo mientras yo (Alvaro) tomo decisiones de alto nivel.

**Arquitectura objetivo:**
```
Alvaro + Claude.ai (chat)      →  estrategia, diseño, decisiones
        ↓
OpenCode + LiteLLM (terminal)  →  ejecución, código, commits
        ↓
Agentes especializados          →  tareas concretas en paralelo
```

---

## ▶️ Arranque en 3 pasos (cada sesión)

```bash
# 1. Ir al proyecto y actualizar
cd ~/projects/ai-toolkit && git pull

# 2. Diagnóstico rápido — ¿qué APIs funcionan hoy?
bash scripts/health-check.sh

# 3. Arrancar la colmena completa
bash scripts/start-colmena.sh
```

> Si hay fallos en el health check: `bash scripts/health-check.sh --fix`
> Sin tmux: `bash scripts/start-colmena.sh --solo-proxy`

---

## 📊 Estado del stack — 22 Abril 2026

| Componente | Estado | Notas |
|---|---|---|
| LiteLLM proxy | ✅ Funcionando | puerto 8000, 20 modelos |
| OpenCode | ✅ Funcionando | v1.4.6 |
| Claude Code | ✅ Instalado | v2.1.108 |
| Ollama (local) | ✅ Configurado | necesita `ollama serve` |
| health-check.sh | ✅ Activo | diagnóstico antes de cada sesión |
| ensemble.sh | ✅ Activo | comparar modelos en paralelo |
| benchmark-runner.sh | ✅ Activo | rellena comparativa-llms.md solo |
| generar-diario.sh | ✅ Activo | diario automático desde git log |
| ai-menu.sh | ✅ Nuevo S16 | menú interactivo 12 opciones |
| start-colmena.sh | ✅ Fix E1 | busca litellm sin depender de thdora |
| THDORA API | ⚠️ Conflicto puerto 8000 | matar antes de litellm |
| n8n | ⏳ Mayo 2026 | Docker documentado |

**Modelos activos:**
- Principal: Cerebras gpt-oss-120b (→ OpenRouter fallback)
- Local: Ollama gemma3:4b (necesita `ollama serve`)
- Groq: ⚠️ renovar key en console.groq.com
- DeepSeek: ⚠️ renovar key en platform.deepseek.com

---

## 🤖 Modelos disponibles en LiteLLM

| Alias OpenCode | Modelo real | Gratis | Estado |
|---|---|---|---|
| `principal` | Cerebras gpt-oss-120b | ✅ | Activo |
| `local` | Ollama gemma3:4b | ✅ | Requiere ollama serve |
| `ollama-coder` | Ollama qwen2.5-coder:7b | ✅ | Requiere download |
| `ollama-r1` | Ollama deepseek-r1:8b | ✅ | Requiere download |
| `gemini-flash` | gemini/gemini-2.0-flash | ✅ limitado | 429 si hay rate limit |
| `gemini-pro` | gemini/gemini-2.5-pro-exp | ✅ limitado | 429 si hay rate limit |
| `deepseek-r1` | deepseek/deepseek-reasoner | 💳 barato | ⚠️ renovar key |
| `claude-sonnet` | anthropic/claude-3-5-sonnet | 💳 | Disponible |
| `gpt-4o` | openai/gpt-4o | 💳 | Disponible |
| `qwen3-235b` | Cerebras qwen-3-235b | ✅ | Activo |
| `openrouter-fallback` | llama-4-maverick via OR | ✅ | Activo |

Cambiar modelo en OpenCode: `Ctrl+P` → escribir `model`

---

## 🛠️ Scripts disponibles

| Script | Para qué | Cuándo usarlo |
|---|---|---|
| `health-check.sh` | Semáforo de APIs | **Primer paso de cada sesión** |
| `health-check.sh --fix` | Ver cómo arreglar fallos | Cuando algo da rojo |
| `start-colmena.sh` | Arrancar LiteLLM + OpenCode | Cada sesión |
| `start-colmena.sh --solo-proxy` | Solo LiteLLM, sin tmux | Sin tmux instalado |
| `ensemble.sh "prompt"` | Mismo prompt → varios modelos | Decisiones de arquitectura |
| `ensemble.sh --save` | ídem + guarda en investigacion/ | Investigación formal |
| `benchmark-runner.sh` | Rellenar comparativa-llms.md | Semanal |
| `generar-diario.sh` | Diario automático desde git log | Al acabar sesión |
| `ai-menu.sh` | Menú interactivo con todo | Cuando no recuerdas los comandos |
| `opencode-rotate.sh` | Mejor modelo disponible | Alternativa a start-colmena |

---

## ⚠️ Problemas conocidos y soluciones

### Puerto 8000 ocupado (thdora u otro)
```bash
lsof -i :8000
kill -9 <PID>
```

### Google 429 (quota agotada)
Usar `cerebras-fallback` o `openrouter-fallback` en OpenCode (`Ctrl+P → model`).

### Groq 401 (key caducada)
```bash
# 1. Renovar en: https://console.groq.com/keys
# 2. Actualizar ~/.bashrc:
export GROQ_API_KEY="nueva_key"
source ~/.bashrc
```

### Ollama no arranca
```bash
ollama serve &   # arrancar en background
ollama list      # ver modelos descargados
ollama pull gemma3:4b  # si no hay ninguno
```

### OpenCode muestra modelo incorrecto
- Verificar `opencode.json` en la raíz del repo
- El campo `models` dentro del provider es obligatorio

---

## 📂 Mapa del repo

```
ai-toolkit/
├── INICIO-AQUI.md           ← estás aquí
├── ROADMAP.md               ← qué hay que construir
├── CHANGELOG.md             ← qué se ha hecho y cuándo
├── ECOSISTEMA.md            ← visión grande del sistema
├── .env.example             ← plantilla de keys (copia a .env)
├── .gitignore               ← excluye .env, keys, logs, aider
├── litellm-config.yaml      ← proxy con 20 modelos + Ollama
├── opencode.json            ← config OpenCode con todos los aliases
├── docs/
│   ├── errores-frecuentes.md
│   ├── troubleshooting-proveedores.md
│   └── diario/              ← generados por generar-diario.sh
├── investigacion/
│   ├── comparativa-llms.md  ← rellena benchmark-runner.sh
│   ├── ensemble/            ← comparaciones guardadas
│   └── benchmark-results/   ← resultados individuales
├── agentes/
│   ├── PENDIENTES.md
│   └── thdora-primera-sesion.md
└── scripts/
    ├── health-check.sh      ← diagnóstico APIs
    ├── ensemble.sh          ← comparar modelos
    ├── benchmark-runner.sh  ← benchmark automático
    ├── generar-diario.sh    ← diario desde git log
    ├── start-colmena.sh     ← arranque tmux (fix E1)
    ├── ai-menu.sh           ← menú interactivo 12 opciones
    └── opencode-rotate.sh   ← rotación de modelos
```

---

## 🎯 Flujo de trabajo ideal

```
1. git pull                 →  sincronizar
2. health-check.sh          →  ver qué APIs funcionan hoy
3. start-colmena.sh         →  arrancar LiteLLM + OpenCode
4. [trabajar]
5. generar-diario.sh        →  documentar lo hecho
6. git push                 →  guardar todo
```

**Regla de oro:** todo lo que se aprende, se falla o se construye va en el repo.

---

*Última actualización: 22 abril 2026 — auditoría S16 completa (10 fixes)*

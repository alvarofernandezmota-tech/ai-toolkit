# 🤖 Agentes de Coding en Terminal — Guía Completa

> Cómo subir de nivel en programación usando agentes IA que leen tu repo, editan ficheros y hacen commits. Coste = 0€.

---

## El concepto

Un agente de coding necesita dos piezas:
1. **El agente** — programa que lee tu repo, entiende contexto, edita ficheros
2. **El modelo** — el cerebro IA que genera el código (puede ser local o vía API)

Tú sigues siendo el que decide. El agente es el que pica código.

---

## Nivel 1 — Aider + Groq (entrada recomendada)

**Por qué empezar aquí:** Si ya tienes Groq configurado (THDORA lo usa), en 2 minutos tienes un agente corriendo. Llama3.3-70b en Groq es rapidísimo y gratis.

```bash
pip install aider-chat

# Usa tu key de Groq existente
export GROQ_API_KEY=tu_key_de_groq

# Entrar en tu repo
cd ~/projects/thdora
aider --model groq/llama-3.3-70b-versatile
```

### Comandos útiles dentro de Aider
```
> /add src/bot/handlers/config.py    # añade fichero al contexto
> /add COMO_PROCEDER.md              # añade docs al contexto
> fix el issue #10, añade asyncio.wait_for con timeout=5.0 en _show_hab_configs
> crea un test unitario para el handler de borrar cita
> refactoriza este handler para que use rsplit en vez de split
```

### Limitaciones
- Contexto limitado (no carga el repo entero solo, hay que añadir ficheros manualmente)
- Llama3 es bueno pero no al nivel de Claude/GPT4 para razonamiento complejo
- Tu máquina puede ir lenta si combinas con Ollama local simultáneamente

---

## Nivel 2 — Claude Code + OpenRouter (más potencia, sigue gratis)

**Por qué subir aquí:** Claude Code escanea el repo entero automáticamente, entiende proyectos grandes de una, y tiene mejor razonamiento para arquitectura.

### Requisitos
```bash
node --version   # necesitas Node.js instalado
npm --version
```

Si no tienes Node en WSL:
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### Instalación
```bash
npm install -g @anthropic-ai/claude-code
```

### Apuntarlo a OpenRouter (gratis)
```bash
# En tu .bashrc o .zshrc para que persista
export ANTHROPIC_BASE_URL=https://openrouter.ai/api/v1
export ANTHROPIC_API_KEY=tu_key_de_openrouter  # openrouter.ai, sin tarjeta

# Arrancar
cd ~/projects/thdora
claude
```

### Modelos gratuitos recomendados en OpenRouter
| Modelo | Para qué | Comando |
|---|---|---|
| `google/gemma-3-27b-it:free` | Código Python, general | `--model google/gemma-3-27b-it:free` |
| `meta-llama/llama-3.3-70b-instruct:free` | Razonamiento, arquitectura | `--model meta-llama/llama-3.3-70b-instruct:free` |
| `mistralai/mistral-7b-instruct:free` | Rápido, tareas simples | `--model mistralai/mistral-7b-instruct:free` |
| `openrouter/auto` | Rota automáticamente | `--model openrouter/auto` |

### Uso en THDORA
```
> explica qué hace _show_hab_configs y dónde está el bug del timeout
> implementa el fix del issue #10
> pasa el checklist de COMO_PROCEDER.md y dime qué falla
> refactoriza keyboards.py para el menú unificado
```

---

## Nivel 3 — OpenCode (TUI avanzada, 75+ proveedores)

**Por qué subir aquí:** Interfaz TUI completa en terminal, soporta 75+ proveedores de modelos, LSP integrado para mejor comprensión del código.

```bash
# Instalación
npm install -g opencode-ai

# O con npx sin instalar
npx opencode-ai
```

Más info: [opencode.ai](https://opencode.ai)

---

## Comparativa

| | Aider + Groq | Claude Code + OpenRouter | OpenCode |
|---|---|---|---|
| **Dificultad setup** | ⭐ Muy fácil | ⭐⭐ Fácil | ⭐⭐ Fácil |
| **Contexto repo** | Manual (añades ficheros) | Automático completo | Automático |
| **Velocidad** | 🔥 Muy rápido (Groq) | Media | Media |
| **Calidad código** | Buena | Muy buena | Buena |
| **Coste** | 0€ | 0€ | 0€ |
| **Requisitos** | Solo Python | Node.js | Node.js |
| **Cuándo usarlo** | Empezar ya | Proyectos medianos-grandes | Alternativa a Claude Code |

---

## Flujo de trabajo recomendado con THDORA

```
Yo (Perplexity/chat)     → Planificar, entender conceptos, revisar arquitectura
Aider / Claude Code      → Ejecutar: editar ficheros, crear tests, hacer commits
Tú                       → Revisar diffs, decidir qué entra, hacer git push
```

**El combo:** Chat para pensar, agente para hacer.

---

## Proyectos donde aplicarlo
- [thdora](https://github.com/alvarofernandezmota-tech/thdora) — fix issue #10, menú unificado, tests
- [image-calculator](https://github.com/alvarofernandezmota-tech/image-calculator) — refactorizaciones
- [personal](https://github.com/alvarofernandezmota-tech/personal) — scripts de automatización

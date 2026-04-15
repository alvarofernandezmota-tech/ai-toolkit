# CLAUDE.md

Este fichero proporciona contexto a Claude Code cuando trabaja en este repositorio.

---

## ⚡ Comandos rápidos

```bash
# Claude Code con rotación automática de modelos (RECOMENDADO)
cc

# Aider con rotación automática de modelos Groq
bash ~/projects/ai-toolkit/scripts/aider-rotate.sh

# Ver qué modelo está activo ahora
cat ~/.claude/settings.json

# Ver log de rotaciones de Claude Code
cat ~/.claude/rotate.log

# Ver log de rotaciones de Aider
cat ~/.aider/rotate.log

# Forzar un modelo concreto en Claude Code
claude --model deepseek/deepseek-r1:free
```

---

## Comandos de desarrollo habituales

### 1. Configuración del entorno

```bash
# Instalar dependencias base
sudo apt-get install curl wget git unzip build-essential python3.11 python3.11-dev

# Configurar Python
curl -sS https://bootstrap.pypa.io/get-pip.py | python3

# Instalar Node.js
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Instalar Claude Code
npm install -g @anthropic-ai/claude-code
```

### 2. Lanzar agentes

```bash
# Claude Code con rotación automática (alias)
cc

# Claude Code con modelo específico
claude --model deepseek/deepseek-r1:free

# Aider con rotación automática
bash ~/projects/ai-toolkit/scripts/aider-rotate.sh

# Aider con modelo específico
aider --model groq/llama-3.3-70b-versatile
```

### 3. Modelos disponibles — OpenRouter (Claude Code)

| Modelo | ID exacto | Para qué |
|---|---|---|
| DeepSeek R1 | `deepseek/deepseek-r1:free` | Razonamiento profundo |
| Qwen3 235B | `qwen/qwen3-235b-a22b:free` | Código avanzado |
| Llama 4 Maverick | `meta-llama/llama-4-maverick:free` | Código del día a día |
| Gemini 2.5 Pro | `google/gemini-2.5-pro-exp-03-25:free` | Arquitectura |
| GPT-4o Mini | `openai/gpt-4o-mini:free` | Agente rápido |
| Llama 3.3 70B | `meta-llama/llama-3.3-70b-instruct:free` | Fallback final |

### 4. Modelos disponibles — Groq (Aider)

| Modelo | ID exacto | Para qué |
|---|---|---|
| Llama 3.3 70B | `groq/llama-3.3-70b-versatile` | Código rápido (principal) |
| Llama 3.1 70B | `groq/llama-3.1-70b-versatile` | Fallback |
| Mixtral 8x7B | `groq/mixtral-8x7b-32768` | Contexto largo |
| Gemma2 9B | `groq/gemma2-9b-it` | Ligero y rápido |

---

## Arquitectura del ecosistema

### Estructura de directorios

```
ai-toolkit/
├── docs/           → Documentación generada y sesiones de trabajo
│   ├── ecosystem-structure.md      → Estructura ideal del ecosistema
│   └── sesion-15-abril-2026.md    → Resumen de sesión
├── setup/          → Configuraciones y guías de instalación
│   ├── claude-code-openrouter.md   → Claude Code + OpenRouter
│   ├── aider-groq.md               → Aider + Groq
│   ├── cuentas-y-keys.md          → Keys y cuentas necesarias
│   ├── n8n-docker-wsl.md          → n8n con Docker en WSL
│   ├── ollama.md                  → Modelos locales
│   └── tmux-ecosistema.md         → Terminal multipanel
├── agentes/        → Implementaciones y workflows de agentes
├── guias/          → Documentación de modelos y benchmarks
├── investigacion/  → Experimentos reproducibles
├── scripts/        → Scripts de automatización
│   ├── claude-rotate.sh           → Rotación de modelos Claude Code
│   └── aider-rotate.sh            → Rotación de modelos Aider
├── CLAUDE.md       → Este fichero
├── ECOSISTEMA.md   → Visión general del ecosistema
└── README.md       → Punto de entrada
```

### Agentes del ecosistema

- **Claude Code** — Agente principal para análisis de repos y arquitectura. Usa OpenRouter gratis con rotación.
- **Aider** — Fixes rápidos y tareas concretas de implementación. Usa Groq con rotación.
- **n8n** — Orquestación de workflows automáticos.
- **THDORA** — Bot personal de Telegram para gestión rutinaria.

### Flujo de trabajo

1. Las keys se guardan en `~/.bashrc` — nunca en GitHub
2. `~/.claude/settings.json` lo gestiona `claude-rotate.sh` automáticamente
3. Cada proyecto mantiene aislamiento pero comparte los modelos del ecosistema
4. Los resultados de investigación alimentan directamente las implementaciones

---

## Configuración base de Claude Code

`~/.claude/settings.json` (gestionado por `claude-rotate.sh`):
```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://openrouter.ai/api/v1",
    "ANTHROPIC_AUTH_TOKEN": "sk-or-v1-TU_KEY",
    "ANTHROPIC_API_KEY": "",
    "ANTHROPIC_MODEL": "deepseek/deepseek-r1:free"
  }
}
```

---

## Reglas importantes

- ⚠️ Las keys NUNCA van en GitHub — solo en `~/.bashrc` o `~/.claude/settings.json` local
- Usar `cc` siempre en vez de `claude` para aprovechar la rotación
- Usar `aider-rotate.sh` en vez de `aider` directamente
- Documentar cada sesión en `docs/sesion-DD-mes-YYYY.md`
- El primer comando en cualquier repo nuevo es `bash setup.sh`

---

_Última actualización: 15 abril 2026_

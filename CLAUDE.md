# CLAUDE.md

Este fichero proporciona contexto a Claude Code cuando trabaja en este repositorio.

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
# Claude Code con modelo automático gratis
claude

# Claude Code con modelo específico
claude --model openrouter/google/gemini-2.5-pro-exp-03-25

# Aider con Groq
aider --model groq/llama-3.3-70b-versatile
```

### 3. Modelos disponibles (OpenRouter gratis)

| Modelo | ID exacto | Para qué |
|---|---|---|
| Auto (recomendado) | `openrouter/free` | Elige el mejor disponible |
| DeepSeek R1 | `openrouter/deepseek/deepseek-r1:free` | Razonamiento profundo |
| Llama 4 Maverick | `openrouter/meta-llama/llama-4-maverick:free` | Código del día a día |
| GPT-OSS 20B | `openrouter/openai/gpt-oss-20b:free` | Agente rápido |
| Qwen 3 235B | `openrouter/qwen/qwen3-235b-a22b:free` | Código avanzado |
| Gemini 2.5 Pro | `openrouter/google/gemini-2.5-pro-exp-03-25` | Arquitectura y refactorizaciones |

---

## Arquitectura del ecosistema

### Estructura de directorios

```
ai-toolkit/
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
├── CLAUDE.md       → Este fichero
├── ECOSISTEMA.md   → Visión general del ecosistema
└── README.md       → Punto de entrada
```

### Agentes del ecosistema

- **Claude Code** — Agente principal para análisis de repos y commits. Usa OpenRouter gratis.
- **Aider** — Fixes rápidos y tareas concretas de implementación. Usa Groq (ultra rápido).
- **n8n** — Orquestación de workflows automáticos.
- **THDORA** — Bot personal de Telegram para gestión rutinaria.

### Flujo de trabajo

1. Las keys se guardan en `~/.bashrc` — nunca en GitHub
2. `~/.claude/settings.json` configura Claude Code con OpenRouter
3. Cada proyecto mantiene aislamiento pero comparte los modelos del ecosistema
4. Los resultados de investigación alimentan directamente las implementaciones

---

## Configuración de Claude Code

`~/.claude/settings.json`:
```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://openrouter.ai/api",
    "ANTHROPIC_AUTH_TOKEN": "sk-or-v1-TU_KEY",
    "ANTHROPIC_API_KEY": "",
    "ANTHROPIC_MODEL": "openrouter/free"
  }
}
```

---

## Reglas importantes

- ⚠️ Las keys NUNCA van en GitHub — solo en `~/.bashrc` o `~/.claude/settings.json` local
- El primer comando en cualquier repo nuevo es `bash setup.sh`
- Usar Aider para fixes rápidos, Claude Code para arquitectura y decisiones grandes
- Documentar todo en `setup/` para que el ecosistema sea reproducible

---

_Última actualización: 15 abril 2026_

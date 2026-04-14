# 🧠 Claude Code + OpenRouter — Gratis para siempre

> Claude Code escanea tu repo entero y razona sobre él. Apuntado a OpenRouter = 100% gratis.

---

## Requisitos previos

- Node.js 20 instalado
- Key de OpenRouter: [openrouter.ai](https://openrouter.ai) → gratis, sin tarjeta
- Ver [setup/cuentas-y-keys.md](cuentas-y-keys.md) para cómo conseguirla

---

## Instalación

```bash
# Node.js 20 (si no lo tienes)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Claude Code
npm install -g @anthropic-ai/claude-code

# Verificar
claude --version
```

---

## Configuración definitiva (la que funciona)

### Opción A — `~/.claude/settings.json` (recomendada)

Crea o edita el fichero:

```bash
mkdir -p ~/.claude
nano ~/.claude/settings.json
```

Pega esto (con tu key real):

```json
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://openrouter.ai/api",
    "ANTHROPIC_AUTH_TOKEN": "sk-or-v1-TU_KEY_AQUI",
    "ANTHROPIC_API_KEY": "",
    "ANTHROPIC_MODEL": "openrouter/free"
  }
}
```

Con esto basta con escribir `claude` y funciona solo. Sin `--model`, sin nada extra.

### Opción B — Variables en `~/.bashrc`

```bash
export ANTHROPIC_BASE_URL=https://openrouter.ai/api/v1
export ANTHROPIC_API_KEY=sk-or-v1-TU_KEY_AQUI
```

```bash
source ~/.bashrc
```

---

## Uso

```bash
# Sin especificar modelo (usa openrouter/free automáticamente)
cd ~/projects/ai-toolkit
claude

# Especificando modelo concreto
claude --model openrouter/google/gemini-2.5-pro-exp-03-25
```

Claude Code escanea el repo entero solo. Luego le dices qué hacer:

```
> revisa toda la arquitectura y díme qué mejorarías
> crea tests para todos los handlers que no tienen test
> genera ARCHITECTURE.md documentando el patrón actual
> fix el bug en el módulo X
```

---

## Modelos gratuitos disponibles (abril 2026)

| Modelo | ID exacto para `--model` | Para qué |
|---|---|---|
| **Auto (recomendado)** | `openrouter/free` | Elige el mejor disponible automáticamente |
| DeepSeek R1 | `openrouter/deepseek/deepseek-r1:free` | Razonamiento profundo, bugs complejos |
| Llama 4 Maverick | `openrouter/meta-llama/llama-4-maverick:free` | Código del día a día |
| GPT-OSS 20B | `openrouter/openai/gpt-oss-20b:free` | Agente rápido, tareas simples |
| Qwen 3 235B | `openrouter/qwen/qwen3-235b-a22b:free` | Código avanzado |
| Gemini 2.5 Pro | `openrouter/google/gemini-2.5-pro-exp-03-25` | Arquitectura, refactorizaciones grandes |

> Límites cuenta gratuita: 20 req/min, 200 req/día.

---

## Troubleshooting

### Error: "Model not found"
```
There's an issue with the selected model. It may not exist
or you may not have access to it.
```
**Causa:** El nombre del modelo es incorrecto o no está disponible.
**Solución:** Usa `openrouter/free` que elige automáticamente, o consulta
[openrouter.ai/models?q=free](https://openrouter.ai/models?q=free) para los nombres exactos.

### ❌ NO uses `ccr` (claude-code-router)
Ese proxy hardcodea `claude-sonnet-4-6` que OpenRouter no reconoce.
Usa `claude` directamente.

### Modelos que NO funcionan
```
openrouter/mistralai/devstral-2:free          ← no existe
openrouter/google/gemma-3-27b-it:free         ← no disponible
claude-sonnet-4-6                             ← solo en Anthropic directo
```

---

## Diferencia con Aider

| | Aider + Groq | Claude Code + OpenRouter |
|---|---|---|
| **Contexto** | Añades ficheros con `/add` | Escanea repo entero solo |
| **Velocidad** | Más rápido (Groq LPU) | Más lento pero más completo |
| **Mejor para** | Fixes rápidos, tareas concretas | Arquitectura, refactorizaciones grandes |
| **Coste** | 0€ | 0€ |

**Regla:** usa Aider para el día a día y Claude Code para decisiones grandes.

---

_Última actualización: 15 abril 2026 — configuración con openrouter/free router_

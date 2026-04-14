# 🧠 Claude Code + OpenRouter — Agente de código completo

> Claude Code lee tu repo entero automáticamente y razona sobre él. Apuntado a OpenRouter es 100% gratuito.

---

## Requisitos previos

- Node.js 20 instalado (setup.sh lo instala)
- Key de OpenRouter: [openrouter.ai](https://openrouter.ai) → gratis
- Ver [setup/cuentas-y-keys.md](cuentas-y-keys.md) para cómo meter la key

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

Añade esto a `~/.bashrc`:

```bash
export ANTHROPIC_BASE_URL=https://openrouter.ai/api/v1
export ANTHROPIC_API_KEY=sk-or-tu_key_de_openrouter
```

```bash
source ~/.bashrc
```

⚠️ **NO uses `ccr` (claude-code-router)** — ese proxy hardcodea `claude-sonnet-4-6` internamente
y OpenRouter no reconoce ese nombre. Te queda en bucle infinito de error de modelo.
La solución es usar `claude` directamente con `--model`.

---

## Uso correcto

```bash
# Entrar en cualquier repo especificando el modelo explicitamente
cd ~/projects/thdora
claude --model openrouter/google/gemini-2.5-pro-exp-03-25
```

Claude Code escanea el repo entero solo. Luego le dices qué hacer en lenguaje natural:

```
> revisa toda la arquitectura y díme qué mejorarías
> fix el issue #10: asyncio.wait_for con timeout en _show_hab_configs
> crea tests para todos los handlers que no tienen test
> genera ARCHITECTURE.md documentando el patrón actual
> refactoriza el groq_router para que sea más limpio
```

---

## Modelos que funcionan en OpenRouter con Claude Code

> Probado con Claude Code v2.1.108 — 15 abril 2026

| Modelo (nombre exacto para `--model`) | Calidad | Mejor para |
|---|---|---|
| `openrouter/google/gemini-2.5-pro-exp-03-25` | ⭐⭐⭐⭐⭐ | Arquitectura, refactorizaciones grandes |
| `openrouter/deepseek/deepseek-r1-0528:free` | ⭐⭐⭐⭐ | Razonamiento profundo, bugs complejos |
| `openrouter/meta-llama/llama-3.3-70b-instruct:free` | ⭐⭐⭐ | Tareas del día a día, rápido |

### ❌ Modelos que NO funcionan (nombres incorrectos)

```
openrouter/mistralai/devstral-2:free          ← no existe
openrouter/mistralai/devstral-small-2505:free ← no existe en OpenRouter
openrouter/deepseek/deepseek-r1:free          ← nombre incorrecto (falta -0528)
openrouter/google/gemma-3-27b-it:free         ← no disponible
claude-sonnet-4-6                             ← solo en Anthropic directo, no en OpenRouter
```

---

## Troubleshooting

### Error: "Model not found"
```
There's an issue with the selected model (openrouter/xxx). It may not exist
or you may not have access to it. Run /model to pick a different model.
```
**Causa:** El nombre del modelo no existe en OpenRouter o lo escribiste mal.
**Solución:** Sal con Ctrl+C y relanza con el nombre correcto:
```bash
claude --model openrouter/google/gemini-2.5-pro-exp-03-25
```

### Error: Claude Code abre pero el `/model` dentro no funciona
**Causa:** El proxy `ccr` intercepta los comandos `/model` como si fueran prompts.
**Solución:** No uses `ccr code`. Usa `claude --model <nombre>` directamente.

### Claude Code siempre abre con un modelo incorrecto aunque pongas `--model`
**Causa:** Hay una sesión OAuth guardada en el keychain del sistema que sobreescribe la configuración.
**Solución:**
```bash
# Ver configuración actual
cat ~/.claude/settings.json

# Si hay un modelo hardcodeado, bórralo o cámbialo
# El fichero tiene forma: {"model": "claude-sonnet-4-6", ...}
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

_Última actualización: 15 abril 2026 — lecciones aprendidas en producción_

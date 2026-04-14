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

## Configuración

En `~/.bashrc` (ya explicado en cuentas-y-keys.md):

```bash
export ANTHROPIC_BASE_URL=https://openrouter.ai/api/v1
export ANTHROPIC_API_KEY=sk-or-tu_key_de_openrouter
```

```bash
source ~/.bashrc
```

---

## Uso

```bash
# Entrar en cualquier repo
cd ~/projects/thdora
claude
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

## Modelos recomendados en OpenRouter

| Tarea | Modelo | Por qué |
|---|---|---|
| Código del día a día | `qwen/qwen3-coder:free` | #1 open-source en SWE-bench |
| Arquitectura compleja | `deepseek/deepseek-r1:free` | Razonamiento profundo |
| Rápido y ligero | `google/gemma-3-27b-it:free` | Tareas simples |
| Razonamiento general | `meta-llama/llama-3.3-70b-instruct:free` | Equilibrio velocidad/calidad |

Para usar un modelo concreto:
```bash
claude --model openrouter/qwen/qwen3-coder:free
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

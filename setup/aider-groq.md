# 🔧 Aider + Groq — Agente de código en terminal

> Aider es un agente que edita tu código directamente desde el terminal. Con Groq como motor es instantáneo (750 tok/s) y gratis.

---

## Requisitos previos

- Python 3.10+ instalado
- `GROQ_API_KEY` en `~/.bashrc` → ver [cuentas-y-keys.md](cuentas-y-keys.md)

---

## Instalación

```bash
pip install aider-chat

# Verificar
aider --version
```

---

## Primer uso — en THDORA

```bash
cd ~/projects/thdora

# Usando alias (setup.sh lo crea)
aider-thdora

# O directamente
aider --model groq/llama-3.3-70b-versatile
```

Aider arranca en modo interactivo. Te pide qué ficheros añadir al contexto y luego edita el código directamente.

---

## Flujo de trabajo real

```
1. Entras al repo: cd ~/projects/thdora
2. Abres aider: aider-thdora
3. Añades contexto: /add src/bot/handlers/config.py
4. Dices qué hacer: > fix el timeout en _show_hab_configs
5. Aider edita el fichero + hace el commit
6. Revisas el diff: /diff
7. Si no te gusta: /undo
```

---

## Comandos esenciales dentro de Aider

| Comando | Qué hace |
|---|---|
| `/add fichero.py` | Añade fichero al contexto de la IA |
| `/drop fichero.py` | Quita fichero del contexto |
| `/diff` | Ver cambios antes de aceptar |
| `/undo` | Deshacer último cambio |
| `/commit` | Hacer commit manual |
| `/run comando` | Ejecutar comando en shell |
| `/help` | Ver todos los comandos |
| `Ctrl+C` | Salir |

---

## Ejemplos de prompts que funcionan

```
# Fix de bug concreto
> fix el issue #10: asyncio.wait_for con timeout en _show_hab_configs

# Crear tests
> crea tests unitarios para todos los handlers de citas que no tienen test

# Refactorizar
> refactoriza el groq_router separando la lógica de intents en su propio módulo

# Documentar
> añade docstrings a todas las funciones públicas de appointment_handler.py

# Entender código
> explícame qué hace _get_api_context y cómo fluye el contexto en el NLP

# Añadir feature
> añade un comando /borrar_todo_habitos con confirmación doble
```

---

## Modelos disponibles con Groq

| Modelo | Cuándo usarlo |
|---|---|
| `groq/llama-3.3-70b-versatile` | **Default** — fixes del día a día, rapidísimo |
| `groq/qwen-qwq-32b` | Bugs difíciles que necesitan razonamiento |
| `groq/llama-3.1-8b-instant` | Tareas simples, cuando no quieres gastar tokens |

```bash
# Cambiar modelo desde dentro de aider
/model groq/qwen-qwq-32b
```

---

## Alias útiles (setup.sh los crea en ~/.bashrc)

```bash
alias aider-thdora='cd ~/projects/thdora && aider --model groq/llama-3.3-70b-versatile'
alias aider-toolkit='cd ~/projects/ai-toolkit && aider --model groq/llama-3.3-70b-versatile'
```

---

## Diferencia con Claude Code

| | Aider + Groq | Claude Code + OpenRouter |
|---|---|---|
| Velocidad | ⚡⚡⚡ Instantáneo | ⚡⚡ Más lento |
| Contexto | Añades tú los ficheros con `/add` | Escanea el repo entero solo |
| Mejor para | Fixes rápidos, tareas del día a día | Arquitectura, refactorizaciones grandes |
| Coste | 0€ | 0€ |

**Regla práctica:** usa Aider para el 90% del trabajo diario. Usa Claude Code cuando necesitas que entienda todo el repo.

# ⚡ Aider + Groq — Agente de código en terminal

> Pair programming con IA en tu terminal. Llama3.3 en Groq es gratis y rapidísimo.

## Instalación

```bash
pip install aider-chat
```

## Configuración

```bash
# Usa la misma key que tienes en THDORA
export GROQ_API_KEY=tu_key_de_groq

# Para que persista en WSL:
echo 'export GROQ_API_KEY=tu_key' >> ~/.bashrc
source ~/.bashrc
```

## Uso básico

```bash
# Entrar en un repo
cd ~/projects/thdora
aider --model groq/llama-3.3-70b-versatile
```

## Comandos dentro de Aider

```
# Añadir ficheros al contexto
/add src/bot/handlers/config.py
/add COMO_PROCEDER.md

# Tareas naturales
> fix el issue #10: añade asyncio.wait_for con timeout=5.0 en _show_hab_configs
> crea un test unitario para el handler de borrar cita
> refactoriza este handler para que use rsplit en lugar de split
> explica qué hace _get_api_context y cómo funciona el cache TTL

# Ver diff antes de aceptar
/diff

# Deshacer el último cambio
/undo

# Commit manual
/commit
```

## Modelos disponibles en Groq (gratis)

| Modelo | Velocidad | Calidad | Uso recomendado |
|---|---|---|---|
| `groq/llama-3.3-70b-versatile` | ⚡⚡ | ⭐⭐⭐ | General, el mejor |
| `groq/llama-3.1-8b-instant` | ⚡⚡⚡ | ⭐⭐ | Tareas simples, muy rápido |
| `groq/mixtral-8x7b-32768` | ⚡⚡ | ⭐⭐⭐ | Contexto largo |

## Limitaciones

- Contexto: hay que añadir ficheros manualmente con `/add`
- No escanea el repo entero automáticamente (para eso: Claude Code)
- Límites de rate en Groq (generosos en plan gratuito)

## Referencia oficial

- [aider.chat/docs/llms/groq.html](https://aider.chat/docs/llms/groq.html)
- [aider.chat/docs/install.html](https://aider.chat/docs/install.html)

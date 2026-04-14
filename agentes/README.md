# 🤖 Agentes

Implementaciones y configuraciones de los agentes del ecosistema.

## Agentes disponibles

| Agente | Herramienta | Para qué | Coste |
|---|---|---|---|
| **Claude Code** | `claude` | Análisis de repos, arquitectura, commits autónomos | 0€ |
| **Aider** | `aider` | Fixes rápidos, tareas concretas, edición de ficheros | 0€ |
| **n8n** | Docker | Orquestación de workflows 24/7 | 0€ |
| **THDORA** | Telegram Bot | Gestión rutinaria personal | 0€ |

## Cómo usar

```bash
# Claude Code en cualquier repo
cd ~/projects/tu-repo
claude

# Aider para fix rápido
aider-fast archivo.py

# Agente en repo concreto
cc-thdora    # Claude Code en THDORA
aider-thdora # Aider en THDORA
```

## Estructura de esta carpeta

Cada agente tiene su propia subcarpeta con:
- `config/` — ficheros de configuración
- `prompts/` — prompts base del agente
- `workflows/` — flujos de trabajo definidos

---
_Ver [setup/claude-code-openrouter.md](../setup/claude-code-openrouter.md) y [setup/aider-groq.md](../setup/aider-groq.md) para la configuración detallada._

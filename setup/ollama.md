# 📦 Setup: Ollama

Ollama te permite correr modelos de IA en tu propia máquina. Sin API key, sin límites, sin coste.

## Instalación

```bash
# Linux / Mac
curl -fsSL https://ollama.com/install.sh | sh

# Windows
# Descarga el instalador desde https://ollama.com/download
```

## Modelos recomendados por RAM

| RAM disponible | Modelo recomendado | Tamaño | Para qué |
|---|---|---|---|
| 4-6 GB | `phi3:mini` | 2.3 GB | Coding ligero, respuestas rápidas |
| 6-8 GB | `gemma3:4b` | 2.5 GB | **Recomendado** — buen balance código/chat |
| 8-16 GB | `deepseek-r1:8b` | 4.9 GB | Razonamiento, planificación |
| +16 GB | `llama3.3:70b` | 40 GB | Máxima calidad local |

## Comandos básicos

```bash
# Descargar modelo
ollama pull gemma3:4b

# Chatear en terminal
ollama run gemma3:4b

# Listar modelos instalados
ollama list

# Eliminar modelo
ollama rm gemma3:4b

# Ver si está corriendo (servidor en puerto 11434)
curl http://localhost:11434
```

## Conectar con Aider

```bash
aider --model ollama/gemma3:4b
```

## Conectar con Claude Code

```bash
export ANTHROPIC_BASE_URL=http://localhost:11434/v1
export ANTHROPIC_API_KEY=ollama
claude --model ollama/gemma3:4b
```

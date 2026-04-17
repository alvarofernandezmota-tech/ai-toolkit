# 🤖 Orquestador LLM — Arquitectura

> Cerebro que decide qué modelo usar para cada tarea.
> Hardware base: GTX 1060 6GB VRAM + 16GB RAM.
> Actualizado: 17 abril 2026.

---

## El problema que resuelve

Con 6GB VRAM no puedes tener dos modelos grandes cargados a la vez.
El orquestador es un modelo **pequeño y rápido** que:
1. Recibe la petición del usuario
2. Decide qué modelo worker usar
3. Carga el worker correcto en Ollama
4. Devuelve la respuesta

---

## Arquitectura

```
Usuario / OpenCode / Claude Code
          │
          ▼
  ┌─────────────────────────────┐
  │   ORQUESTADOR               │
  │   qwen3:4b (2.5GB VRAM)     │
  │   Rápido, siempre cargado   │
  └─────────────┬───────────────┘
                │ decide
                ▼
  ┌─────────────────────────────────────────┐
  │ ROUTER DE TAREAS                        │
  │                                         │
  │  tarea coding    → qwen2.5-coder:7b     │
  │  tarea rápida    → responde él mismo    │
  │  tarea thinking  → deepseek-r1 (nube)   │
  │  tarea general   → llama3.1:8b          │
  └─────────────────────────────────────────┘
```

---

## Modelos del ecosistema

### Local (Ollama — GTX 1060 6GB)

| Modelo | VRAM | Rol | Comando |
|--------|------|-----|---------|
| `qwen3:4b` | ~2.5GB | ⭐ Orquestador/router | `ollama pull qwen3:4b` |
| `qwen2.5-coder:7b-instruct-q4_K_M` | ~4.5GB | Worker coding principal | `ollama pull qwen2.5-coder:7b-instruct-q4_K_M` |
| `phi4-mini` | ~2.5GB | Razonamiento rápido | `ollama pull phi4-mini` |
| `llama3.1:8b-instruct-q4_K_M` | ~5GB | Chat general | `ollama pull llama3.1:8b-instruct-q4_K_M` |

> ⚠️ Con 6GB VRAM solo un modelo grande a la vez. Ollama hace swap automático.

### Nube gratis (OpenRouter / Groq) — para tareas que necesitan más potencia

| Modelo | Dónde | Rol | Velocidad |
|--------|-------|-----|-----------|
| `qwen3-32b` | Groq gratis | Razonamiento rápido nube | ~200 t/s |
| `deepseek-r1:free` | OpenRouter | Thinking complejo | Lenta, potente |
| `qwen3-coder-480b:free` | OpenRouter | Coding avanzado | Media |
| `llama-3.3-70b-versatile` | Groq gratis | Chat general rápido | ~750 t/s |

---

## Reglas de routing

```
SI la tarea contiene [código, función, bug, implementar, refactor]
  → worker: qwen2.5-coder:7b (local)
  → fallback nube: qwen3-coder-480b (OpenRouter)

SI la tarea contiene [analiza, piensa, arquitectura, decisión]
  → worker: deepseek-r1:free (OpenRouter, thinking)
  → fallback local: phi4-mini

SI la tarea es corta o conversacional
  → el propio orquestador (qwen3:4b) responde sin cambiar modelo

SI la API de nube está caída o sin cuota
  → fallback siempre al modelo local equivalente
```

---

## Setup — Comandos para arrancar

```bash
# 1. Instalar modelos locales
ollama pull qwen3:4b
ollama pull qwen2.5-coder:7b-instruct-q4_K_M
ollama pull phi4-mini

# 2. Verificar que cargan
ollama list
nvidia-smi  # ver VRAM usada

# 3. Probar orquestador
ollama run qwen3:4b "Eres un router. Tengo esta tarea: arreglar un bug en Python. ¿Qué modelo debo usar?"
```

---

## Integración con LiteLLM

En `litellm-config.yaml` añadir los modelos locales Ollama:

```yaml
# Modelos locales via Ollama
- model_name: orquestador
  litellm_params:
    model: ollama/qwen3:4b
    api_base: http://localhost:11434

- model_name: coder-local
  litellm_params:
    model: ollama/qwen2.5-coder:7b-instruct-q4_K_M
    api_base: http://localhost:11434

- model_name: thinking-local
  litellm_params:
    model: ollama/phi4-mini
    api_base: http://localhost:11434
```

---

## Estado

- [x] Arquitectura definida
- [x] Modelos seleccionados por hardware real
- [ ] `ollama pull qwen3:4b` — ejecutar en PC
- [ ] `ollama pull qwen2.5-coder:7b-instruct-q4_K_M` — ejecutar en PC
- [ ] Añadir modelos Ollama a `litellm-config.yaml`
- [ ] Probar routing real con prompt de test
- [ ] Documentar resultados en `diario/`

---

_Creado: 17 abril 2026 — por Perplexity AI MCP_

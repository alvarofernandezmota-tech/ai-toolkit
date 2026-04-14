# 🧠 Modelos thinking gratuitos — IA que razona

> Los modelos “thinking” o de razonamiento dedican tiempo a pensar antes de responder. Son mejores para problemas complejos: arquitectura, bugs difíciles, decisiones de diseño.

---

## ¿Qué es un modelo thinking?

Un modelo normal responde directo. Un modelo thinking genera primero un bloque interno de razonamiento (`<think>...</think>`) y luego responde. Es más lento pero mucho más preciso en tareas complejas.

**Cuándo usarlo:**
- Diseñar la arquitectura de un nuevo módulo
- Detectar un bug difícil de encontrar
- Decidir entre dos enfoques técnicos
- Refactorizaciones grandes

**Cuándo NO usarlo:**
- Fixes rápidos del día a día (usa Llama 3.3 en Groq, es instantáneo)
- Preguntas simples o tareas repetitivas

---

## Modelos gratuitos disponibles hoy

### En OpenRouter (`:free`)

| Modelo | ID | Thinking | Mejor para |
|---|---|---|---|
| **DeepSeek R1** | `deepseek/deepseek-r1:free` | ✅ Sí | Arquitectura, razonamiento profundo |
| **Qwen3 Coder 480B** | `qwen/qwen3-coder:free` | ✅ Híbrido | Código — #1 open-source SWE-bench |
| **Qwen3 32B** | `qwen/qwen3-32b:free` | ✅ Híbrido | Razonamiento general rápido |
| **GPT-OSS 120B** | `openai/gpt-4o-mini:free` | ✅ Sí | Tool use + razonamiento |
| **Gemma 3 27B** | `google/gemma-3-27b-it:free` | ❌ No | Código rápido |
| **Llama 3.3 70B** | `meta-llama/llama-3.3-70b-instruct:free` | ❌ No | Equilibrado |

### En Groq (instantáneo, para el día a día)

| Modelo | ID | Velocidad | Mejor para |
|---|---|---|---|
| **Llama 3.3 70B** | `llama-3.3-70b-versatile` | ⚡⚡⚡ | THDORA NLP, Aider diario |
| **Qwen3 32B** | `qwen-qwq-32b` | ⚡⚡ | Razonamiento en terminal |
| **Llama 3.1 8B** | `llama-3.1-8b-instant` | ⚡⚡⚡⚡ | Tareas simples ultrarrápidas |

---

## Cómo usarlos

### Con Aider
```bash
# Día a día (rápido)
aider --model groq/llama-3.3-70b-versatile

# Tarea compleja (thinking)
aider --model openrouter/deepseek/deepseek-r1:free
aider --model openrouter/qwen/qwen3-coder:free
```

### Con Claude Code
```bash
# Día a día
claude  # usa el modelo por defecto de OpenRouter

# Thinking específico
claude --model openrouter/deepseek/deepseek-r1:free
claude --model openrouter/qwen/qwen3-coder:free
```

### Con Python directo (para agentes)
```python
from groq import Groq

client = Groq(api_key=os.getenv('GROQ_API_KEY'))

# Modelo rápido
resp = client.chat.completions.create(
    model='llama-3.3-70b-versatile',
    messages=[{'role': 'user', 'content': 'tu pregunta'}]
)

# Modelo thinking (Qwen en Groq)
resp = client.chat.completions.create(
    model='qwen-qwq-32b',
    messages=[{'role': 'user', 'content': 'arquitectura compleja...'}]
)
```

---

## Regla de uso rápido

```
Tarea rápida    → groq/llama-3.3-70b-versatile     (instantáneo)
Código complejo → openrouter/qwen/qwen3-coder:free  (mejor para SWE)
Arquitectura    → openrouter/deepseek/deepseek-r1:free (razonamiento profundo)
```

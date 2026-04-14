# 🧠 Modelos de lenguaje — Guía completa Abril 2026

> Todos los modelos gratuitos disponibles hoy, con benchmarks reales y cuándo usar cada uno en este ecosistema.

---

## 🏆 Ranking actual de los mejores modelos gratuitos

### Coding (SWE-bench / LiveCodeBench)

| # | Modelo | Benchmark | Dónde gratis | Context |
|---|---|---|---|---|
| 1 | **Devstral 2 123B** | Mejor agentic coding open | OpenRouter `:free` | 262K |
| 2 | **Qwen3 Coder 480B** | #1 open-source SWE | OpenRouter `:free` | 262K |
| 3 | **DeepSeek V3.2** | 90% LiveCodeBench | Together.ai | 128K |
| 4 | **GPT-OSS 120B** | Tool use + structured output | OpenRouter `:free` | 131K |
| 5 | **Qwen3 235B-A22B** | 70.7 LiveCodeBench | OpenRouter `:free` | 131K |

### Razonamiento / Thinking

| # | Modelo | Benchmark | Dónde gratis | Thinking |
|---|---|---|---|---|
| 1 | **DeepSeek R1-0528** | Cerca de o3 y Gemini 2.5 Pro | OpenRouter `:free` | ✅ |
| 2 | **Qwen3 235B-A22B** | ArenaHard 95.6 (casi Gemini) | OpenRouter `:free` | ✅ Híbrido |
| 3 | **GLM-5** | Quality Index 49.64 lider open | OpenRouter | ✅ |
| 4 | **Qwen3 32B** | AIME 2025 72.9% | Groq gratis | ✅ |

### General / Rápido

| # | Modelo | Por qué | Dónde gratis | Velocidad |
|---|---|---|---|---|
| 1 | **Llama 3.3 70B** | GPT-4 level, 14.400 req/día | Groq | ⚡⚡⚡⚡ |
| 2 | **Nemotron 3 Super 120B** | 262K contexto, agentes | OpenRouter `:free` | ⚡⚡⚡ |
| 3 | **Qwen3-Next 80B** | RAG + tool use optimizado | OpenRouter `:free` | ⚡⚡⚡ |
| 4 | **Hermes 3 405B** | Mejor instruction following | OpenRouter `:free` | ⚡⚡ |

---

## 🔧 Tabla maestra — ¿Qué modelo usar para cada cosa?

| Tarea | Modelo recomendado | Plataforma | Coste |
|---|---|---|---|
| **THDORA NLP día a día** | `llama-3.3-70b-versatile` | Groq | 0€ |
| **Aider fixes rápidos** | `llama-3.3-70b-versatile` | Groq | 0€ |
| **Aider bug difícil** | `qwen-qwq-32b` | Groq | 0€ |
| **Claude Code diario** | `qwen/qwen3-coder:free` | OpenRouter | 0€ |
| **Arquitectura / diseño** | `deepseek/deepseek-r1:free` | OpenRouter | 0€ |
| **Multi-file agentic coding** | `mistralai/devstral-2:free` | OpenRouter | 0€ |
| **Razonamiento profundo** | `deepseek/deepseek-r1-0528:free` | OpenRouter | 0€ |
| **Contexto muy largo (200K+)** | `nvidia/nemotron-3-super:free` | OpenRouter | 0€ |
| **CrewAI agentes** | `llama-3.3-70b-versatile` | Groq | 0€ |
| **Voz Whisper (F15)** | `whisper-large-v3` | Groq | 0€ |

---

## 💻 IDs exactos para usar en el código

### Groq (instantáneo, 750 tok/s)

```python
# En Aider o Python directo
GROQ_MODELS = {
    'default':       'llama-3.3-70b-versatile',    # 14.400 req/día
    'thinking':      'qwen-qwq-32b',               # 1.000 req/día
    'fast':          'llama-3.1-8b-instant',        # ultra rápido
    'code':          'qwen-2.5-coder-32b',          # coding especializado
    'whisper':       'whisper-large-v3',            # transcripción de voz
}
```

### OpenRouter (`:free` = gratis)

```python
OPENROUTER_MODELS = {
    'coding_best':   'qwen/qwen3-coder:free',                    # mejor coding open
    'coding_agent':  'mistralai/devstral-2:free',                # agentic multi-file  
    'reasoning':     'deepseek/deepseek-r1:free',                # razonamiento clásico
    'reasoning_new': 'deepseek/deepseek-r1-0528:free',           # más potente, cerca de o3
    'general_big':   'meta-llama/llama-3.3-70b-instruct:free',   # equilibrado
    'context_long':  'nvidia/nemotron-3-super-49b-instruct:free',# 262K tokens
    'tool_use':      'openai/gpt-oss-120b:free',                 # tool use + structured output
    'agents':        'qwen/qwen3-next-80b:free',                 # RAG + agentes
}
```

### En Aider (flags directos)

```bash
# Día a día
aider --model groq/llama-3.3-70b-versatile

# Bug difícil / thinking
aider --model groq/qwen-qwq-32b

# Mejor coding open source
aider --model openrouter/qwen/qwen3-coder:free

# Agentic multi-file (refactorizaciones grandes)
aider --model openrouter/mistralai/devstral-2:free

# Razonamiento profundo
aider --model openrouter/deepseek/deepseek-r1-0528:free
```

### En Claude Code (variable de entorno)

```bash
# Por defecto (OpenRouter usa tu modelo preferido)
claude

# Modelo específico
claude --model openrouter/qwen/qwen3-coder:free
claude --model openrouter/mistralai/devstral-2:free
```

---

## 📊 Límites gratuitos por plataforma

| Plataforma | Límite diario | Límite/minuto | Nota |
|---|---|---|---|
| **Groq** (Llama 3.3 70B) | 14.400 req | 100 req | Más que suficiente para uso personal |
| **Groq** (Qwen 32B) | 1.000 req | 30 req | Para tareas thinking puntuales |
| **OpenRouter** `:free` | 200 req | 20 req | Para tareas complejas (Claude Code, arquitectura) |
| **Google AI Studio** | 1.500 req | 15 req | Gemini 2.5 Flash gratuito |
| **Cerebras** | Ilimitado | 30 req | Ultra rápido, modelos Llama |

---

## 🔄 Plataformas alternativas que vale tener

### Cerebras — Más rápido que Groq

**URL:** [inference.cerebras.ai](https://inference.cerebras.ai)

- Llama 3.3 70B y Llama 3.1 8B
- Sin límite diario en el tier gratuito
- Velocidad comparable a Groq LPU

```python
# En Aider
aider --model cerebras/llama3.3-70b
```

### Google AI Studio — Gemini 2.5 Flash gratis

**URL:** [aistudio.google.com](https://aistudio.google.com)

- Gemini 2.5 Flash: 1.500 req/día gratis
- 1M tokens de contexto
- Muy bueno para documentos largos

```python
# En Aider
aider --model gemini/gemini-2.5-flash
```

### SambaNova — Modelos grandes gratis

**URL:** [sambanova.ai](https://cloud.sambanova.ai)

- DeepSeek R1 y Qwen3 235B disponibles
- Velocidad alta en hardware especializado
- Alternativa si OpenRouter tiene rate limits

---

## 🚨 Estrategia anti-rate-limit

Si Groq o OpenRouter alcanzan el límite diario, rotar en este orden:

```bash
# Orden de fallback para tasks de código:
# 1. Groq (llama-3.3-70b) → si rate limit:
# 2. Cerebras (llama3.3-70b) → si rate limit:
# 3. OpenRouter (llama-3.3-70b:free) → si rate limit:
# 4. Google AI Studio (gemini-2.5-flash)

# En Aider es tan fácil como:
/model cerebras/llama3.3-70b
# o
/model gemini/gemini-2.5-flash
```

---

## ⚡ Regla de oro simplificada

```
Velocidad máxima          → Groq llama-3.3-70b-versatile
Mejor código open source  → OpenRouter qwen/qwen3-coder:free
Mejor multi-file / agente  → OpenRouter mistralai/devstral-2:free  
Razonamiento más profundo  → OpenRouter deepseek/deepseek-r1-0528:free
Contexto muy largo         → OpenRouter nvidia/nemotron-3-super:free
Sin internet (backup)      → Cerebras llama3.3-70b
```

*Última actualización: Abril 2026*

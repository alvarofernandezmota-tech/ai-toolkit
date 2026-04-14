# 🧠 mem0 — Memoria persistente para THDORA

> mem0 es la librería open source para dar memoria larga a agentes IA. Permite que Toki recuerde conversaciones de semanas atrás.

**Repo oficial:** [github.com/mem0ai/mem0](https://github.com/mem0ai/mem0)
**Fecha integración en THDORA:** Verano 2026

---

## Por qué mem0 y no otras soluciones

| Solución | Precisión | Latencia | Tokens | Mantenimiento |
|---|---|---|---|---|
| **mem0** | +26% vs OpenAI | 91% más rápido | 90% menos | Activo, 30K+ stars |
| OpenAI Memory | Base (100%) | Base | Base | Propietario |
| Guardar todo en prompt | Alta | Alta (prompt enorme) | Muchísimos | Ninguno |
| Sin memoria | 0% | ⚡ | Mínimos | Ninguno |

Fuente de benchmarks: [mem0ai/mem0 README](https://github.com/mem0ai/mem0/)

---

## Instalación

```bash
pip install mem0ai
```

---

## Cómo funciona

```
Usuario escribe en Telegram
        ↓
mem0 busca memorias relevantes (semántico, vectores)
        ↓
Se inyectan en el contexto del prompt de Groq
        ↓
Groq responde con contexto real de conversaciones pasadas
        ↓
mem0 guarda la nueva conversación como memoria
```

---

## Implementación en THDORA — código completo

### 1. Configuración (sin OpenAI, usando Groq)

```python
# src/core/memory.py
import os
from mem0 import Memory

# Configuración usando Groq como LLM (gratis)
MEM0_CONFIG = {
    'llm': {
        'provider': 'groq',
        'config': {
            'model': 'llama-3.3-70b-versatile',
            'api_key': os.getenv('GROQ_API_KEY'),
        }
    },
    'embedder': {
        'provider': 'huggingface',
        'config': {
            'model': 'sentence-transformers/all-MiniLM-L6-v2'  # local, sin API
        }
    },
    'vector_store': {
        'provider': 'chroma',  # SQLite local, sin servidor externo
        'config': {
            'collection_name': 'thdora_memories',
            'path': './data/memories'
        }
    }
}

memory = Memory.from_config(MEM0_CONFIG)
```

### 2. Guardar conversaciones

```python
# En el handler NLP, después de cada respuesta:

async def handle_nlp_con_memoria(user_id: int, mensaje: str, respuesta: str):
    # Guardar la conversación en memoria
    memory.add(
        messages=[
            {'role': 'user', 'content': mensaje},
            {'role': 'assistant', 'content': respuesta}
        ],
        user_id=str(user_id)
    )
```

### 3. Recuperar contexto antes de responder

```python
# En groq_router.py, antes de llamar a Groq:

async def get_response_con_memoria(user_id: int, mensaje: str) -> str:
    # Buscar memorias relevantes
    memorias = memory.search(
        query=mensaje,
        user_id=str(user_id),
        limit=5
    )
    
    contexto_memoria = ''
    if memorias['results']:
        hechos = [m['memory'] for m in memorias['results']]
        contexto_memoria = 'Recuerdas esto del usuario:\n' + '\n'.join(f'- {h}' for h in hechos)
    
    # Prompt enriquecido con memoria
    system_prompt = f"""
    Eres Toki, el asistente personal de {user_id}.
    {contexto_memoria}
    Responde de forma concisa y personal.
    """
    
    resp = groq_client.chat.completions.create(
        model='llama-3.3-70b-versatile',
        messages=[
            {'role': 'system', 'content': system_prompt},
            {'role': 'user', 'content': mensaje}
        ]
    )
    return resp.choices[0].message.content
```

---

## Cómo añadirlo con Aider (cuando llegue el momento)

```bash
cd ~/projects/thdora
pip install mem0ai chromadb sentence-transformers

aider-thdora
/add src/core/groq_router.py
> crea src/core/memory.py con mem0 configurado para usar Groq como LLM y chroma como vector store local
> integra memory.py en groq_router para que cada conversación se guarde y el contexto relevante se inyecte en el prompt
> crea tests para memory.py mockeando las llamadas a Groq y chroma
```

---

## Dependencias adicionales

```bash
pip install mem0ai chromadb sentence-transformers
```

Añadir a `requirements.txt` de THDORA cuando se integre.

---

## Alternativa: mcp-mem0

**Repo:** [github.com/coleam00/mcp-mem0](https://github.com/coleam00/mcp-mem0)

Servidor MCP con mem0 integrado. Útil si en el futuro Claude Code necesita memoria persistente entre sesiones de trabajo.

---

## Qué recordará Toki cuando esté implementado

Ejemplos de memorias que guardará automáticamente:
```
- "Al usuario le gusta entrenar por la mañana"
- "Prefiere citas médicas los martes"
- "Está trabajando en un proyecto de ecosistema IA"
- "Su equipo de fútbol favorito es el Atlético de Madrid"
- "Duerme mejor cuando marca el hábito de lectura nocturna"
```

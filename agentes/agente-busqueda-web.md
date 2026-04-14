# 🌐 Agente de búsqueda web — THDORA con internet (Junio 2026)

> Añade a THDORA la capacidad de responder preguntas sobre el mundo real. "¿Qué tiempo hace mañana?" → busca → responde. Con DuckDuckGo (gratis) o Tavily (mejor calidad).

**Fecha objetivo: Junio 2026.**

---

## Opciones disponibles

| Herramienta | Coste | Calidad | Key necesaria |
|---|---|---|---|
| **DuckDuckGo** | Gratis total | Buena | ❌ No |
| **Tavily** | Gratis 1.000/mes | Muy buena | ✅ Sí |
| **SerpAPI** | Pago | Excelente | ✅ + pago |

**Plan:** empezar con DuckDuckGo. Si la calidad no es suficiente, migrar a Tavily.

---

## Instalación

```bash
# DuckDuckGo
pip install duckduckgo-search

# Tavily (cuando tengas la key)
pip install tavily-python
```

---

## Implementación DuckDuckGo (Opción 1 — sin key)

```python
# src/core/web_search.py

import os
from duckduckgo_search import DDGS
from groq import Groq

client = Groq(api_key=os.getenv('GROQ_API_KEY'))

async def buscar_y_responder(pregunta: str, n_resultados: int = 3) -> str:
    """Busca en la web y responde usando Groq como razonador."""
    try:
        with DDGS() as ddgs:
            resultados = list(ddgs.text(pregunta, max_results=n_resultados))
        
        if not resultados:
            return "No encontré información sobre eso en la web."
        
        contexto = '\n\n'.join([
            f"Fuente: {r['href']}\n{r['body']}"
            for r in resultados
        ])
        
        resp = client.chat.completions.create(
            model='llama-3.3-70b-versatile',
            messages=[
                {
                    'role': 'system',
                    'content': f'Eres Toki, asistente personal en español. '
                               f'Responde de forma concisa usando esta información:\n\n{contexto}'
                },
                {'role': 'user', 'content': pregunta}
            ],
            max_tokens=500
        )
        return resp.choices[0].message.content
        
    except Exception as e:
        return f"Error en búsqueda web: {str(e)}"
```

---

## Implementación Tavily (Opción 2 — mejor calidad)

```python
# src/core/web_search.py (versión Tavily)

import os
from tavily import TavilyClient
from groq import Groq

tavily = TavilyClient(api_key=os.getenv('TAVILY_API_KEY'))
client = Groq(api_key=os.getenv('GROQ_API_KEY'))

async def buscar_y_responder(pregunta: str) -> str:
    """Busca con Tavily y responde con Groq."""
    resultados = tavily.search(
        query=pregunta,
        search_depth='basic',
        max_results=3
    )
    
    contexto = '\n\n'.join([
        f"{r['title']}\n{r['content']}"
        for r in resultados['results']
    ])
    
    resp = client.chat.completions.create(
        model='llama-3.3-70b-versatile',
        messages=[
            {
                'role': 'system',
                'content': f'Eres Toki. Responde en español usando:\n\n{contexto}'
            },
            {'role': 'user', 'content': pregunta}
        ]
    )
    return resp.choices[0].message.content
```

---

## Integrar en el NLP de THDORA

En `src/core/groq_router.py`, añadir el intent `busqueda_web`:

```python
# En el system prompt del router NLP, añadir:
INTENTS_DISPONIBLES = [
    # ... intents actuales ...
    'busqueda_web',    # NUEVO: preguntas sobre el mundo real
]

# En el handler de intents:
elif intent == 'busqueda_web':
    from src.core.web_search import buscar_y_responder
    respuesta = await buscar_y_responder(mensaje_usuario)
    await message.answer(respuesta)
```

---

## Ejemplos que funcionarán

```
Usuario: ¿Qué tiempo hace mañana en Madrid?
THDORA: Mañana en Madrid habrá 18°C con cielos despejados...

Usuario: ¿Cuándo es el próximo partido del Atleti?
THDORA: El Atlético de Madrid juega el sábado 20 contra...

Usuario: ¿Cuál es el precio del bitcoin ahora?
THDORA: Bitcoin está a $67.400 según los últimos datos...
```

---

## Cómo añadirlo con Aider

```bash
cd ~/projects/thdora
aider-thdora
/add src/core/groq_router.py
> crea src/core/web_search.py con la función buscar_y_responder usando duckduckgo-search y groq
> añade el intent busqueda_web al NLP router
> crea el test para web_search.py mockeando las llamadas externas
```

# 🌐 Groq + Búsqueda Web — IA con acceso a internet

> Groq por sí solo no busca en internet. Pero combinado con APIs de búsqueda, puedes construir tu propio "Perplexity" gratuito.

---

## ¿Groq tiene API de búsqueda tipo Perplexity?

**No directamente.** Groq es solo inferencia — el modelo razona muy rápido pero no sale a internet.

Pero hay dos caminos:

### Opción A — Perplexity API (la más directa)
Perplexity tiene su propia API con modelos que buscan en internet en tiempo real.

```python
import requests

response = requests.post(
    'https://api.perplexity.ai/chat/completions',
    headers={'Authorization': 'Bearer TU_KEY'},
    json={
        'model': 'sonar',           # modelo con búsqueda web incluida
        'messages': [{
            'role': 'user',
            'content': '¿Qué novedades hay en Python 3.13?'
        }]
    }
)
```

**Modelos con búsqueda web:**
| Modelo | Búsqueda | Coste |
|---|---|---|
| `sonar` | ✅ Tiempo real | ~$1/1M tokens |
| `sonar-pro` | ✅ Tiempo real, mejor | ~$3/1M tokens |
| `sonar-reasoning` | ✅ + razonamiento | ~$5/1M tokens |

Plan gratuito disponible en [perplexity.ai/api](https://www.perplexity.ai/api)

---

### Opción B — Groq + Tavily (búsqueda gratuita)
Tavily es una API de búsqueda web diseñada para agentes IA. Plan gratuito: 1000 búsquedas/mes.

```python
from groq import Groq
import requests

def buscar_web(query: str) -> str:
    resp = requests.post(
        'https://api.tavily.com/search',
        json={'api_key': 'TU_KEY_TAVILY', 'query': query, 'max_results': 3}
    )
    resultados = resp.json()['results']
    return '\n'.join([r['content'] for r in resultados])

client = Groq(api_key='TU_KEY_GROQ')

# 1. Buscar info actualizada
contexto = buscar_web('Python 3.13 novedades 2025')

# 2. Groq razona sobre esa info
respuesta = client.chat.completions.create(
    model='llama-3.3-70b-versatile',
    messages=[
        {'role': 'system', 'content': 'Responde usando este contexto: ' + contexto},
        {'role': 'user', 'content': '¿Qué hay de nuevo en Python 3.13?'}
    ]
)
print(respuesta.choices[0].message.content)
```

**Resultado:** Groq con acceso a internet en tiempo real, coste prácticamente 0.

---

### Opción C — Groq + DuckDuckGo (100% gratis, sin API key)
```python
from duckduckgo_search import DDGS
from groq import Groq

def buscar_gratis(query: str) -> str:
    with DDGS() as ddgs:
        resultados = list(ddgs.text(query, max_results=3))
    return '\n'.join([r['body'] for r in resultados])

# pip install duckduckgo-search groq
```

Sin límites, sin API key, completamente gratis. Menos fiable que Tavily pero funciona.

---

## ¿Cómo encaja esto en THDORA?

En el futuro THDORA podría responder preguntas como:
- "¿Cómo está el tiempo esta semana en Madrid?"
- "¿Qué eventos hay este fin de semana?"
- "Busca información sobre [tema] y añádela a mis notas"

El patrón sería:
```
Usuario → THDORA NLP → detecta intent 'busqueda_web'
                     → llama a Tavily/DDG
                     → Groq resume
                     → responde en Telegram
```

Esto está en el **ROADMAP** de THDORA como feature futura.

---

## Comparativa de opciones de búsqueda

| | Perplexity API | Groq + Tavily | Groq + DuckDuckGo |
|---|---|---|---|
| **Calidad búsqueda** | ⭐⭐⭐ Mejor | ⭐⭐ Buena | ⭐ Básica |
| **Coste** | Bajo (~$1/1M) | Gratis (1000/mes) | 0€ siempre |
| **API key** | Sí | Sí (gratis) | No |
| **Facilidad** | Muy fácil | Fácil | Fácil |
| **Cuándo usarlo** | Producción | Desarrollo/personal | Prototipado |

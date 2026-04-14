# 🤖 Ecosistema Personal de Agentes IA

> Agentes que trabajan para ti: en tu código, en tu vida, en tu información. Coste = 0€.

---

## La visión completa

```
TÚ
 │
 ├── Telegram (THDORA)          → agente de vida: citas, hábitos, búsqueda web
 ├── Terminal (Aider/Claude Code) → agente de código: edita repos, hace commits
 ├── n8n (self-hosted)           → orquestador: conecta todo con 400+ servicios
 └── personal repo               → memoria: diarios, tracking, contexto de todo

Todo gratis. Todo tuyo. Todo conectado.
```

---

## Estado actual (Abril 2026)

| Bloque | Estado | Notas |
|---|---|---|
| THDORA bot (citas + hábitos) | ✅ Funcionando | v4.1.0 casi lista |
| THDORA NLP (Groq) | ✅ Funcionando | F13-v2, 4 intents nuevos |
| ai-toolkit docs | 🟡 En progreso | Guías base creadas |
| Aider + Groq en terminal | ❌ Pendiente | Próximo paso inmediato |
| Claude Code + OpenRouter | ❌ Pendiente | Nivel 2 |
| n8n self-hosted | ❌ Pendiente | Mayo 2026 |
| Búsqueda web en THDORA | ❌ Pendiente | Junio 2026 |
| Multi-agente CrewAI | ❌ Pendiente | Otoño 2026 |

---

## BLOQUE 1 — Agente de código en terminal (AHORA)

### Paso 1: Aider + Groq (mañana mismo)

Ya tienes Groq configurado en THDORA. La key está lista.

```bash
# Instalar
pip install aider-chat

# Configurar (usa tu key existente de THDORA)
export GROQ_API_KEY=tu_key_de_groq  # ya la tienes en .env de THDORA

# Entrar en cualquier repo
cd ~/projects/thdora
aider --model groq/llama-3.3-70b-versatile
```

**Comandos dentro de Aider:**
```
/add src/bot/handlers/config.py      # añade fichero al contexto
/add COMO_PROCEDER.md                # añade docs
> fix el issue #10 de THDORA        # ejecuta tarea
> crea test para handler borrar cita
> explica qué hace este método
```

Referencia oficial: [aider.chat/docs/llms/groq.html](https://aider.chat/docs/llms/groq.html)

---

### Paso 2: Claude Code + OpenRouter (cuando quieras más potencia)

**Ventaja sobre Aider:** escanea el repo entero automáticamente, sin añadir ficheros manualmente.

```bash
# Requisito: Node.js en WSL
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Instalar Claude Code
npm install -g @anthropic-ai/claude-code

# Apuntar a OpenRouter (gratis, sin tarjeta)
# Consigue key en: https://openrouter.ai
export ANTHROPIC_BASE_URL=https://openrouter.ai/api/v1
export ANTHROPIC_API_KEY=tu_key_openrouter

# Añadir al .bashrc para que persista
echo 'export ANTHROPIC_BASE_URL=https://openrouter.ai/api/v1' >> ~/.bashrc
echo 'export ANTHROPIC_API_KEY=tu_key_openrouter' >> ~/.bashrc

# Arrancar en tu repo
cd ~/projects/thdora
claude
```

**Modelos gratuitos recomendados:**
| Modelo | Para qué |
|---|---|
| `google/gemma-3-27b-it:free` | Código Python, tareas concretas |
| `meta-llama/llama-3.3-70b-instruct:free` | Razonamiento, arquitectura |
| `mistralai/mistral-7b-instruct:free` | Rápido, refactorizaciones simples |

---

### Paso 3: OpenCode (TUI avanzada, alternativa)

```bash
npm install -g opencode-ai
# o sin instalar:
npx opencode-ai
```

Soporta 75+ proveedores de modelos, LSP integrado. Más info: [opencode.ai](https://opencode.ai)

---

## BLOQUE 2 — n8n como orquestador (Mayo 2026)

n8n conecta THDORA con el resto de tu vida digital: Gmail, GitHub, calendario, Notion, Telegram, y 400+ servicios más. Con IA integrada nativamente.

### Setup en WSL con Docker (el más rápido)

```bash
# 1. Instalar Docker en WSL Ubuntu
sudo apt update
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER  # para no usar sudo

# 2. Arrancar n8n
docker run -d \
  --name n8n \
  --restart unless-stopped \
  -p 5678:5678 \
  -v ~/.n8n:/root/.n8n \
  n8nio/n8n

# 3. Abrir en navegador
# http://localhost:5678
```

### Setup con el starter kit oficial (recomendado para IA)

```bash
# Incluye n8n + Ollama + Qdrant (vector DB) preconfigurados
git clone https://github.com/n8n-io/self-hosted-ai-starter-kit.git
cd self-hosted-ai-starter-kit
docker compose up -d
# http://localhost:5678
```

### Workflows que puedes montar para tu ecosistema

| Workflow | Qué hace | Servicios |
|---|---|---|
| **Diario automático** | Crea entrada en `personal` repo con commits del día | GitHub + Groq |
| **Resumen semanal** | Agrega tus citas, hábitos y commits en un informe | THDORA API + GitHub + Groq |
| **Alertas inteligentes** | Te avisa por Telegram si no has registrado hábitos | THDORA + Telegram |
| **Buscar + resumir** | Busca info en internet y te la manda por Telegram | Tavily + Groq + Telegram |
| **Sync calendario** | Sincroniza citas THDORA con Google Calendar | THDORA API + Google |

---

## BLOQUE 3 — Búsqueda web en THDORA (Junio 2026)

Groq por sí solo no sale a internet. El patrón es: buscador externo + Groq razona sobre los resultados.

### Opción A — DuckDuckGo (gratis, sin key, para empezar)

```bash
pip install duckduckgo-search
```

```python
from duckduckgo_search import DDGS
from groq import Groq

def buscar_y_responder(pregunta: str) -> str:
    with DDGS() as ddgs:
        resultados = list(ddgs.text(pregunta, max_results=3))
    contexto = '\n'.join([r['body'] for r in resultados])

    client = Groq(api_key=os.getenv('GROQ_API_KEY'))
    resp = client.chat.completions.create(
        model='llama-3.3-70b-versatile',
        messages=[
            {'role': 'system', 'content': f'Responde usando este contexto:\n{contexto}'},
            {'role': 'user', 'content': pregunta}
        ]
    )
    return resp.choices[0].message.content
```

### Opción B — Tavily (mejor calidad, gratis 1000/mes)

Key gratuita en: [tavily.com](https://tavily.com)

```python
import requests

def buscar_tavily(query: str) -> str:
    resp = requests.post(
        'https://api.tavily.com/search',
        json={'api_key': os.getenv('TAVILY_API_KEY'), 'query': query, 'max_results': 3}
    )
    return '\n'.join([r['content'] for r in resp.json()['results']])
```

### Intent en THDORA para activarlo

```python
# En tu NLP de THDORA añadiremos:
'busqueda_web': [
    'busca información sobre',
    'qué hay de',
    'cómo está el tiempo',
    'noticias de',
]
```

---

## BLOQUE 4 — Multi-agente CrewAI (Otoño 2026)

Cuando THDORA crezca, podrás tener agentes especializados colaborando:

```python
from crewai import Agent, Crew, Task

# Agente 1: Revisa el código
revisor = Agent(
    role='Code Reviewer',
    goal='Revisar PRs de THDORA y detectar bugs',
    backstory='Experto en Python async y telegram-bot',
    model='groq/llama-3.3-70b-versatile'
)

# Agente 2: Escribe tests
tester = Agent(
    role='Test Writer',
    goal='Crear tests para los handlers revisados',
    backstory='Especialista en pytest y testing de bots',
    model='groq/llama-3.3-70b-versatile'
)

# Crew: trabajan juntos
crew = Crew(agents=[revisor, tester], tasks=[...], verbose=True)
crew.kickoff()
```

Referencia: [crewai.com](https://www.crewai.com) | [docs.crewai.com](https://docs.crewai.com)

```bash
# Instalar cuando llegue el momento
pip install crewai crewai-tools
```

---

## Hoja de ruta completa

```
AHORA (Abril 2026)
  └── ✅ THDORA v4.1.0 — cerrar issue #10 + tag
  └── 🔧 Aider + Groq en terminal — pip install aider-chat

Esta semana
  └── Probar Aider en thdora con fix issue #10
  └── Conseguir key OpenRouter (openrouter.ai)
  └── Probar Claude Code apuntado a OpenRouter

Mayo 2026
  └── n8n self-hosted con Docker en WSL
  └── Primer workflow: resumen semanal automático
  └── Workflow: sync THDORA → Google Calendar

Junio 2026
  └── Búsqueda web en THDORA (DuckDuckGo + Groq)
  └── Intent 'busqueda_web' en NLP de THDORA
  └── Key Tavily para mejor calidad de búsqueda

Otoño 2026
  └── CrewAI multi-agente para revisar/testear THDORA
  └── Agente diario: resume commits + genera entrada en personal repo
  └── Ecosistema completo funcionando
```

---

## Flujo de trabajo diario (visión final)

```
Tú hablas con THDORA por Telegram
    │
    ├── "Qué tengo mañana"     → THDORA consulta API → responde
    ├── "Busca noticias de IA"  → Tavily + Groq → responde
    ├── "Resumen de la semana"  → n8n agrega todo → responde
    └── "Fix el issue #10"      → Aider en terminal → edita repo

Mientras tú duermes:
    n8n → genera diario automático
    n8n → commit en personal repo
    n8n → resumen semanal listo para el lunes
```

---

## APIs y keys necesarias

| Servicio | Para qué | Coste | Link |
|---|---|---|---|
| **Groq** | NLP THDORA + Aider | Gratis | [console.groq.com](https://console.groq.com) |
| **OpenRouter** | Claude Code + modelos gratis | Gratis | [openrouter.ai](https://openrouter.ai) |
| **Tavily** | Búsqueda web calidad | Gratis 1000/mes | [tavily.com](https://tavily.com) |
| **Telegram Bot** | THDORA | Gratis | [@BotFather](https://t.me/BotFather) |
| **GitHub** | Repos + commits | Gratis | [github.com](https://github.com) |

---

## La diferencia THDORA vs ai-toolkit

| | THDORA | ai-toolkit |
|---|---|---|
| **Qué es** | Tu asistente personal | Tu caja de herramientas pública |
| **Para quién** | Solo para ti | Para cualquier dev |
| **Config** | `.env` con tus keys reales | Plantillas con `TU_KEY` |
| **Datos** | Tu BBDD, tus citas, tu vida | Sin datos personales |
| **Regla** | Lo que vives y personalizas | Lo que aprendes y generalizas |

---

*Documentado en abril 2026. Actualizar conforme avanza el ecosistema.*

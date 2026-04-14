# 🤖 Ecosistema Personal de Agentes IA

> Agentes que trabajan para ti: en tu código, en tu vida, en tu información. Coste = 0€.
> Última actualización: 14 abril 2026 (noche, partido Atleti-Barça)

---

## La visión completa

```
TÚ
 │
 ├── Telegram (THDORA)           → agente de vida: citas, hábitos, búsqueda web
 ├── Terminal (Aider/Claude Code) → agente de código: edita repos, hace commits
 ├── n8n (self-hosted)            → orquestador: conecta todo con 400+ servicios
 └── personal repo                → memoria: diarios, tracking, contexto de todo

Todo gratis. Todo tuyo. Todo conectado.
```

---

## Estado actual — 14 Abril 2026

| Bloque | Estado | Notas |
|---|---|---|
| THDORA bot (citas + hábitos) | ✅ Funcionando | v0.14.0 en producción |
| THDORA NLP Groq (modo Toki) | ✅ Funcionando | F13-v2, contexto real de API |
| setup.sh instalador | ✅ Listo | 1 comando instala todo |
| ai-toolkit docs base | ✅ Listo | ECOSISTEMA + setup/ + guias/ |
| Aider + Groq en terminal | 🔧 Siguiente | `pip install aider-chat` |
| Claude Code + OpenRouter | 🔧 Esta semana | Node.js + 3 exports |
| n8n self-hosted | ❌ Mayo 2026 | Docker ya documentado |
| Búsqueda web en THDORA | ❌ Junio 2026 | DuckDuckGo o Tavily |
| Multi-agente CrewAI | ❌ Otoño 2026 | Diseño listo |

---

## ⚡ Consumo de recursos — ¿pesa en el ordenador?

### La respuesta corta: NO. Casi cero.

El secreto es que **la IA no corre en tu máquina** — corre en los servidores de Groq y OpenRouter. Tu ordenador solo envía texto y recibe texto. [web:715][web:717]

| Pieza | CPU en uso | RAM | Dónde corre la IA |
|---|---|---|---|
| **THDORA bot** | ~0% idle | ~50 MB | Groq (en la nube, gratis) |
| **THDORA API** | ~0% idle | ~40 MB | — |
| **Aider** | ~0% idle | ~30 MB | Groq/OpenRouter (en la nube) |
| **Claude Code** | ~0% idle | ~60 MB | OpenRouter (en la nube) |
| **n8n Docker** | ~0% idle | ~180 MB | — |
| **TOTAL ecosistema** | **<1% CPU** | **~360 MB RAM** | — |

> Groq genera 750-1000 tokens/segundo en sus LPUs. Tu CPU no procesa nada de IA. [web:717]

### Comparación con alternativas locales

| Enfoque | RAM necesaria | CPU | Velocidad IA |
|---|---|---|---|
| **Nuestro stack (cloud gratis)** | ~360 MB | <1% | 750 tok/s |
| Ollama local (Llama 70B) | 40+ GB | 80-100% | 1-3 tok/s |
| Ollama local (Llama 8B) | 8 GB | 30-50% | 15-30 tok/s |

**Conclusión: cloud gratis > local en velocidad y consumo.** Ollama solo tiene sentido si necesitas privacidad total o sin internet.

---

## 🎯 Mapa completo de agentes

### Agentes de vida personal (THDORA)

| Agente | Estado | Qué hace |
|---|---|---|
| 🗓️ **Agenda** | ✅ Vivo | Citas, conflictos, semana completa |
| 💧 **Hábitos** | ✅ Vivo | Agua, sueño, ejercicio — tracking diario |
| 🤖 **NLP Toki** | ✅ Vivo | Lenguaje natural → acciones reales |
| 🎙️ **Voz Whisper** | ❌ F15 | Hablas → transcribe → actúa (manos libres) |
| 📊 **Tracking F14** | ❌ F14 | Estado, sueño, sustancias — puntuación diaria |
| 🌐 **Búsqueda web** | ❌ Junio | Preguntas en tiempo real con Tavily+Groq |
| 📅 **Brief diario** | ❌ Mayo | Cada noche: qué tienes mañana |

### Agentes de código (terminal)

| Agente | Herramienta | Qué hace |
|---|---|---|
| 🔧 **Coding** | Aider + Groq | Edita código, hace commits, arregla bugs |
| 🧠 **Arquitectura** | Claude Code + OpenRouter | Lee repo entero, propone diseño |
| 🧪 **Tests** | CrewAI sub-agente | Crea tests automáticamente |
| 📝 **Docs** | CrewAI sub-agente | Genera ARCHITECTURE.md, docstrings |

### Agentes de orquestación (n8n — corren solos 24/7)

| Agente | Cuándo | Qué produce |
|---|---|---|
| 📓 **Diario nocturno** | 23:00 cada noche | Commit en `personal` repo con tu día |
| 📬 **Resumen semanal** | Lunes 8:00 | Informe: citas, hábitos, commits |
| ⚠️ **Alerta hábitos** | 22:00 si no los marcaste | Telegram: recordatorio |
| 🔔 **Brief mañana** | 22:00 cada noche | Telegram: qué tienes mañana |

---

## 🧠 Modelos thinking gratuitos (razonamiento profundo)

Para tareas complejas (arquitectura, diseño, decisiones difíciles) usa modelos con razonamiento:

| Modelo | Dónde | Thinking | Mejor para |
|---|---|---|---|
| **DeepSeek R1** | OpenRouter `:free` | ✅ Sí | Arquitectura, decisiones complejas |
| **Qwen3 Coder 480B** | OpenRouter `:free` | ✅ Híbrido | Agente coding — el mejor open-source |
| **Qwen3 32B** | Groq gratis | ✅ Sí | Razonamiento rápido en terminal |
| **Llama 3.3 70B** | Groq gratis | ❌ No | THDORA NLP — velocidad máxima |
| **GPT-OSS 120B** | OpenRouter `:free` | ✅ Sí | Razonamiento general + tool use |

**Regla de uso:**
- Tareas rápidas (THDORA, Aider diario) → `llama-3.3-70b-versatile` en Groq
- Tareas complejas (diseño, arquitectura) → `DeepSeek R1` o `Qwen3 Coder` en OpenRouter

---

## BLOQUE 1 — Agente de código en terminal (AHORA)

### Paso 1: Aider + Groq

```bash
pip install aider-chat

# Usa la key que ya tienes en THDORA .env
export GROQ_API_KEY=tu_key_de_groq

cd ~/projects/thdora
aider --model groq/llama-3.3-70b-versatile
# alias creado por setup.sh: aider-thdora
```

**Comandos dentro de Aider:**
```
/add src/bot/handlers/config.py
/add COMO_PROCEDER.md
> fix el issue #10: asyncio.wait_for timeout en _show_hab_configs
> crea test para handler borrar cita
> explica qué hace _get_api_context
/diff    → ver cambios antes de aceptar
/undo    → deshacer último cambio
```

### Paso 2: Claude Code + OpenRouter

```bash
# Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Claude Code
npm install -g @anthropic-ai/claude-code

# Apuntar a OpenRouter (gratis)
export ANTHROPIC_BASE_URL=https://openrouter.ai/api/v1
export ANTHROPIC_API_KEY=tu_key_openrouter

cd ~/projects/thdora && claude
```

**Ventaja sobre Aider:** escanea el repo entero automáticamente.

---

## BLOQUE 2 — n8n como orquestador (Mayo 2026)

```bash
# Docker + n8n en un comando
docker run -d \
  --name n8n \
  --restart unless-stopped \
  -p 5678:5678 \
  -v ~/.n8n:/root/.n8n \
  n8nio/n8n
# → http://localhost:5678
```

Ver guía completa: [`setup/n8n-docker-wsl.md`](setup/n8n-docker-wsl.md)

---

## BLOQUE 3 — Búsqueda web en THDORA (Junio 2026)

```python
# DuckDuckGo gratis, sin key
pip install duckduckgo-search

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
            {'role': 'system', 'content': f'Responde usando:\n{contexto}'},
            {'role': 'user', 'content': pregunta}
        ]
    )
    return resp.choices[0].message.content
```

---

## BLOQUE 4 — Multi-agente CrewAI (Otoño 2026)

```python
from crewai import Agent, Crew, Task

revisor = Agent(role='Code Reviewer', goal='Revisar PRs de THDORA',
                model='groq/llama-3.3-70b-versatile')
tester  = Agent(role='Test Writer', goal='Crear tests automáticamente',
                model='groq/llama-3.3-70b-versatile')

crew = Crew(agents=[revisor, tester], tasks=[...], verbose=True)
crew.kickoff()
```

```bash
pip install crewai crewai-tools
```

---

## 🗺️ Hoja de ruta completa

```
AHORA (Abril 2026)
  ├── ✅ THDORA v0.14.0 en producción
  ├── 🔧 Cerrar v4.1.0: issue #10 + Bloque 1 citas
  └── 🔧 pip install aider-chat → primer agente coding

Esta semana
  ├── Aider en THDORA — fix issue #10 con IA
  ├── Key OpenRouter (openrouter.ai) — gratis
  └── Claude Code apuntado a OpenRouter

Mayo 2026
  ├── n8n Docker en WSL
  ├── Workflow: brief nocturno → Telegram
  ├── Workflow: resumen semanal automático
  └── Workflow: alerta hábitos 22:00

Junio 2026
  ├── Búsqueda web en THDORA (DuckDuckGo + Groq)
  ├── Intent 'busqueda_web' en NLP
  └── Key Tavily (tavily.com) para mejor calidad

Otoño 2026
  ├── F15 Voz Whisper en THDORA
  ├── F14 Tracking diario (estado, sueño, puntuación)
  ├── CrewAI: revisor + tester automático
  └── Ecosistema completo 24/7
```

---

## 🔄 Ciclo 24/7 una vez montado

```
08:00  n8n → brief del día → Telegram (qué tienes hoy)
       ↓
Todo el día → THDORA escucha Telegram
            → Groq responde en <1s (750 tok/s en la nube)
            → Aider disponible en terminal cuando lo llamas
       ↓
22:00  n8n → alerta si no marcaste hábitos
       n8n → brief de mañana → Telegram
       ↓
23:00  n8n → diario automático → commit en personal repo

Consumo total: <1% CPU, ~360 MB RAM, 0€/mes
```

---

## 🔑 APIs y keys necesarias (todo gratis)

| Servicio | Para qué | Coste | Link |
|---|---|---|---|
| **Groq** | NLP THDORA + Aider + Whisper | Gratis | [console.groq.com](https://console.groq.com) |
| **OpenRouter** | Claude Code + modelos thinking | Gratis | [openrouter.ai](https://openrouter.ai) |
| **Tavily** | Búsqueda web calidad | Gratis 1000/mes | [tavily.com](https://tavily.com) |
| **Telegram Bot** | THDORA | Gratis | [@BotFather](https://t.me/BotFather) |
| **GitHub** | Repos + commits automáticos | Gratis | [github.com](https://github.com) |

---

## 📁 Estructura de repos del ecosistema

| Repo | Qué es | Regla |
|---|---|---|
| `thdora` | Tu asistente personal | Lo que **vives** y personalizas |
| `ai-toolkit` | Caja de herramientas pública | Lo que **aprendes** y generalizas |
| `personal` | Tu memoria escrita | Diarios, tracking, contexto de vida |

**La diferencia clave:** THDORA tiene tus keys reales y tu BBDD. ai-toolkit tiene plantillas con `TU_KEY` para que cualquier dev pueda usarlo.

---

## 🚀 Arrancar esta noche (cuando llegues a casa)

```bash
# 1. Instalar todo
bash <(curl -fsSL https://raw.githubusercontent.com/alvarofernandezmota-tech/ai-toolkit/main/setup.sh)
# → elegir opción 1 (todo)

# 2. Meter tus keys
nano ~/.bashrc
# descomentar GROQ_API_KEY y añadir ANTHROPIC_API_KEY

# 3. Recargar
source ~/.bashrc

# 4. Arrancar THDORA
thdora   # alias al directorio
make run-api &
make run-bot

# 5. Primer agente coding
aider-thdora   # alias directo
```

---

*Documentado: 14 abril 2026 — ecosistema diseñado, auditado y listo para ejecutar.*

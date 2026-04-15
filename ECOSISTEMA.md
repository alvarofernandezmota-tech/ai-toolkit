# 🤖 Ecosistema Personal de Agentes IA

> Agentes que trabajan para ti: en tu código, en tu vida, en tu información. Coste = 0€.
> Última actualización: **15 abril 2026**

---

## La visión

```
TÚ
 │
 ├── Telegram (THDORA)           → agente de vida: citas, hábitos, búsqueda web
 ├── Terminal (Claude Code)      → agente de código: edita repos, hace commits
 ├── Terminal (OpenCode)         → agente open source: investigación, docs, coding
 ├── n8n (self-hosted)            → orquestador: conecta todo con 400+ servicios
 └── ai-toolkit repo              → memoria: guias, diarios, contexto de todo

Todo gratis. Todo tuyo. Todo conectado.
```

### El modelo mental: BYOK (Bring Your Own Key)

Este ecosistema se construye sobre una idea sencilla: **las APIs de IA ya son gratuitas si las usas directamente**. No necesitas pagar suscripciones. Solo necesitas tus propias keys y saber cómo conectarlas.

- **OpenRouter** da acceso a DeepSeek R1, Llama 4, Qwen3 y más — gratis
- **Groq** da inferencia a 750 tokens/segundo — gratis
- **Claude Code** funciona con tu OPENROUTER_API_KEY apuntando a modelos Anthropic gratuitos
- **OpenCode** funciona igual, con cualquier modelo compatible con OpenAI API

La infraestructura ya existe. El trabajo es conectarla bien y documentar lo que funciona.

---

## Estado actual — 15 Abril 2026

| Bloque | Estado | Notas |
|---|---|---|
| THDORA bot (citas + hábitos) | ✅ Funcionando | v0.14.0 en producción |
| THDORA NLP Groq (modo Toki) | ✅ Funcionando | F13-v2, contexto real de API |
| Claude Code + OpenRouter | ✅ Funciona | Variables de entorno directas, sin ccr |
| OpenCode + DeepSeek R1 | ✅ Funciona | Config: `opencode.json` + OPENROUTER_API_KEY |
| Scripts de rotación de modelos | ✅ Listo | `scripts/model-rotate.sh` y `aider-rotate.sh` |
| setup.sh instalador | ✅ Listo | 1 comando instala todo |
| ai-toolkit docs base | ✅ Listo | Estructura completa: agentes, guias, docs, investigacion |
| Agente revisor de código | 🛠 Borrador | Generado por OpenCode, necesita prueba real |
| Agente resumen de sesión | 🛠 Borrador | Generado por OpenCode, necesita prueba real |
| Primer uso Claude Code en THDORA | 🔧 Siguiente | Bugs identificados en `agentes/thdora-primera-sesion.md` |
| n8n self-hosted | ❌ Mayo 2026 | Docker ya documentado |
| Búsqueda web en THDORA | ❌ Junio 2026 | DuckDuckGo o Tavily |
| Multi-agente CrewAI | ❌ Otoño 2026 | Diseño listo |

---

## ⚡ Consumo de recursos — ¿pesa en el ordenador?

### La respuesta corta: NO. Casi cero.

El secreto es que **la IA no corre en tu máquina** — corre en los servidores de Groq y OpenRouter. Tu ordenador solo envía texto y recibe texto.

| Pieza | CPU en uso | RAM | Dónde corre la IA |
|---|---|---|---|
| **THDORA bot** | ~0% idle | ~50 MB | Groq (en la nube, gratis) |
| **THDORA API** | ~0% idle | ~40 MB | — |
| **Claude Code** | ~0% idle | ~60 MB | OpenRouter (en la nube, gratis) |
| **OpenCode** | ~0% idle | ~40 MB | OpenRouter (en la nube, gratis) |
| **n8n Docker** | ~0% idle | ~180 MB | — |
| **TOTAL ecosistema** | **<1% CPU** | **~370 MB RAM** | — |

> Groq genera 750-1000 tokens/segundo en sus LPUs. Tu CPU no procesa nada de IA.

---

## 📊 Comparativa de agentes de coding (verificado abril 2026)

| Agente | Modelo base | Coste | Mejor para | Estado |
|---|---|---|---|---|
| **Claude Code** | claude-3.5-sonnet via OpenRouter | Gratis | Coding en repo real, leer contexto amplio | ✅ Funciona |
| **OpenCode** | DeepSeek R1 via OpenRouter | Gratis | Investigación, docs, coding | ✅ Funciona |
| **Aider** | Cualquier modelo | Gratis | Cambios rápidos en archivos concretos | ✅ Funciona |
| **Roo Code** | Cualquier modelo | Gratis (VSCode) | VSCode con interfaz gráfica | 📝 Documentado |

### Por qué Claude Code es el principal
- Entiende el repo entero sin que tengas que añadir archivos manualmente
- Hace commits, crea ramas, resuelve conflictos solo
- Con OpenRouter + modelos gratuitos es gratis

### Por qué OpenCode es el segundo
- 100% open source, sin dependencia de Anthropic
- Funciona con cualquier modelo compatible con la API de OpenAI
- DeepSeek R1 gratis es excelente para razonamiento

---

## 🧠 Modelos thinking gratuitos (abril 2026)

| Modelo | Dónde | Thinking | Velocidad | Mejor para |
|---|---|---|---|---|
| **DeepSeek R1** | OpenRouter `:free` | ✅ Sí | Lenta (30-60s) | Arquitectura, decisiones complejas |
| **Qwen3 Coder 480B** | OpenRouter `:free` | ✅ Híbrido | Media | Agente coding — el mejor open-source |
| **Llama 4 Scout** | OpenRouter `:free` | ❌ No | Media | Tareas generales rápidas |
| **Qwen3 32B** | Groq gratis | ✅ Sí | Rápida | Razonamiento rápido en terminal |
| **Llama 3.3 70B** | Groq gratis | ❌ No | Muy rápida | THDORA NLP — velocidad máxima |

**Regla de uso:**
- Tareas rápidas (THDORA, Aider diario) → `llama-3.3-70b-versatile` en Groq
- Tareas complejas (diseño, arquitectura) → `deepseek-r1:free` o `qwen3-coder` en OpenRouter

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

| Agente | Herramienta | Estado | Qué hace |
|---|---|---|---|
| 🔧 **Coding THDORA** | Claude Code + OpenRouter | 🔧 Siguiente | Edita código real, hace commits, arregla bugs |
| 🧠 **Investigación** | OpenCode + DeepSeek R1 | ✅ Funciona | Investiga temas, genera docs en MD |
| 🔍 **Revisor código** | OpenCode | 🛠 Borrador | Revisa PRs, sugiere mejoras |
| 📝 **Generador docs** | OpenCode | 🛠 Borrador | Genera ARCHITECTURE.md, docstrings |
| 🧪 **Tests** | CrewAI sub-agente | ❌ Otoño | Crea tests automáticamente |

### Agentes de orquestación (n8n — corren solos 24/7)

| Agente | Cuándo | Qué produce |
|---|---|---|
| 📓 **Diario nocturno** | 23:00 cada noche | Commit en `personal` repo con tu día |
| 📦 **Resumen semanal** | Lunes 8:00 | Informe: citas, hábitos, commits |
| ⚠️ **Alerta hábitos** | 22:00 si no los marcaste | Telegram: recordatorio |
| 🔔 **Brief mañana** | 22:00 cada noche | Telegram: qué tienes mañana |

---

## 🚀 Cómo arrancar en cada sesión

### Claude Code (agente coding principal)
```bash
# Método recomendado: variables de entorno directas
OPENAI_API_KEY="$OPENROUTER_API_KEY" \
OPENAI_BASE_URL="https://openrouter.ai/api/v1" \
claude --model anthropic/claude-3.5-sonnet

# NO uses ccr (claude-code-router) — rompe el formato de mensajes en v2.1.108+
```

### OpenCode + DeepSeek R1 (agente open source)
```bash
# Config ya guardada en ~/.config/opencode/opencode.json
OPENAI_API_KEY="$OPENROUTER_API_KEY" \
OPENAI_BASE_URL="https://openrouter.ai/api/v1" \
opencode

# Para continuar una sesión anterior:
opencode -s <session-id>  # el ID aparece en el banner al arrancar
```

Ver guía completa personal: [`guias/opencode-deepseek.md`](guias/opencode-deepseek.md)

### Aider (alternativa ligera)
```bash
bash scripts/aider-rotate.sh  # con fallback automático de modelos
```

---

## 🖥️ BLOQUE 2 — n8n como orquestador (Mayo 2026)

```bash
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

## 🌐 BLOQUE 3 — Búsqueda web en THDORA (Junio 2026)

```python
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

## 🗂️ Estructura de repos del ecosistema

| Repo | Qué es | Regla |
|---|---|---|
| `thdora` | Tu asistente personal | Lo que **vives** y personalizas |
| `ai-toolkit` | Caja de herramientas pública | Lo que **aprendes** y generalizas |
| `personal` | Tu memoria escrita | Diarios, tracking, contexto de vida |

**La diferencia clave:** THDORA tiene tus keys reales y tu BBDD. ai-toolkit tiene plantillas con `TU_KEY` para que cualquier dev pueda usarlo.

---

## 🗺️ Hoja de ruta

```
Abril 2026 (AHORA)
  ├── ✅ Claude Code + OpenRouter funcionando
  ├── ✅ OpenCode + DeepSeek R1 funcionando
  ├── ✅ Scripts rotación modelos listos
  └── 🔧 Siguiente: primer uso real de Claude Code en THDORA (bugs en agentes/thdora-primera-sesion.md)

Mayo 2026
  ├── n8n Docker en WSL
  ├── Workflow: brief nocturno → Telegram
  ├── Workflow: resumen semanal automático
  └── Workflow: alerta hábitos 22:00

Junio 2026
  ├── Búsqueda web en THDORA (DuckDuckGo + Groq)
  ├── Intent 'busqueda_web' en NLP
  └── Key Tavily para mejor calidad

Otoño 2026
  ├── F15 Voz Whisper en THDORA
  ├── F14 Tracking diario (estado, sueño, puntuación)
  ├── CrewAI: revisor + tester automático
  └── Ecosistema completo 24/7
```

---

## 🔑 APIs y keys necesarias (todo gratis)

| Servicio | Para qué | Coste | Link |
|---|---|---|---|
| **OpenRouter** | Claude Code + OpenCode + modelos thinking | Gratis | [openrouter.ai](https://openrouter.ai) |
| **Groq** | NLP THDORA + Aider + velocidad máxima | Gratis | [console.groq.com](https://console.groq.com) |
| **Tavily** | Búsqueda web calidad | Gratis 1000/mes | [tavily.com](https://tavily.com) |
| **Telegram Bot** | THDORA | Gratis | [@BotFather](https://t.me/BotFather) |
| **GitHub** | Repos + commits automáticos | Gratis | [github.com](https://github.com) |

> **La clave maestra es OPENROUTER_API_KEY.** Con ella tienes acceso a DeepSeek R1, Llama 4, Qwen3, Claude 3.5 y decenas de modelos más, todo gratis.

---

## 🔄 Ciclo 24/7 cuando esté montado

```
08:00  n8n → brief del día → Telegram
       ↓
Todo el día → THDORA escucha Telegram
             → Groq responde en <1s
             → Claude Code disponible en terminal
             → OpenCode para investigación y docs
       ↓
22:00  n8n → alerta si no marcaste hábitos
       n8n → brief de mañana → Telegram
       ↓
23:00  n8n → diario automático → commit en personal repo

Consumo total: <1% CPU, ~370 MB RAM, 0€/mes
```

---

*Documentado y actualizado: 15 abril 2026 — Claude Code + OpenCode funcionando, ecosistema base sólido, siguiente paso: usar los agentes en THDORA real.*

# 🤖 THDORA — Agente de vida personal

> THDORA es tu asistente personal en Telegram. Gestiona citas, hábitos y responde en lenguaje natural con Groq. Corre en Python con FastAPI + aiogram.

**Repo:** [github.com/alvarofernandezmota-tech/thdora](https://github.com/alvarofernandezmota-tech/thdora)

---

## Qué hace THDORA hoy (v0.14.0)

| Feature | Comando | Estado |
|---|---|---|
| **Citas** | `/citas`, `/nueva_cita` | ✅ Vivo |
| **Hábitos** | `/habitos`, `/marcar` | ✅ Vivo |
| **NLP Toki** | Lenguaje natural libre | ✅ Vivo (F13-v2) |
| **Agenda semana** | `/semana` | ✅ Vivo |
| **Contexto API** | El NLP lee datos reales | ✅ Vivo |
| **Voz Whisper** | Audio → texto → acción | ❌ F15 |
| **Búsqueda web** | Preguntas sobre el mundo | ❌ Junio 2026 |
| **Tracking diario** | Estado/sueño/puntuación | ❌ F14 |

---

## Cómo funciona por dentro

```
Usuario escribe en Telegram
        ↓
aiogram (bot Python) recibe el mensaje
        ↓
Router decide: ¿es comando? (/citas) → handler directo
               ¿es texto libre?  → NLP con Groq
        ↓
Groq (llama-3.3-70b-versatile) detecta el intent
        ↓
Handler ejecuta la acción (leer/escribir BBDD SQLite)
        ↓
Respuesta → Telegram
```

---

## Instalación y arranque

```bash
# Clonar
git clone https://github.com/alvarofernandezmota-tech/thdora ~/projects/thdora
cd ~/projects/thdora

# Instalar dependencias
pip install -r requirements.txt

# Crear .env
nano .env
```

Contenido del `.env`:
```env
TELEGRAM_TOKEN=123456:ABC-tu-token
GROQ_API_KEY=gsk_tu_key_de_groq
```

```bash
# Arrancar (dos procesos)
make run-api   # API REST en :8000
make run-bot   # Bot Telegram

# O con alias del toolkit
thdora
```

---

## Próximas features (roadmap)

### F14 — Tracking diario (Mayo 2026)

Qué añade:
- Registro de estado de ánimo (1-10)
- Registro de sueño (horas)
- Puntuación diaria calculada
- Historial y tendencias

Cómo se construye:
```bash
cd ~/projects/thdora
aider-thdora
> crea el módulo de tracking con campos: estado_animo (1-10), horas_sueno, puntuacion_dia
> añade los intents al NLP para que Toki entienda registro de estado
> crea los comandos /estado y /tracking
```

---

### F15 — Voz con Whisper (Verano 2026)

Qué añade:
- Manda un audio a THDORA
- Groq Whisper transcribe el audio
- El texto pasa al NLP → acción real

Cómo se construye:
```python
# Handler de audio en aiogram
@dp.message(F.voice)
async def handle_voice(message: Message):
    file = await bot.get_file(message.voice.file_id)
    audio_bytes = await bot.download_file(file.file_path)
    
    # Transcribir con Groq Whisper
    transcription = client.audio.transcriptions.create(
        file=('audio.ogg', audio_bytes),
        model='whisper-large-v3'
    )
    
    # Pasar al NLP como si fuera texto
    await handle_nlp(message, transcription.text)
```

---

### F16 — Búsqueda web (Junio 2026)

Qué añade:
- THDORA responde preguntas sobre el mundo real
- "¿Qué tiempo hace en Madrid?" → busca → responde
- "¿Cuándo es el próximo partido del Atleti?" → busca → responde

Cómo se construye:
```python
# Intent nuevo en NLP
# Si Groq detecta intent 'busqueda_web'

from duckduckgo_search import DDGS

async def busqueda_web(pregunta: str) -> str:
    with DDGS() as ddgs:
        resultados = list(ddgs.text(pregunta, max_results=3))
    contexto = '\n'.join([r['body'] for r in resultados])
    
    resp = groq_client.chat.completions.create(
        model='llama-3.3-70b-versatile',
        messages=[
            {'role': 'system', 'content': f'Responde en español usando: {contexto}'},
            {'role': 'user', 'content': pregunta}
        ]
    )
    return resp.choices[0].message.content
```

---

## Estructura de ficheros

```
thdora/
├── src/
│   ├── api/          # FastAPI REST endpoints
│   ├── bot/
│   │   ├── handlers/ # Un fichero por dominio (citas, habitos, nlp...)
│   │   └── router.py # Enrutador principal
│   ├── core/
│   │   ├── groq_router.py  # NLP con Groq
│   │   └── database.py     # SQLite
│   └── models/       # Modelos de datos
├── tests/            # Tests por handler
├── .env              # Keys (nunca a GitHub)
├── Makefile          # make run-api, make run-bot, make test
└── requirements.txt
```

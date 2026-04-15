# 🤖 Agente THDORA

> Agente especializado en el repo `thdora` — el bot Telegram personal.
> Contexto para OpenCode cuando trabaja en ~/thdora/

---

## Identidad del agente

Eres un agente de código especializado en el proyecto THDORA. Tu trabajo es:
- Leer, entender y modificar el código del bot Telegram
- Hacer commits limpios y descriptivos
- NO romper funcionalidades existentes
- Documentar los cambios que hagas

---

## Arquitectura de THDORA

```
thdora/
├── bot.py              # Punto de entrada — handlers de Telegram
├── agentes/            # Módulos de cada feature
│   ├── agenda.py       # Gestión de citas y calendario
│   ├── habitos.py      # Tracking de hábitos diarios
│   └── nlp.py          # NLP con Groq — interpreta mensajes
├── db/
│   └── database.py     # SQLite — citas, hábitos, datos
├── config/
│   └── settings.py     # Variables de entorno y configuración
└── tests/              # Tests unitarios
```

---

## Stack técnico

- **Python 3.11+**
- **python-telegram-bot** — framework del bot
- **Groq API** — NLP e interpretación de lenguaje natural
- **SQLite** — base de datos local
- **python-dotenv** — gestión de variables de entorno

---

## Variables de entorno (NO las toques)

```bash
TELEGRAM_BOT_TOKEN=...   # Token del bot — nunca en el código
GROQ_API_KEY=...         # Key de Groq — nunca en el código
OPENROUTER_API_KEY=...   # Para modelos avanzados
```

---

## Reglas de este agente

```
✅ Leer bot.py y el módulo relevante antes de cualquier cambio
✅ Mantener el patrón de handlers existente
✅ Añadir logging en funciones nuevas
✅ Tests para features nuevas si el tiempo lo permite
✅ Commit con formato: feat/fix/docs/refactor: descripción corta

❌ Cambiar la estructura de la BBDD sin migración
❌ Hardcodear keys o tokens
❌ Romper handlers existentes
❌ Cambiar el nombre de funciones públicas sin avisar
```

---

## Cómo arrancar este agente

```bash
cd ~/thdora

OPENAI_API_KEY="$OPENROUTER_API_KEY" \
OPENAI_BASE_URL="https://openrouter.ai/api/v1" \
opencode
```

---

## Estado actual — Abril 2026

| Feature | Estado | Notas |
|---|---|---|
| Agenda (citas) | ✅ Producción | v0.14.0 |
| Hábitos (agua, sueño, ejercicio) | ✅ Producción | Tracking diario |
| NLP Groq (modo Toki) | ✅ Producción | F13-v2 |
| Revisor de código | 🛠 Borrador | Necesita prueba real |
| Resumen de sesión | 🛠 Borrador | Necesita prueba real |
| Búsqueda web | ❌ Junio 2026 | DuckDuckGo + Groq |
| Voz Whisper | ❌ F15 | Hablas → transcribe → actúa |

---

*Ver bugs conocidos y sesión de trabajo en: `agentes/thdora-primera-sesion.md`*

# 🎯 Estrategia de escalado del ecosistema

> Documento de toma de decisiones. Aquí se define qué es público, qué es privado, y cómo se escala.

---

## La idea en una frase

**THDORA completa se queda privada. Las partes genéricas y reutilizables se extraen a un repo público open source.**

El repo público beneficia a la comunidad y da visibilidad. THDORA sigue siendo la implementación personal con datos reales.

---

## Qué va a cada sitio

### 🔒 THDORA (privado, siempre)

Todo lo que tiene que ver con datos personales reales:

- BBDD de citas, hábitos, rutinas reales
- Contexto personal (nombre, preferencias, API keys)
- Prompts afinados con contexto personal
- Toki (la personalidad del bot, construida con el tiempo)
- Integraciones con servicios personales (Google Calendar, etc.)
- Historial de conversaciones y memorias (mem0)

### 🌍 Repo público open source (nuevo repo)

Todo lo genérico que cualquiera puede usar:

- Framework base del bot de Telegram con NLP + Groq
- Sistema de gestión de citas (estructura, sin datos)
- Sistema de hábitos (estructura, sin datos)
- Integración con mem0 (memoria persistente genérica)
- Guías de modelos (lo que ya está en ai-toolkit)
- Scripts de setup del ecosistema (Aider, Claude Code, etc.)
- Documentación de arquitectura

### 🧩 ai-toolkit (este repo, público)

- Guías de modelos y benchmarks
- Investigación verificada
- Scripts reutilizables
- Registro de experimentos (sin datos personales)

---

## Hoja de ruta — por fases

### Fase 1 — Ecosistema propio (AHORA → Mayo 2026)

> **Primero construir bien para uno mismo. Luego escalar.**

**Semana 1-2 (Abril 2026):**
- [x] ai-toolkit documentado con modelos, benchmarks e investigación
- [ ] THDORA + Aider funcionando en producción
- [ ] Claude Code escaneando THDORA con Devstral 2
- [ ] Primer workflow n8n: brief diario por Telegram

**Semana 3-4 (Abril-Mayo 2026):**
- [ ] THDORA v0.15: limpieza de código lista para extraer partes
- [ ] Identificar exactamente qué partes son genéricas y extraibles
- [ ] Primeras pruebas de mem0 en rama separada

### Fase 2 — Primer repo público (Mayo-Junio 2026)

> **Extraer la capa genérica. Que otros puedan instalarlo.**

**Nombre tentativo del repo público:** `toki-bot` o `telegram-ai-assistant`

**Contenido inicial del repo público:**
- Bot Telegram base (sin datos personales)
- NLP con Groq (configurable: cualquier modelo)
- README con setup en 5 minutos
- .env.example con todas las variables necesarias
- Docker-compose para despliegue fácil
- Tests de ejemplo

**Cómo hacer la extracción:**
```bash
# Clonar THDORA
git clone thdora-privado toki-bot-publico

# Eliminar datos privados
git filter-repo --path src/core/ --path src/modules/appointments/ --path src/modules/habits/ --invert-paths  # quitar lo privado

# Añadir .env.example y README
aider-toki-bot
> escribe README.md con setup en 5 pasos y .env.example con todas las variables

# Push al nuevo repo público
git remote add origin https://github.com/alvarofernandezmota-tech/toki-bot
git push
```

### Fase 3 — Comunidad y visibilidad (Julio 2026+)

> **Cuando el repo público esté maduro.**

- Issues y PRs de la comunidad
- Publicar en Reddit r/selfhosted, r/homeassistant
- Post en dev.to sobre la arquitectura
- Evaluar si algún módulo merece ser librería independiente en PyPI

---

## Reglas de oro

1. **Primero funcionar, luego compartir.** Nada va al repo público hasta que funcione bien en THDORA.
2. **Ninguna API key ni dato personal en ningún commit público, jamas.**
3. **El repo público tiene que funcionar para cualquiera en 5 minutos.** Si no, no es el momento de publicarlo.
4. **THDORA siempre va un paso por delante.** El repo público es el pasado de THDORA, no el presente.

---

## Estado actual de cada parte

| Componente | Repo | Estado | ¿Listo para extraer? |
|---|---|---|---|
| Bot Telegram base | THDORA (privado) | ✅ Producción | Fase 2 |
| NLP + Groq | THDORA (privado) | ✅ Producción | Fase 2 |
| Gestión de citas | THDORA (privado) | ✅ Producción | Fase 2 |
| Gestión de hábitos | THDORA (privado) | ✅ Producción | Fase 2 |
| mem0 (memoria larga) | — | ⏳ Pendiente | Fase 2-3 |
| n8n workflows | — | ⏳ Pendiente | Fase 2 |
| Guías de modelos | ai-toolkit (público) | ✅ Documentado | Ya público |
| Benchmarks e investigación | ai-toolkit (público) | ✅ Documentado | Ya público |

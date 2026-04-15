# 🧠 Visión del sistema — Por qué existe esto y hacia dónde va

> Este documento es el norte. Si alguna vez no sabes qué hacer, lee esto primero.
> Escrito el 15 de abril de 2026, sesión tarde.

---

## La idea central

Este ecosistema existe por dos razones:

1. **Es una forma de estudiar haciendo.** Cada agente que construyes, cada modelo que pruebas, cada script que funciona — es conocimiento real, no teoría. La repo es el cuaderno de prácticas.

2. **Es infraestructura personal.** Los agentes trabajan para ti. Hacen commits, generan documentación, investigan temas, revisan código. Tú das órdenes de alto nivel, ellos ejecutan.

No son herramientas que usas. Son agentes que trabajan.

---

## El ciclo de vida del sistema

```
TÚ investigas un tema o una herramienta
         ↓
Lo documentas en la repo (donde toca: guias/, investigacion/, agentes/)
         ↓
Lo implementas (script, agente, config)
         ↓
Lo pruebas en real (en THDORA o en ai-toolkit)
         ↓
Lo escalas (lo conectas con el resto del ecosistema)
         ↓
La repo refleja exactamente dónde estás
         ↓
Vuelves aquí y sabes exactamente qué sigue
```

Este ciclo es el método. Cada sesión sigue este ciclo.

---

## Las cuatro capas del ecosistema

### Capa 1 — Herramientas conectadas ✅ (ya está)
Claude Code, OpenCode, Aider — funcionando con modelos gratuitos via OpenRouter y Groq.
Menu interactivo para lanzarlos.
Documentación de cómo funciona cada uno.

### Capa 2 — Menú inteligente con estado real 🔧 (esta semana)
El menú muestra:
- Qué modelos gratuitos están disponibles ahora mismo
- Rate limits restantes de cada API
- Rotación automática si un modelo está caído
- Última sesión usada y último agente activo

### Capa 3 — Agentes que escalan solos 🔧 (abril-mayo)
Das una orden de alto nivel.
El agente lee el contexto del repo (INICIO-AQUI, PENDIENTES, ECOSISTEMA).
Decide qué hacer, lo hace, hace commit.
La repo crece sola.

Ejemplos:
- "Construye el agente de documentación automática"
- "Revisa los últimos commits de THDORA y sugiere mejoras"
- "Investiga las novedades de OpenCode esta semana y docúmenta"

### Capa 4 — Automatización 24/7 ❌ (mayo con n8n)
Sin que hagas nada:
- Cada noche: diario automático → commit en la repo
- Cada mañana: brief del día → Telegram
- Cada vez que hay algo pendiente: alerta → Telegram
- Los lunes: resumen de la semana → Telegram

---

## Principios del sistema

### 1. Todo documentado donde toca
Cada herramienta tiene su guia en `guias/`.
Cada agente tiene su archivo en `agentes/`.
Cada investigación tiene su archivo en `investigacion/`.
Cada sesión tiene su entrada en `CHANGELOG.md`.
Las sesiones grandes tienen su diario en `docs/diario/`.

**Regla:** Si no está documentado, no existe.

### 2. La repo es un reflejo vivo
Lo que funciona entra en la repo.
Lo que no funciona también entra (con la solución).
La repo siempre refleja el estado real, no el estado ideal.

### 3. BYOK (Bring Your Own Key)
Todo open source. Todo gratis. Todo tuyo.
OpenRouter + Groq dan acceso a los mejores modelos sin pagar.
Ninguna dependencia de herramientas de pago.

### 4. OpenCode construye el ecosistema
La idea de bootstrapping: usas OpenCode para construir los propios agentes del ecosistema.
OpenCode lee la documentación existente, entiende el contexto, y construye lo que falta.
Es el agente constructor.

### 5. Educar y entrenar el sistema
Cada prompt que funciona bien se guarda en `prompts/`.
Cada configuración que funciona se documenta en `guias/`.
Cada error encontrado y resuelto se documenta donde toca.
El sistema mejora con cada sesión porque aprende de lo que ya hicimos.

---

## Para qué sirve más allá de ti

Lo que estás construyendo es exactamente lo que muchas empresas quieren y no saben cómo hacer:
- Un desarrollador que entiende cómo orquestar agentes IA sobre código real
- Con coste cero
- Todo open source
- Documentado y replicable

Esto es portfolio. Es conocimiento. Es un sistema que puedes replicar en cualquier proyecto.

---

## Cuando no sepas qué hacer en una sesión

1. Lee `INICIO-AQUI.md` — te dice dónde estás
2. Lee `agentes/PENDIENTES.md` — te dice qué sigue
3. Abre el menú: `bash scripts/ai-menu.sh`
4. Elige OpenCode (opción 2)
5. Dale el contexto y pídele que construya lo siguiente de PENDIENTES

El sistema se construye a sí mismo.

---

*Escrito por Álvaro Fernández Mota · 15 abril 2026*
*"Es para nosotros."*

# 🤖 El primer agente — Bootstrapping del ecosistema

> Decisión tomada: 14 abril 2026.
> El primer agente que construimos es el que nos ayuda a construir todos los demás.
> Si el primer agente es el correcto, el resto del ecosistema se construye solo.

---

## El razonamiento

```
Si construimos el agente equivocado primero:
  → Cada agente siguiente lo construimos a mano
  → El ecosistema tarda meses
  → Nos agotamos antes de llegar al final

Si construimos el agente correcto primero:
  → Ese agente nos ayuda a construir los siguientes
  → Cada agente es más fácil que el anterior
  → El ecosistema se acelera exponencialmente
  → En semanas tenemos lo que tardaría meses
```

Esto es **bootstrapping**. El mismo principio que usan los compiladores:
se compilan a sí mismos usando una versión anterior.

---

## ¿Cuál es el primer agente correcto?

### Candidatos evaluados

| Candidato | Qué haría | Ayuda a construir los demás? | Veredicto |
|---|---|---|---|
| Agente de vida (THDORA) | Citas, hábitos | No directamente | ❌ No es el primero |
| Agente de automatización (n8n) | Workflows | Sí, pero requiere n8n montado primero | ⚠️ Demasiado complejo de arrancar |
| Agente de portfolio | Mejora READMEs | Solo sirve cuando hay algo que mostrar | ⚠️ Prematuro |
| **Agente de código (Aider + Groq)** | **Escribe código en cualquier repo** | **Sí — construye TODOS los demás** | **✅ EL PRIMERO** |

### El ganador: Agente de código

**Por qué es el primero:**

1. **Puede construirse a sí mismo** — una vez que Aider funciona, le pedimos que mejore su propia configuración
2. **Construye el agente de automatización** — le pedimos que escriba los workflows de n8n
3. **Construye el agente de portfolio** — le pedimos que mejore los READMEs de todos los repos
4. **Construye el agente de orquestación** — le pedimos que escriba el código de CrewAI
5. **Mejora THDORA** — que es el laboratorio de vida real de todo el ecosistema
6. **Ya funciona hoy** — Aider + Groq están disponibles ahora mismo, gratis, sin instalar nada más

```
Agente de código (Aider)
        │
        ├───► Construye agente de automatización (escribe workflows n8n)
        ├───► Construye agente de portfolio (mejora READMEs de todos los repos)
        ├───► Construye orquestador CrewAI (escribe el código multi-agente)
        ├───► Mejora THDORA (añade mem0, búsqueda web, voz)
        └───► Se mejora a sí mismo (optimiza su propia config)
```

---

## Cómo arrancarlo (10 minutos mañana)

### Paso 1: instalar Aider

```bash
pip install aider-chat

# Verificar
aider --version
```

### Paso 2: configurar los modelos

```bash
# En ~/.bashrc o ~/.zshrc (ya debería estar si ejecutaste setup.sh)
export GROQ_API_KEY=tu_key
export OPENROUTER_API_KEY=tu_key

# Aliases del ecosistema
alias aider-fast='aider --model groq/llama-3.3-70b-versatile'   # rápido, día a día
alias aider-think='aider --model groq/qwen-qwq-32b'             # razonamiento
alias aider-code='aider --model openrouter/mistralai/devstral-2:free'  # mejor coding
```

### Paso 3: primera tarea real en THDORA

```bash
cd ~/projects/thdora
aider-fast

# Dentro de Aider:
/add src/bot/handlers/config.py
> fix el issue #10: asyncio.wait_for timeout en _show_hab_configs
```

### Paso 4: pedirle que construya el siguiente agente

```bash
# Dentro de Aider, una vez que el issue #10 esté resuelto:
> crea el fichero agents/portfolio_agent.py que recorra todos los repos
> de GitHub del usuario, lea su README actual y genere una versión mejorada
> orientada a portfolio profesional usando la API de Groq
```

---

## El orden de construcción (bootstrapping completo)

```
Semana 1 (Abril 2026)
└── 🤖 Agente de código (Aider + Groq)
    ├── Tarea 1: fix issue #10 en THDORA         ← valida que funciona
    ├── Tarea 2: mejora su propia config          ← bootstrapping puro
    └── Tarea 3: escribe agente de portfolio      ← primer agente construido por agente

Semana 2 (Abril-Mayo 2026)
└── 🏆 Agente de portfolio (construido por agente de código)
    ├── Mejora README de THDORA
    ├── Mejora README de ai-toolkit
    └── Crea GitHub profile README de Álvaro      ← portfolio activo

Semana 3 (Mayo 2026)
└── ⚙️ Agente de automatización (construido por agente de código)
    ├── Escribe workflow n8n: brief diario
    ├── Escribe workflow n8n: resumen semanal
    └── Escribe workflow n8n: alerta hábitos

Semana 4 (Mayo 2026)
└── 🧠 Agente de orquestación CrewAI (construido por agente de código)
    ├── Investigador + Desarrollador + Documentador
    └── Primer crew funcionando en un repo real

Junio 2026
└── 🔧 THDORA mejorada (por agente de código + orquestación)
    ├── mem0 integrado (memoria persistente)
    ├── Búsqueda web añadida
    └── v1.0.0 lista para extraer repo público
```

---

## La conclusión clave

**El agente de código es el multiplicador de todo lo demás.**

Cada hora que inviertas en Aider ahora te ahorra 10 horas después. No porque Aider sea mágico, sino porque:
- Cada tarea que le damos valida que funciona
- Cada agente que construye es uno que no tenemos que construir a mano
- Cada mejora que hace en ai-toolkit o THDORA es portfolio real automático

Arranca el agente de código mañana. El resto se construye solo.

---

*Decisión tomada por bootstrapping lógico: 14 abril 2026.*

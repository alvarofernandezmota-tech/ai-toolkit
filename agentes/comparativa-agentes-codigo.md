# ⚖️ Comparativa de agentes de código — Verificada Abril 2026

> Pregunta clave: ¿es Aider la mejor opción para el primer agente que construya el resto del ecosistema?
> Respuesta: depende del caso de uso. Aquí los datos reales.

Fuente principal verificada: [dev.to — Claude Code vs Cursor vs Aider 2026](https://dev.to/sameer_saleem/claude-code-vs-cursor-vs-aider-the-2026-battle-for-your-terminal-and-ide-3cb4)

---

## Tabla maestra de comparativa

| Feature | **Aider** | **Claude Code** | **Roo Code** |
|---|---|---|---|
| **Interfaz** | Terminal CLI | Terminal Agent + Shell | VS Code extension |
| **Nivel agentic** | Medio (chat-to-edit) | **Extremo (shell autónomo)** | Alto (multi-modo) |
| **Multi-repo** | ❌ NO (1 repo a la vez) | ✅ Sí | ✅ Sí |
| **MCP support** | Plugin-based | **Deep integration** | ✅ Sí |
| **Entiende el repo solo** | Parcial (tienes que /add ficheros) | ✅ Lo escanea todo solo | ✅ Sí |
| **Permisos autónomos** | Requiere confirmación manual | Configurable (can-i mode) | Configurable por modo |
| **Mejor para** | Refactoring + Git workflow estricto | **Debugging, infra, autonomy** | Dev team multi-agente |
| **Modelos compatibles** | Cualquiera (Groq, OpenRouter) | OpenRouter / Anthropic | Cualquiera |
| **Coste** | Gratis + tus APIs | Gratis + tus APIs | Gratis (open source) |
| **Hallucinations** | Muy bajo (Architect Mode) | Bajo | Medio |

---

## Veredicto por caso de uso

### Para el PRIMER AGENTE que construye el resto del ecosistema

**Ganador: Claude Code** — por goleada.

¿Por qué? Porque tiene **autonomy extrema**: escanea el repo entero solo, ejecuta comandos en el shell, decide qué ficheros tocar sin que le digas tú cuáles, y puede hacer cambios multi-fichero complejos sin intervención.

Aider es bueno cuando TÚ controlas el flujo y le dices qué hacer paso a paso. Claude Code es bueno cuando quieres que éL decida cómo hacerlo.

Para bootstrapping — que el agente construya otros agentes — necesitas el nivel más alto de autonomía. Eso es Claude Code.

### Para fixes rápidos del día a día

**Ganador: Aider** — más predecible, menos sorpresas, mejor con Groq.

Cuando sabes exactamente qué quieres cambiar y en qué fichero, Aider es más rápido y más preciso. Architect Mode de Aider (2026) primero razona, luego edita — muy baja tasa de alucinaciones.

### Para orquestar un equipo de agentes

**Ganador: Roo Code** — tiene modos especializados (Architect, Developer, Tester) y marketplace de roles.

[github.com/cline/cline](https://github.com/cline/cline) (Roo Code es un fork de Cline con multi-agente nativo).

---

## La estrategia correcta para el ecosistema de Álvaro

No elegir UNO. Usar cada uno para lo que hace mejor:

```
TAREA                          →  HERRAMIENTA CORRECTA
──────────────────────────────────────────────────────────
Bootstrapping (construir agentes) →  Claude Code (autónomo)
Escanear repo + arquitectura      →  Claude Code (lee todo solo)
Fix rápido bug concreto          →  Aider + Groq (predecible, rápido)
Refactor de 1 fichero             →  Aider + Groq (bajo error)
Thinking / decisión difícil      →  Aider + Qwen3 32B (razonamiento)
Orquestación multi-agente        →  Roo Code o CrewAI
```

---

## La limitación crítica de Aider para nuestro caso

**Aider NO puede trabajar con múltiples repos a la vez.**

Fuente: [github.com/Aider-AI/aider/issues/339](https://github.com/Aider-AI/aider/issues/339) y [aider.chat/docs/faq.html](https://aider.chat/docs/faq.html)

> “Currently aider can only work with one repo at a time.”

Para un ecosistema con THDORA + ai-toolkit + toki-bot + repos de portfolio, necesitamos algo que pueda moverse entre repos. Eso es Claude Code o Roo Code, no Aider.

---

## Decisión final verificada

| Agente | Rol en el ecosistema |
|---|---|
| **Claude Code** (con Devstral 2 / Qwen3 Coder) | **EL PRIMER AGENTE** — bootstrapping, multi-repo, autónomo |
| **Aider** (con Groq llama-3.3-70b) | Segundo plano — fixes rápidos, commits limpios, día a día |
| **Roo Code** | Futuro — cuando necesitemos equipo multi-agente en VS Code |

**El primer agente que arrancamos mañana es Claude Code, no Aider.**

Pasos para arrancar:
```bash
# 1. Instalar Claude Code (ya documentado)
npm install -g @anthropic-ai/claude-code

# 2. Apuntar a OpenRouter (gratis)
export ANTHROPIC_BASE_URL=https://openrouter.ai/api/v1
export ANTHROPIC_API_KEY=sk-or-tu_key

# 3. Arrancar en THDORA con el mejor modelo de coding
cd ~/projects/thdora
claude --model openrouter/mistralai/devstral-2:free

# 4. Primera orden de alto nivel (sin decirle qué ficheros tocar):
# > escanea el repo, entiéndelo y construye el fichero
# > agents/portfolio_agent.py que mejore los READMEs de todos mis repos de GitHub
```

---

*Investigación verificada con fuentes reales: Abril 2026.*

# 🤖 Agente AI-TOOLKIT

> Agente especializado en el repo `ai-toolkit` — la caja de herramientas pública.
> Contexto para OpenCode cuando trabaja en ~/ai-toolkit/

---

## Identidad del agente

Eres un agente de código y documentación especializado en ai-toolkit. Tu trabajo es:
- Mantener y mejorar las guías, scripts y documentación
- Generar nuevas guías cuando se aprenden cosas nuevas
- Mantener el ECOSISTEMA.md y ROADMAP.md actualizados
- Hacer este repo útil para cualquier developer

---

## Arquitectura del repo

```
ai-toolkit/
├── CEREBRO.md          # Orquestador — este es el cerebro
├── ECOSISTEMA.md       # Visión y estado del ecosistema
├── ROADMAP.md          # Hoja de ruta
├── CHANGELOG.md        # Historial de cambios
├── CLAUDE.md           # Instrucciones para Claude Code
├── ALVARO.md           # Contexto personal de Álvaro
├── agentes/            # Definiciones de agentes (este directorio)
├── guias/              # Guías paso a paso
├── scripts/            # Scripts bash reutilizables
├── prompts/            # Prompts probados y documentados
├── setup/              # Guías de instalación
├── docs/               # Documentación técnica
├── investigacion/      # Notas de investigación
├── litellm-config.yaml # Config de LiteLLM/Colmena
└── opencode.json       # Config de OpenCode
```

---

## Reglas de documentación

```
✅ Guías en formato paso a paso, con comandos reales
✅ Siempre incluir: qué hace, por qué funciona, cómo verificar
✅ Fecha de verificación en cada guía
✅ Mantener CHANGELOG.md con cada cambio relevante
✅ Este repo es PÚBLICO — no incluir keys reales nunca

❌ Guías teóricas sin comandos reales
❌ Keys, tokens o datos personales
❌ Borrar guías funcionales sin archivarlas
```

---

## Stack técnico

- **Markdown** — toda la documentación
- **Bash** — todos los scripts
- **Python** — scripts de utilidades y agentes
- **YAML** — configuraciones (litellm, opencode)

---

## Cómo arrancar este agente

```bash
cd ~/ai-toolkit

OPENAI_API_KEY="$OPENROUTER_API_KEY" \
OPENAI_BASE_URL="https://openrouter.ai/api/v1" \
opencode
```

---

*Este agente es también el Cerebro cuando se trabaja solo en este repo.*

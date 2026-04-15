# 🧠 INICIO AQUI — Cuando vuelvas al proyecto

> Este archivo es tu brujula. Si no sabes por donde empezar, empieza aqui.

---

## 📍 Donde estamos ahora (15 abril 2026)

### Lo que ya funciona ✅
- **Claude Code + OpenRouter** conectado y funcionando con modelos gratuitos
- **OpenCode + DeepSeek R1** funcionando via OpenRouter
- **Scripts de rotación de modelos** con fallback automatico
- **Estructura completa del repo**: agentes, guias, investigacion, docs, scripts
- **Documentacion base**: ECOSISTEMA.md, ESTRATEGIA.md, CLAUDE.md, ALVARO.md

### Lo que esta pendiente 🔧
- [ ] Crear el agente de coding real (ver `agentes/PENDIENTES.md`)
- [ ] Crear el agente de investigacion web real
- [ ] Crear el agente de documentacion automatica
- [ ] Primer uso real de Claude Code sobre THDORA (bugs identificados en `agentes/thdora-primera-sesion.md`)
- [ ] Guia de instalacion completa para OpenCode

### El siguiente paso concreto ➡️
Abrir `agentes/PENDIENTES.md` y elegir el primer agente que quieres construir.

---

## 🚀 Como arrancar en cada sesion

### Si vas a usar Claude Code (agente coding principal)
```bash
# Opcion 1: OpenRouter directo (recomendado)
OPENAI_API_KEY="$OPENROUTER_API_KEY" \
OPENAI_BASE_URL="https://openrouter.ai/api/v1" \
claude --model anthropic/claude-3.5-sonnet

# Opcion 2: Script con menu interactivo
bash scripts/ai-menu.sh
```

### Si vas a usar OpenCode + DeepSeek (agente investigacion/coding open source)
```bash
# Config ya guardada en ~/.config/opencode/opencode.json
OPENAI_API_KEY="$OPENROUTER_API_KEY" \
OPENAI_BASE_URL="https://openrouter.ai/api/v1" \
opencode

# Para continuar una sesion anterior:
opencode -s <session-id>
```

### Si vas a usar Aider (alternativa ligera)
```bash
bash scripts/aider-rotate.sh
# o con modelo especifico:
aider --model openrouter/deepseek/deepseek-r1:free
```

---

## 📋 Estado de los agentes

| Agente | Estado | Herramienta | Archivo |
|--------|--------|-------------|---------|
| Claude Code coding | ✅ Funciona | Claude Code + OpenRouter | `agentes/claude-code.md` |
| OpenCode + DeepSeek | ✅ Funciona | OpenCode + OpenRouter | `guias/opencode-deepseek.md` |
| Agente resumen sesion | 🛠 Borrador | OpenCode | `agentes/agente-resumen.md` |
| Agente revisor codigo | 🛠 Borrador | OpenCode | `agentes/agente-revisor-codigo.md` |
| Agente busqueda web | 📝 Documentado | Groq + Perplexity | `agentes/agente-busqueda-web.md` |
| Agente terminal | 📝 Documentado | Claude Code | `agentes/agente-codigo-terminal.md` |
| Agente multiagente CrewAI | 📝 Documentado | CrewAI | `agentes/agente-multiagente-crewai.md` |
| Agente n8n automatizacion | 📝 Documentado | n8n | `agentes/agente-n8n-automatizacion.md` |
| Agente THDORA vida | 📝 Documentado | - | `agentes/thdora-agente-vida.md` |

**Leyenda:** ✅ Funciona en produccion · 🛠 Borrador/en construccion · 📝 Solo documentado, no implementado

---

## 📖 Donde esta cada cosa

```
ai-toolkit/
├── INICIO-AQUI.md          ← Este archivo. Empieza siempre aqui
├── CHANGELOG.md            ← Que se ha hecho en cada sesion
├── ECOSISTEMA.md           ← Vision completa del ecosistema
├── ESTRATEGIA.md           ← Estrategia de escalado y negocio
├── ROADMAP.md              ← Proximos pasos a largo plazo
├── CLAUDE.md               ← Instrucciones para Claude Code
├── ALVARO.md               ← Perfil personal + vision profesional
│
├── agentes/                ← Cada agente tiene su propio MD
│   ├── PENDIENTES.md         ← Agentes por construir (TU SIGUIENTE PASO)
│   ├── claude-code.md        ← Agente principal de coding
│   └── ...
│
├── guias/                  ← Guias de instalacion y uso personal
│   └── opencode-deepseek.md  ← Como uso yo OpenCode + DeepSeek
│
├── docs/
│   └── diario/               ← Una entrada por sesion grande
│
├── scripts/                ← Scripts listos para usar
│   ├── ai-menu.sh            ← Menu interactivo para elegir agente
│   ├── model-rotate.sh       ← Rotacion automatica de modelos
│   └── aider-rotate.sh       ← Aider con fallback de modelos
│
└── investigacion/          ← Investigacion verificada con fuentes
```

---

## 🔑 Variables de entorno necesarias

```bash
# En tu .bashrc o .zshrc
export OPENROUTER_API_KEY="sk-or-..."
export ANTHROPIC_API_KEY="sk-ant-..."  # Solo si tienes cuenta de pago
export GROQ_API_KEY="gsk_..."          # Para modelos rapidos gratuitos
```

> **Nota personal:** La OPENROUTER_API_KEY es la mas importante. Con ella tienes acceso a DeepSeek R1, Llama 4, Qwen y muchos mas modelos gratis. Es la llave maestra del ecosistema.

---

## 💬 Cuando no sepas que hacer

1. Lee `ROADMAP.md` para ver el siguiente paso estrategico
2. Lee `agentes/PENDIENTES.md` para ver el siguiente agente a construir
3. Lee `docs/diario/` para recordar donde lo dejaste
4. Si hay un problema tecnico, busca en `docs/` que seguramente ya lo has resuelto antes

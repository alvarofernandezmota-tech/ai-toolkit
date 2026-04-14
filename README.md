# 🤖 AI Toolkit — Stack Open Source de IA para Devs

> Programa, automatiza y escala sin pagar suscripciones. Claude Code + OpenRouter + Ollama + n8n, coste = 0€.

Este repositorio documenta el stack completo que uso para trabajar con IA sin depender de planes de pago. Cada vez que aprendo algo nuevo, lo documento aquí para que cualquiera pueda replicarlo.

---

## 🧠 El Stack

```
TU ORDENADOR
├── Ollama          → motor de IA local (modelos corren en tu máquina)
├── Aider           → coding en terminal con cualquier modelo
├── Claude Code     → agente de coding (apuntado a modelos gratis)
└── n8n (Docker)    → automatizaciones de vida y trabajo
        ↓
INTERNET (gratis)
├── OpenRouter      → hub de modelos gratuitos vía API
├── GitHub          → repos + historial
└── Vercel          → portfolio online
```

---

## 📦 Módulos

| Carpeta | Qué encontrarás |
|---|---|
| [`/setup`](/setup) | Scripts de instalación paso a paso |
| [`/prompts`](/prompts) | Prompts para Aider, Claude Code y n8n |
| [`/workflows`](/workflows) | Automatizaciones n8n exportadas |
| [`/guias`](/guias) | Guías de cada herramienta en español |

---

## 🚀 Empezar en 3 pasos

### 1. Instala Ollama (IA local, sin API key)
```bash
curl -fsSL https://ollama.com/install.sh | sh
ollama pull gemma3:4b   # modelo ligero, bueno para código
```

### 2. Instala Aider (coding en terminal)
```bash
pip install aider-chat

# Apuntarlo a Ollama (coste 0)
aider --model ollama/gemma3:4b
```

### 3. Claude Code + OpenRouter (agente completo gratis)
```bash
npm install -g @anthropic-ai/claude-code

export ANTHROPIC_BASE_URL=https://openrouter.ai/api/v1
export ANTHROPIC_API_KEY=tu_key_de_openrouter

claude --model openrouter/auto   # rota entre modelos gratuitos
```

> Consigue tu API key gratis en [openrouter.ai](https://openrouter.ai)

---

## 💸 Coste real

| Herramienta | Alternativa de pago | Tu coste |
|---|---|---|
| Claude Code + OpenRouter | Claude Pro ($20/mes) | **0€** |
| Ollama + Gemma3 | GitHub Copilot ($10/mes) | **0€** |
| n8n self-hosted | Make / Zapier ($9-20/mes) | **0€** |
| Vercel free tier | Hosting ($5-10/mes) | **0€** |
| **Total** | **~$400-600/año** | **0€** |

---

## 🗺️ Roadmap

- [x] Stack base documentado
- [ ] Script de instalación automática (setup.sh)
- [ ] Guía completa de OpenRouter
- [ ] Workflows de n8n exportados
- [ ] Guía de despliegue del portfolio en Vercel
- [ ] Integración con THEA IA y THDORA

---

## 🔗 Parte del ecosistema

Este toolkit alimenta estos proyectos:
- [thea-ia](https://github.com/alvarofernandezmota-tech/thea-ia) — Asistente IA personal
- [thdora](https://github.com/alvarofernandezmota-tech/thdora) — Bot Telegram + Ollama
- [personal](https://github.com/alvarofernandezmota-tech/personal) — Gestión de vida

---

## 🤝 Contribuciones

Si encuentras algo útil, abre un PR o una issue. La idea es que esto crezca con la comunidad.

---

*Documentado en español para la comunidad hispana de devs que aprenden en público.*

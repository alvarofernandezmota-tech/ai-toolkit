# 🤖 ai-toolkit

> A personal ecosystem of AI agents that work for you — coding, research, automation. Cost: $0/month.

Build your own AI agent ecosystem using free APIs (OpenRouter, Groq), open source tools (Claude Code, OpenCode, Aider), and your own keys. No subscriptions. No vendor lock-in. Just your stack.

---

## What this is

A documented, working setup of AI agents for developers who want to:

- Use **Claude Code, OpenCode and Aider** with free models via OpenRouter
- Run **DeepSeek R1, Llama 4, Qwen3** without paying a cent
- Build agents that work on real codebases, generate docs, and automate repetitive tasks
- Connect everything with **n8n** for 24/7 automation

Everything here has been tested and is actually running in production.

---

## The stack

```
Your machine
 │
 ├── Claude Code → OpenRouter (free models) → coding agent
 ├── OpenCode    → OpenRouter (DeepSeek R1)  → research + docs agent
 ├── Aider       → Groq (free, 750 tok/s)   → fast code edits
 └── n8n         → self-hosted               → orchestration (coming May 2026)

Cost: $0/month. CPU: <1%. RAM: ~370 MB.
```

---

## Quick start

```bash
git clone https://github.com/alvarofernandezmota-tech/ai-toolkit
cd ai-toolkit
bash setup.sh
```

You need:
- `OPENROUTER_API_KEY` from [openrouter.ai](https://openrouter.ai) (free)
- `GROQ_API_KEY` from [console.groq.com](https://console.groq.com) (free)

---

## Running Claude Code with free models

```bash
# No paid Anthropic account needed
OPENAI_API_KEY="$OPENROUTER_API_KEY" \
OPENAI_BASE_URL="https://openrouter.ai/api/v1" \
claude --model anthropic/claude-3.5-sonnet
```

Or use the rotation script that automatically falls back across 6 free models:

```bash
bash scripts/model-rotate.sh
```

---

## Running OpenCode with DeepSeek R1

```bash
# 1. Create config (the file must be named opencode.json, not config.json)
mkdir -p ~/.config/opencode
cat > ~/.config/opencode/opencode.json << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "model": "openrouter/deepseek/deepseek-r1:free"
}
EOF

# 2. Launch
OPENAI_API_KEY="$OPENROUTER_API_KEY" \
OPENAI_BASE_URL="https://openrouter.ai/api/v1" \
opencode
```

---

## Free models worth using (April 2026)

| Model | Provider | Thinking | Best for |
|---|---|---|---|
| `deepseek/deepseek-r1:free` | OpenRouter | ✅ Yes | Architecture, complex reasoning |
| `qwen/qwen3-235b-a22b:free` | OpenRouter | ✅ Hybrid | Coding — best open source |
| `meta-llama/llama-4-scout:free` | OpenRouter | ❌ No | Fast general tasks |
| `llama-3.3-70b-versatile` | Groq | ❌ No | Maximum speed (750 tok/s) |

---

## Repo structure

```
ai-toolkit/
├── README.md               ← This file (public, for the community)
├── INICIO-AQUI.md          ← Personal dashboard (in Spanish, for the author)
├── ECOSISTEMA.md           ← Full ecosystem architecture
├── CHANGELOG.md            ← What changed in each session
├── agentes/                ← One file per agent (definition + usage)
│   └── PENDIENTES.md       ← Agents being built
├── guias/                  ← Personal usage guides
│   └── opencode-deepseek.md
├── docs/
│   └── diario/             ← Session logs
├── scripts/                ← Ready-to-use scripts
│   ├── model-rotate.sh     ← Auto-rotation across free models
│   └── aider-rotate.sh     ← Aider with Groq fallback
└── investigacion/          ← Verified research with sources
```

---

## Agents built so far

| Agent | Tool | Status |
|---|---|---|
| Coding agent | Claude Code + OpenRouter | ✅ Working |
| Research + docs agent | OpenCode + DeepSeek R1 | ✅ Working |
| Web search agent | Groq + DuckDuckGo | 📝 Documented |
| n8n automation agent | n8n self-hosted | ❌ May 2026 |
| Multi-agent orchestration | CrewAI | ❌ Autumn 2026 |

---

## Why BYOK (Bring Your Own Key)

The insight behind this project: **free AI APIs already exist if you connect them directly**. You don't need subscriptions. OpenRouter gives you access to DeepSeek R1, Llama 4, Qwen3 and more — all free — with a single API key. Groq gives you 750 tokens/second for free.

The work is in connecting them well and documenting what actually works.

---

## Contributing

This is a personal toolkit that's being built in public. If something works for you, open a PR. If something is broken or outdated, open an issue.

---

*Built and maintained by [Álvaro Fernández Mota](https://github.com/alvarofernandezmota-tech) · April 2026*

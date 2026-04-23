# AGENTS.md — Rules for OpenCode & Claude Code

> This file is read automatically by OpenCode at the start of each session.
> These are the instructions you MUST always follow, without exception.
> Last updated: 23 April 2026.

---

## 🏗️ PROJECT CONTEXT

This repo is **ai-toolkit**: AI infrastructure for an Ubuntu/WSL server.

### Current Stack (April 2026)
- **LiteLLM Colmena** — multi-model proxy at `localhost:8000`
- **OpenCode** — code agent (this program)
- **Claude Code v2.1.117** — via LiteLLM or OpenRouter directly
- **Ollama** — local models at `localhost:11434`
- **Main model** — Devstral 2 via OpenRouter (OpenCode) | groq-fallback (Claude Code)
- **Hardware** — Dell Inspiron, Intel i5, 16GB RAM, GTX 1060 6GB, WSL2 Ubuntu

### Related Repos
- `ai-toolkit` (this one) — infrastructure and documentation
- `thdora` — Telegram bot with AI (Alvaro's main project) — active branch: `feature/ui-unificada`

### The Owner
- **Álvaro** — works at night, reviews commits in the morning
- Speaks Spanish, prefers direct answers and semantic commits
- Goal: automate THDORA with AI agents

---

## 🧠 THE 4 ECOSYSTEM ENTITIES

| Entity | Type | Repo Access | Role |
|--------|------|-------------|------|
| **Álvaro** | Human | Full | Director. Makes decisions, gives context, supervises. |
| **Perplexity** | Web AI with MCP GitHub | Via API | Planning, diaries, tracking commits, audits. |
| **Claude Code (you)** | CLI agent in terminal | Direct filesystem | Execute autonomous tasks, read/write files, technical commits. |
| **Claude IA** | Web language model | None (manual context) | Reasoning, analysis, code, technical planning. |

**Flow:** Perplexity + Álvaro plan → you execute → Álvaro supervises.

---

## 🔴 RULE #1 — Files to disk, always

When a task involves creating or modifying a file:
1. USE the `Write` tool to write it **physically to disk**
2. Do NOT mark the task as `completed` until the file exists on disk
3. Verify with `Read` or `Glob` that the file was created correctly

**NEVER** mark a task as completed if you only planned it in your head.

---

## 🔴 RULE #2 — ALWAYS use repo tools for commits

For commits, use **obligatorily** the repo script, NOT git directly:

```bash
bash herramientas/git-commit-push.sh "type(scope): short description"
```

Correct examples:
- `bash herramientas/git-commit-push.sh "feat(agents): create agent-test card"`
- `bash herramientas/git-commit-push.sh "docs(diary): session 17-april documented"`
- `bash herramientas/git-commit-push.sh "fix(config): fix Ollama timeout"`

**NEVER** accumulate multiple files without committing. One commit per task.

---

## 🔴 RULE #3 — Verify before declaring success

```bash
bash herramientas/verificar-archivo.sh path/to/file.md
git log --oneline -1  # must show your commit
```

If the file doesn't exist → something failed. Repeat the Write.

---

## 🔴 RULE #4 — Computer mode / long tasks

When Álvaro says "computer mode" or "do it all":
1. Write a plan with TodoWrite BEFORE starting
2. Execute task by task in order
3. Each task = 1 file created + verify + 1 commit
4. At the end: update `CHANGELOG.md` with everything done
5. Report summary to user

---

## 🔴 RULE #5 — Create agent cards

To create new agents use **obligatorily** the script:

```bash
bash herramientas/crear-ficha-agente.sh "agent-name" "description" "tag1, tag2"
```

This automatically creates the .md in `agentes/` with the correct format.
NEVER create agent cards manually.

---

## 🟡 RULE #6 — Repo structure

```
ai-toolkit/
├── CLAUDE.md              ← your context (always read first)
├── AGENTS.md              ← your rules (this file)
├── ARQUITECTURA.md        ← ecosystem master map
├── CHANGELOG.md           ← update at end of each session
├── ROADMAP.md             ← what needs to be built
├── README.md              ← public project status
├── INICIO-AQUI.md         ← Alvaro's personal compass
├── opencode.json          ← your configuration
├── litellm-config.yaml    ← LiteLLM proxy configuration
├── scripts/               ← startup and ecosystem management
├── herramientas/          ← YOUR tools to operate the repo
│   ├── git-commit-push.sh ← USE for all commits
│   ├── crear-ficha-agente.sh ← USE for new agents
│   └── verificar-archivo.sh  ← USE to verify files
├── docs/                  ← technical documentation
├── agentes/               ← each agent's card
├── guias/                 ← usage guides
└── diario/                ← session diary (YYYY-MM-DD-moment.md)
```

---

## 🟡 RULE #7 — Available models

### Cloud via LiteLLM (available while Colmena is up)
| Model | Best use |
|-------|----------|
| `groq-fallback` | **DEFAULT for Claude Code** — Llama 3.3 70B, fast |
| `qwen/qwen3-coder:free` | **Best for code** — free via OpenRouter |
| `meta/llama-3.3-70b-instruct:free` | Reasoning, free via OpenRouter |
| `sambanova-llama4` | Llama 4 Maverick, complex tasks |
| `sambanova-deepseek` | DeepSeek R1, reasoning |

### Local (no quota, requires Ollama)
| Model | Note |
|-------|------|
| `ollama/qwen3:8b` | 6GB VRAM — default local |
| `ollama/qwen2.5-coder:14b` | code, no quota |

### If Ollama is not running
```
/model groq-fallback
```
Or start Ollama first:
```bash
ollama serve &
sleep 5
bash scripts/start-colmena.sh
```

---

## 🟢 CORRECT WORKFLOW

```
Receive task
    ↓
Read CLAUDE.md + ARQUITECTURA.md for context
    ↓
Plan with TodoWrite (in_progress)
    ↓
Write file with Write() ← MANDATORY
    ↓
bash herramientas/verificar-archivo.sh ← MANDATORY
    ↓
bash herramientas/git-commit-push.sh ← MANDATORY
    ↓
Mark task completed (TodoWrite: completed)
    ↓
Next task
```

---

## 🟢 CONFIRMED MILESTONES

- ✅ 17 abril 2026: OpenCode end-to-end confirmed (read → write → verify → commit)
- ✅ 22 abril 2026: Claude Code via OpenRouter + Devstral 2 operational
- ✅ 22 abril 2026: LiteLLM + OpenCode + Claude Code colmena running
- ✅ 23 abril 2026: 4-entity ecosystem documented, prompts prepared

---

## 🟢 SYSTEM STARTUP

```bash
# Diagnosis first:
bash scripts/check-colmena.sh

# Start from OUTSIDE tmux:
cd ~/projects/ai-toolkit
bash scripts/start-colmena.sh

# Navigate tmux panels: Ctrl+B → arrow
# Exit without closing: Ctrl+B D
# Return: tmux attach -t colmena
```

---

*Updated: 2026-04-23 — merged AGENTS.md + AGENTES.md, added 4-entity ecosystem documentation*

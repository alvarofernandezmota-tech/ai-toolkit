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
- **Claude Code v2.1.117** — via OpenRouter directly
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

## 📂 PARA STRUCTURE (since 23 April 2026)

The repo now uses the PARA method as a second brain:

```
ai-toolkit/
├── CLAUDE.md              ← Claude Code reads this first
├── AGENTS.md              ← OpenCode reads this (you are here)
├── context/               ← who Álvaro is and how the stack works
│   ├── about-alvaro.md    ← master profile, projects, rules
│   └── stack.md           ← services, models, ports, env vars
├── projects/              ← active projects with deadlines
│   ├── thdora.md          ← F9.4, open issues, next steps
│   └── ai-toolkit.md      ← current state, roadmap
├── areas/                 ← ongoing responsibilities
│   └── ia-desarrollo.md   ← KPIs, habits, horizon
├── diario/                ← session memory (YYYY-MM-DD[-moment].md)
├── agentes/               ← agent cards
├── docs/                  ← technical documentation
├── prompts/               ← prompts/commands for tasks
├── scripts/               ← automation
└── herramientas/          ← YOUR tools to operate the repo
```

**Always read at session start:**
1. `context/about-alvaro.md` — who Álvaro is, active projects, ecosystem rules
2. `context/stack.md` — services, models, env variables, ports
3. `projects/thdora.md` or `projects/ai-toolkit.md` depending on the task

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
- `bash herramientas/git-commit-push.sh "docs(diary): session 23-april documented"`
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

## 🟡 RULE #6 — Routine scripts

```bash
bash scripts/morning.sh           # start of session — services + diary + urgents
bash scripts/day-close.sh         # end of day — 3 wins + error + priority + auto commit
bash scripts/weekly-planning.sh   # every Monday — plan from ROADMAP
bash scripts/health-check.sh      # API diagnosis (auth fix included)
bash scripts/bootstrap.sh         # ecosystem status in 30s
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

### Local (no quota, requires Ollama)
| Model | Note |
|-------|------|
| `ollama/qwen3:8b` | 6GB VRAM — default local |

### If Ollama is not running
```bash
/model groq-fallback
# or start Ollama:
ollama serve &
sleep 5 && bash scripts/start-colmena.sh
```

---

## 🟢 CORRECT WORKFLOW

```
Receive task
    ↓
Read context/about-alvaro.md + context/stack.md
    ↓
Read relevant project file (projects/thdora.md etc)
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
- ✅ 23 abril 2026: PARA structure implemented — context/ projects/ areas/ scripts/

---

## 🟢 SYSTEM STARTUP

```bash
# Diagnosis first:
bash scripts/morning.sh
bash scripts/health-check.sh

# Start from OUTSIDE tmux:
cd ~/projects/ai-toolkit
bash scripts/start-colmena.sh

# Navigate tmux panels: Ctrl+B → arrow
# Exit without closing: Ctrl+B D
# Return: tmux attach -t colmena
```

---

*Updated: 2026-04-23 — PARA structure added, routine scripts documented, context/ as primary knowledge source*

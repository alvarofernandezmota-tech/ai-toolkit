# INICIO AQUÍ — ai-toolkit

> Lee esto primero cada vez que abras una nueva sesión.

---

## Estado actual — 2026-04-22 noche

| Componente | Estado | Notas |
|---|---|---|
| Claude Code v2.1.117 | ✅ Operativo | Auth fix en ~/.bashrc |
| OpenCode | ✅ Operativo | Via OpenRouter GRATIS |
| LiteLLM proxy :8000 | ⚠️ Arranca OK, health 401 | master_key activo — fix pendiente |
| OpenRouter | ✅ Key en ~/.bashrc | llama-4-maverick:free funcional |
| SSH :2222 | ✅ Operativo | IP: 10.202.77.228 |
| Ollama local | ✅ qwen3:8b | 6GB VRAM, NO usar 14B |
| Groq | ⚠️ Key caducada | Renovar en console.groq.com |
| DeepSeek | ⚠️ Key caducada | Renovar en platform.deepseek.com |
| Gemini | ⚠️ Cuota agotada | Renovar en aistudio.google.com |

---

## Arranque rápido mañana

```bash
cd ~/projects/ai-toolkit
source ~/.bashrc          # carga OPENROUTER_API_KEY y unset ANTHROPIC_API_KEY
bash scripts/start-colmena.sh --colmena-full
```

Eso abre **tmux con 3 paneles**:
- Izquierdo: Claude Code → LiteLLM → modelos
- Derecho arriba: OpenCode → OpenRouter → llama-3.3-70b free
- Derecho abajo: bash libre

---

## Modos disponibles

```bash
bash scripts/start-colmena.sh                  # colmena normal: LiteLLM + Claude Code
bash scripts/start-colmena.sh --colmena-full   # 3 paneles: Claude Code + OpenCode + bash ← PRINCIPAL
bash scripts/start-colmena.sh --opencode       # solo OpenCode (más rápido, gratis)
bash scripts/start-colmena.sh --claude-local   # Claude Code con Ollama local (qwen3:8b)
bash scripts/start-colmena.sh --claude-thdora  # Claude Code en ~/projects/thdora
bash scripts/start-colmena.sh --solo-proxy     # solo LiteLLM proxy
```

---

## Lo más urgente

1. **Arreglar health-check 401** — quitar `master_key` de `litellm-config.yaml` o pasarlo en el script
2. **Primera sesión THDORA** — `bash scripts/start-colmena.sh --claude-thdora`
3. **Renovar keys** — Groq, DeepSeek, Gemini
4. **Benchmarks** — `bash scripts/benchmark-runner.sh`

---

## Scripts disponibles

| Script | Qué hace |
|---|---|
| `scripts/start-colmena.sh` | Arranque completo (varios modos) |
| `scripts/health-check.sh` | Diagnóstico de todos los proveedores |
| `scripts/ai-menu.sh` | Menú interactivo con 12 opciones |
| `scripts/generar-diario.sh` | Genera entrada de diario desde git log |
| `scripts/benchmark-runner.sh` | Benchmarks de velocidad/calidad |
| `scripts/opencode-rotate.sh` | Rota modelos en OpenCode |

---

## Archivos clave

| Archivo | Para qué |
|---|---|
| `CLAUDE.md` | Contexto para Claude Code al arrancar |
| `AGENTS.md` | Contexto para OpenCode al arrancar |
| `ALVARO.md` | Quién eres, proyectos, decisiones |
| `litellm-config.yaml` | Config del proxy LiteLLM |
| `opencode.json` | Config de OpenCode |
| `.env.example` | Variables de entorno necesarias |
| `agentes/thdora-primera-sesion.md` | Plan para los bugs de THDORA |
| `diario/` | Registro de sesiones |

---

## Repo

- GitHub: https://github.com/alvarofernandezmota-tech/ai-toolkit
- Rama principal: `main`
- Ruta local: `~/projects/ai-toolkit`

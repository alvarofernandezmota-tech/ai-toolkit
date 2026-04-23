# INICIO AQUÍ — ai-toolkit

> Lee esto primero cada vez que abras una nueva sesión.

---

## Estado actual — 2026-04-23

| Componente | Estado | Notas |
|---|---|---|
| Claude Code v2.1.117 | ✅ Operativo | Auth fix en ~/.bashrc |
| OpenCode | ✅ Operativo | Devstral 2 via OpenRouter |
| LiteLLM proxy :8000 | ⚠️ Arranca OK, health 401 | master_key activo — fix: añadir header auth |
| OpenRouter | ✅ Key en ~/.bashrc | qwen3-coder:free + llama-3.3-70b:free confirmados |
| SSH :2222 | ✅ Operativo | IP: 10.202.77.228 |
| Ollama local | ✅ qwen3:8b | 6GB VRAM, NO usar 14B |
| Groq | ⚠️ Key caducada | Renovar en console.groq.com |
| DeepSeek | ⚠️ Key caducada | Renovar en platform.deepseek.com |
| Gemini | ⚠️ Cuota agotada | Renovar en aistudio.google.com |

---

## Arranque rápido

```bash
cd ~/projects/ai-toolkit
source ~/.bashrc          # carga OPENROUTER_API_KEY y unset ANTHROPIC_API_KEY

# Opción A: colmena completa
bash scripts/start-colmena.sh --colmena-full

# Opción B: si Ollama no está activo
ollama serve &
sleep 5
bash scripts/start-colmena.sh --colmena-full

# Opción C: solo OpenCode (más rápido, gratis)
bash scripts/start-colmena.sh --opencode
```

Eso abre **tmux con 3 paneles**:
- Izquierdo: Claude Code → LiteLLM → modelos
- Derecho arriba: OpenCode → OpenRouter → Devstral 2 free
- Derecho abajo: bash libre

---

## Si Claude Code no tiene modelo activo

```
/model groq-fallback
```
o
```
/model qwen/qwen3-coder:free
```

Modelos gratuitos confirmados (23 abril 2026):
- `qwen/qwen3-coder:free` — mejor para código
- `meta-llama/llama-3.3-70b-instruct:free` — mejor para razonamiento
- `openai/gpt-oss-120b:free` — alternativa potente
- `nvidia/nemotron-3-super-120b-a12b:free`
- `google/gemma-3-27b-it:free`

Verificar modelos disponibles:
```bash
curl -s https://openrouter.ai/api/v1/models \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" | \
  python3 -c "import sys,json; [print(m['id']) for m in json.load(sys.stdin)['data'] if ':free' in m['id']]"
```

---

## Modos disponibles

```bash
bash scripts/start-colmena.sh                  # colmena normal
bash scripts/start-colmena.sh --colmena-full   # 3 paneles ← PRINCIPAL
bash scripts/start-colmena.sh --opencode       # solo OpenCode (más rápido)
bash scripts/start-colmena.sh --claude-local   # Claude Code con Ollama local
bash scripts/start-colmena.sh --claude-thdora  # Claude Code en ~/projects/thdora
bash scripts/start-colmena.sh --solo-proxy     # solo LiteLLM proxy
bash scripts/start-colmena.sh --groq           # Claude Code via Groq directo
bash scripts/start-colmena.sh --opencode       # Claude Code via OpenRouter
```

---

## Lo más urgente

1. **Arreglar health-check 401** — añadir `-H "Authorization: Bearer sk-litellm-local"` al curl en scripts/health-check.sh
2. **Renovar keys** — Groq, DeepSeek, Gemini
3. **Ejecutar auditoría** — usar `prompts/auditoria-claude-code.md` con Claude Code + groq-fallback
4. **Crear bootstrap.sh** — estado del ecosistema en 30 segundos
5. **Primera sesión THDORA** — `bash scripts/start-colmena.sh --claude-thdora`

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
| `AGENTS.md` | Reglas para OpenCode y Claude Code |
| `ALVARO.md` | Quién eres, proyectos, decisiones |
| `litellm-config.yaml` | Config del proxy LiteLLM |
| `opencode.json` | Config de OpenCode |
| `.env.example` | Variables de entorno necesarias |
| `docs/entidades-ecosistema.md` | Las 4 entidades y su dinámica |
| `docs/plan-evolucion-ai-toolkit.md` | Plan de evolución completo |
| `prompts/contexto-claude-ia.md` | Prompt de contexto para Claude IA |
| `prompts/auditoria-claude-code.md` | Prompt de auditoría para Claude Code |
| `diario/` | Registro de sesiones |

---

## Repo

- GitHub: https://github.com/alvarofernandezmota-tech/ai-toolkit
- Rama principal: `main`
- Ruta local: `~/projects/ai-toolkit`

_Actualizado: 23 abril 2026, ~16:18 CEST — modelos free confirmados, 4 entidades documentadas, prompts preparados_

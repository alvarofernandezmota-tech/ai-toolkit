# INICIO AQUÍ — ai-toolkit

> Lee esto primero cada vez que abras una nueva sesión.

---

## Estado del stack — medido el 2026-04-23, **sin volver a comprobar**

> Esta tabla es de abril y nadie la ha medido desde entonces. Se conserva
> porque puede seguir siendo cierta, pero **no se da por buena**: lo de las
> claves caducadas y las cuotas lleva cinco meses sin mirarse.
> Se comprueba con `bash scripts/health-check.sh`, y lo que salga se escribe.

| Componente | Estado | Notas |
|---|---|---|
| OpenCode | ✅ Operativo | vía LiteLLM proxy :8000 |
| Claude Code v2.1.117 | ✅ Operativo | vía OpenRouter (Acer SSH) |
| LiteLLM proxy :8000 | ⚠️ Arranca OK, health 401 | fix pendiente: header auth |
| OpenRouter | ✅ Key en ~/.bashrc | qwen3-coder:free + llama-3.3-70b:free |
| SSH | ✅ Operativo | Desde el 2026-09-10 va por VPN mesh, puerto 22. Ver abajo |
| Ollama local | ✅ qwen3:8b | 6GB VRAM — NO usar modelos 14B |
| Kimi K2 | ✅ Añadido a opencode.json | vía LiteLLM proxy |
| Groq | ⚠️ Key caducada | Renovar en console.groq.com |
| DeepSeek | ⚠️ Key caducada | Renovar en platform.deepseek.com |
| Gemini | ⚠️ Cuota agotada | Renovar en aistudio.google.com |

---

## 🖥️ ORDENADOR GRANDE — OpenCode + LiteLLM

OpenCode es la herramienta principal en el ordenador grande.
Se conecta al proxy LiteLLM local que gestiona todos los modelos.

```
┌────────────────────┬─────────────────────┐
│                    │  LiteLLM proxy      │
│  OpenCode          │  logs/status        │
│  (izquierda)       ├─────────────────────┤
│                    │  bash libre         │
└────────────────────┴─────────────────────┘
```

### Arranque rápido

```bash
cd ~/projects/ai-toolkit
source ~/.bashrc
bash scripts/start-colmena.sh --colmena-full   # ← PRINCIPAL
```

### Modos disponibles

```bash
bash scripts/start-colmena.sh --colmena-full   # 3 paneles: OpenCode + proxy + bash
bash scripts/start-colmena.sh --opencode       # solo OpenCode (sin proxy)
bash scripts/start-colmena.sh --solo-proxy     # solo LiteLLM proxy
```

### Modelos disponibles en OpenCode

Dentro de OpenCode usa `Ctrl+X` → cambiar modelo:

| Alias | Modelo | Coste |
|---|---|---|
| `principal` | Ollama qwen3:8b → Groq → Nube | Gratis (local primero) |
| `kimi-k2` | Kimi K2 MoE 1T | OpenRouter |
| `ollama-fast` | qwen3:8b local | Gratis |
| `llama-4-scout` | Llama 4 Scout | OpenRouter free |
| `groq-fallback` | llama3.3-70b Groq | Gratis |

---

## 💻 ACER (vía SSH) — Claude Code + OpenRouter

Claude Code es la herramienta en el Acer. Se conecta directamente a
OpenRouter, sin necesitar proxy local.

> **La topología cambió el 2026-09-10.** Las dos máquinas están en una VPN
> mesh (Tailscale), así que el Acer llega al servidor **desde cualquier red**
> —incluso compartiendo datos del móvil, fuera de casa— sin abrir un puerto
> en el router y sin depender de la IP que le toque a cada una ese día.
>
> Las direcciones concretas **no se escriben aquí**: este repo es público.
> Están en el repo privado.

```
┌────────────────────┬─────────────────────┐
│                    │                     │
│  Claude Code       │  bash libre         │
│  (izquierda)       │  (git, curl, etc.)  │
│                    │                     │
└────────────────────┴─────────────────────┘
```

### Conexión SSH desde el Acer

```bash
ssh USUARIO@MAQUINA          # nombre de la máquina en la red mesh
cd ~/projects/ai-toolkit
source ~/.bashrc
bash scripts/start-colmena.sh --claude-acer   # ← PRINCIPAL
```

La línea anterior traía un usuario, una IP de LAN y un puerto fijos. Los tres
dejaron de existir — y una IP de LAN no pinta nada en un repo público, así que
tampoco se reproduce aquí para enseñar cómo estaba.

### Modos disponibles

```bash
bash scripts/start-colmena.sh --claude-acer     # 2 paneles: Claude Code + bash ← PRINCIPAL
bash scripts/start-colmena.sh --claude-thdora   # ⚠️ el repo thdora ya no existe (2026-09-10)
```

### Variables necesarias en ~/.bashrc

```bash
export OPENROUTER_API_KEY="sk-or-v1-..."
unset ANTHROPIC_API_KEY        # CRÍTICO: sin esto hay conflicto de auth
# NO setear ANTHROPIC_AUTH_TOKEN junto con ANTHROPIC_API_KEY
```

### Modelos gratuitos confirmados (OpenRouter)

```
qwen/qwen3-coder:free           ← mejor para código
meta-llama/llama-3.3-70b-instruct:free
openai/gpt-oss-120b:free
nvidia/nemotron-3-super-120b-a12b:free
google/gemma-3-27b-it:free
```

Dentro de Claude Code: `/model openrouter/qwen/qwen3-coder:free`

---

## Lo más urgente

**Pendiente de comprobar si sigue siéndolo.** Esta lista es del 23 de abril:

1. **Arreglar health-check 401** — añadir `-H "Authorization: Bearer sk-litellm-local"` al curl en `scripts/health-check.sh`
2. **Renovar keys** — Groq, DeepSeek, Gemini. Cinco meses sin mirarlo
3. **Añadir kimi-k2 a `litellm-config.yaml`** — ya está en `opencode.json`, falta el proxy
4. ~~Primera sesión THDORA~~ — **el repo `thdora` ya no existe.** Retirado el 2026-09-10

Lo primero de todo, en realidad, es correr `bash scripts/health-check.sh` y
escribir lo que salga. Los tres primeros puntos puede que ya no existan.

---

## Scripts disponibles

| Script | Qué hace |
|---|---|
| `scripts/start-colmena.sh` | Arranque completo (todos los modos) |
| `scripts/health-check.sh` | Diagnóstico de todos los proveedores |
| `scripts/ai-menu.sh` | Menú interactivo |
| `scripts/generar-diario.sh` | Genera entrada de diario desde git log |
| `scripts/benchmark-runner.sh` | Benchmarks velocidad/calidad |

---

## Archivos clave

| Archivo | Para qué |
|---|---|
| `CLAUDE.md` | Contexto automático para Claude Code |
| `AGENTS.md` | Reglas para OpenCode |
| `ALVARO.md` | Quién eres, proyectos, decisiones |
| `opencode.json` | Config de OpenCode (modelos, keybinds) |
| `litellm-config.yaml` | Config del proxy LiteLLM |
| `.env.example` | Variables de entorno necesarias |
| `prompts/contexto-claude-ia.md` | Prompt de contexto para Claude IA |
| `prompts/auditoria-claude-code.md` | Prompt de auditoría para Claude Code |
| `diario/` | Registro de sesiones |

---

## Repo

- GitHub: https://github.com/alvarofernandezmota-tech/ai-toolkit
- Rama principal: `main`
- Ruta local: `~/projects/ai-toolkit`

_Actualizado: 2026-09-10 — corregidos el acceso SSH (usuario, IP y puerto
que ya no existen), la topología de red y los pendientes que apuntaban a un
repo borrado. Lo verificado se dejó intacto: los 8 ficheros clave, los 5
scripts y los 6 modos de arranque existen todos._

_Anterior: 23 abril 2026 — OpenCode y Claude Code separados, Kimi K2 añadido, modelos 14B eliminados_

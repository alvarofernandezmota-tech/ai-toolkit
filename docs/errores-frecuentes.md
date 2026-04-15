# 🔥 Errores Frecuentes y Soluciones

> Registro vivo de errores reales encontrados en sesiones de trabajo.  
> Actualizado: 15 abril 2026 (sesión noche v2)

---

## 1. Puerto 8000 en uso — `[Errno 98] address already in use`

**Causa:** LiteLLM ya está corriendo en background (proceso previo no terminado).

**Solución:**
```bash
pkill -f litellm 2>/dev/null || true
lsof -ti :8000 | xargs kill -9 2>/dev/null || true
sleep 2
bash scripts/start-colmena.sh
```

---

## 2. Git pull falla por cambios locales — `would be overwritten by merge`

**Causa:** Se editó `litellm-config.yaml` localmente sin commit previo.

**Solución — descartar cambios locales:**
```bash
git checkout -- litellm-config.yaml && git pull
```

**Solución — guardar cambios locales:**
```bash
git stash && git pull && git stash pop
```

---

## 3. Rate limit — `429 Too Many Requests`

**Causa:** El modelo en fallbacks automáticos tenía Gemini, que se agota rápido con agentes.

**Solución permanente (ya aplicada):**  
Regla de oro: **Gemini NUNCA en fallbacks automáticos**. Solo usar con `Ctrl+P` manualmente.

**Si aparece ahora:** Esperar 60s o cambiar modelo con `Ctrl+P`.

---

## 4. Cerebras 404 — nombre de modelo incorrecto

**Error completo:**
```
litellm.NotFoundError: CerebrasException - No deployments available
```

**Causa:** El modelo `cerebras/llama3.1-70b` no existe. El nombre correcto es `cerebras/llama-3.3-70b` (con guiones).

**Modelos Cerebras válidos:**

| Modelo | Contexto | Notas |
|---|---|---|
| `cerebras/llama-3.3-70b` | 128K | ⭐ Principal recomendado |
| `cerebras/llama3.1-8b` | 8K | Solo prompts cortos |

**Ya corregido en `litellm-config.yaml`.**

---

## 5. LiteLLM zombie de otro proyecto — `thdora` corriendo en vez de `ai-toolkit`

**Síntoma:**
```
File "/home/alvaro/projects/thdora/.venv/lib/python3.10/..."
No deployments available for selected model
```

**Causa:** Hay un proceso LiteLLM arrancado desde `/projects/thdora` con un yaml viejo. `git pull` actualiza el yaml pero el proceso ya está corriendo con la config anterior.

**Solución:**
```bash
pkill -f litellm 2>/dev/null || true          # mata TODOS los litellm
lsof -ti :8000 | xargs kill -9 2>/dev/null || true
sleep 2
cd ~/projects/ai-toolkit && git pull
bash scripts/start-colmena.sh
```

> ⚠️ `pkill -f litellm` mata cualquier proceso litellm sin importar de qué proyecto venga.

---

## 6. No puedo ver logs de LiteLLM mientras uso OpenCode

**Causa:** LiteLLM y OpenCode comparten la misma terminal. Al arrancar OpenCode, los logs quedan ocultos.

**Solución permanente (ya implementada): tmux**

El script `bash scripts/start-colmena.sh` ahora usa tmux con 3 paneles:

```
┌────────────────────┬─────────────────────┐
│                    │  LOGS LiteLLM       │
│    OPENCODE        ├─────────────────────┤
│                    │  BASH LIBRE         │
└────────────────────┴─────────────────────┘
```

**Atajos tmux:**
- `Ctrl+B → ←→↑↓` — moverse entre paneles
- `Ctrl+B → D` — detach (deja todo corriendo, sales de tmux)
- `tmux attach -t colmena` — volver a la sesión
- `tmux kill-session -t colmena` — cerrar todo

---

## 7. `ContextWindowExceededError` — Groq/Cerebras rompen tareas largas

**Causa:** Groq y Cerebras tienen límite de 8192 tokens. Las tareas de agente generan 10K-20K tokens fácilmente.

**Regla práctica:**

| Tarea | Modelo recomendado |
|---|---|
| Chat rápido (<2K tokens) | `groq-fallback`, `cerebras-fallback` |
| Agente, documentación, refactor | `principal` (cerebras-3.3-70b), `deepseek-v3` |
| Razonamiento complejo | `deepseek-r1`, `gemini-pro` (manual) |

---

## 8. Prompt escrito en bash en vez de OpenCode

**Síntoma:**
```
Command 'Lee' not found
```

**Solución:** Abrir `opencode` primero, esperar la interfaz TUI, luego escribir.

---

## 🚀 Arranque limpio (referencia rápida)

```bash
sudo apt install tmux -y          # solo la primera vez
cd ~/projects/ai-toolkit
git pull
bash scripts/start-colmena.sh    # abre tmux con 3 paneles
```

> Ver `scripts/start-colmena.sh` para el script completo con tmux.

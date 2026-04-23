# THDORA — Plan primera sesión real (23 abril 2026)

Sesión de hoy: atacar bugs de THDORA con Claude Code operativo.

---

## 🎯 Objetivo de la sesión

Primera sesión real de Claude Code trabajando sobre el repo `thdora`. No es exploración — es atacar bugs concretos uno a uno.

---

## 🛠️ Stack disponible (actualizado 23 abril)

| Herramienta | Modelo | Coste | Estado |
|---|---|---|---|
| Claude Code (principal) | `anthropic/claude-sonnet-4` via OpenRouter | 💰 Créditos OR | ✅ Funciona |
| Claude Code (gratis) | `qwen/qwen3-coder:free` via OpenRouter | 🆓 Gratis | ✅ Confirmado |
| Claude Code (gratis) | `meta-llama/llama-3.3-70b-instruct:free` | 🆓 Gratis | ✅ Confirmado |
| OpenCode (alternativa) | cualquier modelo LiteLLM | 🆓/💰 | ✅ Via proxy |

> ⚠️ `qwen2.5-coder:14b` via Ollama — DESCARTADO. No cabe bien en 6GB VRAM, timeout frecuente.
> ⚠️ `anthropic/claude-sonnet-4-5` con guión — ID incorrecto, usar `claude-sonnet-4` o `claude-sonnet-4.5` con punto.

---

## 🚀 Arranque de sesión (método correcto hoy)

```bash
# 1. SSH al servidor
ssh -p 2222 alvaro@10.202.77.228

# 2. Verificar que OpenRouter key está activa
echo $OPENROUTER_API_KEY   # debe mostrar sk-or-v1-...

# 3. Ir al repo de thdora
cd ~/projects/thdora

# 4. Arrancar Claude Code con modelo gratuito OpenRouter
export ANTHROPIC_BASE_URL="https://openrouter.ai/api/v1"
export ANTHROPIC_API_KEY="$OPENROUTER_API_KEY"
claude --model anthropic/claude-sonnet-4

# Alternativa 100% gratis:
claude --model qwen/qwen3-coder:free
```

---

## 📋 Bugs prioritarios identificados en auditoría (23 abril)

### 🔴 Críticos
1. **PR #1 sin mergear** — `feat/delete-appointment` lleva ~1 mes abierto, bloquea dependencias
2. **Bug /config timeout** — `api.get_all_habit_configs()` sin timeout → bloqueo indefinido
3. **`feature/ui-unificada` no existe en remoto** — rama activa según OPENCODE.md pero no pusheada

### 🟡 Moderados
4. `cb_hab_add_value` importado en `main.py` pero no registrado como handler
5. Sin tests para `SqliteLifeManager` (backend de producción)
6. `datos/` y `data/` duplicados en raíz

---

## 📋 Protocolo de sesión

### Paso 1 — Leer CLAUDE.md de thdora
```
Lee el CLAUDE.md y lista todos los bugs documentados.
Luego priorízalos por impacto y dime cuál atacamos primero.
```

### Paso 2 — Mergear o cerrar PR #1
```
Revisa el PR #1 (feat/delete-appointment). 
¿Es safe mergearlo a main? Si sí, hazlo. Si no, dime qué falta.
```

### Paso 3 — Fix /config timeout (3 líneas)
```python
# En handlers/config.py — añadir timeout:
import asyncio
try:
    configs = await asyncio.wait_for(api.get_all_habit_configs(), timeout=10.0)
except asyncio.TimeoutError:
    await update.message.reply_text("⚠️ Timeout cargando configuración. Intenta de nuevo.")
    return ConversationHandler.END
```

### Paso 4 — Crear rama feature/ui-unificada
```bash
git checkout -b feature/ui-unificada
git push -u origin feature/ui-unificada
```

---

## 📝 Post-sesión — rellenar aquí

- [ ] PR #1 mergeado/cerrado
- [ ] Bug /config corregido
- [ ] Rama feature/ui-unificada pusheada
- [ ] Tests pasando

---

_Creado: 22 abril 2026 | Actualizado: 23 abril 2026 — Perplexity AI MCP_

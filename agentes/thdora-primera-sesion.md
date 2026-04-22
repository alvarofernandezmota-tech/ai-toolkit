# THDORA — Plan primera sesión real (23 abril 2026)

Mañana atacamos los bugs de THDORA con Claude Code + Ollama local (gratis).

---

## 🎯 Objetivo de la sesión

Primera sesión real de Claude Code trabajando sobre el repo `thdora`. No es exploración — es atacar bugs concretos uno a uno.

---

## 🛠️ Stack disponible

| Herramienta | Modelo | Coste |
|---|---|---|
| Claude Code (principal) | `qwen2.5-coder:14b` via Ollama | 🆓 Gratis |
| OpenCode (alternativa) | `devstral-2:free` via OpenRouter | 🆓 Gratis |
| Claude Code (si hace falta potencia) | `claude-sonnet-4-5` via OR | 💰 Créditos |

**Prioridad:** empezar con Ollama local. Si el modelo no llega para algo concreto, cambiar al plan B.

---

## 🚀 Arranque de sesión

```bash
# 1. SSH al servidor
ssh -p 2222 alvaro@10.202.77.228

# 2. Arrancar Ollama si no está corriendo
ollama serve &

# 3. Ir al repo de thdora
cd ~/projects/thdora

# 4. Arrancar Claude Code con Ollama
export ANTHROPIC_BASE_URL="http://localhost:11434"
export ANTHROPIC_AUTH_TOKEN="ollama"
export ANTHROPIC_API_KEY=""
claude --model qwen2.5-coder:14b

# O con el alias (si ya está en ~/.bashrc)
cc-thdora
```

---

## 📋 Protocolo de sesión

### Paso 1 — Leer CLAUDE.md de thdora
Lo primero que hace Claude Code al arrancar es leer `CLAUDE.md` de ese repo. Debe contener:
- Arquitectura del proyecto
- Lista de bugs conocidos
- Reglas de trabajo

Si `CLAUDE.md` de thdora no existe o está vacío → **crear antes de atacar bugs**.

### Paso 2 — Listar todos los bugs
Pedir a Claude Code:
```
Lee el CLAUDE.md y lista todos los bugs documentados. 
Luego priorízalos por impacto y dime cuál atacamos primero.
```

### Paso 3 — Atacar uno a uno
- Un bug por sesión o por PR
- Rama `fix/nombre-del-bug` para cada uno
- Commit descriptivo, PR pequeño
- Marcar como resuelto en CLAUDE.md de thdora

---

## ⚠️ Limitaciones conocidas de qwen2.5-coder:14b

- Contexto largo (>20k tokens): puede perder el hilo → trabajar en ficheros pequeños
- Refactorizaciones grandes: dividir en pasos
- Si falla: cambiar a `deepseek-r1:14b` para razonamiento o a OpenCode con Devstral

---

## 📝 Post-sesión

Al terminar, documentar aquí:
- Qué bugs se atacaron
- Qué funcionó / qué no
- Si Ollama fue suficiente o necesitamos créditos

---

_Creado: 22 abril 2026 — Sesión pendiente: 23 abril 2026_

# Sesión 2026-04-22 Noche — Diario completo

> Sesión larga de troubleshooting, configuración SSH, y primer arranque real de Claude Code con Ollama local (gratis).

---

## ✅ Logros de la sesión

- **Claude Code v2.1.117 operativo** con `qwen2.5-coder:14b` via Ollama local (GRATIS)
- **SSH desde Acer al PC grande** configurado y funcionando (puerto 2222)
- **start-colmena.sh** actualizado con modos `--claude-local` y `--claude-thdora`
- **CLAUDE.md** completamente reescrito con el stack real verificado
- **agentes/thdora-primera-sesion.md** creado con el plan para mañana
- **CHANGELOG.md** actualizado con toda la sesión
- **CLAUDE.md en thdora** pendiente (crear mañana)

---

## 🔧 Problemas resueltos

### 1. Cuelgue del PC por saturación de RAM
- **Causa**: Lanzar deepseek-r1:14b + qwen2.5-coder:14b simultáneamente (~18GB RAM)
- **Solución temporal**: Reinicio forzado
- **Solución permanente pendiente**:
```bash
sudo systemctl edit ollama
# [Service]
# Environment="OLLAMA_MAX_LOADED_MODELS=1"
# Environment="OLLAMA_NUM_PARALLEL=1"
```

### 2. Setup SSH Acer → PC grande (WSL2)
- IP Windows (WiFi): `10.202.77.228`
- IP WSL interna: `172.25.139.192`
- Puerto SSH WSL: `2222` (el 22 lo intercepta Windows)

```bash
# En WSL (PC grande):
sudo service ssh start
sudo sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config
sudo service ssh restart

# En PowerShell Admin (Windows):
netsh interface portproxy add v4tov4 listenport=2222 listenaddress=0.0.0.0 connectport=2222 connectaddress=172.25.139.192
netsh advfirewall firewall add rule name="SSH2222" dir=in action=allow protocol=TCP localport=2222

# Desde el Acer:
ssh -p 2222 alvaro@10.202.77.228
```

### 3. Claude Code no aceptaba modelos gratuitos de OpenRouter
- `meta-llama/llama-4-maverick:free` → funciona via curl pero Claude Code dice "model not supported"
- `anthropic/claude-sonnet-4.6` → NO existe (modelo inválido)
- `anthropic/claude-sonnet-4-5` → requiere créditos Anthropic reales en OpenRouter
- **Solución**: Ollama local como backend. Claude Code habla con `localhost:11434` usando el protocolo Anthropic que Ollama expone.

```bash
export ANTHROPIC_BASE_URL="http://localhost:11434"
export ANTHROPIC_AUTH_TOKEN="ollama"
export ANTHROPIC_API_KEY=""
claude --model qwen2.5-coder:14b
```

### 4. Conflicto ANTHROPIC_AUTH_TOKEN + ANTHROPIC_API_KEY
- Warning: "Both a token and an API key are set"
- **Causa**: `start-colmena.sh` exportaba ambas
- **Solución**: `unset ANTHROPIC_API_KEY` antes de arrancar Claude Code
- **Fix definitivo**: En `~/.bashrc` no poner `ANTHROPIC_API_KEY` cuando se usa Ollama

### 5. Modelo arrancaba como `qwen2.5-coder:14b~` (con tilde)
- **Causa**: Pegar comandos del chat dentro del prompt de Claude Code en vez del bash
- **Solución**: Salir con `/exit`, volver al bash, ejecutar los comandos allí

### 6. Claude Code decia "Not logged in"
- **Causa**: Al usar Ollama como backend, Claude Code igualmente pide autenticación inicial
- **Solución**: Ejecutar `/login` dentro de Claude Code, seguir el flujo OAuth

---

## 📦 Archivos modificados hoy

| Archivo | Cambio |
|---|---|
| `CLAUDE.md` | Reescrito completo — stack real, config Ollama, aliases |
| `scripts/start-colmena.sh` | +2 modos: `--claude-local`, `--claude-thdora` |
| `CHANGELOG.md` | Sesión completa del 22 abril documentada |
| `agentes/thdora-primera-sesion.md` | Creado — plan primera sesión thdora |
| `docs/sesion-2026-04-22-noche.md` | Este archivo |

---

## 📊 Estado del sistema al final

| Componente | Estado | Notas |
|---|---|---|
| Claude Code | ✅ v2.1.117 | Arrancado con qwen2.5-coder:14b + Ollama |
| Ollama | ✅ Corriendo | localhost:11434 |
| qwen2.5-coder:14b | ✅ Cargado | Modelo principal para coding |
| LiteLLM proxy | ✅ puerto 8000 | sesión tmux colmena |
| OpenRouter key | ✅ Activa | sk-or-v1-... confirmada |
| SSH puerto 2222 | ✅ Operativo | Acer → PC grande |
| SSH puerto 22 | ❌ Bloqueado | Windows lo intercepta |
| ANTHROPIC_API_KEY | ⚠️ Conflicto | Hacer unset para usar Ollama |
| Claude Code login | ⚠️ Pendiente | Ejecutar /login la primera vez |

---

## 📋 Pendientes inmediatos (para mañana)

- [ ] Ejecutar `/login` en Claude Code si no se hizo esta noche
- [ ] Añadir a `~/.bashrc`: alias `cc-local` y `cc-thdora` + `unset ANTHROPIC_API_KEY`
- [ ] Configurar `OLLAMA_MAX_LOADED_MODELS=1` para evitar cuelgues de RAM
- [ ] Hacer el portproxy SSH persistente (se pierde al reiniciar Windows)
- [ ] Crear `CLAUDE.md` en el repo `thdora`
- [ ] Primera sesión real de Claude Code en thdora (ver `agentes/thdora-primera-sesion.md`)

---

## 🚀 Cómo reconectar mañana

```bash
# Desde el Acer:
ssh -p 2222 alvaro@10.202.77.228

# Si la sesión tmux sigue viva:
tmux attach -t colmena

# Si no, arrancar de nuevo:
cd ~/projects/ai-toolkit
unset ANTHROPIC_API_KEY
bash scripts/start-colmena.sh --claude-local

# O ir directo a thdora:
bash scripts/start-colmena.sh --claude-thdora
```

---

_Sesión documentada: 22 abril 2026, ~23:00 CEST_

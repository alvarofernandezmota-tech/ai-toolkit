# CHANGELOG — ai-toolkit

Historial de cambios importantes del proyecto.

---

## [Unreleased]

### Pendiente
- [ ] Conectar VSCode del Acer via SSH puerto 2222
- [ ] Verificar modelos 14b con `ollama list` tras descarga
- [ ] Añadir modelos 14b a opencode.json como proveedores ollama local
- [ ] Arreglar error openclaw en `.bashrc`

---

## 2026-04-16 — Sesión servidor + Ollama local

### ✅ Añadido
- **OpenSSH Server** instalado en Windows (PC grande) — sshd corriendo en Automatic
- **Port forwarding** configurado: puerto 2222 → WSL 172.25.139.192
- **OpenSSH Server** instalado en WSL Ubuntu, configurado en puerto 2222
- **Ollama local** funcionando en WSL con GPU GTX 1060 6GB:
  - `qwen3:8b-q4_K_M` (5.2 GB) — chat general y razonamiento
  - `qwen2.5-coder:7b` (4.7 GB) — código rápido
  - `qwen2.5-coder:14b` (9.0 GB) — código potente (VRAM+RAM offload)
  - `deepseek-r1:14b` (9.0 GB) — razonamiento profundo (VRAM+RAM offload)
  - `nomic-embed-text` (274 MB) — embeddings / RAG
- **OpenCode v1.4.6** instalado en WSL, apuntando a LiteLLM Colmena + Ollama local
- **Guía completa** `guias/setup-servidor-ssh-wsl.md` documentada
- **Regla de oro** `git pull` antes de arrancar añadida a `docs/arranque-rapido.md`

### ❌ Errores encontrados
- `qwen2.5-coder:14b-q4_K_M` — nombre incorrecto para Ollama, el correcto es `qwen2.5-coder:14b`
- `deepseek-r1:14b-q4_K_M` — ídem, usar `deepseek-r1:14b`
- Error `openclaw.bash: No such file or directory` en `.bashrc` — workaround: `mkdir -p ~/.openclaw/completions && touch ~/.openclaw/completions/openclaw.bash`
- OpenCode no arranca automáticamente desde `tmux send-keys` — requiere lanzarlo manualmente o desde fuera de tmux
- `git pull` bloqueado por `opencode.json` modificado localmente — fix: `git checkout -- opencode.json`
- Descarga `qwen2.5-coder:14b` falló primera vez por timeout DNS de Cloudflare R2 — solución: reintentar

### ⚠️ Pendiente de esa sesión
- Clave SSH del Acer NO copiada (se quedó sin batería)
- VSCode Remote-SSH NO conectado aún

---

## 2026-04-15 — Setup inicial LiteLLM + OpenCode

### ✅ Añadido
- LiteLLM Colmena configurado con múltiples proveedores
- Scripts de arranque con tmux (start-colmena.sh)
- opencode.json con modelo principal y fallbacks
- Documentación agentes y guías iniciales

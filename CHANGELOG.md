# CHANGELOG — ai-toolkit

## [2026-04-17] — Sesión servidor + OpenCode primera tarea real

### ✅ Completado
- LiteLLM Colmena arrancando correctamente en puerto 8000
- OpenCode v1.4.6 instalado en WSL (`~/.npm-global/bin/opencode`)
- OpenCode corriendo con `opencode.json` del repo → apunta a LiteLLM local
- Primera tarea real ejecutada: generación de `scripts/generar-diario.sh`
- Ollama local funcionando con modelos descargados:
  - `qwen3:8b-q4_K_M` — 5.2 GB ✅
  - `qwen2.5-coder:7b` — 4.7 GB ✅
  - `nomic-embed-text` — 274 MB ✅
  - `qwen2.5-coder:14b` — 9.0 GB ✅ (descargado esta sesión)
  - `deepseek-r1:14b` — descargando al cierre
- `opencode.json` actualizado con nombres correctos de modelos Ollama
- `start-colmena.sh` corregido: PATH de npm-global incluido antes de llamar opencode
- `docs/hardware-strategy.md` creado: estrategia GPU, límites APIs gratuitas
- SSH configurado (pendiente copiar clave desde Acer)

### ⏳ En proceso al cierre
- `deepseek-r1:14b` descargando (~9 GB)
- OpenCode terminando de generar `scripts/generar-diario.sh` (modelo local tarda ~6 min)

### ❌ Pendiente próxima sesión
- Copiar clave SSH del Acer: `type $env:USERPROFILE\.ssh\id_ed25519.pub | ssh -p 2222 alvaro@10.159.182.228 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"`
- Conectar VSCode del Acer via Remote-SSH puerto 2222
- Verificar que `ollama list` muestre los 5 modelos
- Probar OpenCode con modelo más rápido (groq-fallback) para tareas cortas
- Evaluar GPU dedicada para acelerar inferencia local

---

## [2026-04-16] — Setup servidor WSL + SSH + Ollama

### ✅ Completado
- OpenSSH Server instalado en Windows (sshd corriendo, Automatic)
- Port forwarding configurado: puerto 2222 → WSL 172.25.139.192
- OpenSSH instalado también en WSL Ubuntu
- LiteLLM Colmena configurado con Ollama primero en `principal`
- `litellm-config.yaml` con todos los proveedores cloud como fallback

### ❌ Pendiente (Acer sin batería)
- Clave pública del Acer NO copiada
- VSCode Remote-SSH NO conectado

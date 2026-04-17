# CHANGELOG — ai-toolkit

## [2026-04-17 noche] — Primera sesión de trabajo autónomo nocturno

### 🌟 HITO: OpenCode trabajando de forma autónoma
- OpenCode v1.4.7 ejecutando tareas sin intervención humana
- Gemini 2.0 Flash configurado como modelo por defecto (respuesta 1-2s)
- LiteLLM Colmena con 5+ `POST /v1/chat/completions 200 OK` en paralelo
- Sistema de cola de tareas funcionando: 11 tareas planificadas esta noche

### ✅ Completado en esta sesión
- **OpenCode v1.4.7** actualizado y funcionando ✅
- **Modelo default cambiado** a `gemini-flash` — fin del cold start de Ollama ✅
- **5 fichas de agentes** creadas y subidas a `agentes/`:
  - `agentes/agente-opencode.md`
  - `agentes/agente-litellm.md`
  - `agentes/agente-ollama.md`
  - `agentes/agente-investigacion.md`
  - `agentes/agente-git-commits.md`
- **`COMO-PROCEDEMOS.md`** actualizado con lecciones del día:
  - Advertencia tmux / panel equivocado
  - El 401 en `/v1/models` es inofensivo
  - Gemini-flash como default, no principal
  - Sección de modo trabajo nocturno documentada
- **`opencode.json`** actualizado con `gemini-flash` como default
- **`agentes/PENDIENTES.md`** reorganizado con estado real

### 🤖 Tareas en cola para OpenCode esta noche (11 tareas)
1. `scripts/cerrar-sesion.sh` — commit automático con fecha ⏳
2. `docs/auditoria-repo.md` — auditoría de todos los .md ⏳
3. `CHANGELOG.md` — actualización sesión completa ⏳
4. `scripts/investigar.sh` — búsqueda automática con Perplexity ⏳
5. `agentes/agente-revisor-codigo.md` — ficha revisor para THDORA ⏳
6. `docs/pre-commit-anti-secrets.md` — protección anti-keys ⏳
7. `docs/indice.md` — índice navegable de toda la documentación ⏳
8. `guias/guia-modelos.md` — cuándo usar cada modelo ⏳
9. `README.md` — reescritura completa con estado real ⏳
10. `docs/troubleshooting.md` — guía de problemas comunes ⏳
11. `investigacion/2026-04-17-estado-arte-agentes-ia.md` ⏳

### 💡 Lecciones aprendidas hoy
- OpenCode planifica tareas bien pero necesita instrucción explícita para escribir archivos al disco
- `git push` hay que pedírselo explícitamente o hacerlo manual
- MiniMax M2.5 Free funciona como fallback cuando Gemini no responde
- El sistema de fallback de LiteLLM es robusto — siempre encuentra un modelo

### ⚠️ Nota técnica
- OpenCode marca tareas como "completed" en su plan interno aunque no haya escrito los archivos al disco
- Solución: pedir explícitamente `write_file` o hacer `git status` para verificar

---

## [2026-04-17 mañana] — Sesión servidor + OpenCode primera tarea real

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
- Copiar clave SSH del Acer
- Conectar VSCode del Acer via Remote-SSH puerto 2222
- Verificar que `ollama list` muestre los 5 modelos
- Atacar bugs de THDORA con Claude Code
- Construir `scripts/cerrar-sesion.sh` y `scripts/investigar.sh`
- RAG con `nomic-embed-text` + ChromaDB

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

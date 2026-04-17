# 🚀 INICIO AQUÍ — ai-toolkit

> Última actualización: 17 abril 2026, 02:30 CEST

Este archivo es el punto de entrada para cualquier sesión nueva. Lee esto primero.

---

## 🎯 Estado actual del sistema

| Componente | Estado | Notas |
|---|---|---|
| LiteLLM Colmena | ✅ Funcionando | Puerto 8000, `start-colmena.sh` |
| OpenCode v1.4.6 | ✅ Instalado | `~/.npm-global/bin/opencode` |
| Ollama local | ✅ Funcionando | 4-5 modelos descargados |
| SSH PC grande | ⏳ Parcial | Falta copiar clave del Acer |
| VSCode Remote-SSH | ❌ Pendiente | Depende del SSH |

---

## ⚡ Arrancar el sistema (cada sesión)

```bash
# En WSL del PC grande:
cd ~/projects/ai-toolkit
bash scripts/start-colmena.sh
```

Espera hasta ver: `✅ LiteLLM listo en :8000`

Luego en otra ventana/panel:
```bash
cd ~/projects/ai-toolkit
~/.npm-global/bin/opencode
```

---

## 📋 Próximos pasos (en orden)

1. **Verificar modelos Ollama:**
   ```bash
   ollama list
   # Deben aparecer: qwen3:8b, qwen2.5-coder:7b, qwen2.5-coder:14b, deepseek-r1:14b, nomic-embed-text
   ```

2. **Copiar clave SSH desde Acer** (necesita cargador):
   ```powershell
   type $env:USERPROFILE\.ssh\id_ed25519.pub | ssh -p 2222 alvaro@10.159.182.228 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
   ```

3. **Conectar VSCode del Acer:**
   - Host: `10.159.182.228`, Puerto: `2222`, User: `alvaro`

4. **Primera tarea OpenCode pendiente:**
   - Ver si `scripts/generar-diario.sh` se creó correctamente
   - Si no: pedir a OpenCode que lo regenere con modelo `groq-fallback` (más rápido)

---

## 🧠 Estrategia de modelos

**Ollama local = trabajo principal**
- Sin límites, sin coste, privado
- Lento sin GPU dedicada (~5-6 min en CPU para 14b)
- Con RTX 3070+ sería ~30 segundos

**APIs cloud = emergencia puntual**
- Groq: rápido pero 429 en contextos >12k tokens
- Gemini/Sambanova/Together: cuotas diarias, inestables
- Usar solo si Ollama está sobrecargado o falla

**Para tareas rápidas en OpenCode:** usar `litellm/groq-fallback` directamente

---

## 📂 Archivos clave del repo

| Archivo | Para qué |
|---|---|
| `litellm-config.yaml` | Config completa de LiteLLM con todos los modelos |
| `opencode.json` | Config de OpenCode → apunta a LiteLLM local |
| `scripts/start-colmena.sh` | Script de arranque del servidor |
| `scripts/generar-diario.sh` | Brief diario automático (generado por OpenCode) |
| `ROADMAP.md` | Qué construir y en qué orden |
| `ECOSISTEMA.md` | Arquitectura completa del sistema |
| `guias/setup-servidor-ssh-wsl.md` | Guía técnica SSH + Ollama + OpenCode |
| `docs/hardware-strategy.md` | Estrategia GPU y límites por hardware |

---

## 🐛 Problemas conocidos y soluciones

**`opencode: command not found`**
```bash
export PATH="$HOME/.npm-global/bin:$PATH"
# O usar ruta completa:
~/.npm-global/bin/opencode
```

**LiteLLM 429 en groq/gemini**
- Normal — las APIs gratuitas tienen límites
- LiteLLM hace fallback automático al siguiente modelo
- Si todo falla: Ollama local siempre responde (más lento)

**Ollama tarda mucho (>5 min)**
- Normal en CPU sin GPU dedicada
- Solución real: GPU dedicada RTX 3070/3080
- Workaround: usar modelos 7b-8b en vez de 14b para tareas rápidas

# 🏠 OpenCode + Ollama — Modelos 100% locales, 0€, sin internet

Ollama corre modelos IA en tu máquina. Combinado con LiteLLM, OpenCode puede usarlos exactamente igual que cualquier modelo de nube.

> Probado: 17 abril 2026.

---

## Por qué usar Ollama

| Situación | Usa Ollama |
|---|---|
| Sin internet / viaje | ✅ |
| Privacidad total (datos sensibles) | ✅ |
| Rate limits de todos los proveedores gratuitos agotados | ✅ |
| Contexto corto y tarea simple | ✅ |
| Razonamiento profundo o repos grandes (32K+) | ❌ Prefiere nube |

---

## Instalación (solo primera vez)

```bash
# Instalar Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# Verificar
ollama --version
```

## Descargar modelos

### Por RAM disponible

```bash
# 4-6 GB RAM → gemma3:4b (2.5 GB) — recomendado para empezar
ollama pull gemma3:4b

# 6-8 GB RAM → qwen2.5-coder:7b (4.1 GB) — mejor para código
ollama pull qwen2.5-coder:7b

# 8-16 GB RAM → deepseek-r1:8b (4.9 GB) — razonamiento local
ollama pull deepseek-r1:8b

# +16 GB RAM → qwen2.5-coder:14b — mejor coding local
ollama pull qwen2.5-coder:14b
```

### Ver modelos descargados

```bash
ollama list
```

---

## Arrancar Ollama

```bash
# Arrancar el servidor (necesario antes de usar OpenCode)
ollama serve

# O en background
ollama serve &

# Verificar que responde
curl http://localhost:11434
# → Ollama is running
```

> ⚠️ Ollama debe estar corriendo ANTES de arrancar LiteLLM.

---

## Flujo de arranque completo con modelos locales

```bash
# Terminal 1 — Ollama
ollama serve

# Terminal 2 — LiteLLM (ya tiene Ollama configurado)
cd ~/ai-toolkit
pkill -f litellm; sleep 1
litellm --config litellm-config.yaml --port 8000 &

# Terminal 2 — OpenCode (misma terminal que LiteLLM)
sleep 4 && opencode

# Dentro de OpenCode: Ctrl+P → model → "Local" o "Ollama gemma3:4b"
```

### Con tmux (más limpio)

```bash
tmux new -s local
# Panel 1: ollama serve
# Panel 2: litellm + opencode (start-colmena.sh)
```

---

## Cambiar al modelo local en OpenCode

Dos formas:

**Desde la UI:**
```
Ctrl+P → model → seleccionar "🏠 Local (Ollama default)"
```

**Cambiando el modelo por defecto en opencode.json:**
```json
{
  "model": "litellm/local"
}
```

---

## Modelos disponibles en LiteLLM desde Ollama

| Alias LiteLLM | Modelo Ollama | RAM | Mejor para |
|---|---|---|---|
| `local` | gemma3:4b | 4-6 GB | Default — general |
| `ollama-local` | gemma3:4b | 4-6 GB | Igual que local |
| `ollama-coder` | qwen2.5-coder:7b | 6-8 GB | Código |
| `ollama-r1` | deepseek-r1:8b | 8-16 GB | Razonamiento |

---

## Usar Ollama directamente sin LiteLLM

Si no tienes LiteLLM montado, puedes conectar OpenCode directo a Ollama:

```bash
# Editar temporalmente opencode.json
cat > ~/.config/opencode/opencode.json << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "model": "ollama/gemma3:4b",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama Local",
      "options": {
        "baseURL": "http://localhost:11434/v1",
        "apiKey": "ollama"
      },
      "models": {
        "gemma3:4b":          { "name": "Gemma 3 4B" },
        "qwen2.5-coder:7b":   { "name": "Qwen 2.5 Coder 7B" },
        "deepseek-r1:8b":     { "name": "DeepSeek R1 8B" }
      }
    }
  }
}
EOF

# Luego arrancar OpenCode (sin LiteLLM)
opencode
```

---

## Limitaciones conocidas de Ollama en OpenCode

| Limitación | Detalle | Workaround |
|---|---|---|
| Contexto corto | gemma3:4b = 8K tokens | Usar repos pequeños o archivos concretos |
| Lento sin GPU | CPU inference = 1-5 tok/s | Tener paciencia, o usar GPU si tienes |
| Sin tool use en algunos modelos | Afecta a funciones de agente | Usar qwen2.5-coder que sí lo soporta |
| No funciona offline la primera vez | Necesita descargar el modelo | Hacer `ollama pull` antes de salir |

---

## Diagnóstico rápido

```bash
# ¿Ollama está corriendo?
curl http://localhost:11434
# → "Ollama is running"  ✅

# ¿Qué modelos hay descargados?
ollama list

# ¿LiteLLM ve Ollama?
curl http://localhost:8000/v1/models | python3 -m json.tool | grep ollama

# Test directo a Ollama (sin LiteLLM)
curl http://localhost:11434/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"gemma3:4b","messages":[{"role":"user","content":"hola"}],"max_tokens":20}'
```

### Error frecuente: modelo no descargado

```
Error: model 'gemma3:4b' not found, try pulling it first
```

Solución:
```bash
ollama pull gemma3:4b
```

---

## Cuándo NO usar Ollama

- **Repos grandes (>8K tokens de contexto)** → Cerebras o OpenRouter
- **Razonamiento profundo** → DeepSeek R1 en nube
- **Velocidad crítica** → Groq (cuando la key esté activa)

---

*Guía verificada: 17 abril 2026 — Ollama integrado en LiteLLM Colmena*

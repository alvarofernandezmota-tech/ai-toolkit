# 🖥️ Estrategia de modelos por hardware

## Hardware actual

- **CPU**: Intel Core i5-8400 @ 2.80GHz (6 núcleos, 2018)
- **GPU**: Intel UHD 630 (integrada, ~128MB VRAM compartida)
- **Ollama**: corre en CPU pura

## ¿Por qué los modelos grandes van lentos?

Con CPU pura, `qwen2.5-coder:14b` genera ~2-3 tokens/segundo.
Una tarea de OpenCode con 8k tokens de contexto = **4-6 minutos** de espera.
Impossible distinguir "pensando" de "colgado".

## ¿Se puede forzar la GPU integrada?

Ollama soporta Intel GPU via oneAPI, pero:
- UHD 630 solo tiene ~128MB VRAM dedicada
- Requiere compilar Ollama manualmente con soporte oneAPI
- Ganancia real: ~2x velocidad (pasa de 2 a 4 tok/s)
- **No merece la pena** para este hardware

## ✅ Estrategia recomendada

### Modelos locales (Ollama) — tareas simples y rápidas

| Modelo | RAM necesaria | Velocidad CPU | Usar para |
|--------|--------------|---------------|----------|
| `qwen2.5-coder:3b` | ~2GB | ~10 tok/s | Autocompletado, snippets cortos |
| `llama3.2:3b` | ~2GB | ~10 tok/s | Preguntas rápidas |

```bash
# Cambiar a modelo ligero
ollama pull qwen2.5-coder:3b
```

### Modelos en nube (via LiteLLM) — tareas complejas

| Proveedor | Modelo | Contexto | Velocidad | Tier gratis |
|-----------|--------|----------|-----------|-------------|
| Groq | llama-3.3-70b | 128k | ~300 tok/s | ✅ Sí |
| Together | llama-4 | 1M | ~150 tok/s | ✅ Sí |
| Gemini | 2.0 Flash | 1M | ~200 tok/s | ✅ Sí |
| SambaNova | llama-3.3-70b | 128k | ~200 tok/s | ✅ Sí |

Estos modelos ya están configurados en LiteLLM como fallbacks.

## 🔧 Fix necesario: OpenCode config

OpenCode necesita `~/.config/opencode/config.json` para conectar con LiteLLM.
Sin él manda `sk-...` como placeholder → LiteLLM devuelve `401 Unauthorized`.

```bash
mkdir -p ~/.config/opencode
cat > ~/.config/opencode/config.json << 'EOF'
{
  "providers": {
    "openai": {
      "apiKey": "sk-colmena-local",
      "baseUrl": "http://localhost:8000/v1"
    }
  }
}
EOF
```

Y en LiteLLM config yaml añadir:
```yaml
general_settings:
  master_key: sk-colmena-local
```

## 📋 Conclusión del experimento (2026-04-17)

OpenCode **sí funciona de forma autónoma** con modelos en nube:
- Crea todo-lists, lee ficheros, ejecuta bash
- El problema era hardware + config faltante, no el agente

Con i5-8400: **siempre usar modelos de nube para tareas complejas**.
Local solo para autocompletado rápido con modelos 3b.

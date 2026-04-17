# 🚀 INICIO AQUÍ — Arranque rápido

> Última actualización: 2026-04-17 02:00 | Estado: ✅ TODO OPERATIVO

## Stack completo

| Componente | Puerto | Estado |
|-----------|--------|--------|
| Ollama (modelos locales) | :11434 | ✅ Operativo |
| LiteLLM Colmena (router) | :8000 | ✅ Operativo |
| OpenCode (editor IA) | — | ✅ Operativo |

## Arranque en 3 pasos

### 1. Ollama ya corre solo al iniciar (systemd)
Verificar:
```bash
curl http://localhost:11434/api/tags
```

### 2. Arrancar LiteLLM Colmena
```bash
cd ~/projects/ai-toolkit
git pull  # siempre actualizar primero

# Lanzar LiteLLM directamente (forma correcta)
pkill -f litellm 2>/dev/null; sleep 1
/home/alvaro/projects/thdora/.venv/bin/litellm \
  --config /home/alvaro/projects/ai-toolkit/litellm-config.yaml \
  --port 8000 &

# Esperar a que esté listo
for i in $(seq 1 20); do
  curl -s http://localhost:8000/health/liveliness &>/dev/null && echo '✅ LiteLLM listo en :8000' && break
  echo -n '.'; sleep 1
done
```

> ⚠️ **NOTA**: NO usar `scripts/start-colmena.sh` todavía — tiene un bug que interpreta el YAML como comandos bash. Usar el comando directo de arriba.

### 3. Arrancar OpenCode
```bash
cd ~/projects/ai-toolkit
opencode
```

## Modelos disponibles (Ollama local, sin límites)

| Modelo | Uso ideal | Tamaño |
|--------|-----------|--------|
| `qwen2.5-coder:14b` | Código, análisis repos | 9 GB |
| `deepseek-r1:14b` | Razonamiento complejo | 9 GB |
| `qwen3:8b-q4_K_M` | Tareas rápidas | 5.2 GB |
| `nomic-embed-text` | Embeddings/búsqueda | 274 MB |

## Troubleshooting

### Ollama timeout (primera petición lenta)
- **Normal**: primera petición tarda 30-60s cargando modelo en RAM
- **Fix aplicado**: `request_timeout: 120` en litellm-config.yaml ✅
- **No hacer nada** — simplemente esperar

### Groq 429 RateLimitError
- Límite TPM: 12000 tokens/min en free tier
- Con contextos grandes (>12000 tokens) falla siempre
- **Solución**: Ollama local va primero — Groq solo es fallback de emergencia

### Gemini 429 / cuota agotada
- Free tier diario agotado
- **Solución**: está al final de la cadena de fallbacks — no se usa si Ollama funciona

### start-colmena.sh da error "command not found"
- Bug conocido: el script parsea mal el YAML
- **Fix temporal**: usar el comando directo del paso 2
- **TODO**: reescribir el script (tarea pendiente)

## Próxima tarea en curso

OpenCode está creando `scripts/generar-diario.sh` — primera tarea autónoma real del agente.

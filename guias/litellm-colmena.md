# 🐝 LiteLLM Colmena — Guía Completa

> Arquitectura de load balancing entre múltiples modelos gratuitos.
> Si uno tiene rate limit, el siguiente coge la tarea automáticamente.

---

## ¿Qué es la arquitectura colmena?

```
OpenCode
    ↓
LiteLLM Proxy (localhost:4000 o 7090)
    ↓
┌─────────────────────────────────────┐
│     Router — least-busy strategy    │
├──────────┬──────────┬───────┬───────┤
│  Google  │  Groq    │Cerebras│OpenR │
│  Gemini  │ llama3.3 │llama8b│DeepS │
│  (1M ctx)│ (12K)    │ (8K)  │(164K)│
└──────────┴──────────┴───────┴───────┘
```

Todos los modelos comparten el nombre `principal`.
LiteLLM distribuye cada request al modelo con menos carga en ese momento.

---

## Instalación (solo primera vez)

```bash
# Dentro del venv de thdora o ai-toolkit
pip install litellm[proxy]
```

---

## Arranque — TODO EN UNA SOLA TERMINAL

```bash
cd ~/projects/ai-toolkit

# 1. Arrancar LiteLLM en background (& lo manda al fondo)
litellm --config litellm-config.yaml --port 4000 &

# 2. Esperar 3 segundos
sleep 3

# 3. Arrancar OpenCode en la misma terminal
opencode
```

El `&` es la clave — LiteLLM corre detrás sin ocupar la terminal.

---

## Configuración OpenCode para usar LiteLLM

```bash
cat > ~/.config/opencode/opencode.json << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "model": "openai/principal",
  "baseURL": "http://localhost:4000",
  "apiKey": "sk-litellm-local"
}
EOF
```

> ⚠️ El puerto puede variar (4000 o 7090) — usar el que aparezca en el log de arranque de LiteLLM.

---

## Variables de entorno necesarias

```bash
# En ~/.bashrc
export GOOGLE_GENERATIVE_AI_API_KEY="tu-key"
export GROQ_API_KEY="tu-key"
export CEREBRAS_API_KEY="tu-key"
export OPENROUTER_API_KEY="tu-key"
```

---

## Gestionar procesos en background

```bash
# Ver procesos corriendo en background
jobs

# Traer LiteLLM al frente (si necesitas verlo)
fg %1

# Mandarlo de nuevo al fondo
# Ctrl+Z luego:
bg %1

# Matar LiteLLM si necesitas reiniciarlo
kill %1
# o
pkill -f litellm
```

---

## Uso con tmux (para ver ambos a la vez)

```bash
# Crear nueva sesión tmux
tmux new -s ai

# Dividir pantalla horizontalmente
Ctrl+B luego "

# Moverse entre paneles
Ctrl+B luego flecha arriba/abajo

# Panel superior: LiteLLM
litellm --config litellm-config.yaml --port 4000

# Panel inferior: OpenCode
opencode
```

Atajos tmux útiles:
- `Ctrl+B C` → nueva ventana
- `Ctrl+B 0` → ir a ventana 0
- `Ctrl+B 1` → ir a ventana 1
- `Ctrl+B "` → dividir horizontalmente
- `Ctrl+B %` → dividir verticalmente
- `Ctrl+B D` → desconectar sesión (sigue corriendo)
- `tmux attach -t ai` → reconectar

> ⚠️ IMPORTANTE: `Ctrl+B C` NO es para cerrar — es para crear ventana nueva.
> Para cerrar una ventana: `Ctrl+B &` o escribir `exit`

---

## Script de arranque rápido

Guardado en `scripts/start-colmena.sh`:

```bash
#!/bin/bash
cd ~/projects/ai-toolkit
git pull  # siempre actualizar antes
litellm --config litellm-config.yaml --port 4000 &
echo "⏳ Esperando que LiteLLM arranque..."
sleep 4
echo "✅ LiteLLM corriendo en background"
echo "🚀 Abriendo OpenCode..."
opencode
```

---

## Modelos del pool principal

| Modelo | Proveedor | Contexto | Mejor para |
|---|---|---|---|
| `gemini/gemini-2.0-flash` | Google AI | 1M tokens | Repos grandes, tareas largas |
| `groq/llama-3.3-70b-versatile` | Groq | 12K | Velocidad máxima, prompts cortos |
| `cerebras/llama3.1-8b` | Cerebras | 8K | Velocidad alta, prompts medios |
| `openrouter/deepseek-r1:free` | OpenRouter | 164K | Fallback gratuito |

---

## Logs y diagnóstico

```bash
# Ver si LiteLLM está corriendo
curl http://localhost:4000/health

# Ver modelos disponibles
curl http://localhost:4000/v1/models

# Test manual de una request
curl http://localhost:4000/v1/chat/completions \
  -H "Authorization: Bearer sk-litellm-local" \
  -H "Content-Type: application/json" \
  -d '{"model": "principal", "messages": [{"role": "user", "content": "hola"}]}'
```

---

## Problemas conocidos

| Problema | Causa | Solución |
|---|---|---|
| Puerto 4000 ocupado | Otra instancia corriendo | `pkill -f litellm` y reiniciar |
| `command not found: litellm` | No está en PATH | `python3 -m litellm --config ...` |
| Modelos no aparecen | Config no actualizado | `git pull` antes de arrancar |
| OpenCode no conecta | Puerto incorrecto | Verificar puerto en log de LiteLLM |

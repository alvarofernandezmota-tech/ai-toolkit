# 🐝 LiteLLM Colmena — Guía Completa

> Arquitectura de load balancing entre múltiples modelos gratuitos.
> Si uno tiene rate limit, el siguiente coge la tarea automáticamente.

---

## ¿Qué es la arquitectura colmena?

```
OpenCode
    ↓
LiteLLM Proxy (localhost:4000)
    ↓
┌─────────────────────────────────────┐
│     Router — least-busy strategy    │
├──────────┬──────────┬───────┬───────┤
│  Google  │  Groq    │Cerebras│OpenR │
│  Gemini  │ llama3.3 │llama8b│DeepS │
│  (1M ctx)│ (12K)    │ (8K)  │(164K)│
└──────────┴──────────┴───────┴───────┘
```

---

## Instalación (solo primera vez)

```bash
pip install litellm[proxy]
```

---

## Arranque — TODO EN UNA SOLA TERMINAL

```bash
cd ~/projects/ai-toolkit

# Matar instancias previas
pkill -f litellm 2>/dev/null; sleep 1

# Arrancar LiteLLM en background
litellm --config litellm-config.yaml --port 4000 &

# Esperar a que arranque
sleep 4

# Abrir OpenCode
opencode
```

---

## Configuración OpenCode para LiteLLM — SINTAXIS CORRECTA

```bash
cat > ~/.config/opencode/opencode.json << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "model": "openai/principal",
  "providers": {
    "openai": {
      "api": "http://localhost:4000",
      "apiKey": "sk-litellm-local"
    }
  }
}
EOF
```

> ⚠️ `baseURL` y `apiKey` en raíz NO funcionan — usar siempre bloque `providers.openai`

> ⚠️ Verificar el puerto en el log de LiteLLM: `Uvicorn running on http://0.0.0.0:XXXX`

---

## Variables de entorno necesarias

```bash
# En ~/.bashrc
export GOOGLE_GENERATIVE_AI_API_KEY="tu-key"  # OJO: no GOOGLE_API_KEY
export GROQ_API_KEY="tu-key"
export CEREBRAS_API_KEY="tu-key"
export OPENROUTER_API_KEY="tu-key"
```

---

## Gestionar procesos en background

```bash
jobs              # ver procesos background
fg %1             # traer LiteLLM al frente
bg %1             # mandarlo de nuevo al fondo
pkill -f litellm  # matar LiteLLM
```

---

## Uso con tmux (pantalla dividida)

```bash
tmux new -s ai    # nueva sesión
Ctrl+B "          # dividir horizontalmente
# Panel arriba: litellm --config litellm-config.yaml --port 4000
# Panel abajo: opencode
```

Atajos tmux:
- `Ctrl+B C` → nueva ventana (NO cierra la actual)
- `Ctrl+B 0/1` → cambiar ventana
- `Ctrl+B "` → dividir horizontal
- `Ctrl+B %` → dividir vertical
- `Ctrl+B D` → desconectar (sigue corriendo)
- `tmux attach -t ai` → reconectar

---

## Diagnóstico

```bash
# Verificar que LiteLLM responde
curl http://localhost:4000/health

# Ver modelos disponibles
curl http://localhost:4000/v1/models

# Test rápido
curl http://localhost:4000/v1/chat/completions \
  -H "Authorization: Bearer sk-litellm-local" \
  -H "Content-Type: application/json" \
  -d '{"model": "principal", "messages": [{"role": "user", "content": "hola"}]}'
```

---

## Problemas conocidos

| Problema | Causa | Solución |
|---|---|---|
| Puerto 4000 ocupado | Otra instancia | `pkill -f litellm` |
| Puerto aleatorio en log | Conflicto de puertos | Leer puerto real en log |
| `command not found: litellm` | No en PATH | `python3 -m litellm --config ...` |
| `Unrecognized keys: baseURL` | Sintaxis incorrecta | Usar bloque `providers.openai` |
| Modelos no aparecen | Config desactualizado | `git pull` antes de arrancar |

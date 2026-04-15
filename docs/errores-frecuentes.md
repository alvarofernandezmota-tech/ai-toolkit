# 🔥 Errores Frecuentes y Soluciones

> Registro vivo de errores reales encontrados en sesiones de trabajo.  
> Actualizado: 15 abril 2026 (sesión noche)

---

## 1. Puerto 8000 en uso — `[Errno 98] address already in use`

**Error completo:**
```
ERROR: [Errno 98] error while attempting to bind on address ('0.0.0.0', 8000): address already in use
INFO:  Waiting for application shutdown.
INFO:  Application shutdown complete.
```

**Causa:** LiteLLM ya está corriendo en background (proceso previo no terminado).

**Solución rápida:**
```bash
pkill -f litellm && sleep 2 && litellm --config litellm-config.yaml --port 8000 &
```

**Solución manual si persiste:**
```bash
lsof -i :8000        # Ver qué PID usa el puerto
kill -9 <PID>        # Matar ese proceso
```

---

## 2. Git pull falla por cambios locales — `would be overwritten by merge`

**Error completo:**
```
error: Your local changes to the following files would be overwritten by merge:
        litellm-config.yaml
Please commit your changes or stash them before you merge.
Aborting
```

**Causa:** Se editó `litellm-config.yaml` localmente (o se regeneró) sin hacer commit antes del pull.

**Solución — descartar cambios locales y quedarse con el repo:**
```bash
git checkout -- litellm-config.yaml && git pull
```

**Solución — guardar cambios locales y luego hacer pull:**
```bash
git stash && git pull && git stash pop
```

> ⚠️ Usa `git checkout -- <archivo>` sólo si los cambios locales son descartables. Si son importantes, haz `git stash`.

---

## 3. Rate limit / No deployments — `429 Too Many Requests`

**Error completo:**
```
litellm.RateLimitError: No deployments available for selected model, Try again in 60 seconds.
litellm.proxy.proxy_server: Exception occured - No deployments available
```

**Causa:** El modelo `principal` (Gemini Flash) o un fallback alcanzó el rate limit del proveedor. LiteLLM pone en cooldown el deployment por 60 segundos.

**Soluciones:**
1. Esperar 60 segundos y reintentar.
2. Cambiar de modelo en OpenCode: `Ctrl+P` → buscar `model` → seleccionar otro (ej: `deepseek-r1`, `claude-sonnet`).
3. Reiniciar LiteLLM para limpiar cooldowns:
   ```bash
   pkill -f litellm && sleep 2 && litellm --config litellm-config.yaml --port 8000 &
   ```

**Modelos de fallback recomendados cuando `principal` está en cooldown:**

| Modelo | Proveedor | Límite gratuito |
|---|---|---|
| `deepseek-r1` | DeepSeek | Generoso |
| `gemini-flash-lite` | Google | Alto |
| `groq-fallback` | Groq | Rápido pero bajo RPM |
| `cerebras-fallback` | Cerebras | Rápido pero bajo RPM |

---

## 4. Prompt escrito en la terminal en vez de en OpenCode

**Síntoma:**
```
Command 'Lee' not found, did you mean:
  command 'ree' from deb ree...
```

**Causa:** Se escribió el prompt de OpenCode directamente en la terminal bash, fuera de la interfaz de OpenCode.

**Solución:** Abrir OpenCode primero:
```bash
opencode
```
Esperar a que cargue la interfaz TUI completa (logo + campo de texto), y **entonces** escribir el prompt.

---

## 5. LiteLLM no arranca — `[7]+ Exit 1` al iniciar en background

**Síntoma:**
```
[7]+  Exit 1    sleep 2 && litellm --config litellm-config.yaml --port 8000
```

**Causas posibles:**
- El `sleep 2` precedente falló (proceso anterior no terminó)
- El config YAML tiene errores de sintaxis
- Las API keys no están exportadas en el entorno

**Diagnóstico:**
```bash
# Ver el error real sin background
litellm --config litellm-config.yaml --port 8000

# Verificar que las keys están disponibles
echo $GOOGLE_GENERATIVE_AI_API_KEY
echo $ANTHROPIC_API_KEY
```

**Solución:** Arrancar LiteLLM en primer plano para ver el error completo, corregirlo y luego mandarlo a background con `&`.

---

## Procedimiento de arranque limpio (referencia rápida)

Para evitar todos estos errores, usar siempre esta secuencia:

```bash
cd ~/projects/ai-toolkit
git pull                                              # 1. Actualizar repo
pkill -f litellm 2>/dev/null; sleep 2                # 2. Matar procesos previos
litellm --config litellm-config.yaml --port 8000 &   # 3. Arrancar proxy
sleep 3 && opencode                                   # 4. Abrir OpenCode
```

> Ver `docs/arranque-rapido.md` para la versión completa con todos los modelos disponibles.

# APIs verificadas — Test real 15 abril 2026

> Resultado de tests `curl` reales ejecutados en la máquina de desarrollo.
> Usar esta info para configurar rotación de modelos.

---

## Resultados del test

| API | Modelo | HTTP | Estado | ID para curl | ID para OpenCode |
|---|---|---|---|---|---|
| Groq | llama-3.3-70b-versatile | 200 | ✅ OK | `llama-3.3-70b-versatile` | `groq/llama-3.3-70b-versatile` |
| Cerebras | llama3.1-8b | 200 | ✅ OK | `llama3.1-8b` | `cerebras/llama3.1-8b` |
| OpenRouter | deepseek/deepseek-r1:free | 404 | ❌ Caído ese día | igual | `openrouter/deepseek/deepseek-r1:free` |
| OpenRouter | meta-llama/llama-4-scout:free | 404 | ❌ Caído ese día | igual | `openrouter/meta-llama/llama-4-scout:free` |
| Google AI | gemini-2.5-flash | — | ⏳ Key en repo, pendiente test en OpenCode | — | `google/gemini-2.5-flash-preview-04-17` |

---

## 🚨 Problema crítico detectado: Groq — límite de contexto

**Fecha:** 15 abril 2026, ~18:40h  
**Síntoma:** OpenCode con `llama-3.3-70b-versatile` devuelve error al intentar leer archivos del repo.

**Error exacto:**
```
Request too large for model `llama-3.3-70b-versatile`
in organization `org_01kccmrrkhf498n01hyvpfd2c6`
service tier `on_demand` on tokens per minute (TPM):
Limit 12000, Requested 32475
```

**Causa:** OpenCode manda todo el contexto del repo de golpe (~32K tokens). Groq solo acepta 12K TPM en el tier gratuito.

**Consecuencia:** Groq NO puede ser el modelo principal para OpenCode cuando hay repos con contexto grande. Solo sirve para prompts cortos.

---

## Nuevo orden de prioridad para OpenCode

Basado en ventana de contexto disponible:

| Prioridad | API | Modelo | Contexto | Velocidad | Uso |
|---|---|---|---|---|---|
| 1 ⭐ | **Google AI** | gemini-2.5-flash-preview-04-17 | **1.000.000 tokens** | Rápida | Principal — repos grandes |
| 2 | OpenRouter | deepseek/deepseek-r1:free | 164.000 tokens | Media | Fallback contexto largo |
| 3 | Together AI | meta-llama/Llama-3.3-70b | 131.000 tokens | Media | Fallback (NUEVA — pendiente test) |
| 4 | Cerebras | llama3.1-8b | 8.192 tokens | Muy rápida | Prompts cortos |
| 5 | Groq | llama-3.3-70b-versatile | ~~12.000 TPM~~ | Muy rápida | Último fallback solo prompts cortos |

### Config OpenCode con Google AI (solución al problema de contexto):
```bash
cat > ~/.config/opencode/opencode.json << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "model": "google/gemini-2.5-flash-preview-04-17"
}
EOF
```

---

## Aprendizajes clave

### 1. IDs de modelos: curl ≠ OpenCode
Groq y Cerebras tienen IDs **distintos** según dónde los uses:
- **curl directo:** sin prefijo → `llama-3.3-70b-versatile`
- **OpenCode config:** con prefijo → `groq/llama-3.3-70b-versatile`

### 2. HTTP codes que significan "funciona"
- `200` = OK perfecto
- `400` = key válida pero parámetro mal (ej: max_tokens muy bajo en Groq) → también OK
- `401` = key incorrecta o no exportada
- `403` = key no válida o sin permisos
- `404` = modelo no existe o saturado
- `000` = variable de entorno vacía (key no exportada)

### 3. Groq requiere max_tokens >= 10 para algunos modelos
Con `max_tokens: 1` da 400. Usar `max_tokens: 10` en tests.

### 4. OpenRouter puede dar 404 temporal
No siempre es que el modelo no existe — puede estar saturado o con mantenimiento.
Por eso está como fallback, no como principal.

### 5. La rotación funciona
`opencode-rotate.sh` probó Groq primero, obtuvo 200, seleccionó automáticamente.
Si Groq estuviera caído habría pasado a Cerebras.

### 6. Groq solo para prompts cortos
Con repos de más de ~8K tokens en contexto, Groq falla por límite TPM.
Siempre poner Google AI o DeepSeek como primeros en la rotación.

---

## Keys disponibles en esta máquina

| Variable | Estado |
|---|---|
| `OPENROUTER_API_KEY` | ✅ Exportada |
| `GROQ_API_KEY` | ✅ Exportada |
| `CEREBRAS_API_KEY` | ✅ Exportada |
| `GOOGLE_API_KEY` | ✅ En repo — pendiente exportar en .bashrc |

Para activar Google AI en terminal:
```bash
echo 'export GOOGLE_API_KEY="tu-key-aqui"' >> ~/.bashrc
source ~/.bashrc
# Verificar:
curl -s "https://generativelanguage.googleapis.com/v1beta/models?key=$GOOGLE_API_KEY" | head -5
```

---

## Modelos a investigar (pendiente verificar)

- `google/gemini-2.5-flash-preview-04-17` — **PRIORITARIO**, soluciona problema contexto
- `groq/qwen-qwq-32b` — Qwen3 con thinking, test pendiente con max_tokens correcto
- `groq/gemma2-9b-it` — Google Gemma 2 en Groq
- `cerebras/llama3.3-70b` — Llama 3.3 grande en Cerebras (ID exacto pendiente)
- `together/meta-llama/Llama-3.3-70b-Instruct-Turbo` — Together AI, 131K contexto
- OpenRouter cuando vuelva a estar disponible

---

## Estrategia de investigación de modelos

El flujo acordado para probar nuevos modelos:

```
1. Test curl (HTTP 200?)
         ↓
2. Añadir a opencode-rotate.sh
         ↓
3. Probar en OpenCode real (leer repo)
         ↓
4. Documentar resultado aquí
         ↓
5. Si funciona bien → sube en lista de prioridad
   Si va mal → baja o se elimina
```

---

*Test ejecutado por Álvaro Fernández Mota · 15 abril 2026*  
*Actualizado 15 abril 2026 ~18:46h con problema Groq contexto y nuevo orden*

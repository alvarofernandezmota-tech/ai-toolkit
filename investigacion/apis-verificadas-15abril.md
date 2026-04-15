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
| Google AI | — | 403 | ❌ Key no exportada | — | — |

---

## Aprendizajes clave

### 1. IDs de modelos: curl ≠ OpenCode
Groq y Cerebras tienen IDs **distintos** según dónde los uses:
- **curl directo:** sin prefijo → `llama-3.3-70b-versatile`
- **OpenCode config:** con prefijo → `groq/llama-3.3-70b-versatile`

### 2. HTTP codes que significan “funciona”
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

---

## Keys disponibles en esta máquina

| Variable | Estado |
|---|---|
| `OPENROUTER_API_KEY` | ✅ Exportada |
| `GROQ_API_KEY` | ✅ Exportada |
| `CEREBRAS_API_KEY` | ✅ Exportada |
| `GOOGLE_API_KEY` | ❌ Pendiente de exportar |

Para añadir Google AI:
```bash
echo 'export GOOGLE_API_KEY="tu-key-aqui"' >> ~/.bashrc
source ~/.bashrc
```

---

## Modelos a investigar (pendiente verificar)

- `groq/qwen-qwq-32b` — Qwen3 con thinking, test pendiente con max_tokens correcto
- `groq/gemma2-9b-it` — Google Gemma 2 en Groq
- `cerebras/llama3.3-70b` — Llama 3.3 grande en Cerebras (ID exacto pendiente)
- OpenRouter cuando vuelva a estar disponible

---

*Test ejecutado por Álvaro Fernández Mota · 15 abril 2026*

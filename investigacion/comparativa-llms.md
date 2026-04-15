# Comparativa de LLMs — Experimento Colmena

> **Objetivo:** Probar cada modelo con las mismas tareas y documentar para qué sirve mejor cada uno.  
> **Método:** Mismo prompt → distintos modelos vía LiteLLM → anotar resultados aquí.  
> **Última actualización:** 2026-04-15

---

## 🥇 Ranking actual (se actualiza tras las pruebas)

| Posición | Modelo | Mejor para | Estado |
|---|---|---|---|
| 1 | `principal` (Gemini 2.5 Pro) | Coding general | ✅ Activo |
| 2 | — | — | Pendiente de prueba |
| 3 | — | — | Pendiente de prueba |

---

## Fichas de modelos

---

### 1. Gemini 2.5 Pro — `gemini-pro` / `principal`

| Campo | Detalle |
|---|---|
| **Empresa** | Google DeepMind |
| **Tipo** | Multimodal, thinking |
| **Contexto** | 1.000.000 tokens |
| **Precio aprox.** | $1.25/M input · $10/M output |
| **Fortalezas** | Contexto enorme, razonamiento, código, multimodal |
| **Debilidades** | Lento en respuestas largas |
| **Ideal para** | Análisis de repos completos, tareas complejas, coding |

**Notas personales:**
> _(añadir tras las pruebas)_

**Resultado prueba coding:**
> _(pendiente)_

---

### 2. Gemini 2.0 Flash — `gemini-flash`

| Campo | Detalle |
|---|---|
| **Empresa** | Google DeepMind |
| **Tipo** | Multimodal, rápido |
| **Contexto** | 1.000.000 tokens |
| **Precio aprox.** | $0.10/M input · $0.40/M output |
| **Fortalezas** | Muy rápido, contexto enorme, casi gratuito |
| **Debilidades** | Menos preciso que Pro en tareas complejas |
| **Ideal para** | Pipelines, tareas repetitivas, contexto largo barato |

**Notas personales:**
> _(añadir tras las pruebas)_

**Resultado prueba coding:**
> _(pendiente)_

---

### 3. Claude Sonnet — `claude-sonnet`

| Campo | Detalle |
|---|---|
| **Empresa** | Anthropic |
| **Tipo** | Texto, coding |
| **Contexto** | 200.000 tokens |
| **Precio aprox.** | $3/M input · $15/M output |
| **Fortalezas** | El mejor modelo para coding del mercado (benchmark SWE-bench), muy preciso, sigue instrucciones al pie de la letra |
| **Debilidades** | Caro, sin multimodal avanzado |
| **Ideal para** | Coding profesional, refactors complejos, PR reviews |

**Notas personales:**
> _(añadir tras las pruebas)_

**Resultado prueba coding:**
> _(pendiente)_

---

### 4. Claude Opus — `claude-opus`

| Campo | Detalle |
|---|---|
| **Empresa** | Anthropic |
| **Tipo** | Texto, razonamiento |
| **Contexto** | 200.000 tokens |
| **Precio aprox.** | $15/M input · $75/M output |
| **Fortalezas** | Razonamiento profundo, escritura, análisis |
| **Debilidades** | Muy caro, más lento que Sonnet |
| **Ideal para** | Tareas de alto valor donde la calidad es prioritaria |

**Notas personales:**
> _(añadir tras las pruebas)_

**Resultado prueba coding:**
> _(pendiente)_

---

### 5. GPT-4o — `gpt-4o`

| Campo | Detalle |
|---|---|
| **Empresa** | OpenAI |
| **Tipo** | Multimodal |
| **Contexto** | 128.000 tokens |
| **Precio aprox.** | $2.50/M input · $10/M output |
| **Fortalezas** | Equilibrado, multimodal real, API muy madura |
| **Debilidades** | Ya no es el mejor en coding ni razonamiento |
| **Ideal para** | Tareas generales, integraciones, compatibilidad |

**Notas personales:**
> _(añadir tras las pruebas)_

**Resultado prueba coding:**
> _(pendiente)_

---

### 6. GPT-4o Mini — `gpt-4o-mini`

| Campo | Detalle |
|---|---|
| **Empresa** | OpenAI |
| **Tipo** | Texto |
| **Contexto** | 128.000 tokens |
| **Precio aprox.** | $0.15/M input · $0.60/M output |
| **Fortalezas** | Barato, rápido, suficientemente capaz para tareas simples |
| **Debilidades** | Calidad notablemente inferior a 4o |
| **Ideal para** | Clasificación, resumen, tareas rutinarias en pipelines |

**Notas personales:**
> _(añadir tras las pruebas)_

**Resultado prueba coding:**
> _(pendiente)_

---

### 7. o3-mini — `o3-mini`

| Campo | Detalle |
|---|---|
| **Empresa** | OpenAI |
| **Tipo** | Reasoning (chain-of-thought interno) |
| **Contexto** | 200.000 tokens |
| **Precio aprox.** | $1.10/M input · $4.40/M output |
| **Fortalezas** | Matemáticas, lógica, STEM, mejor que GPT-4o en razonamiento |
| **Debilidades** | Lento, no sigue bien instrucciones de formato |
| **Ideal para** | Problemas de algoritmos, debugging complejo, matemáticas |

**Notas personales:**
> _(añadir tras las pruebas)_

**Resultado prueba coding:**
> _(pendiente)_

---

### 8. DeepSeek R1 — `deepseek-r1`

| Campo | Detalle |
|---|---|
| **Empresa** | DeepSeek (China) |
| **Tipo** | Reasoning, open source |
| **Contexto** | 128.000 tokens |
| **Precio aprox.** | $0.55/M input · $2.19/M output |
| **Fortalezas** | Razonamiento comparable a o3, open source, muy barato |
| **Debilidades** | A veces verboso en el thinking, datos de entrenamiento chinos |
| **Ideal para** | Razonamiento complejo con presupuesto limitado |

**Notas personales:**
> _(añadir tras las pruebas)_

**Resultado prueba coding:**
> _(pendiente)_

---

### 9. DeepSeek V3 — `deepseek-v3`

| Campo | Detalle |
|---|---|
| **Empresa** | DeepSeek (China) |
| **Tipo** | Chat, coding, open source |
| **Contexto** | 128.000 tokens |
| **Precio aprox.** | $0.27/M input · $1.10/M output |
| **Fortalezas** | Excelente relación calidad/precio, muy bueno en coding |
| **Debilidades** | Sin thinking, datos de entrenamiento chinos |
| **Ideal para** | Coding cotidiano con bajo coste |

**Notas personales:**
> _(añadir tras las pruebas)_

**Resultado prueba coding:**
> _(pendiente)_

---

### 10. Llama 4 Maverick — `llama-4-maverick`

| Campo | Detalle |
|---|---|
| **Empresa** | Meta (open source) |
| **Tipo** | Multimodal, MoE |
| **Contexto** | 1.000.000 tokens |
| **Precio aprox.** | $0.20/M input · $0.60/M output (vía OpenRouter) |
| **Fortalezas** | Open source, contexto enorme, MoE eficiente |
| **Debilidades** | Menos refinado que Claude/GPT en instrucciones |
| **Ideal para** | Proyectos open source, contexto largo, self-hosting |

**Notas personales:**
> _(añadir tras las pruebas)_

**Resultado prueba coding:**
> _(pendiente)_

---

### 11. Llama 4 Scout — `llama-4-scout`

| Campo | Detalle |
|---|---|
| **Empresa** | Meta (open source) |
| **Tipo** | Ligero, MoE |
| **Contexto** | 10.000.000 tokens |
| **Precio aprox.** | $0.11/M input · $0.34/M output (vía OpenRouter) |
| **Fortalezas** | Contexto absurdo (10M tokens), muy barato, open source |
| **Debilidades** | Calidad inferior a Maverick |
| **Ideal para** | Indexar repos gigantes, contexto extremo barato |

**Notas personales:**
> _(añadir tras las pruebas)_

**Resultado prueba coding:**
> _(pendiente)_

---

### 12. Qwen3 235B Thinking — `qwen3-235b`

| Campo | Detalle |
|---|---|
| **Empresa** | Alibaba |
| **Tipo** | Thinking, MoE, open source |
| **Contexto** | 128.000 tokens |
| **Precio aprox.** | Gratuito vía OpenRouter (free tier) |
| **Fortalezas** | 235B params, thinking mode, open source, gratis |
| **Debilidades** | Lento, verbose en thinking, infraestructura china |
| **Ideal para** | Experimentos, comparativas sin coste, razonamiento |

**Notas personales:**
> Era el modelo por defecto antes de configurar LiteLLM correctamente.

**Resultado prueba coding:**
> _(pendiente)_

---

### 13. Mistral Large — `mistral-large`

| Campo | Detalle |
|---|---|
| **Empresa** | Mistral AI (Francia) |
| **Tipo** | Texto, coding |
| **Contexto** | 128.000 tokens |
| **Precio aprox.** | $2/M input · $6/M output |
| **Fortalezas** | Europeo (privacidad GDPR), bueno en código y multilingüe |
| **Debilidades** | No llega a Claude/GPT-4o en benchmarks |
| **Ideal para** | Proyectos europeos con requisitos de privacidad |

**Notas personales:**
> _(añadir tras las pruebas)_

**Resultado prueba coding:**
> _(pendiente)_

---

### 14. Codestral — `codestral`

| Campo | Detalle |
|---|---|
| **Empresa** | Mistral AI (Francia) |
| **Tipo** | Especializado en código |
| **Contexto** | 32.000 tokens |
| **Precio aprox.** | $0.20/M input · $0.60/M output |
| **Fortalezas** | Fill-in-the-middle nativo, 80+ lenguajes, muy rápido en completions |
| **Debilidades** | Contexto corto, solo coding |
| **Ideal para** | Autocomplete, completions en tiempo real, integración con IDE |

**Notas personales:**
> _(añadir tras las pruebas)_

**Resultado prueba coding:**
> _(pendiente)_

---

## Plantilla de prueba estándar

Usar este prompt en cada modelo para comparación justa:

```
Tarea: Refactoriza la siguiente función Python para que sea más eficiente, 
añade manejo de errores y escribe tests unitarios con pytest.

def calcular_promedio(numeros):
    total = 0
    for n in numeros:
        total = total + n
    return total / len(numeros)
```

### Criterios de evaluación (puntuación 1-5)

| Criterio | Descripción |
|---|---|
| **Calidad código** | ¿Es el código correcto, limpio y pythonico? |
| **Tests** | ¿Los tests son completos y cubren edge cases? |
| **Manejo errores** | ¿Gestiona lista vacía, tipos incorrectos, etc.? |
| **Velocidad** | ¿Cuánto tarda en responder? |
| **Seguir instrucciones** | ¿Hizo exactamente lo que se pidió? |
| **Extra** | ¿Añadió algo útil no pedido? |

### Tabla de resultados (rellenar tras pruebas)

| Modelo | Código | Tests | Errores | Velocidad | Instrucciones | Total |
|---|---|---|---|---|---|---|
| gemini-pro | ⭐ | ⭐ | ⭐ | ⭐ | ⭐ | /25 |
| gemini-flash | ⭐ | ⭐ | ⭐ | ⭐ | ⭐ | /25 |
| claude-sonnet | ⭐ | ⭐ | ⭐ | ⭐ | ⭐ | /25 |
| claude-opus | ⭐ | ⭐ | ⭐ | ⭐ | ⭐ | /25 |
| gpt-4o | ⭐ | ⭐ | ⭐ | ⭐ | ⭐ | /25 |
| o3-mini | ⭐ | ⭐ | ⭐ | ⭐ | ⭐ | /25 |
| deepseek-r1 | ⭐ | ⭐ | ⭐ | ⭐ | ⭐ | /25 |
| deepseek-v3 | ⭐ | ⭐ | ⭐ | ⭐ | ⭐ | /25 |
| llama-4-maverick | ⭐ | ⭐ | ⭐ | ⭐ | ⭐ | /25 |
| llama-4-scout | ⭐ | ⭐ | ⭐ | ⭐ | ⭐ | /25 |
| qwen3-235b | ⭐ | ⭐ | ⭐ | ⭐ | ⭐ | /25 |
| mistral-large | ⭐ | ⭐ | ⭐ | ⭐ | ⭐ | /25 |
| codestral | ⭐ | ⭐ | ⭐ | ⭐ | ⭐ | /25 |

---

## Cómo ejecutar la prueba en OpenCode

```bash
# Cambiar modelo en el config
cat ~/.config/opencode/opencode.json | grep model

# Override rápido sin editar config
# Ctrl+P en OpenCode -> "model" -> seleccionar

# Arrancar con modelo específico
cd ~/projects/ai-toolkit
opencode
```

Luego dentro de OpenCode: pegar la tarea de la plantilla y anotar resultado aquí.

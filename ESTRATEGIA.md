# 🎯 Estrategia — Modelos, Hardware y Escalado

> Estado: 2026-04-17 | Revisión completa tras primera sesión operativa

## Principio fundamental

**Local primero, nube solo de emergencia.**

Las APIs gratuitas tienen límites tan bajos que no sirven para trabajo real con contextos grandes. Ollama local no tiene límites, es privado, y con el hardware adecuado es tan rápido o más que las APIs.

## Por qué las APIs gratuitas fallan en trabajo real

| Proveedor | Límite | Problema real |
|-----------|--------|---------------|
| Groq | 12.000 TPM | Un solo contexto de código grande lo supera |
| Gemini | Cuota diaria | 3-4 sesiones intensas y se acaba |
| Sambanova | 429 frecuente | Inestable, no fiable |
| Together | $1 crédito | Se acaba en horas |
| Cerebras | Límite diario | Variable, no predecible |

**Conclusión**: las APIs gratuitas solo sirven para demos y pruebas. Para trabajo real de agentes que procesan repos enteros, necesitas Ollama local o APIs de pago.

## Modelos disponibles ahora (Ollama)

| Modelo | Tamaño | Uso ideal |
|--------|--------|-----------|
| `qwen2.5-coder:14b` | 9 GB | Código, análisis repos ⭐ Principal |
| `deepseek-r1:14b` | 9 GB | Razonamiento complejo, debugging |
| `qwen3:8b-q4_K_M` | 5.2 GB | Tareas rápidas, respuestas simples |
| `qwen2.5-coder:7b` | 4.7 GB | Fallback rápido |
| `nomic-embed-text` | 274 MB | Embeddings y búsqueda semántica |

## Escalado por hardware

### Situación actual (CPU only)
- Velocidad: ~5-8 min por tarea compleja de código
- Máximo recomendado: modelos `14b`
- El `32b` swapea y va más lento que las APIs

### Con GPU dedicada (próximo paso)

| GPU | VRAM | Modelos posibles | Velocidad vs CPU |
|-----|------|-----------------|------------------|
| RTX 3070 | 8 GB | `14b` parcial | 5-7x más rápido |
| RTX 3080 | 10 GB | `14b` completo | **10x más rápido** |
| RTX 4070 Ti | 12 GB | `14b` completo | 12x más rápido |
| RTX 4090 | 24 GB | `32b` completo | 20x más rápido |
| Dual RTX 3090 | 48 GB | `70b` completo | N/A |

### Opciones para escalar (en orden de coste)

1. **eGPU** (Thunderbolt) — si el Acer tiene TB4: RTX 3080 en caja externa ~400€
2. **PC desktop dedicado** — RTX 4080/4090 + Ryzen, servidor de agentes 24/7
3. **Servidor cloud puntual** — RunPod/vast.ai ~$0.3/h con A100 para tareas pesadas

## Roadmap hardware

```
Ahora          ──────────────> Corto plazo    ─────────> Largo plazo
Acer CPU only              eGPU o desktop          Servidor 24/7
qwen2.5-coder:14b          qwen2.5-coder:32b       deepseek-r1:70b
~5-8 min/tarea             ~1-2 min/tarea          ~30 seg/tarea
```

## Estrategia de modelos en el config

El `litellm-config.yaml` ya refleja la estrategia correcta:
1. Ollama `qwen2.5-coder:14b` → PRIMERO (trabajo principal)
2. Ollama `deepseek-r1:14b` → SEGUNDO (razonamiento)
3. Ollama `qwen3:8b` → TERCERO (tareas rápidas)
4. Groq/Sambanova/etc → fallback emergencia

Con GPU dedicada: mismo config, solo que Ollama responderá 10x más rápido.

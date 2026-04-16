# Ollama local como modelo principal — 2026-04-17

## Problema

Durante la sesión del 2026-04-17 ~01:20-01:30, todos los proveedores gratuitos fallaron con 429:

- **Groq**: `rate_limit_exceeded` — tokens agotados en free tier
- **Sambanova**: `429` — rate limit
- **Gemini Flash**: `429` — cuota diaria agotada (`GenerateRequestsPerDayPerProjectPerModel-FreeTier`)
- **Gemini Lite**: `429` — ídem
- **Together AI**: sin crédito disponible

OpenCode quedó sin modelo funcional durante la sesión.

## Causa raíz

La arquitectura original ponía las APIs gratuitas en primer lugar y los modelos locales (Ollama) no estaban incluidos en la rotación `principal`. Las APIs gratuitas tienen límites diarios/por-minuto que se agotan rápido con uso intensivo.

## Solución aplicada

Reordenado `litellm-config.yaml` para poner **Ollama local primero**:

```
1. ollama/qwen2.5-coder:14b   → LOCAL, sin límites, código no sale de la máquina
2. ollama/deepseek-r1:14b     → LOCAL, razonamiento
3. ollama/qwen3:8b-q4_K_M     → LOCAL, rápido
4. groq/llama-3.3-70b         → nube, solo si local no disponible
5. sambanova/Llama-4-Maverick → nube, fallback
... resto APIs como último recurso
```

## Ventajas de Ollama local primero

- **Sin límites de cuota** — el hardware es el único límite
- **Privacidad total** — el código nunca sale de la máquina
- **Sin coste** — 0€ por token
- **Sin latencia de red** — más rápido para contextos grandes

## Prerequisitos

```bash
ollama pull qwen2.5-coder:14b
ollama pull deepseek-r1:14b
ollama pull qwen3:8b-q4_K_M
```

## Próximos pasos

- [ ] Instalar Perplexica local para búsqueda web con modelos locales
- [ ] Configurar servidor SSH para arquitectura híbrida (ver `ARQUITECTURA-SERVIDOR.md`)

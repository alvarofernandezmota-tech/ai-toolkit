# OpenCode — Configuración y Compaction

## Problema: Compaction agota tokens de OpenRouter

OpenCode compacta automáticamente el contexto cuando supera cierto límite.
Esa petición de compaction puede pedir 32.000 tokens de golpe, lo que supera
el saldo gratuito de OpenRouter (~6.000 tokens).

## Solución implementada

El `opencode.json` está en la raíz del proyecto y OpenCode lo carga automáticamente
al ejecutarse desde `~/projects/ai-toolkit`.

Los modelos registrados en el provider `litellm` permiten cambiar de modelo
en OpenCode con `Ctrl+P → model` sin tocar ningún config.

## Si la compaction sigue fallando

Opción 1 — Desactivar autocompaction completamente:
```bash
export OPENCODE_DISABLE_AUTOCOMPACT=true
```
Añadir al `.env` del proyecto para que persista.

Opción 2 — Compactar manualmente cuando tú quieras:
En OpenCode: `/compact`
Esto compacta en ese momento con el modelo activo.

Opción 3 — Nueva sesión (nuclear):
```bash
opencode  # sin -s, abre sesión nueva sin contexto
```

## Cambiar de modelo en OpenCode

```
Ctrl+P → model → seleccionar
```

Modelos disponibles (todos vía LiteLLM en localhost:8000):
- `principal` — Cerebras gpt-oss-120b → fallback OpenRouter
- `cerebras-fallback` — llama3.1-8b (pequeño, para compaction)
- `openrouter-fallback` — Llama 4 Maverick vía OpenRouter
- `gemini-flash` — cuando Gemini esté operativo
- `claude-sonnet`, `gpt-4o` — de pago

## Reseteos de límites gratuitos

| Proveedor | Reset |
|---|---|
| Cerebras | Diario (00:00 UTC = 02:00 CEST) |
| OpenRouter | Por créditos (recargar en openrouter.ai/settings/credits) |
| Gemini Free Tier | Por minuto y por día (00:00 PST) |
| Groq | Por minuto/día según tier |

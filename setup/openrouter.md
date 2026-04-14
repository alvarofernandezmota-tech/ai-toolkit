# 📦 Setup: OpenRouter

OpenRouter es un hub de modelos de IA con tier gratuito. Accedes a Claude, Gemini, DeepSeek y más desde una sola API key.

## 1. Crear cuenta y API key

1. Ve a [openrouter.ai](https://openrouter.ai)
2. Regstráte (gratis)
3. En el panel, ve a **API Keys** → **Create Key**
4. Copia la key (empieza por `sk-or-...`)

## 2. Modelos gratuitos disponibles

En [openrouter.ai/models](https://openrouter.ai/models) filtra por **Free** para ver todos los disponibles.

Los más útiles para coding:
- `google/gemma-3-27b-it:free`
- `deepseek/deepseek-chat:free`
- `meta-llama/llama-4-scout:free`

## 3. Configurar Claude Code con OpenRouter

```bash
# En tu .bashrc o .zshrc (para que sea permanente)
export ANTHROPIC_BASE_URL=https://openrouter.ai/api/v1
export ANTHROPIC_API_KEY=sk-or-tu_key_aqui

# Recargar configuración
source ~/.bashrc

# Arrancar con modelo gratuito
claude --model google/gemma-3-27b-it:free

# O rotación automática entre free models
claude --model openrouter/auto
```

## 4. Configurar Aider con OpenRouter

```bash
export OPENROUTER_API_KEY=sk-or-tu_key_aqui
aider --model openrouter/google/gemma-3-27b-it:free
```

## Notas

- Los modelos gratuitos tienen límite de requests por día, pero es más que suficiente para aprender y proyectos personales.
- Cuando necesites más potencia, puedes cargar crédito de pago y usar Claude Sonnet o GPT-4o pagando solo por lo que uses.

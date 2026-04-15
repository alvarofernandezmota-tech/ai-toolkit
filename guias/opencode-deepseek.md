# Guia personal: OpenCode + DeepSeek R1 via OpenRouter

> Como lo uso yo. Version probada el 15/04/2026 con OpenCode y DeepSeek R1 free.

---

## Que es y para que lo uso

**OpenCode** es un agente de coding open source que funciona en terminal, similar a Claude Code pero sin necesitar una cuenta de Anthropic. Lo uso conectado a **DeepSeek R1 free** via OpenRouter como alternativa gratuita para:
- Investigacion y generacion de documentacion
- Coding cuando no quiero gastar creditos de Claude Code
- Experimentos y pruebas rapidas

**Por que DeepSeek R1:** Es el mejor modelo gratuito para razonamiento y codigo en abril 2026. Es lento (30-60s por respuesta) pero la calidad es buena.

---

## Instalacion

```bash
# Instalar OpenCode (requiere Node.js)
npm install -g opencode-ai

# Verificar instalacion
opencode --version
```

---

## Configuracion

### El archivo correcto (IMPORTANTE)

El archivo de config se llama `opencode.json`, NO `config.json`. Este fue el error que encontre el 15/04/2026.

```bash
mkdir -p ~/.config/opencode
cat > ~/.config/opencode/opencode.json << 'EOF'
{
  "$schema": "https://opencode.ai/config.json",
  "model": "openrouter/deepseek/deepseek-r1:free"
}
EOF
```

### Error tipico que NO debes hacer

```json
// ❌ ESTO FALLA — ~/.config/opencode/config.json
{
  "model": "deepseek/deepseek-r1:free",
  "provider": {
    "openai": {
      "apiKey": "ENV_OPENROUTER_API_KEY",
      "baseURL": "https://openrouter.ai/api/v1"
    }
  }
}
// Error: Unrecognized keys: "apiKey", "baseURL" provider.openai
```

---

## Como arrancar

```bash
# Arranque normal (nueva sesion)
OPENAI_API_KEY="$OPENROUTER_API_KEY" \
OPENAI_BASE_URL="https://openrouter.ai/api/v1" \
opencode

# Continuar sesion anterior (el session ID lo ves en el banner al arrancar)
opencode -s ses_XXXXXXXXXX

# Ejemplo real de sesion del 15/04/2026:
# opencode -s ses_271205fbbffenOUPDJ2caJaYo1
```

> **Tip:** Cuando arranca OpenCode, te muestra el session ID en el banner. Copialo si crees que vas a querer continuar la sesion despues.

---

## Modelos alternativos que puedes usar

| Modelo | ID en opencode.json | Velocidad | Calidad | Gratis |
|--------|---------------------|-----------|---------|--------|
| DeepSeek R1 | `openrouter/deepseek/deepseek-r1:free` | Lenta | Alta | Si |
| Llama 4 Scout | `openrouter/meta-llama/llama-4-scout:free` | Media | Buena | Si |
| Qwen 3 | `openrouter/qwen/qwen3-235b-a22b:free` | Media | Buena | Si |
| Gemini Flash | `openrouter/google/gemini-flash-1.5:free` | Rapida | Media | Si |

Para cambiar de modelo: edita `~/.config/opencode/opencode.json` con el nuevo ID.

---

## Flujo de trabajo real

### Para investigacion y docs
```
1. Arranca OpenCode con DeepSeek R1
2. Prompt: "Investiga [tema] y genera un MD con estructura clara en investigacion/YYYY-MM-DD-tema.md"
3. Revisa el output, ajusta si hace falta
4. Commit: git add . && git commit -m "docs: investigacion [tema]"
```

### Para coding
```
1. Posicionate en el directorio del proyecto antes de arrancar
2. Arranca OpenCode
3. Prompt: "Lee los archivos del proyecto y [tarea concreta]"
4. Revisa los cambios antes de hacer commit
```

---

## Problemas conocidos y soluciones

| Problema | Causa | Solucion |
|----------|-------|----------|
| Error `Unrecognized keys` al arrancar | Nombre de archivo incorrecto o formato incorrecto | Usa `opencode.json` con `$schema` |
| Respuesta muy lenta | DeepSeek R1 tarda 30-60s | Normal, ten paciencia. Para tareas urgentes usa Gemini Flash |
| Sesion perdida | Cerraste la terminal sin guardar el session ID | No hay forma de recuperarla, empieza nueva |
| Modelo no disponible | Rate limit del tier gratuito | Espera unos minutos o cambia a otro modelo gratuito |

---

## Variables de entorno necesarias

```bash
# Asegurate de tener esto en tu .bashrc o .zshrc
export OPENROUTER_API_KEY="sk-or-v1-..."

# Verificar que esta cargada
echo $OPENROUTER_API_KEY
```

Si la variable no esta cargada, OpenCode arranca pero falla al enviar el primer mensaje.

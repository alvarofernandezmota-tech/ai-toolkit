# 🔑 Cuentas y keys — Empieza aquí

> Antes de instalar nada, necesitas estas cuentas. Todas gratuitas, ninguna requiere tarjeta.

---

## Cuentas necesarias

### 1. Groq — Motor de IA (ya puedes tenerla)

**URL:** [console.groq.com](https://console.groq.com)

1. Registro con Google o email
2. Ir a **API Keys** → **Create API Key**
3. Copiar la key (empieza por `gsk_...`)
4. Límites gratuitos: 14.400 peticiones/día, 750 tokens/segundo

**Para qué:** THDORA NLP + Aider en terminal + Whisper (voz)

---

### 2. OpenRouter — Hub de modelos gratuitos

**URL:** [openrouter.ai](https://openrouter.ai)

1. Registro con Google o email
2. Ir a **Keys** → **Create Key**
3. Copiar la key (empieza por `sk-or-...`)
4. Sin tarjeta. Créditos gratis al registrarte.

**Para qué:** Claude Code + modelos thinking (DeepSeek R1, Qwen3 Coder)

**Modelos gratuitos destacados:**

| Modelo | ID en OpenRouter | Thinking |
|---|---|---|
| DeepSeek R1 | `deepseek/deepseek-r1:free` | ✅ |
| Qwen3 Coder 480B | `qwen/qwen3-coder:free` | ✅ |
| Llama 3.3 70B | `meta-llama/llama-3.3-70b-instruct:free` | ❌ |
| Gemma 3 27B | `google/gemma-3-27b-it:free` | ❌ |

---

### 3. Tavily — Búsqueda web (para más adelante)

**URL:** [tavily.com](https://tavily.com)

1. Registro con Google o email
2. Dashboard → **API Key**
3. Copiar la key (empieza por `tvly-...`)
4. Gratis: 1.000 búsquedas/mes

**Para qué:** THDORA con internet — responde sobre el mundo real (Junio 2026)

---

### 4. Telegram Bot — Si vas a montar THDORA

**URL:** [t.me/BotFather](https://t.me/BotFather)

1. Abrir BotFather en Telegram
2. `/newbot` → elegir nombre y username
3. Copiar el token (`123456:ABC-DEF...`)

---

## Cómo meter las keys — SIEMPRE A MANO

> ⚠️ Las keys NUNCA van en el script automático ni en GitHub. Las metes tú a mano.

### En `~/.bashrc` (variables globales de sistema)

```bash
nano ~/.bashrc
```

Busca el bloque `# ECOSISTEMA IA` (lo añadió setup.sh) y descomentar y rellenar:

```bash
# ECOSISTEMA IA
export GROQ_API_KEY=gsk_xxxxxxxxxxxxxxxxxxxx
export ANTHROPIC_BASE_URL=https://openrouter.ai/api/v1
export ANTHROPIC_API_KEY=sk-or-xxxxxxxxxxxxxxxxxxxx
export TAVILY_API_KEY=tvly-xxxxxxxxxxxxxxxxxxxx     # cuando lo necesites
```

Guardar (`Ctrl+O`, `Enter`, `Ctrl+X`) y aplicar:

```bash
source ~/.bashrc
```

Verificar que están cargadas:

```bash
echo $GROQ_API_KEY        # debe mostrar tu key
echo $ANTHROPIC_API_KEY   # debe mostrar tu key
```

### En `.env` de THDORA (variables del proyecto)

```bash
nano ~/projects/thdora/.env
```

```env
TELEGRAM_TOKEN=123456:ABC-DEF-tu-token
GROQ_API_KEY=gsk_xxxxxxxxxxxxxxxxxxxx
```

> El `.env` ya está en `.gitignore` de THDORA — nunca se sube a GitHub. 🔒

---

## Resumen de qué key va dónde

| Key | `~/.bashrc` | `.env` THDORA | Cuándo |
|---|---|---|---|
| `GROQ_API_KEY` | ✅ | ✅ | Ahora |
| `ANTHROPIC_API_KEY` | ✅ | ❌ | Ahora |
| `ANTHROPIC_BASE_URL` | ✅ | ❌ | Ahora |
| `TELEGRAM_TOKEN` | ❌ | ✅ | Ahora |
| `TAVILY_API_KEY` | ✅ | Opcional | Junio 2026 |

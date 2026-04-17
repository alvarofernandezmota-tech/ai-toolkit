# Agente OpenCode — Coding Agent Principal

> El agente de coding que corre en el terminal y trabaja sobre codebases reales.

---

## ¿Qué es?

OpenCode es el agente de coding principal del ecosistema. Corre en el terminal, lee el contexto del proyecto, ejecuta comandos, edita archivos y hace commits. Es el "cerebro ejecutor" — recibe una tarea y la completa autónomamente.

**Versión actual:** v1.4.7 (actualizado 17/04/2026)

---

## Stack

| Componente | Valor |
|---|---|
| Herramienta | OpenCode v1.4.7 |
| Instalación | `~/.npm-global/bin/opencode` |
| Config | `~/projects/ai-toolkit/opencode.json` |
| Modelo por defecto | `litellm/principal` (auto-fallback) |
| Backend | LiteLLM Colmena en `:8000` |
| Coste | $0/mes |

---

## Arranque

```bash
# Prerequisito: LiteLLM corriendo en :8000
bash ~/projects/ai-toolkit/scripts/start-colmena.sh

# Lanzar OpenCode (desde el directorio del proyecto)
cd ~/projects/TU-PROYECTO
~/.npm-global/bin/opencode
```

## Actualizar

```bash
npm i -g opencode-ai@latest
~/.npm-global/bin/opencode --version
```

---

## Modelos disponibles vía LiteLLM

| Alias | Modelo real | Cuándo usarlo |
|---|---|---|
| `principal` | auto-fallback | Siempre, deja que elija |
| `gemini-pro` | Gemini 2.5 Pro | Tareas complejas, análisis |
| `gemini-flash` | Gemini 2.0 Flash | Rápido y gratis |
| `groq-fallback` | Llama 3.x en Groq | Velocidad máxima |
| `qwen3:8b-q4_K_M` | Qwen3 8B LOCAL | Sin internet, privado |
| `qwen2.5-coder:14b` | Qwen2.5 Coder 14B LOCAL | Código potente offline |
| `deepseek-r1:14b` | DeepSeek R1 14B LOCAL | Razonamiento profundo offline |

---

## Atajos dentro de OpenCode

| Atajo | Acción |
|---|---|
| `@archivo` | Adjuntar fichero al contexto |
| `Ctrl+p` | Menú de comandos |
| `tab → agents` | Cambiar a modo agente |
| `/` | Cambiar modelo sobre la marcha |
| `Ctrl+x` (leader) | Líder de keybinds |

---

## Novedades v1.4.7 (16/04/2026)

- Snapshots respetan `.gitignore` completamente
- Lectura de imágenes no cuenta contra quota
- Fix para sesiones atascadas con providers OpenAI-compatible → afecta a LiteLLM
- Permisos de proyecto actualizables mid-sesión

---

## Problemas conocidos

### `GET /v1/models → 401 Unauthorized`
**Causa:** OpenCode hace un probe sin API key para listar modelos, LiteLLM requiere auth.  
**Impacto:** Ninguno. Las llamadas de chat llevan `sk-litellm-local` y pasan con `200 OK`.  
**Solución:** Ignorar. No afecta al funcionamiento.

---

## Estado

- ✅ Funcionando en producción desde 15/04/2026
- ✅ v1.4.7 instalado 17/04/2026
- ✅ Integrado con LiteLLM Colmena
- ✅ Primera tarea real completada: `scripts/generar-diario.sh`

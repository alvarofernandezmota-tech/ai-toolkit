# Sesión 15 abril 2026 — Resumen de trabajo

## Qué se hizo

### 1. Análisis de la estructura del ecosistema ✅
- Claude Code leyó `CLAUDE.md` y `agentes/claude-code.md`
- Analizó la estructura de directorios del repo `ai-toolkit`
- Identificó agentes, herramientas y flujos existentes

### 2. Creación de estructura del ecosistema ✅
- Archivo creado: `docs/ecosystem-structure.md` (112 líneas)
- Documenta la arquitectura ideal: agentes, herramientas, flujos, principios de diseño
- Objetivo: 0€/mes, <1% CPU, ~360MB RAM, alta modularidad

### 3. Script de rotación de modelos ✅
- Archivo: `scripts/claude-rotate.sh`
- Rota entre 6 modelos gratuitos de OpenRouter con fallback automático
- Prueba conectividad antes de lanzar (timeout 5s)
- Persiste el último modelo usado en `~/.claude/rotate-index`
- Alias creado: `cc` en `~/.bashrc`

## Modelos en rotación (orden de preferencia)

| # | Modelo | API | Para qué |
|---|---|---|---|
| 1 | `deepseek/deepseek-r1:free` | OpenRouter | Razonamiento profundo |
| 2 | `qwen/qwen3-235b-a22b:free` | OpenRouter | Código avanzado |
| 3 | `meta-llama/llama-4-maverick:free` | OpenRouter | Código del día a día |
| 4 | `google/gemini-2.5-pro-exp-03-25:free` | OpenRouter | Arquitectura |
| 5 | `openai/gpt-4o-mini:free` | OpenRouter | Agente rápido |
| 6 | `meta-llama/llama-3.3-70b-instruct:free` | OpenRouter | Fallback final |

## Problemas encontrados y soluciones

| Problema | Solución |
|---|---|
| Modelo `openrouter/free` lento e inestable | Script de rotación con fallback |
| IDs de modelos con prefijo doble (`openrouter/openrouter/...`) | Quitar el prefijo extra — Claude Code lo añade solo |
| Claude Code se cuelga sin contexto previo | Dar instrucciones cortas y concretas, 1 a 1 |
| `git push` dentro de Claude Code no ejecuta en bash | Ejecutar en terminal externa |

## Comandos clave del ecosistema

```bash
# Lanzar Claude Code con rotación automática
cc

# Forzar un modelo concreto
claude --model deepseek/deepseek-r1:free

# Ver log de rotaciones
cat ~/.claude/rotate.log

# Ver qué modelo está activo
cat ~/.claude/settings.json
```

## Pendiente

- [ ] Push de `docs/ecosystem-structure.md` al repo remoto
- [ ] Script de rotación para Aider (con modelos Groq)
- [ ] Implementar THDORA
- [ ] Configurar n8n workflows
- [ ] Añadir Groq como fallback en `claude-rotate.sh`

---
_Sesión: 15 abril 2026, 02:00–02:30 CEST_

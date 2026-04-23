# Proyecto: ai-toolkit

> Infraestructura IA — el cerebro compartido del ecosistema
> Área: [[areas/ia-desarrollo.md]]
> Última actualización: 23 abril 2026

## Qué es

Repo público que centraliza toda la infraestructura IA de Álvaro.
OpenCode + Claude Code + LiteLLM proxy + Ollama + scripts de automatización.
Es la base que potencia todos los demás proyectos.

## Estado actual

- Rama activa: `main`
- Todos los scripts verificados y funcionales ✅
- Documentación completa y al día ✅
- Estructura PARA implementada ✅ (esta sesión)

## Componentes principales

| Componente | Estado | Notas |
|---|---|---|
| LiteLLM proxy :8000 | ✅ Funcional | 18+ modelos configurados |
| Ollama qwen3:8b | ✅ Funcional | 6GB VRAM, arranque manual |
| OpenCode | ✅ Funcional | Devstral 2 via OpenRouter |
| Claude Code v2.1.117 | ✅ Funcional | OpenRouter directo |
| scripts/health-check.sh | ✅ Con auth fix | Diagnóstico completo |
| scripts/bootstrap.sh | ✅ Funcional | Estado en 30s |
| scripts/morning.sh | ✅ Nuevo | Contexto del día |
| scripts/weekly-planning.sh | ✅ Nuevo | Plan de semana |
| scripts/day-close.sh | ✅ Nuevo | Cierre diario |

## Roadmap activo

- [ ] Renovar keys: Groq, DeepSeek, Gemini (manual)
- [ ] Ejecutar auditoría con Claude Code
- [ ] Primera sesión THDORA con Claude Code
- [ ] Health-check con detección de keys caducadas
- [ ] Mover MDs a docs/ (reorganización raíz)
- [ ] n8n workflows (Mayo 2026)

## Estructura PARA

```
ai-toolkit/
├── context/      — quién eres, stack, herramientas
├── projects/     — proyectos activos con deadline
├── areas/        — responsabilidades continuas
├── diario/       — memoria de sesiones
├── docs/         — recursos y referencias
├── prompts/      — skills/commands
└── scripts/      — automatización
```

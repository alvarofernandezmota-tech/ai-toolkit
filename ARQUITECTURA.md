# 🏗️ Arquitectura del Repositorio

> Mapa maestro para humanos y agentes.
> Si eres un agente nuevo, empieza aquí.

---

## Estructura de carpetas

```
ai-toolkit/
├── agentes/          ← Fichas .md de cada agente (qué hace, modelos, inputs/outputs)
├── scripts/          ← Scripts .sh ejecutables por agente o por el usuario
├── herramientas/     ← Utilidades reutilizables (bloques LEGO para agentes)
├── prompts/          ← Prompts que funcionan bien, organizados por uso
├── guias/            ← Guías de uso: modelos, hardware, configuración
├── docs/             ← Documentación técnica: errores, visión, arquitectura servidor
├── diario/           ← Diario de sesiones (YYYY-MM-DD-momento.md)
├── investigacion/    ← Comparativas, experimentos, resultados de pruebas
├── pruebas/          ← Scripts y resultados de pruebas puntuales
├── opensource/       ← Notas sobre proyectos open source relevantes
├── setup/            ← Instalación y configuración del entorno
├── litellm-config.yaml  ← Config de LiteLLM Colmena (18+ modelos)
├── opencode.json        ← Config de OpenCode (modelo default, reglas)
├── AGENTS.md            ← Instrucciones para OpenCode en computer-mode
├── ARQUITECTURA.md      ← Este archivo
├── ROADMAP.md           ← Qué hay hecho y qué viene
├── INICIO-AQUI.md       ← Brújula personal de Alvaro
└── README.md            ← README público del repo
```

---

## Cómo se conecta todo

```
Alvaro / Perplexity
       ↓ define fichas + arquitectura
   agentes/*.md
       ↓ describe qué hace cada agente
   scripts/*.sh
       ↓ implementa cómo ejecutarlo
   herramientas/*.sh
       ↓ bloques reutilizables (git, verificar, crear fichas)
   LiteLLM Colmena (:8000)
       ↓ enruta a 18+ modelos (Groq, Ollama, SambaNova...)
   OpenCode (computer-mode)
       ↓ lee AGENTS.md, ejecuta scripts, hace commits
   GitHub (main)
       ← fuente de verdad de todo
```

---

## Reglas para agentes

1. **Lee siempre `AGENTS.md`** antes de ejecutar cualquier tarea
2. **Busca en `agentes/`** si ya existe una ficha para lo que quieres hacer
3. **Usa `herramientas/`** en vez de reinventar git-commit o verificaciones
4. **Escribe en `diario/`** al terminar una sesión importante
5. **Actualiza `ROADMAP.md`** cuando completes algo
6. **Commits semánticos siempre**: `feat:`, `fix:`, `docs:`, `chore:`

---

## Flujo para crear un agente nuevo

```bash
# 1. Crear la ficha
bash herramientas/crear-ficha-agente.sh nombre-agente "descripcion" "capacidades"

# 2. Verificar que existe
bash herramientas/verificar-archivo.sh agentes/nombre-agente.md

# 3. Crear el script en scripts/
# (manualmente o con agente-creador-agentes)

# 4. Commit y push
bash herramientas/git-commit-push.sh "feat(agentes): add nombre-agente"
```

---

## Stack tecnológico

| Capa | Tecnología | Puerto |
|---|---|---|
| Proxy LLM | LiteLLM Colmena | :8000 |
| Agente código | OpenCode | TUI |
| Modelos locales | Ollama | :11434 |
| Modelos remotos | Groq / SambaNova / Together | API |
| Control versiones | Git + GitHub | — |
| Automatización | tmux (3 paneles) | — |

---

_Última actualización: 17 abril 2026 — carpeta herramientas/ operativa, sistema Colmena funcional_

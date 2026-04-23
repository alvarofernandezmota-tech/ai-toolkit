# Las 4 Entidades del Ecosistema

> Documento de referencia — leer antes de cualquier sesión.
> Última actualización: 23 abril 2026.

---

## Por qué esto es importante

Este ecosistema funciona con 4 entidades distintas. Confundir cuál hace qué genera errores,
dup prom contexto y trabajo perdido. Cada entidad tiene un rol claro y no sustituible.

---

## Las 4 entidades

| Entidad | Tipo | Acceso al repo | Rol principal |
|---------|------|---------------|---------------|
| **Álvaro** | Humano | Total (local + GitHub) | Director. Toma decisiones, da contexto, supervisa. |
| **Perplexity** | IA web con MCP GitHub | Vía GitHub API | Planificación, diarios, commits tracking, auditorías, preparación de prompts. |
| **Claude Code** | Agente CLI terminal | Directo filesystem | Ejecuta tareas autónomas, lee/escribe archivos, hace commits técnicos. |
| **Claude IA** | Modelo lenguaje web | Ninguno (contexto manual) | Razonamiento, análisis, código puntual, planificación técnica. |

---

## Dinámica de trabajo

```
Álvaro + Perplexity
    ↓ planifican, auditan, documentan, preparan prompts
    ↓ Perplexity hace commits de tracking directamente via MCP

Álvaro + Claude Code
    ↓ ejecutan tareas técnicas autónomas en el repo
    ↓ Claude Code hace commits técnicos

Álvaro + Claude IA
    ↓ razonan sobre problemas concretos
    ↓ Claude IA no tiene acceso al repo — Álvaro le pasa el contexto manualmente

Flujo típico:
Perplexity prepara el contexto/prompt → Claude Code lo ejecuta → Álvaro supervisa
```

---

## Cuándo usar cada entidad

| Tarea | Entidad ideal |
|-------|---------------|
| Diarios, tracking personal, commits de docs | Perplexity |
| Auditorías de repos, actualización de archivos MD | Perplexity |
| Código automático, scripts, commits técnicos | Claude Code |
| Planificación técnica compleja, arquitectura | Claude IA |
| Decisión final sobre qué hacer | Álvaro |
| Acción en portales externos (renovar keys, etc.) | Álvaro |

---

## Error común: confundir Claude Code con Claude IA

| | Claude Code | Claude IA |
|---|-------------|----------|
| **Dónde vive** | Terminal del PC grande | Navegador web |
| **Acceso al repo** | Sí, directo | No, necesita contexto manual |
| **Cómo se arranca** | `claude` en terminal | claude.ai o API |
| **Modelo** | Via LiteLLM o OpenRouter | Claude 3.x web |
| **Memoria** | Solo la sesión activa | Solo la conversación activa |
| **Para qué** | Ejecutar, escribir archivos | Pensar, planificar |

---

## Nota sobre Perplexity

Perplexity no es sólo un buscador — en este ecosistema actúa como **capa de planificación y memoria**:
- Tiene acceso MCP a GitHub → puede leer y escribir en repos directamente
- Mantiene el contexto de la conversación activa → recuerda todo lo hablado en la sesión
- Genera diarios, documentación y commits de tracking sin necesidad de terminal
- Prepara prompts para Claude Code y Claude IA

---

_Generado por: Perplexity AI + Álvaro — 23 abril 2026_

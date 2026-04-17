# 🤖 Agente — Autocorrección ai-toolkit

> **Propósito:** El propio repo `ai-toolkit` se audita, corrige y mantiene al día.
> Este agente revisa inconsistencias, actualiza docs y hace commits automáticos.

---

## 🎯 Qué hace

| Tarea | Frecuencia | Resultado |
|---|---|---|
| Revisar que todos los agentes en `agentes/` tienen su script en `scripts/` | Semanal | Lista de scripts faltantes |
| Actualizar ROADMAP marcando completados | Con cada sesión | ROADMAP al día |
| Actualizar CHANGELOG con los últimos commits | Con cada sesión | Historial completo |
| Crear diario de sesión en `diario/` | Al terminar de trabajar | `diario/YYYY-MM-DD.md` |
| Verificar que `litellm-config.yaml` tiene los modelos activos | Mensual | Config válida |
| Sincronizar ECOSISTEMA.md con el estado real de los repos | Semanal | Mapa actualizado |

---

## 🔧 Cómo invocarlo

Desde OpenCode (computer-mode), pega este prompt:

```
Eres el agente de autocorrección del repo ai-toolkit.
Repo: https://github.com/alvarofernandezmota-tech/ai-toolkit

Tarea:
1. Lee el ROADMAP.md y marca como ✅ todo lo que ya existe en el repo
2. Lee los últimos 10 commits y actualiza CHANGELOG.md
3. Crea diario/[HOY].md con resumen de la sesión
4. Verifica que cada agente en agentes/ tiene entrada en PENDIENTES.md
5. Commit todo: "docs(auto): auditoría repo [fecha]"

Reglas:
- Nunca borres contenido existente, solo añade/actualiza
- Si algo no está claro, déjalo con nota TODO:
- Commits semánticos siempre
```

---

## 📋 Checklist de auditoría semanal

```bash
# Ejecutar cada domingo antes del protocolo semanal
bash scripts/check-colmena.sh          # sistema OK
bash scripts/auditoria-repo.sh         # pendiente crear
```

**Puntos de la auditoría:**
- [ ] Todos los agentes en `agentes/` documentados
- [ ] ROADMAP refleja estado real
- [ ] CHANGELOG al día con todos los commits
- [ ] `litellm-config.yaml` sin modelos obsoletos
- [ ] ECOSISTEMA.md con versiones actuales de cada repo
- [ ] Diario de la semana cerrado
- [ ] Scripts en `herramientas/` todos ejecutables (`chmod +x`)

---

## 🧠 Prompt para auditoría completa del ecosistema

```
Audita el ecosistema completo de Álvaro:

Repos a revisar:
1. ai-toolkit — https://github.com/alvarofernandezmota-tech/ai-toolkit
2. thdora — https://github.com/alvarofernandezmota-tech/thdora
3. personal — https://github.com/alvarofernandezmota-tech/personal

Para cada repo:
- ¿Tiene AGENTE.md? Si no, crearlo
- ¿CHANGELOG al día?
- ¿Último commit hace más de 7 días? Alertar
- ¿README refleja versión actual?

Genera un informe markdown y commitéalo en:
ai-toolkit/diario/auditoria-[FECHA].md
```

---

_Creado: 17 abril 2026 — por Perplexity AI MCP_

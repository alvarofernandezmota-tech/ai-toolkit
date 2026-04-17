# Agente Git Commits — Gestión Automática de Repos

> Documenta, commitea y mantiene el histórico de trabajo sin esfuerzo manual.

---

## ¿Qué hace?

Automatiza el ciclo git: analiza cambios, genera mensajes de commit semánticos, hace push y actualiza el CHANGELOG. Puede correr como paso final de cualquier sesión de trabajo.

---

## Repos del ecosistema

| Repo | Path local | Propósito |
|---|---|---|
| `ai-toolkit` | `~/projects/ai-toolkit` | Infraestructura, config, docs |
| `thdora` (privado) | `~/projects/thdora` | App principal en desarrollo |

---

## Flujo de commit recomendado

```bash
# 1. Ver qué cambió
git status
git diff --stat

# 2. Añadir todo
git add -A

# 3. Commit con mensaje semántico
git commit -m "tipo(scope): descripción corta"

# 4. Push
git push
```

### Tipos de commit (Conventional Commits)

| Tipo | Cuándo |
|---|---|
| `feat` | Nueva funcionalidad o agente |
| `fix` | Corrección de bug o config rota |
| `docs` | Documentación, MDs, diarios |
| `chore` | Mantenimiento, scripts, dependencias |
| `refactor` | Reorganización sin cambio funcional |

---

## Con OpenCode (modo agente)

```bash
cd ~/projects/ai-toolkit
~/.npm-global/bin/opencode

# Prompt:
"Revisa todos los archivos modificados, genera mensajes de commit semánticos
con Conventional Commits, haz git add -A, git commit y git push.
Actualiza también CHANGELOG.md con los cambios de hoy."
```

---

## Script de cierre de sesión

```bash
# scripts/cerrar-sesion.sh — uso al final de cada sesión
git add -A
git commit -m "docs(diario): sesión $(date +%Y-%m-%d) — $(git diff --cached --stat | tail -1)"
git push
echo "✅ Sesión guardada en GitHub"
```

---

## Reglas de la repo

- **SIEMPRE** `git pull` antes de empezar a trabajar
- **NUNCA** commitear `.env`, keys, o archivos con credenciales
- **SIEMPRE** actualizar `CHANGELOG.md` con los cambios del día
- El `.gitignore` excluye: `.env`, `*.log`, `__pycache__/`, `node_modules/`, `.DS_Store`

---

## Estado

- ✅ Flujo manual documentado y funcionando
- ✅ OpenCode puede hacer commits autónomamente
- 🔴 Pendiente: `scripts/cerrar-sesion.sh` automatizado
- 🔴 Pendiente: pre-commit hook para validar no-secrets

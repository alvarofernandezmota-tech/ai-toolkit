# 🛠️ Herramientas

Scripts reutilizables que cualquier agente puede invocar como bloques LEGO.
No contienen lógica de negocio — son utilidades puras.

## Catálogo

| Script | Qué hace | Uso |
|---|---|---|
| `git-commit-push.sh` | add + commit semántico + push | `bash herramientas/git-commit-push.sh "feat: mensaje"` |
| `crear-ficha-agente.sh` | Genera `.md` en `agentes/` | `bash herramientas/crear-ficha-agente.sh nombre "descripcion"` |
| `verificar-archivo.sh` | Comprueba que un archivo existe | `bash herramientas/verificar-archivo.sh ruta/archivo.md` |

## Reglas

- Cada script es independiente y ejecutable directamente
- Siempre imprimen ✅ o ❌ con mensaje claro
- Se ejecutan desde la raíz del repo: `~/projects/ai-toolkit`
- Los agentes los llaman desde sus propios scripts en `scripts/`

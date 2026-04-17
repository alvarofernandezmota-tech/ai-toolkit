# 🛠️ herramientas/

Carpeta de scripts reutilizables para el ecosistema de agentes. Aquí viven las herramientas de apoyo que cualquier agente o sesión puede invocar directamente desde terminal.

---

## Propósito

Centralizar operaciones repetitivas (git, creación de fichas, verificación de archivos) en scripts bien definidos con interfaz clara: parámetros de entrada, salida esperada y códigos de error.

---

## Scripts disponibles

| Script | Uso | Descripción |
|---|---|---|
| `git-commit-push.sh` | `./git-commit-push.sh "feat: mensaje"` | add + commit semántico + push |
| `crear-ficha-agente.sh` | `./crear-ficha-agente.sh nombre "descripcion"` | genera `agentes/nombre.md` con plantilla |
| `verificar-archivo.sh` | `./verificar-archivo.sh ruta/archivo.md` | comprueba existencia, imprime OK o ERROR |

---

## Convenciones

- Todos los scripts son ejecutables (`chmod +x`)
- Reciben parámetros posicionales, no flags complejos
- Imprimen mensajes claros con emojis para facilitar lectura en terminal
- Devuelven código de salida `0` (éxito) o `1` (error)
- Se pueden llamar desde cualquier directorio del repo

---

## Cómo añadir un nuevo script

1. Crea el archivo `.sh` en esta carpeta
2. Añade cabecera con: propósito, uso, parámetros, ejemplos
3. Registralo en la tabla de arriba
4. Haz commit semántico: `feat(herramientas): añade script X`

---

_Parte del ecosistema [ai-toolkit](../README.md) — Sistema Colmena_

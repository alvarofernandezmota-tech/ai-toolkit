# Prueba: OpenCode no arranca automáticamente desde tmux

**Fecha:** 2026-04-16  
**Categoría:** opencode  
**Estado:** ⚠️ Parcial — funciona manualmente, no automático

## Qué probamos

Arrancar OpenCode automáticamente desde `tmux send-keys` en el script `start-colmena.sh`.

## Entorno

- OS: WSL Ubuntu en PC grande
- Node: v22.22.1
- opencode-ai: 1.4.7
- tmux: dentro de sesión colmena

## Pasos ejecutados

```bash
# El script lanza esto automáticamente:
tmux send-keys -t colmena:0.0 "cd $DIR && sleep 10 && opencode" Enter

# Intentos manuales:
opencode 2>/dev/null           # sale sin output
opencode 2>&1                  # sale sin output
script -q -c "opencode" /dev/null  # sale sin output
opencode --version             # sale sin output
```

## Resultado

OpenCode sale inmediatamente sin mostrar nada, ni error ni UI.

## Error

```
-bash: /home/alvaro/.openclaw/completions/openclaw.bash: No such file or directory
```

Este error aparece en cada nuevo panel tmux (es del `.bashrc`).

## Causa raíz

OpenCode v1.4.7 no arranca cuando se lanza desde `tmux send-keys` sin TTY interactiva completa. El proceso termina silenciosamente.

## Solución / Workaround

**Fix del error openclaw (permanente):**
```bash
mkdir -p ~/.openclaw/completions
touch ~/.openclaw/completions/openclaw.bash
```

**Para arrancar OpenCode:**
1. Salir de tmux: `Ctrl+B D`
2. Ejecutar desde terminal normal: `bash scripts/start-colmena.sh`
3. Una vez dentro de tmux, si no abre solo: hacer click en panel izquierdo y escribir `opencode` manualmente

## Lecciones aprendidas

- OpenCode requiere TTY interactiva real — no funciona bien lanzado automáticamente desde scripts tmux
- El error de openclaw no es el causante, solo ruido visual
- Node v22 y opencode-ai 1.4.7 están correctos — el problema es el entorno de lanzamiento
- Pendiente: investigar si `tmux new-window` en lugar de `send-keys` resuelve el problema

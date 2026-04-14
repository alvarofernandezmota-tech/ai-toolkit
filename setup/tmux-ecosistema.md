# 🖥️ tmux — Arrancar todo el ecosistema en 1 comando

> tmux divide tu terminal en paneles. Ves THDORA, Aider y los logs a la vez sin abrir varias ventanas.

---

## Instalar tmux

```bash
sudo apt-get install -y tmux
```

---

## Comando maestro — levanta todo

Añade este alias a `~/.bashrc` (setup.sh ya lo hace):

```bash
alias arrancar='tmux new-session -s ecosistema \
  \; send-keys "cd ~/projects/thdora && make run-api" C-m \
  \; split-window -h \
  \; send-keys "sleep 2 && make run-bot" C-m \
  \; split-window -v \
  \; send-keys "aider-thdora" C-m \
  \; select-pane -t 0 \
  \; split-window -v \
  \; send-keys "docker start n8n 2>/dev/null; echo n8n en localhost:5678" C-m'
```

Uso:
```bash
arrancar
```

Resultado en pantalla:
```
┌──────────────────────┬──────────────────────┐
│  THDORA API (logs)    │  THDORA BOT (logs)    │
├──────────────────────┼──────────────────────┤
│  n8n arrancado        │  AIDER (coding IA)    │
└──────────────────────┴──────────────────────┘
```

---

## Comandos básicos de tmux

| Acción | Comando |
|---|---|
| Moverse entre paneles | `Ctrl+B` luego flecha direccional |
| Cerrar panel actual | `Ctrl+B` luego `X` |
| Salir sin cerrar nada | `Ctrl+B` luego `D` (detach) |
| Volver a la sesión | `tmux attach -t ecosistema` |
| Ver sesiones activas | `tmux ls` |
| Matar todo | `tmux kill-session -t ecosistema` |

---

## Parar todo limpiamente

```bash
tmux kill-session -t ecosistema   # para THDORA + Aider
docker stop n8n                   # para n8n
```

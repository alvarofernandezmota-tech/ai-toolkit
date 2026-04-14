# 🔄 n8n self-hosted — Orquestador de automatizaciones (Mayo 2026)

> n8n es el Zapier/Make open-source. Corre en Docker, se programa con interfaz visual, y conecta THDORA con el mundo.
> **Fecha objetivo: Mayo 2026.**

---

## Requisitos previos

- Docker instalado (setup.sh lo instala)
- WSL2 con Ubuntu 22.04 o Ubuntu nativo

### Instalar Docker en WSL2

```bash
# Método 1: script oficial Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
newgrp docker

# Verificar
docker --version
docker run hello-world
```

---

## Arrancar n8n en 1 comando

```bash
docker run -d \
  --name n8n \
  --restart unless-stopped \
  -p 5678:5678 \
  -v ~/.n8n:/root/.n8n \
  n8nio/n8n
```

**Acceder:** abrir navegador → `http://localhost:5678`

Primer uso: te pide crear usuario y contraseña. Solo para ti, no hay que usar email real.

---

## Comandos de gestión

```bash
docker start n8n      # arrancar
docker stop n8n       # parar
docker restart n8n    # reiniciar
docker logs n8n       # ver logs
docker ps             # ver si está corriendo
```

---

## Los 5 workflows que hay que crear

### Workflow 1 — Brief nocturno (prioridad 1)

**Cuándo:** cada noche a las 22:00
**Qué hace:** mira la agenda de mañana en THDORA → manda mensaje por Telegram

```
Schedule (22:00) → HTTP Request (THDORA API /citas/manana) → Telegram (mensaje resumen)
```

**Mensaje que llega:**
```
📅 Mañana tienes:
• 10:00 — Médico
• 16:00 — Gimnasio
```

---

### Workflow 2 — Alerta hábitos (prioridad 2)

**Cuándo:** cada noche a las 22:00
**Qué hace:** comprueba si has marcado todos los hábitos del día → si no, avisa

```
Schedule (22:00) → HTTP Request (THDORA API /habitos/hoy) → IF (hay pendientes) → Telegram (alerta)
```

**Mensaje que llega:**
```
⚠️ Te quedan hábitos sin marcar:
• 💧 Agua (4/8 vasos)
• 🏃 Ejercicio
```

---

### Workflow 3 — Diario automático (prioridad 3)

**Cuándo:** cada noche a las 23:00
**Qué hace:** recoge hábitos del día + citas del día → genera texto → commit en repo `personal`

```
Schedule (23:00) → HTTP Request (THDORA API /resumen/hoy) → Code (generar markdown) → GitHub (commit en personal)
```

**Fichero que crea:**
```
personal/diarios/2026-05-01.md
```

---

### Workflow 4 — Resumen semanal (prioridad 4)

**Cuándo:** lunes a las 08:00
**Qué hace:** recoge la semana (hábitos, citas, commits) → resumen → Telegram

```
Schedule (lunes 08:00) → HTTP Request (varios endpoints) → Merge → Code (generar resumen) → Telegram
```

---

### Workflow 5 — Commit personal automático (prioridad 5)

**Cuándo:** cada noche a las 23:30
**Qué hace:** comprueba si has escrito en el diario → si no, crea entrada vacía → commit en `personal`

---

## Variables de entorno para n8n

En el panel de n8n: **Settings → Credentials** → añadir:

| Credencial | Tipo | Valor |
|---|---|---|
| Telegram | Telegram API | Tu token de @BotFather |
| GitHub | GitHub API | Token con permisos `repo` |
| THDORA API | HTTP Header Auth | `localhost:8000` |

---

## Datos en `~/.n8n`

Todos los workflows, credenciales y configuración se guardan en `~/.n8n`. Para hacer backup:

```bash
tar -czf n8n-backup-$(date +%Y%m%d).tar.gz ~/.n8n
```

---

## Actualizar n8n

```bash
docker stop n8n
docker rm n8n
docker pull n8nio/n8n
# Volver a ejecutar el comando de arranque
```

Los datos en `~/.n8n` no se pierden.

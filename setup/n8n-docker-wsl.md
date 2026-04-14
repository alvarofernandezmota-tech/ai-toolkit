# 🔄 n8n en WSL con Docker — Setup completo

> Orquestador de workflows con IA integrada. Conecta THDORA con Gmail, GitHub, Telegram, y 400+ servicios.

## Opción A — Docker simple (más rápido)

```bash
# 1. Instalar Docker en WSL Ubuntu-22.04
sudo apt update
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
newgrp docker  # aplicar sin reiniciar

# 2. Verificar
docker --version

# 3. Arrancar n8n
docker run -d \
  --name n8n \
  --restart unless-stopped \
  -p 5678:5678 \
  -v ~/.n8n:/root/.n8n \
  n8nio/n8n

# 4. Acceder
# Abrir en navegador: http://localhost:5678
```

## Opción B — AI Starter Kit oficial (recomendado)

Incluye n8n + Ollama + Qdrant preconfigurados para IA:

```bash
git clone https://github.com/n8n-io/self-hosted-ai-starter-kit.git
cd self-hosted-ai-starter-kit
docker compose up -d
# http://localhost:5678
```

## Comandos útiles

```bash
# Ver estado
docker ps
docker logs n8n

# Parar / arrancar
docker stop n8n
docker start n8n

# Actualizar n8n
docker pull n8nio/n8n
docker stop n8n && docker rm n8n
# volver a ejecutar el docker run de arriba
```

## Primeros workflows a crear

1. **Resumen semanal** — agrega citas y hábitos de THDORA + commits de GitHub → genera resumen con Groq → manda por Telegram
2. **Diario automático** — cada noche crea entrada en `personal` repo
3. **Alertas hábitos** — si a las 22:00 no has marcado agua, te avisa por Telegram
4. **Sync calendario** — citas THDORA → Google Calendar

## Referencia

- [n8n.io/docs](https://docs.n8n.io)
- [github.com/n8n-io/self-hosted-ai-starter-kit](https://github.com/n8n-io/self-hosted-ai-starter-kit)

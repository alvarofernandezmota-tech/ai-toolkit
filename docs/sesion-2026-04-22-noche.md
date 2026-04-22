# Sesión 2026-04-22 Noche

## Resumen
Sesión de troubleshooting y configuración de acceso remoto SSH desde el Acer al PC grande (WSL).

---

## Problemas resueltos

### 1. Cuelgue del PC por saturación de RAM
- **Causa**: Lanzar varios modelos grandes simultáneamente (deepseek-r1:14b + qwen2.5-coder:14b = ~18GB RAM)
- **Síntoma**: El sistema se colgó completamente al cargar el modelo
- **Solución temporal**: Reinicio forzado del PC
- **Solución permanente pendiente**: Limitar Ollama a 1 modelo cargado a la vez

```bash
# Añadir al servicio ollama
sudo systemctl edit ollama
# [Service]
# Environment="OLLAMA_MAX_LOADED_MODELS=1"
# Environment="OLLAMA_NUM_PARALLEL=1"
```

### 2. Setup SSH Acer → PC grande (WSL)

**Contexto**: El PC grande corre Ubuntu en WSL2 sobre Windows. Para controlarlo remotamente desde el Acer hay que hacer portproxy porque WSL tiene su propia IP interna.

**IPs relevantes**:
- IP Windows (WiFi): `10.202.77.228`
- IP WSL interna: `172.25.139.192`
- Puerto SSH WSL: `2222` (el 22 lo intercepta Windows)

**Pasos realizados**:

1. Arrancar SSH en WSL (PC grande):
```bash
sudo service ssh start
```

2. Cambiar puerto SSH a 2222 en WSL:
```bash
sudo sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config
sudo service ssh restart
```

3. Configurar portproxy en PowerShell Admin (PC grande):
```powershell
netsh interface portproxy delete v4tov4 listenport=22 listenaddress=0.0.0.0
netsh interface portproxy add v4tov4 listenport=2222 listenaddress=0.0.0.0 connectport=2222 connectaddress=172.25.139.192
netsh advfirewall firewall add rule name="SSH2222" dir=in action=allow protocol=TCP localport=2222
```

4. Conectar desde el Acer:
```bash
ssh -p 2222 alvaro@10.202.77.228
```

**Nota**: El puerto 22 da `Connection reset` porque Windows tiene su propio SSH server que intercepta antes de llegar a WSL.

---

## Estado del sistema al final de la sesión

- ✅ Ollama corriendo en localhost:11434
- ✅ Modelos disponibles: deepseek-r1:14b, qwen2.5-coder:14b, qwen3:8b-q4_K_M, nomic-embed-text
- ✅ LiteLLM arrancado en puerto 8000
- ✅ OpenCode actualizado a v1.14.20
- ✅ SSH accesible desde Acer vía puerto 2222
- ✅ Colmena tmux activa (sesión `colmena`)

---

## Pendientes

- [ ] Configurar OLLAMA_MAX_LOADED_MODELS=1 para evitar cuelgues de RAM
- [ ] Hacer el portproxy persistente (se pierde al reiniciar Windows)
- [ ] Documentar IP del Acer para conectar en sentido inverso si hace falta

---

## Cómo reconectar en próximas sesiones

Desde el Acer:
```bash
ssh -p 2222 alvaro@10.202.77.228
cd ~/projects/ai-toolkit
bash scripts/start-colmena.sh
tmux attach -t colmena
```

# Setup Servidor: WSL + SSH + Ollama + OpenCode

> Guía actualizada el 17/04/2026. Estado: SSH instalado, pendiente copiar clave (Acer sin batería).

## Arquitectura

```
PC Grande (Windows + WSL2 Ubuntu) — GTX 1060 6GB
├── Ollama         → modelos locales corriendo en WSL (GPU: GTX 1060 6GB)
├── OpenCode v1.4.6 → apunta a Ollama local + LiteLLM Colmena
├── Todas las repos → gestionadas desde aquí
└── SSH Server     → acceso remoto desde Acer (puerto 2222)

        ↑ SSH (VSCode Remote-SSH, puerto 2222)
        ↑ IP: 10.159.182.228 (Windows Wi-Fi)

Acer 15" (Windows)
└── VSCode + Remote-SSH
    → edita y ejecuta todo en el PC grande
    → el Acer sigue siendo independiente
```

---

## Datos de red

| Concepto | Valor |
|---|---|
| IP Windows (Wi-Fi) | `10.159.182.228` |
| IP WSL interno | `172.25.139.192` |
| Usuario SSH | `alvaro` |
| Puerto SSH | `2222` |
| Clave SSH Acer | `C:\Users\Varo\.ssh\id_ed25519` |

---

## 1. Ollama ✅ (instalado y funcionando)

### Modelos disponibles

| Modelo | Tamaño | Estado | Uso |
|---|---|---|---|
| qwen3:8b-q4_K_M | 5.2 GB | ✅ Funcionando | Chat general, razonamiento |
| qwen2.5-coder:7b | 4.7 GB | ✅ Funcionando | Código rápido |
| nomic-embed-text | 274 MB | ✅ Descargado | Embeddings / RAG |
| qwen2.5-coder:14b | ~9 GB | ⏳ Descargando | Código potente (VRAM + RAM) |
| deepseek-r1:14b | ~9 GB | ⏳ Pendiente | Razonamiento profundo |

> GPU: GTX 1060 6GB — modelos 8b caben en VRAM, los 14b usan VRAM + RAM.

### Comandos básicos
```bash
ollama list           # ver modelos instalados
ollama run <modelo>   # probar un modelo
ollama serve          # arrancar servidor en http://localhost:11434
curl http://localhost:11434/api/tags  # verificar que está corriendo
```

---

## 2. OpenCode v1.4.6 ✅

```bash
# Versión instalada
opencode --version  # 1.4.6

# Arrancar (usa opencode.json de esta repo)
opencode
```

El `opencode.json` de esta repo apunta a:
- Ollama local en `http://localhost:11434`
- LiteLLM Colmena (modelos en la nube)

Pendiente: añadir qwen2.5-coder:14b y deepseek-r1:14b cuando terminen de descargarse.

---

## 3. SSH Server en Windows — Setup completo

### 3.1 Instalar OpenSSH Server ✅
```powershell
# PowerShell como Administrador en el PC grande
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType Automatic
```

### 3.2 OpenSSH Server en WSL Ubuntu ✅
```bash
sudo apt install openssh-server
sudo nano /etc/ssh/sshd_config
# Cambiar: Port 2222
sudo service ssh restart
```

### 3.3 Port forwarding Windows → WSL (puerto 2222) ✅
```powershell
netsh interface portproxy add v4tov4 listenport=2222 listenaddress=0.0.0.0 connectport=2222 connectaddress=172.25.139.192
```

### 3.4 Firewall ✅
```powershell
netsh advfirewall firewall add rule name="SSH-WSL" dir=in action=allow protocol=TCP localport=2222
netsh advfirewall firewall add rule name="SSH-WSL" dir=out action=allow protocol=TCP localport=2222
```

### 3.5 Verificar que todo está corriendo
```powershell
Get-Service sshd  # debe decir "Running"
```

---

## 4. Clave SSH sin contraseña — desde el Acer

### 4.1 Generar clave ✅ (ya hecho)
```powershell
# PowerShell en el Acer
ssh-keygen -t ed25519 -f "$env:USERPROFILE\.ssh\id_ed25519"
# Enter x2 (sin passphrase)
```

### 4.2 Copiar clave al servidor ❌ (pendiente — Acer se quedó sin batería)
```powershell
# Ejecutar desde Acer — pedirá contraseña UNA ÚLTIMA VEZ
type $env:USERPROFILE\.ssh\id_ed25519.pub | ssh -p 2222 alvaro@10.159.182.228 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

### 4.3 Probar conexión sin contraseña
```powershell
ssh -p 2222 alvaro@10.159.182.228
# Debe conectar directo, sin pedir contraseña
```

---

## 5. VSCode Remote-SSH desde el Acer ❌ (pendiente)

### 5.1 Extensión necesaria
`Ctrl+Shift+X` → buscar **"Remote - SSH"** → instalar

### 5.2 Config SSH (`C:\Users\Varo\.ssh\config`)
```
Host servidor-pc
  HostName 10.159.182.228
  User alvaro
  Port 2222
  IdentityFile ~/.ssh/id_ed25519
```

### 5.3 Conectar
`Ctrl+Shift+P` → **"Remote-SSH: Connect to Host"** → `servidor-pc`

### 5.4 Abrir repo
`File → Open Folder` → `/home/alvaro/` (o la ruta de tu repo)

---

## 6. OpenCode con modelo local (una vez conectado)

```bash
# Desde terminal de VSCode remoto
curl http://localhost:11434/api/tags  # verificar Ollama
opencode  # usa opencode.json de la repo
```

---

## ⚠️ Port forwarding no persiste al reiniciar Windows

El port forwarding con `netsh portproxy` se pierde al reiniciar. Script para automatizarlo:

```powershell
# Guardar como setup-ssh-forwarding.ps1 y ejecutar al iniciar Windows
netsh interface portproxy delete v4tov4 listenport=2222 listenaddress=0.0.0.0
$wslIP = (wsl hostname -I).Trim()
netsh interface portproxy add v4tov4 listenport=2222 listenaddress=0.0.0.0 connectport=2222 connectaddress=$wslIP
```

Este script detecta la IP de WSL automáticamente (cambia en cada reinicio).

---

## Estado actual (17/04/2026)

| Paso | Estado |
|---|---|
| Ollama instalado y funcionando | ✅ |
| Modelos 7-8b listos | ✅ |
| Modelos 14b | ⏳ Descargando/pendiente |
| OpenCode v1.4.6 instalado | ✅ |
| IP de red identificada | ✅ |
| Port forwarding puerto 2222 | ✅ |
| Firewall abierto puerto 2222 | ✅ |
| OpenSSH Server (Windows) | ✅ sshd Running + Automatic |
| OpenSSH Server (WSL) puerto 2222 | ✅ |
| Clave SSH copiada al servidor | ❌ Pendiente (Acer sin batería) |
| VSCode Acer conectado por SSH | ❌ Pendiente |
| opencode.json con modelos 14b | ❌ Pendiente |
| OpenCode funcionando desde Acer | ❌ Pendiente |

---

## Próximos pasos

> **Requisito previo:** Comprar cargador Acer

1. `Get-Service sshd` → verificar `Running`
2. `ollama list` → verificar modelos 14b descargados
3. Copiar clave SSH desde Acer (paso 4.2)
4. Conectar VSCode del Acer (paso 5)
5. Actualizar `opencode.json` con los modelos 14b
6. Actualizar `ECOSISTEMA.md` → Ollama local ✅ Funcionando
7. Crear script permanente para port forwarding (ver sección ⚠️)

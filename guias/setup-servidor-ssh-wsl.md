# Setup Servidor: WSL + SSH + Ollama + OpenCode

> Guía creada el 16/04/2026. Estado: SSH en proceso de configuración.

## Arquitectura

```
PC Grande (Windows + WSL2 Ubuntu)
├── Ollama         → modelo de lenguaje local corriendo en WSL
├── OpenCode       → agente de código apuntando a Ollama
├── Todas las repos → gestionadas desde aquí
└── SSH Server     → acceso remoto desde Acer

        ↑ SSH (VSCode Remote-SSH)
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
| Puerto SSH | `22` |
| Clave SSH Acer | `C:\Users\Varo\.ssh\id_ed25519` |

---

## 1. Ollama (ya instalado ✅)

Ollama corre en WSL Ubuntu. Para verificar:
```bash
ollama list          # ver modelos instalados
ollama run <modelo>  # probar un modelo
```

Para que OpenCode lo use, Ollama debe estar escuchando:
```bash
ollama serve
```
Por defecto en `http://localhost:11434`.

---

## 2. SSH Server en Windows — Setup completo

### 2.1 Instalar OpenSSH Server
```powershell
# PowerShell como Administrador en el PC grande
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType Automatic
```

### 2.2 Port forwarding Windows → WSL
```powershell
netsh interface portproxy add v4tov4 listenport=22 listenaddress=0.0.0.0 connectport=22 connectaddress=172.25.139.192
```

### 2.3 Firewall
```powershell
netsh advfirewall firewall add rule name="SSH" dir=in action=allow protocol=TCP localport=22
netsh advfirewall firewall add rule name="SSH" dir=out action=allow protocol=TCP localport=22
```

### 2.4 Verificar que todo está corriendo
```powershell
Get-Service sshd  # debe decir "Running"
```

---

## 3. Clave SSH sin contraseña — desde el Acer

### 3.1 Generar clave (ya hecho ✅)
```powershell
# PowerShell en el Acer
ssh-keygen -t ed25519 -f "$env:USERPROFILE\.ssh\id_ed25519"
# Enter x2 (sin passphrase)
```

### 3.2 Copiar clave al servidor (pendiente ⏳)
```powershell
# Ejecutar desde Acer — pedirá contraseña UNA ÚLTIMA VEZ
type $env:USERPROFILE\.ssh\id_ed25519.pub | ssh alvaro@10.159.182.228 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

### 3.3 Probar conexión sin contraseña
```powershell
ssh alvaro@10.159.182.228
# Debe conectar directo, sin pedir contraseña
```

---

## 4. VSCode Remote-SSH desde el Acer

### 4.1 Extensión necesaria
`Ctrl+Shift+X` → buscar **"Remote - SSH"** → instalar

### 4.2 Config SSH (`C:\Users\Varo\.ssh\config`)
```
Host servidor-pc
  HostName 10.159.182.228
  User alvaro
  IdentityFile ~/.ssh/id_ed25519
```

### 4.3 Conectar
`Ctrl+Shift+P` → **"Remote-SSH: Connect to Host"** → `servidor-pc`

### 4.4 Abrir repo
`File → Open Folder` → `/home/alvaro/` (o la ruta de tu repo)

---

## 5. OpenCode con modelo local

Una vez conectado por SSH, desde la terminal de VSCode:

```bash
# Verificar que Ollama está corriendo
curl http://localhost:11434/api/tags

# Arrancar OpenCode apuntando al modelo local
opencode  # usará opencode.json de la repo
```

El `opencode.json` ya está configurado en esta repo con los modelos disponibles.

---

## ⚠️ Problema conocido: port forwarding no persiste

El port forwarding con `netsh portproxy` se pierde al reiniciar Windows. Para que sea permanente, crear una tarea programada o un script de inicio:

```powershell
# Guardar como setup-ssh-forwarding.ps1 y ejecutar al iniciar
netsh interface portproxy delete v4tov4 listenport=22 listenaddress=0.0.0.0
$wslIP = (wsl hostname -I).Trim()
netsh interface portproxy add v4tov4 listenport=22 listenaddress=0.0.0.0 connectport=22 connectaddress=$wslIP
```

Este script detecta la IP de WSL automáticamente (cambia en cada reinicio).

---

## Estado actual (16/04/2026)

| Paso | Estado |
|---|---|
| Ollama instalado y funcionando | ✅ |
| OpenCode configurado (`opencode.json`) | ✅ |
| IP de red identificada | ✅ |
| Port forwarding configurado | ✅ |
| Firewall abierto | ✅ |
| OpenSSH Server instalado | ⏳ Instalando |
| Clave SSH copiada al servidor | ❌ Pendiente |
| VSCode Acer conectado por SSH | ❌ Pendiente |
| OpenCode funcionando desde Acer | ❌ Pendiente |

---

## Próximos pasos

1. Verificar: `Get-Service sshd` → debe estar `Running`
2. Copiar clave SSH desde Acer
3. Conectar VSCode del Acer
4. Abrir esta repo en VSCode remoto
5. Lanzar `opencode` y probar con modelo local
6. Crear script permanente para el port forwarding

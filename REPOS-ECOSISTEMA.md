# 🗂️ REPOS-ECOSISTEMA — Auditoría completa

> Última actualización: 2026-04-16
> Total repos: 11

---

## Resumen rápido

| Repo | Estado | Descripción | Clonar |
|------|--------|-------------|--------|
| [thdora](https://github.com/alvarofernandezmota-tech/thdora) | ✅ Activa v0.14.0 | Bot Telegram + FastAPI, 10 issues abiertos | `git clone https://github.com/alvarofernandezmota-tech/thdora` |
| [personal](https://github.com/alvarofernandezmota-tech/personal) | ✅ Activa | Sistema vida personal, diarios, tracking | `git clone https://github.com/alvarofernandezmota-tech/personal` |
| [ai-toolkit](https://github.com/alvarofernandezmota-tech/ai-toolkit) | ✅ Activa | Stack IA, LiteLLM proxy, OpenCode (ESTE REPO) | — |
| [thea-ia](https://github.com/alvarofernandezmota-tech/thea-ia) | ⏸️ Pausada | Python FastAPI, precursor de THDORA | `git clone https://github.com/alvarofernandezmota-tech/thea-ia` |
| [AppointmentManager](https://github.com/alvarofernandezmota-tech/AppointmentManager) | ⏸️ Pausada | Gestor citas Python | `git clone https://github.com/alvarofernandezmota-tech/AppointmentManager` |
| [ejerciciosbego](https://github.com/alvarofernandezmota-tech/ejerciciosbego) | ✅ Activa | Docencia Python asociación | `git clone https://github.com/alvarofernandezmota-tech/ejerciciosbego` |
| [python-snippets](https://github.com/alvarofernandezmota-tech/python-snippets) | ✅ Activa | Contenido Instagram (snippets Python) | `git clone https://github.com/alvarofernandezmota-tech/python-snippets` |
| [image-calculator](https://github.com/alvarofernandezmota-tech/image-calculator) | 📦 Publicada | OCR + tkinter, calculadora por imagen | `git clone https://github.com/alvarofernandezmota-tech/image-calculator` |
| [ocr-number-adder](https://github.com/alvarofernandezmota-tech/ocr-number-adder) | 📦 Publicada | OCR simple, suma números en imagen | `git clone https://github.com/alvarofernandezmota-tech/ocr-number-adder` |
| [unix](https://github.com/alvarofernandezmota-tech/unix) | ✅ Activa | Apuntes SO II, ejercicios bash/Unix | `git clone https://github.com/alvarofernandezmota-tech/unix` |
| [brunobailosolo](https://github.com/alvarofernandezmota-tech/brunobailosolo) | ⚠️ Otro | Perfil externo / otro propietario | — |

---

## Clonar workspace completo

```bash
cd ~/projects
git clone https://github.com/alvarofernandezmota-tech/thdora
git clone https://github.com/alvarofernandezmota-tech/personal
git clone https://github.com/alvarofernandezmota-tech/unix
git clone https://github.com/alvarofernandezmota-tech/ejerciciosbego
git clone https://github.com/alvarofernandezmota-tech/python-snippets
# Pausadas (clonar si retomas):
# git clone https://github.com/alvarofernandezmota-tech/thea-ia
# git clone https://github.com/alvarofernandezmota-tech/AppointmentManager
```

---

## Detalle por repo

### thdora ✅
- **Stack:** Python, FastAPI, python-telegram-bot
- **Estado:** v0.14.0 activa, ~10 issues abiertos
- **Descripción:** Bot de Telegram personal con IA integrada. Precursor del ecosistema actual.
- **Conexión ai-toolkit:** usa los mismos modelos vía API directa (futuro: conectar al proxy LiteLLM)
- **Pendiente:** Revisar issues abiertos, conectar al proxy LiteLLM de ai-toolkit

### personal ✅
- **Stack:** Markdown, scripts bash
- **Estado:** Activa, uso diario
- **Descripción:** Sistema personal — diarios, tracking hábitos, notas de vida.
- **Pendiente:** —

### ai-toolkit ✅ (ESTE REPO)
- **Stack:** Bash, YAML, JSON
- **Estado:** Activa, núcleo del ecosistema IA
- **Descripción:** Stack completo de agentes IA. LiteLLM proxy, OpenCode, Aider, scripts de rotación de modelos.
- **Arquitectura:** `ai-menu.sh → start-colmena.sh → LiteLLM:8000 → Groq/SambaNova/Together/OpenRouter/Gemini/Cerebras`

### thea-ia ⏸️
- **Stack:** Python, FastAPI
- **Estado:** Pausada
- **Descripción:** Precursor de THDORA. API de IA con FastAPI.
- **Pendiente:** Decidir si retomar o archivar definitivamente.

### AppointmentManager ⏸️
- **Stack:** Python
- **Estado:** Pausada
- **Descripción:** Gestor de citas con Python.
- **Pendiente:** Decidir si retomar o archivar.

### ejerciciosbego ✅
- **Stack:** Python
- **Estado:** Activa
- **Descripción:** Ejercicios Python para docencia en asociación.
- **Pendiente:** —

### python-snippets ✅
- **Stack:** Python
- **Estado:** Activa
- **Descripción:** Snippets Python para contenido de Instagram.
- **Pendiente:** —

### image-calculator 📦
- **Stack:** Python, Tesseract OCR, tkinter
- **Estado:** Publicada, sin mantenimiento activo
- **Descripción:** Calculadora que lee números desde imágenes con OCR.
- **Pendiente:** —

### ocr-number-adder 📦
- **Stack:** Python, Tesseract OCR
- **Estado:** Publicada, sin mantenimiento activo
- **Descripción:** Suma números detectados en imágenes con OCR.
- **Pendiente:** —

### unix ✅
- **Stack:** Markdown, bash
- **Estado:** Activa
- **Descripción:** Apuntes y ejercicios de SO II (bash, Unix, sistemas operativos).
- **Pendiente:** —

### brunobailosolo ⚠️
- **Estado:** No es un proyecto propio / perfil externo
- **Pendiente:** Revisar si borrar o mantener.

---

## Instalar gh CLI (para que OpenCode liste repos)

```bash
sudo apt install gh
gh auth login
# Luego para listar repos:
gh repo list alvarofernandezmota-tech
```

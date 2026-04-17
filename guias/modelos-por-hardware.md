# 🖥️ Modelos LLM por Hardware — Guía práctica

> Referencia rápida: qué modelo usar según el hardware disponible.
> Basado en hardware real del ecosistema. Actualizado: 17 abril 2026.

---

## 🎯 Hardware del ecosistema

| Equipo | CPU | GPU | VRAM | RAM | Rol |
|--------|-----|-----|------|-----|-----|
| PC Principal | ⏳ pendiente `lscpu` | GTX 1060 | 6GB | 16GB | Servidor + Dev + LLM local |
| Acer Aspire A515-45 | Ryzen 5 5500U | Radeon integrada | ❌ | 8GB | Cliente SSH ligero |

---

## 🔵 GTX 1060 — 6GB VRAM + 16GB RAM

### Modelos que caben enteros en VRAM (rápidos)

| Modelo | Cuant. | VRAM | t/s estimado | Mejor para |
|--------|--------|------|--------------|------------|
| **Qwen3:4b** | q4_K_M | ~2.5GB | ~50 t/s | ⭐ Orquestador, router, respuestas rápidas |
| **Phi-4 mini** | q4_K_M | ~2.5GB | ~45 t/s | Razonamiento, código corto |
| **Phi-3.5 Mini** | q4_K_M | ~2.5GB | ~55 t/s | Ultra rápido, tareas simples |
| **Gemma3 4B** | q4_K_M | ~3GB | ~40 t/s | Multimodal, chat |
| **DeepSeek-Coder 6.7B** | q4_K_M | ~4GB | ~28 t/s | Coding especializado |
| **Qwen2.5-Coder 7B** | q4_K_M | ~4.5GB | ~25 t/s | ⭐ Coding principal — el mejor para dev |
| **Llama 3.1 8B** | q4_K_M | ~5GB | ~20 t/s | Chat general, instrucciones |

### Modelos en modo split GPU+CPU (más lentos, pero posibles)

| Modelo | VRAM+RAM | t/s estimado | Notas |
|--------|----------|--------------|-------|
| Llama 3 13B | ~8GB split | ~10 t/s | Funciona, lento |
| Mistral 22B | ~14GB split | ~5 t/s | Muy lento, solo para testing |

> Para split: `OLLAMA_NUM_GPU_LAYERS=20 ollama run llama3:13b`

---

## 🟡 CPU-only (sin GPU / Acer Aspire vía SSH al PC)

Sin GPU dedicada, todo en RAM. Solo viable con modelos pequeños:

| Modelo | RAM necesaria | t/s CPU | Para qué |
|--------|---------------|---------|----------|
| Phi-3.5 Mini q4 | ~2.5GB | ~5 t/s | Pruebas ligeras |
| Qwen3:4b q4 | ~2.5GB | ~8 t/s | Emergencia sin GPU |

> 💡 En la práctica: el Acer conecta por SSH al PC Principal y usa su GPU. No corre modelos local.

---

## 🚀 Arquitectura orquestador recomendada

```
Usuario / OpenCode / Claude Code
          │
          ▼
  Orquestador (qwen3:4b — 2.5GB VRAM, rápido)
          │
          ├── tarea coding    → descarga orquestador, carga qwen2.5-coder:7b
          ├── tarea rápida    → responde él mismo sin cambiar modelo
          └── tarea razonamiento → phi-4-mini
```

> Con 6GB VRAM no hay dos modelos simultáneos. Ollama gestiona el swap automáticamente.

---

## ⚡ Comandos rápidos

```bash
# Ver VRAM disponible
nvidia-smi

# Modelo coding principal
ollama pull qwen2.5-coder:7b-instruct-q4_K_M
ollama run qwen2.5-coder:7b-instruct-q4_K_M

# Orquestador rápido
ollama pull qwen3:4b
ollama run qwen3:4b

# Ver modelos instalados
ollama list

# Split GPU+CPU para modelos grandes
OLLAMA_NUM_GPU_LAYERS=20 ollama run llama3:13b
```

---

## 📅 Historial

| Fecha | Cambio |
|-------|--------|
| 17 abril 2026 | Creado — hardware real GTX 1060 6GB, modelos 2026 |

_Creado: 17 abril 2026 — por Perplexity AI MCP_

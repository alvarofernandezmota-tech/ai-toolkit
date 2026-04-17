# Agente Ollama — Modelos Locales GTX 1060

> Modelos de IA corriendo 100% local en el PC grande. Sin internet, sin coste, sin límites.

---

## ¿Qué es?

Ollama gestiona y sirve modelos de lenguaje localmente en el PC grande (WSL Ubuntu + GTX 1060 6GB). Los modelos corren en GPU cuando caben en VRAM, o en modo mixto VRAM+RAM para los más grandes.

**Endpoint:** `http://localhost:11434`  
**Compatible con:** API OpenAI-compatible → LiteLLM los consume directamente.

---

## Hardware

| Componente | Spec |
|---|---|
| GPU | NVIDIA GTX 1060 6GB GDDR5 |
| RAM sistema | Disponible para overflow |
| SO | Windows 11 + WSL2 Ubuntu |
| CUDA | Sí (Ollama usa CUDA automáticamente) |

---

## Modelos instalados

| Modelo | Tamaño | Modo | Uso |
|---|---|---|---|
| `qwen3:8b-q4_K_M` | 5.2 GB | GPU puro | Thinking general, tareas complejas |
| `qwen2.5-coder:7b` | 4.7 GB | GPU puro | Código rápido |
| `qwen2.5-coder:14b` | 9.0 GB | VRAM+RAM | Código potente, contexto largo |
| `deepseek-r1:14b` | 9.0 GB | VRAM+RAM | Razonamiento profundo |
| `nomic-embed-text` | 274 MB | GPU | RAG / embeddings |

---

## Comandos útiles

```bash
# Ver modelos descargados
ollama list

# Probar modelo directamente
ollama run qwen3:8b-q4_K_M

# Ver qué está corriendo
ollama ps

# Descargar nuevo modelo
ollama pull llama3.2:3b

# Ver uso de VRAM
nvidia-smi

# Estado del servicio Ollama
systemctl status ollama  # o: ps aux | grep ollama
```

---

## Integración con LiteLLM

Ollama está configurado como **primera opción** en el fallback de LiteLLM.

```yaml
# En litellm-config.yaml
- model_name: principal
  litellm_params:
    model: ollama/qwen3:8b-q4_K_M
    api_base: http://localhost:11434
    timeout: 120
```

Desde OpenCode, seleccionar modelo `ollama/qwen3:8b-q4_K_M` directamente o dejar que `principal` elija automáticamente.

---

## Cuándo usar modelos locales vs cloud

| Situación | Usar |
|---|---|
| Código privado, datos sensibles | LOCAL siempre |
| Sin internet disponible | LOCAL siempre |
| Tarea larga, contexto grande | LOCAL (sin límites de tokens) |
| Velocidad máxima, tarea corta | Cloud (Groq) |
| Tarea muy compleja | Cloud (Gemini Pro) |

---

## Notas de rendimiento

- **qwen3:8b** en GTX 1060: ~15-25 tokens/s
- **qwen2.5-coder:14b** en VRAM+RAM: ~6-10 tokens/s (más lento pero potente)
- Cold start primera llamada: +30-60s para cargar modelo en VRAM
- Segunda llamada: rápida (modelo en caché)

---

## Estado

- ✅ 5 modelos instalados y validados
- ✅ Integrado con LiteLLM como primera opción
- ✅ `deepseek-r1:14b` descargado 17/04/2026
- ⏳ Pendiente: probar RAG con `nomic-embed-text` + ChromaDB

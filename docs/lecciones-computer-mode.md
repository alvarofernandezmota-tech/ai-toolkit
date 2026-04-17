# Lecciones: Computer Mode con OpenCode

> Actualizado: 17 abril 2026 tarde — observaciones en tiempo real

---

## ⚠️ Problema descubierto: qwen2.5-coder:14b y tool calls

### Qué pasa
`qwen2.5-coder:14b` es excelente para generar código pero **se confunde con las tool calls de OpenCode**.

Ejemplo real observado:
```json
{
  "name": "skill",
  "arguments": {
    "name": "agente-creador-agentes"
  }
}
```
Está intentando llamar a una herramienta `skill` que no existe en OpenCode.

### Por qué ocurre
- `qwen2.5-coder` está optimizado para **completar código**, no para seguir instrucciones de agente
- No tiene buen entrenamiento en function calling / tool use
- Inventa nombres de herramientas que no existen

---

## ✅ Solución: usar modelo con mejor instruction-following

### Para computer-mode (tareas con tool calls)
Usar modelos con mejor entrenamiento en instrucciones:

| Modelo | Dónde | Velocidad | Tool calls |
|--------|--------|-----------|------------|
| `groq-fallback` (Llama 3.3 70B) | Nube gratis | ⚡ muy rápido | ✅ excelente |
| `sambanova-llama4` | Nube gratis | ⚡ rápido | ✅ muy bueno |
| `ollama/qwen3:8b` | Local | 🐢 lento | ⚠️ aceptable |
| `ollama/qwen2.5-coder:14b` | Local | 🐢 lento | ❌ confunde tools |

### Recomendación para nuestro hardware
1. **Computer mode / agente**: `groq-fallback` (Llama 3.3 70B gratis, instantáneo)
2. **Generación de código puro**: `ollama/qwen2.5-coder:14b` (local, sin cuota)
3. **Razonamiento**: `ollama/deepseek-r1:14b` o `sambanova-deepseek`

---

## 🔧 Cómo cambiar modelo en OpenCode

En el chat de OpenCode:
```
/model
```
O buscar con `ctrl+p` → escribir `groq-fallback`

---

## 💡 Insight arquitectura

La arquitectura óptima para nuestro sistema:

```
ORQUESTADOR: groq-fallback (Llama 3.3 70B)
  → Planifica, decide qué agente usar, llama tool calls
  → Rápido, gratuito, excelente instruction-following

WORKER CÓDIGO: qwen2.5-coder:14b (Ollama local)
  → Solo genera código cuando el orquestador lo pide
  → Sin presion de tool calls, solo output de texto/código

WORKER RAZONAMIENTO: deepseek-r1:14b (Ollama local)
  → Para problemas difíciles que necesitan thinking
```

---

*Generado: 17 abril 2026 tarde — Perplexity AI MCP*

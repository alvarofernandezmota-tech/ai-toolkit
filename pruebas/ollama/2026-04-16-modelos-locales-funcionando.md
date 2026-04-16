# Prueba: Stack Ollama local completo en GTX 1060

**Fecha:** 2026-04-16  
**Categoría:** ollama  
**Estado:** ✅ Funciona

## Qué probamos

Correr modelos LLM locales en WSL con GPU GTX 1060 6GB.

## Entorno

- OS: WSL Ubuntu (PC grande)
- GPU: NVIDIA GTX 1060 6GB
- RAM: 32GB
- Ollama: instalado en WSL

## Modelos descargados y estado

| Modelo | Tamaño | VRAM | Estado |
|--------|--------|------|--------|
| `qwen3:8b-q4_K_M` | 5.2 GB | Cabe entero | ✅ Rápido |
| `qwen2.5-coder:7b` | 4.7 GB | Cabe entero | ✅ Rápido |
| `qwen2.5-coder:14b` | 9.0 GB | Offload mixto | ✅ Más lento |
| `deepseek-r1:14b` | 9.0 GB | Offload mixto | ✅ Más lento |
| `nomic-embed-text` | 274 MB | Mínimo | ✅ Instantáneo |

## Comandos

```bash
# Ver modelos instalados
ollama list

# Probar modelo
ollama run qwen3:8b-q4_K_M
ollama run qwen2.5-coder:7b

# Para embeddings
ollama run nomic-embed-text

# Ollama corre como servicio — verificar
ollama serve   # si no está corriendo
curl http://localhost:11434/api/tags  # verificar API
```

## Notas de rendimiento

- **Modelos 7-8B**: caben enteros en VRAM → respuesta fluida
- **Modelos 14B**: offload parcial a RAM → respuesta más lenta (~2-3x) pero funcional
- Ollama gestiona el offload automáticamente

## Uso desde OpenCode

```
Ctrl+P → model → ollama/qwen3:8b-q4_K_M
```

## Lecciones aprendidas

- GTX 1060 6GB es suficiente para modelos 7-8B en local con buena velocidad
- Los 14B funcionan pero requieren paciencia — útiles para razonamiento profundo sin gastar API
- `nomic-embed-text` es perfecto para RAG local — 274MB, instantáneo

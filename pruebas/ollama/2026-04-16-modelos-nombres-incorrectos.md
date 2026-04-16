# Prueba: Nombres incorrectos al hacer ollama pull

**Fecha:** 2026-04-16  
**Categoría:** ollama  
**Estado:** ✅ Resuelto

## Qué probamos

Descargar modelos 14b con flags de cuantización explícitos.

## Entorno

- OS: WSL Ubuntu
- Ollama: corriendo en WSL
- Hardware: GTX 1060 6GB + 32GB RAM

## Pasos ejecutados (con error)

```bash
# ❌ INCORRECTO — estos nombres no existen en Ollama Hub
ollama pull qwen2.5-coder:14b-q4_K_M
ollama pull deepseek-r1:14b-q4_K_M
```

## Error

```
pulling manifest
Error: pull model manifest: file does not exist
```

## Solución

```bash
# ✅ CORRECTO — Ollama gestiona la cuantización internamente
ollama pull qwen2.5-coder:14b
ollama pull deepseek-r1:14b
```

## Resultado final

```
qwen3:8b-q4_K_M        5.2 GB  ✅
qwen2.5-coder:7b       4.7 GB  ✅
qwen2.5-coder:14b      9.0 GB  ✅
deepseek-r1:14b        9.0 GB  ✅
nomic-embed-text       274 MB  ✅
```

## Error adicional durante descarga

```
Error: max retries exceeded: dial tcp: lookup dd20bb891979d25aebc8bec07b2b3bbc.r2.cloudflarestorage.com
... i/o timeout
```

Solución: reintentar el mismo comando — es un timeout puntual del CDN de Cloudflare R2.

## Lecciones aprendidas

- Ollama Hub no acepta el sufijo `-q4_K_M` en el tag — usa el nombre base
- Los timeouts de descarga son transitorios, reintentar resuelve
- Los modelos 14b hacen offload mixto VRAM+RAM en GTX 1060 — funcionan pero más lentos

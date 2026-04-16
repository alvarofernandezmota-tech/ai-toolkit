# Pruebas — Laboratorio

> Aquí documentamos todo lo que probamos: funciona, falla, o funciona con condiciones.
> **Los errores son tan valiosos como los éxitos** — documentar ambos.

---

## Estructura

```
pruebas/
├── opencode/     ← pruebas con OpenCode (arranque, modelos, configuración)
├── ollama/       ← pruebas con modelos locales Ollama
├── agentes/      ← pruebas de agentes (CrewAI, n8n, custom)
└── modelos/      ← comparativas y benchmarks de modelos
```

## Cómo añadir una prueba

1. Crear archivo: `pruebas/<categoria>/YYYY-MM-DD-descripcion.md`
2. Usar la plantilla de abajo
3. Commit: `test: [descripción breve]`

## Plantilla

```markdown
# Prueba: [nombre]

**Fecha:** YYYY-MM-DD  
**Categoría:** opencode / ollama / agentes / modelos  
**Estado:** ✅ Funciona | ❌ Falla | ⚠️ Parcial

## Qué probamos
[descripción de lo que intentamos hacer]

## Entorno
- OS: WSL Ubuntu / Windows
- Hardware: PC grande (GTX 1060 6GB, 32GB RAM)
- Versiones relevantes:

## Pasos ejecutados
```bash
[comandos exactos]
```

## Resultado
[lo que pasó exactamente]

## Error (si aplica)
```
[error exacto copiado del terminal]
```

## Solución / Workaround
[cómo se resolvió o por qué no se pudo]

## Lecciones aprendidas
- ...
```

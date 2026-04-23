# Prompt de Auditoría Completa para Claude Code

> Pega este prompt en Claude Code al arrancar.
> Usar con: `/model groq-fallback` o `/model qwen/qwen3-coder:free` (si Ollama no está activo).
> Última actualización: 23 abril 2026.

---

```
# AUDITORÍA COMPLETA Y CONFIGURACIÓN DE AI-TOOLKIT

Eres Claude Code trabajando de forma autónoma en el repo ai-toolkit.
Esta es tu base de operaciones y tu sistema nervioso central.
Tu tarea es leer TODOS los archivos clave, entender el estado real del sistema
y dejar todo correctamente configurado y documentado.

## LAS 4 ENTIDADES DEL ECOSISTEMA (lee esto primero)

- Álvaro → Director, decisiones
- Perplexity (con MCP GitHub) → Planificación, diarios, commits tracking
- Claude Code (tú) → Ejecutas tareas autónomas en el repo
- Claude IA (web) → Razonamiento y código puntual

Perplexity + Álvaro planifican → tú ejecutas → Álvaro supervisa.

## PASO 1 — LECTURA OBLIGATORIA (en este orden)

Lee estos archivos ANTES de hacer nada:
1. CLAUDE.md → tu contexto principal
2. INICIO-AQUI.md → punto de entrada y estado actual
3. ECOSISTEMA.md → mapa del sistema
4. ARQUITECTURA.md + ARQUITECTURA-SERVIDOR.md → infraestructura
5. AGENTS.md → tus instrucciones como agente
6. ALVARO.md → quién es el usuario
7. COMO-PROCEDEMOS.md → cómo trabajamos
8. litellm-config.yaml → qué modelos tienes disponibles
9. opencode.json → tu propia configuración
10. .env.example → qué variables necesitas
11. scripts/ → qué scripts existen y para qué
12. agentes/ → qué agentes están configurados
13. docs/ → documentación técnica
14. ROADMAP.md → qué está por hacer
15. CHANGELOG.md → qué se ha hecho ya
16. diario/ → contexto reciente (últimas sesiones)

## PASO 2 — AUDITORÍA: detecta y documenta

Despues de leer, crea el archivo docs/auditoria-estado-actual.md con:

### A) ESTADO REAL DEL SISTEMA
- ¿Qué funciona? ¿Qué no funciona?
- ¿Qué archivos tienen información desactualizada o contradictoria?
- ¿Hay archivos duplicados o con solapamiento?
- ¿Falta algún archivo importante para el ecosistema?

### B) CONFIGURACIÓN DETECTADA
- Modelos disponibles en litellm-config.yaml (listar todos)
- Variables de entorno necesarias (del .env.example)
- Scripts disponibles y su estado
- Agentes configurados y su propósito

### C) INCONSISTENCIAS ENCONTRADAS
- Archivos que se referencian entre sí pero no coinciden
- Documentación que describe un estado diferente al real
- Scripts que pueden estar rotos o desactualizados

## PASO 3 — CORRECCIONES PRIORITARIAS

Haz solo los cambios que puedas verificar sin ejecutar código:

1. Actualiza CLAUDE.md si está desactualizado respecto al stack real
2. Actualiza INICIO-AQUI.md si las instrucciones no reflejan la realidad actual
3. Verifica litellm-config.yaml — ¿todos los modelos tienen el formato correcto?
4. Revisa scripts/start-colmena.sh — ¿es el script principal? ¿está correcto?
5. Fix health-check: añade header auth a curl en scripts/health-check.sh:
   curl http://localhost:8000/health -H "Authorization: Bearer sk-litellm-local"

## PASO 4 — CREA docs/claude-instrucciones-sistema.md

Este archivo es tu manual de operaciones. Incluye:
- Tu rol dentro del ecosistema
- Cómo arrancar el sistema (pasos exactos)
- Modelos disponibles y cuándo usar cada uno
- Variables de entorno necesarias
- Flujo de trabajo estándar
- Lo que NUNCA debes hacer
- En caso de error común (tabla error → solución)

## PASO 5 — COMMIT FINAL

Cuando termines, haz commits con:
- docs: auditoría completa ai-toolkit + docs/auditoria-estado-actual.md
- docs: docs/claude-instrucciones-sistema.md — manual de operaciones
- fix: health-check header auth + correcciones detectadas

## REGLAS IMPORTANTES

- NO modifiques ROADMAP.md ni CHANGELOG.md sin que te lo pida explícitamente
- Si encuentras un error en litellm-config.yaml, docuéntalo pero NO lo corrijas sin confirmación
- Si no entiendes algo, escríbelo en la auditoría como "NECESITA VERIFICACIÓN"
- Prioridad: documentar el estado real > hacer cambios
- Usa /model groq-fallback si Ollama no está activo
- Arranca Ollama ANTES de la colmena si quieres modelos locales: ollama serve &
```

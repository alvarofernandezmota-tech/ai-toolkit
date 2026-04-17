# Agente Creador de Agentes

## Qué hace
Recibe nombre y descripción de un agente nuevo y construye
automáticamente su ficha .md en agentes/, su script .sh en scripts/, y
hace git commit + push.

## Modelos recomendados
- groq-fallback (Llama 3.3 70B) — planificación y tool calls
- qwen2.5-coder:14b — generación de código puro

## Inputs
- nombre_agente, descripcion, capacidades

## Output
- Archivo en disco verificado + commit semántico + push

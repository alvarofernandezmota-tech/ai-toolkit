# 🧪 Registro de experimentos

> Aquí van los experimentos que vamos probando: qué funcionó, qué no funcionó y por qué. Para no repetir errores y tener contexto de decisiones.

---

## Formato de entrada

```
### [FECHA] Nombre del experimento
**Qué se probó:** ...
**Resultado:** ✅ Funciona / ❌ No funciona / ⚠️ Funciona con condiciones
**Por qué:** ...
**Conclusión / siguiente paso:** ...
```

---

## Experimentos 2026

### [14 Abril 2026] Stack base del ecosistema
**Qué se probó:** THDORA v0.14.0 + NLP con Groq + citas + hábitos en producción
**Resultado:** ✅ Funciona
**Por qué:** Groq llama-3.3-70b a 750 tok/s, consumo <1% CPU, 0€/mes
**Conclusión:** Stack correcto. Siguiente: añadir Aider + Claude Code al flujo de desarrollo.

---

### [14 Abril 2026] Alternativas a THDORA investigadas
**Qué se probó:** Comparativa de OpenClaw, n8n, Dify, Langflow, LocalAI como posibles sustitutos
**Resultado:** ⚠️ Ninguna sustituye a THDORA, pero OpenClaw es referencia para memoria persistente
**Por qué:** THDORA tiene datos reales integrados (citas+hábitos+NLP) que ninguna tiene. OpenClaw cuesta $5-30/mes managed vs 0€ de THDORA. LocalAI requiere GPU.
**Conclusión:** Mantener THDORA. Añadir mem0 para memoria larga en Verano 2026. Usar n8n como capa de automatización encima (ya planeado).

---

## Pendiente de probar

- [ ] **Devstral 2** en Claude Code vs Qwen3 Coder — ¿cuál es mejor para THDORA?
- [ ] **Cerebras** como backup de Groq cuando hay rate limit
- [ ] **mem0** para memoria persistente entre sesiones en THDORA
- [ ] **Google AI Studio** (Gemini 2.5 Flash) para documentos largos
- [ ] **SambaNova** con DeepSeek R1 — velocidad vs OpenRouter
- [ ] **n8n** primer workflow: brief diario (Mayo 2026)
- [ ] **Aider + Devstral 2** para refactorizaciones multi-fichero grandes

# 🧪 Registro de experimentos

> Aquí van los experimentos que vamos probando: qué funcionó, qué no funcionó y por qué. Para no repetir errores y tener contexto de decisiones.
> **Regla: solo entra lo que se ha probado de verdad. Nada inventado.**

---

## Formato

```
### [FECHA] Nombre del experimento
**Qué se probó:** ...
**Resultado:** ✅ Funciona / ❌ No funciona / ⚠️ Funciona con condiciones
**Por qué:** ...
**Conclusión / siguiente paso:** ...
```

---

## Experimentos completados

### [14 Abril 2026] Stack base del ecosistema
**Qué se probó:** THDORA v0.14.0 en producción con NLP Groq + citas + hábitos
**Resultado:** ✅ Funciona
**Por qué:** Groq llama-3.3-70b a 750 tok/s, consumo <1% CPU, 0€/mes
**Conclusión:** Stack correcto. Siguiente: Aider + Claude Code al flujo de desarrollo.

---

### [14 Abril 2026] Investigación alternativas a THDORA
**Qué se probó:** Comparativa investigada de OpenClaw, n8n, Dify, Langflow, LocalAI
**Resultado:** ⚠️ Ninguna sustituye a THDORA, pero OpenClaw es referencia para memoria larga
**Por qué:** THDORA tiene datos reales (citas+hábitos+NLP). OpenClaw es framework genérico sin datos de vida. LocalAI requiere GPU.
**Conclusión:** Mantener THDORA. Añadir mem0 en Verano 2026. n8n como capa de automatización encima (Mayo 2026). Ver: [alternativas-thdora.md](alternativas-thdora.md)

---

### [14 Abril 2026] Investigación Devstral 2 (no probado aún, investigado)
**Qué se probó:** Research de benchmarks y disponibilidad. **No se ha ejecutado aún.**
**Resultado:** ⏳ Pendiente de probar
**Datos encontrados:** 72.2% SWE-bench Verified, 123B params, 256K contexto, lanzado dic 2025
**Fuente:** [mistral.ai/news/devstral-2-vibe-cli](https://mistral.ai/news/devstral-2-vibe-cli)
**Próximo paso:** Probar con Claude Code en THDORA y documentar resultado real aquí.

---

## Pendiente de probar (ordenado por prioridad)

- [ ] **Aider + Groq en THDORA** — fix real issue #10 (esta semana)
- [ ] **Claude Code + OpenRouter en THDORA** — escanear repo completo (esta semana)
- [ ] **Devstral 2 en Claude Code** — ¿mejor que Qwen3 Coder para multi-fichero?
- [ ] **Cerebras como backup** — cuando Groq llega al rate limit
- [ ] **Google AI Studio Gemini 2.5 Flash** — para documentos largos
- [ ] **SambaNova con DeepSeek R1** — velocidad vs OpenRouter
- [ ] **mem0 en THDORA** — memoria persistente entre sesiones (Verano 2026)
- [ ] **n8n workflow 1** — brief diario a las 08:00 por Telegram (Mayo 2026)

---

## Recursos para investigación futura

| Recurso | URL | Para qué |
|---|---|---|
| OpenRouter Models | [openrouter.ai/models](https://openrouter.ai/models) | Ver todos los `:free` disponibles |
| Groq Models | [console.groq.com/docs/models](https://console.groq.com/docs/models) | Lista actualizada de modelos Groq |
| LMSys Chatbot Arena | [lmarena.ai](https://lmarena.ai) | Ranking de modelos por preferencia humana |
| Aider LLM Leaderboard | [aider.chat/docs/leaderboards](https://aider.chat/docs/leaderboards) | Qué modelos funcionan mejor con Aider |
| mem0 GitHub | [github.com/mem0ai/mem0](https://github.com/mem0ai/mem0) | Memoria persistente para agentes |
| OpenClaw GitHub | [github.com/openclaw/openclaw](https://github.com/openclaw/openclaw) | Referencia de arquitectura multi-canal |

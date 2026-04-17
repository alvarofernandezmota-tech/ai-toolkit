# Agente de Investigación Web

> Dado un tema, busca información actualizada, la resume y la guarda en `investigacion/`.

---

## ¿Qué hace?

Recibe un tema o pregunta, busca información actualizada en la web, sintetiza los hallazgos y genera un documento Markdown estructurado en `investigacion/YYYY-MM-DD-tema.md`.

**Ideal para:** Investigar tecnologías nuevas, comparar herramientas, entender conceptos antes de implementar.

---

## Dos modos de uso

### Modo 1 — Manual con OpenCode (ya funciona hoy)

```bash
cd ~/projects/ai-toolkit
~/.npm-global/bin/opencode

# Prompt en OpenCode:
"Investiga [TEMA]. Busca información actualizada, sintetiza los puntos clave
y guarda el resultado en investigacion/$(date +%Y-%m-%d)-[tema].md"
```

### Modo 2 — Script automatizado (pendiente construir)

```bash
# Uso futuro:
bash scripts/investigar.sh "LangGraph vs CrewAI comparativa 2026"
# → genera investigacion/2026-04-17-langgraph-vs-crewai.md
```

---

## Estructura del output

```markdown
# [Tema investigado]

> Investigado: YYYY-MM-DD | Modelo: [modelo usado]

## Resumen ejecutivo
[3-5 frases con lo más importante]

## Hallazgos principales
[Puntos clave numerados]

## Fuentes consultadas
[URLs relevantes]

## Próximos pasos
[Qué hacer con esta información]
```

---

## Directorio de investigaciones

Todas las investigaciones van en `investigacion/` con formato `YYYY-MM-DD-tema.md`.

```bash
# Ver investigaciones previas
ls investigacion/

# Buscar en investigaciones
grep -r "langchain" investigacion/
```

---

## Estado

- ✅ Modo manual funciona con OpenCode
- 🔴 Pendiente: `scripts/investigar.sh` automatizado
- 🔴 Pendiente: integrar Perplexity/Tavily API para búsqueda real
- **Estimación construcción completa:** 2-3 horas

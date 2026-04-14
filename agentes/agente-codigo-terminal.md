# 🔧 Agente de código en terminal — Aider + Claude Code

> Dos herramientas complementarias para editar código con IA desde el terminal. Juntas cubren el 100% de los casos de uso.

---

## La regla de uso

```
90% del tiempo → Aider + Groq      (rápido, fixes del día)
10% del tiempo → Claude Code        (arquitectura, repo entero)
```

---

## Aider + Groq — Setup completo

Ver guía detallada: [setup/aider-groq.md](../setup/aider-groq.md)

```bash
# Instalar
pip install aider-chat

# Usar en THDORA
aider-thdora   # alias de setup.sh
```

---

## Claude Code + OpenRouter — Setup completo

Ver guía detallada: [setup/claude-code-openrouter.md](../setup/claude-code-openrouter.md)

```bash
# Instalar
npm install -g @anthropic-ai/claude-code

# Usar en cualquier repo
cd ~/projects/thdora
claude
```

---

## Flujo de trabajo combinado

### Scenario 1: Fix de bug del día a día

```bash
# 1. Aider para el fix rápido
aider-thdora
/add src/core/groq_router.py
> fix el timeout que falla en _show_hab_configs (issue #10)
# Aider edita el fichero y hace el commit
```

### Scenario 2: Nueva feature grande

```bash
# 1. Claude Code para diseñar
cd ~/projects/thdora && claude
> analiza la arquitectura actual y propón cómo añadir F14 tracking diario
# Claude Code lee todo el repo y propone el diseño

# 2. Aider para implementar
aider-thdora
/add src/models/tracking.py   # fichero nuevo que Claude diseñó
> implementa el modelo Tracking con campos estado_animo, horas_sueno, puntuacion
```

### Scenario 3: Refactorización

```bash
# 1. Claude Code para entender el impacto
claude
> si refactorizo groq_router.py para separar los intents, qué ficheros se verían afectados

# 2. Aider para ejecutar la refactorización
aider-thdora
/add src/core/groq_router.py
/add src/bot/handlers/nlp_handler.py
> refactoriza groq_router separando la lógica de intents en intents_config.py
```

---

## Modelo de razonamiento para bugs difíciles

Cuando el bug no se ve claro, cambia al modelo thinking:

```bash
# En Aider
/model openrouter/deepseek/deepseek-r1:free
> este bug me tiene loco: [descripción detallada]

# O directamente
aider --model openrouter/qwen/qwen3-coder:free
```

---

## Integración con GitHub Issues

```bash
# En Aider puedes referenciar issues directamente
> fix github issue #10

# O ser específico
> implementa lo que pide el issue #12: añadir paginación a /citas
```

---

## Buenas prácticas

1. **Siempre haz `/diff` antes de aceptar** — revisa qué cambió
2. **Contexto mínimo pero suficiente** — no añadas 20 ficheros, añade los relevantes
3. **Un fix por sesión** — no le pidas 5 cosas a la vez, una a la vez
4. **Mensajes de commit descriptivos** — Aider los hace automáticos pero puedes editarlos
5. **Tests siempre** — pídele que cree el test cuando hace el fix

# 🐛 THDORA — Bugs reales detectados + Primera sesión Claude Code

> Sesión: 14 abril 2026, noche.
> Estado: THDORA parada. Bot y API detenidos con ^C.
> Objetivo: esto es exactamente lo que le damos a Claude Code como primera tarea.

---

## Estado del sistema al parar

```
✅ API uvicorn corriendo en http://localhost:8000
✅ Bot telegram corriendo en polling mode
✅ Scheduler F12 iniciado
✅ BBDD respondiendo (200 OK en todos los endpoints)
⛔ Parado manualmente con ^C a las ~23:30 del 14/04/2026
```

---

## 🔴 Bugs confirmados en producción (sesión real)

Estos bugs los vio Álvaro en el chat real de Telegram. Son reales, no teóricos.

### BUG 1 — Eliminar cita por fecha específica no funciona

**Conversación real:**
```
Alvaro: Elimina la del 15 de abril
THDORA: No encontré la cita que quieres borrar.
        Prueba: "cancela el dentista de hoy" o usa /citas para verlas.

Alvaro: Borra dentista
THDORA: No encontré la cita que quieres borrar.

Alvaro: Cancelar el despista del 15 de abril
THDORA: No encontré la cita que quieres borrar.
```

**Diagnóstico:** El intent `borrar_cita` no extrae correctamente la entidad de fecha cuando es una fecha concreta futura ("del 15 de abril"). Solo funciona con referencias relativas ("de hoy", "de mañana").

**Ficheros afectados:**
- `src/bot/handlers/citas.py` — lógica de borrado
- `src/nlp/` — extracción de entidades de fecha

---

### BUG 2 — Editar/mover cita no funciona por nombre

**Conversación real:**
```
Alvaro: quiero cambiar una cita
THDORA: No encontré la cita que quieres editar.
        Prueba: "mueve el gym de hoy a las 18" o usa /citas para verlas.

Alvaro: Modifica la cita dentista
THDORA: No encontré la cita que quieres editar.

Alvaro: Quiero editar una cita
THDORA: No encontré la cita que quieres editar.
```

**Diagnóstico:** El intent `editar_cita` requiere formato muy específico ("mueve el X de hoy a las HH"). No acepta:
- Nombre de cita sin fecha ("dentista")
- Intención genérica ("quiero editar una cita") que debería abrir flujo interactivo
- Fechas futuras en el nombre ("del 15 de abril")

**Ficheros afectados:**
- `src/bot/handlers/citas.py` — handler de edición
- `src/nlp/` — intent `editar_cita` + extracción entidades

---

### BUG 3 — Cita del dentista duplicada en el mes

**Conversación real:**
```
Alvaro: Este mes que tengo
THDORA: 15 de abril (mañana): 17:00 Dentista
         15 de abril (día siguiente): 17:00 Dentista (repetido)
```

**Diagnóstico:** La cita del dentista aparece duplicada en la vista mensual. Puede ser un bug en la consulta SQL (JOIN duplicando filas) o en la lógica de "mañana" vs "día siguiente" que devuelve el mismo día dos veces.

**Ficheros afectados:**
- `src/api/routers/appointments.py` o endpoint de mes
- Posible query SQL duplicando resultados

---

### BUG 4 — Hábitos: respuesta ambigua ("1 vez de algo no especificado")

**Conversación real:**
```
Alvaro: Hábitos esta semana
THDORA: Alvaro, hoy has registrado:
         - 1 vez de algo (no especificado)
         - 1 hora de ejercicio
         - 7 horas de sueño
```

**Diagnóstico:** Un hábito se registró sin tipo o con tipo null/vacío. La respuesta muestra "algo (no especificado)" en lugar de ocultar ese registro o pedir clarificación.

**Ficheros afectados:**
- `src/bot/handlers/habitos.py` — formateo de respuesta
- Validación al guardar hábito sin tipo

---

### WARN — PTBUserWarning en 5 handlers (no crítico, pero hay que limpiar)

```
citas.py:745, 785 — ConversationHandler per_message=False
habitos.py:478, 506 — ConversationHandler per_message=False
config.py:403 — ConversationHandler per_message=False
```

**Diagnóstico:** Advertencia de python-telegram-bot. No rompe nada pero ensucía los logs. Hay que añadir `per_message=True` o suprimir si es intencional.

---

## ✅ Lo que SÍ funciona (confirmado en producción)

```
✅ Citas de hoy → responde correctamente
✅ Citas de mañana → responde correctamente  
✅ Citas de la semana → responde correctamente
✅ Ver citas por nombre ("Enséñame las citas con el dentista") → funciona
✅ Añadir hábito (ejercicio 1h) → registrado 201 Created
✅ API respondiendo todos los endpoints (200 OK)
✅ Scheduler F12 arrancado correctamente
✅ NLP básico funcionando (intents simples)
```

---

## 🤖 Primera tarea para Claude Code

Esta es exactamente la orden que le vamos a dar cuando arranquemos Claude Code mañana:

```
Eres un agente de código. Tienes acceso completo a este repo.
Escanea la arquitectura completa de THDORA.

Hay 4 bugs confirmados en producción:

1. BUG CRÍTICO: Borrar cita por fecha futura no funciona.
   Ejemplo fallido: "Elimina la del 15 de abril", "Borra dentista"
   Solo funciona con: "cancela el dentista de hoy"
   Arregla el intent borrar_cita para aceptar:
   - Nombre de cita sin fecha
   - Fecha futura ("del 15 de abril", "del martes")
   - Combinación nombre + fecha

2. BUG CRÍTICO: Editar cita no funciona, solo acepta formato exacto.
   Cuando el usuario dice "quiero editar una cita" sin especificar cuál,
   debe abrirse un flujo interactivo que pregunte cuál cita y a qué hora.
   Arregla el handler de edición y el intent editar_cita.

3. BUG MEDIO: Cita del dentista aparece duplicada en vista mensual.
   Revisa la query SQL o la lógica de "mañana" vs "día siguiente".

4. BUG BAJO: Hábito guardado sin tipo muestra "algo (no especificado)".
   Añade validación al guardar y mejora el formateo de respuesta.

Para cada fix:
- Haz los cambios mínimos necesarios
- Añade un test que verifique el caso
- Haz commit separado por bug con mensaje descriptivo
```

---

## Comandos para arrancar mañana

```bash
# 1. Entrar en WSL
wsl

# 2. Verificar que el repo está actualizado
cd ~/projects/thdora
git status
git log --oneline -5

# 3. Instalar Claude Code (si no está)
curl -fsSL https://claude.ai/install.sh | sh
# o: npm install -g @anthropic-ai/claude-code

# 4. Configurar OpenRouter
export ANTHROPIC_BASE_URL=https://openrouter.ai/api/v1
export ANTHROPIC_API_KEY=sk-or-TU_KEY

# 5. Arrancar Claude Code en THDORA
cd ~/projects/thdora
claude --model openrouter/mistralai/devstral-2:free

# 6. Pegar la orden del bloque anterior
```

---

*Documentado en sesión 14 abril 2026. THDORA parada, repo alineado.*

# Cómo Procedemos — Manual Interno

> Este documento define cómo trabajamos en este repositorio: flujo de trabajo, reglas, cómo probamos, cómo documentamos y cómo decidimos qué funciona.

---

## ⚡ Regla de oro — Arranque

SIEMPRE antes de trabajar:

```bash
cd ~/projects/ai-toolkit
git pull                        # ← OBLIGATORIO primero
bash scripts/start-colmena.sh
```

Si `git pull` falla por cambios locales:
```bash
git checkout -- opencode.json && git pull
```

---

## ⚠️ Lecciones aprendidas (17/04/2026)

### No pegar output de comandos en el panel de tmux equivocado
Si pegas el output de `curl /v1/models` directamente en bash, cada nombre de modelo se ejecuta como comando. Solo pegar comandos en el panel correcto de OpenCode.

### El 401 en `/v1/models` es inofensivo
OpenCode hace un GET sin API key para listar modelos → LiteLLM devuelve 401. No afecta al funcionamiento. Las llamadas de chat llevan `sk-litellm-local` y pasan con 200 OK.

### Modelo por defecto: `gemini-flash`, no `principal`
`principal` arranca probando Ollama local primero → cold start de 30-60s → parece que se queda pillado. Usar `gemini-flash` como default (respuesta en 1-2s). Cambiar a `principal` o modelos locales solo cuando Ollama ya esté caliente.

### Actualizar OpenCode con regularidad
```bash
npm i -g opencode-ai@latest
~/.npm-global/bin/opencode --version
```
Revisar [opencode.ai/changelog](https://opencode.ai/changelog) al inicio de cada semana.

---

## 🔄 Flujo de trabajo

```
1. git pull                    ← sincronizar
2. bash scripts/start-colmena.sh
3. Probar / experimentar / trabajar
4. Documentar resultado en pruebas/ o diario/
5. Si funciona → mover a docs/ o agentes/
6. git add . && git commit -m "..."
7. git push
```

### Formato de commit (Conventional Commits)

```
feat:  nueva funcionalidad o agente
fix:   corrección de error o config rota
docs:  documentación, MDs, diarios
chore: mantenimiento, scripts, dependencias
refactor: reorganización sin cambio funcional
```

Ejemplos:
```
feat: añadir agente-opencode.md con ficha completa v1.4.7
fix: cambiar modelo default a gemini-flash para arranque rápido
docs: documentar sesión 2026-04-17 en diario y CHANGELOG
```

---

## 🌙 Modo trabajo nocturno — dejar OpenCode trabajando solo

Cuando el sistema está estable y quieres dejar tareas largas corriendo:

```bash
git pull
~/.npm-global/bin/opencode
```

Prompt de trabajo autónomo recomendado:
```
Lee ROADMAP.md, PENDIENTES.md y todos los archivos de agentes/.
Trabaja de forma autónoma completando las tareas pendientes prioritarias.
Haz commits por cada tarea completada con mensajes semánticos.
Actualiza CHANGELOG.md al final con todo lo que hiciste.
```

**Condiciones para dejarlo solo:**
- ✅ `git status` → `working tree clean` antes de salir
- ✅ LiteLLM corriendo estable (varios 200 OK en los logs)
- ✅ Modelo: `gemini-flash` o `groq-fallback` (no `principal` ni Ollama solo)
- ✅ tmux corriendo — el proceso sobrevive al cerrar la terminal

---

## 🧪 Cómo documentamos pruebas

Cada prueba va en `pruebas/<categoria>/YYYY-MM-DD-descripcion.md`

Estructura mínima de una prueba:

```markdown
# Prueba: [nombre]

**Fecha:** YYYY-MM-DD  
**Estado:** ✅ Funciona / ❌ Falla / ⚠️ Parcial

## Qué probamos
...

## Resultado
...

## Comandos usados
```bash
...
```

## Notas / Lecciones
...
```

---

## 🏗️ Estructura del repositorio

```
ai-toolkit/
│
├── COMO-PROCEDEMOS.md          ← este archivo
├── CHANGELOG.md                ← historial de cambios importantes
├── README.md                   ← presentación del proyecto
│
├── scripts/                    ← scripts de arranque y utilidades
│   ├── start-colmena.sh        ← arranque principal (tmux + LiteLLM + OpenCode)
│   ├── generar-diario.sh       ← genera entrada de diario desde git log
│   └── opencode-rotate.sh      ← rotar modelos en OpenCode
│
├── docs/                       ← documentación técnica estable
│   ├── hardware-strategy.md    ← estrategia GPU, límites APIs
│   ├── sesion-2026-04-17.md    ← sesión documentada
│   └── opencode-config.md      ← guía de configuración OpenCode
│
├── diario/                     ← diario de sesiones (YYYY-MM-DD.md)
│   └── 2026-04-17.md
│
├── agentes/                    ← fichas de agentes documentados
│   ├── agente-opencode.md
│   ├── agente-litellm.md
│   ├── agente-ollama.md
│   ├── agente-investigacion.md
│   ├── agente-git-commits.md
│   └── PENDIENTES.md
│
├── pruebas/                    ← laboratorio: todo lo que probamos
├── guias/                      ← guías de setup paso a paso
└── opensource/                 ← preparado para publicar a la comunidad
```

---

## 📏 Reglas de calidad

- **Todo lo que probamos se documenta** — aunque falle, especialmente si falla
- **Los errores son valiosos** — documentar el error exacto y la solución
- **Sin documentar = no existe** — si no está en GitHub no pasó
- **Commits pequeños y frecuentes** — mejor 10 commits pequeños que 1 enorme
- **Nunca modificar opencode.json localmente** — siempre desde GitHub o con `git pull` previo
- **NUNCA commitear `.env` o API keys** — el `.gitignore` lo previene pero ojo siempre

---

## 🌍 Camino hacia opensource

Cuando algo funciona bien y está documentado:

1. Mover/copiar a `opensource/`
2. Limpiar datos personales (keys, rutas absolutas)
3. Añadir comentarios para la comunidad
4. Actualizar `opensource/README.md`
5. Evaluar si merece repo propia

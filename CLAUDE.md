# CLAUDE.md — Contexto para Claude Code

> Este archivo lo lee Claude Code automáticamente al arrancar en este directorio.
> **Última actualización: 2026-09-10.** Antes ponía 23 abril 2026, y entre
> medias el ecosistema cambió entero: ver «Qué cambió desde abril» al final.

---

## Antes de nada: este repo es PÚBLICO

No se escriben aquí IP, nombres de máquina, nombres de usuario, rutas de
claves ni contenido de repos privados. Si un dato solo sirve estando dentro
de la red de Álvaro, no pinta nada en un repositorio que lee cualquiera.

La versión anterior de este fichero publicaba una IP de LAN. Ya no está.

---

## Quién soy

Álvaro Fernández. Desarrollador Python, Madrid. Construyo un ecosistema de
IAs que trabajan para mí.

**Dos máquinas**, las dos Arch Linux, unidas por una VPN mesh (Tailscale):

- Un **sobremesa que hace de servidor** — corre el bot de Telegram bajo
  systemd. Es la máquina que no se toca a la ligera.
- Un **portátil** — trabajo y experimentación.

Los detalles de red viven en el repo privado, no aquí.

---

## Este repo: ai-toolkit

El **cerebro compartido del ecosistema**: configuración, scripts,
documentación y prompts para operar agentes IA. **No es código de producto.**

### Estructura (comprobada el 2026-09-10, existe entera)

```
ai-toolkit/
├── CLAUDE.md              ← tú lees esto al arrancar
├── AGENTS.md              ← OpenCode lee esto
├── context/               ← quién eres y cómo funciona el stack
├── projects/              ← proyectos activos
├── areas/                 ← responsabilidades continuas
├── diario/                ← memoria de sesiones
├── agentes/               ← fichas de agentes
├── docs/                  ← documentación técnica
├── prompts/               ← prompts para tareas
├── scripts/               ← 22 scripts de automatización
└── herramientas/          ← utilidades para operar el repo
```

**Lee al inicio de sesión:**
1. `context/about-alvaro.md` — perfil, proyectos, reglas
2. `context/stack.md` — servicios, modelos, variables
3. El fichero de `projects/` que corresponda a la tarea

---

## Los proyectos de verdad, a 2026-09-10

| Proyecto | Qué es | Dónde |
|---|---|---|
| **bifrost** | Bot de Telegram **en producción**. Servicio systemd, 179 pruebas, ADRs propios. Es la pieza más presentable del ecosistema | [público](https://github.com/alvarofernandezmota-tech/bifrost) |
| **midgaror** | El repo personal: documentación de trabajo, infraestructura, diario. **Privado desde el 2026-09-10.** bifrost importa sus módulos de diario | privado |
| **ai-toolkit** | Este repo | público |

> **THDORA ya no es el proyecto principal.** Lo era cuando se escribió la
> versión anterior de este fichero. Hoy el repo `thdora` **no existe** en la
> cuenta, y `~/projects/thdora` no es una ruta válida. Queda `THDORA-PERSONAL`,
> privado y sin tocar desde julio. Su auditoría concluyó que se quedó
> bloqueada, y esa conclusión ya está aplicada a las decisiones nuevas.

---

## Variables de entorno (en ~/.bashrc)

```bash
export OPENROUTER_API_KEY="sk-or-v1-..."
unset ANTHROPIC_API_KEY   # CRÍTICO: sin esto hay conflicto de auth
```

**Nunca** setear `ANTHROPIC_API_KEY` y `ANTHROPIC_AUTH_TOKEN` a la vez.

---

## Cómo arrancar

```bash
cd ~/projects/ai-toolkit
source ~/.bashrc
bash scripts/morning.sh                         # contexto del día en 30s
bash scripts/start-colmena.sh --colmena-full    # arrancar todo
```

## Scripts de rutina

```bash
bash scripts/morning.sh           # inicio de sesión
bash scripts/day-close.sh         # fin del día
bash scripts/weekly-planning.sh   # cada lunes
bash scripts/health-check.sh      # diagnóstico de APIs
bash scripts/bootstrap.sh         # estado del ecosistema en 30s
```

Los seis existen, comprobado el 2026-09-10. Hay 22 en total: `ls scripts/`.

---

## Cómo trabajo

- Commits pequeños y frecuentes, con mensaje que explique **por qué**.
- Conventional Commits: `feat/fix/docs/chore: descripción`.
- Un commit por tarea. No acumular ficheros sin commitear.
- Documentar el resultado en `diario/` y `CHANGELOG.md`.
- **Nunca dar por hecha una tarea que solo se planeó.** Comprobar que el
  fichero está en disco y que el commit existe.
- Si algo no funciona → `docs/errores-frecuentes.md`.

### Y una regla que este repo aprendió a base de golpes

**Comprobar antes de afirmar.** Este fichero llevaba cinco meses mandando
leer `projects/thdora.md` de un proyecto muerto y dando una IP que ya no
existía. Un documento de contexto que miente es peor que no tenerlo: hace que
cada sesión empiece con un mapa falso.

Antes de escribir un dato, medirlo. Antes de citar una ruta, comprobar que
existe.

---

## Qué cambió desde abril, y por qué este fichero estaba tan desfasado

Entre la versión anterior (23 abril) y hoy:

- **Nació bifrost** y llegó a producción con servicio systemd.
- **Nació midgaror** como repo personal, y el 2026-09-10 pasó a privado.
- **Se archivaron 13 repos**; `thdora` y otros siete desaparecieron.
- El ecosistema pasó de «OpenCode + LiteLLM en un sobremesa» a dos máquinas
  Arch unidas por VPN mesh.

Nada de eso estaba aquí: `midgaror` y `bifrost` aparecían **cero veces** en
los 158 ficheros del repo, mientras `thdora` salía en 80.

Inventario medido y actualizado en [`REPOS-ECOSISTEMA.md`](REPOS-ECOSISTEMA.md).

---

## Sin verificar

Lo que la versión anterior daba por cierto y **nadie ha comprobado desde
abril**. No se borra —puede seguir siendo verdad— pero no se da por bueno:

- Estado de las claves de Groq, DeepSeek y Gemini («caducadas» en abril).
- Que el proxy LiteLLM siga en el puerto 8000 y con 18+ modelos.
- Las versiones de Claude Code y OpenCode que citaba `INICIO-AQUI.md`.
- Si los alias de modelos (`principal`, `gemini-flash`…) siguen existiendo.

Se comprueba con `bash scripts/health-check.sh`, y lo que salga se escribe.

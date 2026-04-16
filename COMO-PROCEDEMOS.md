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

## 🔄 Flujo de trabajo

```
1. git pull                    ← sincronizar
2. Probar / experimentar
3. Documentar resultado en pruebas/
4. Si funciona → mover a docs/ o agentes/
5. git add . && git commit -m "..."
6. git push
```

### Formato de commit

```
feat:  nueva funcionalidad
fix:   corrección de error
docs:  documentación
test:  prueba nueva
chore: mantenimiento
```

Ejemplos:
```
feat: añadir modelo deepseek-r1:14b a opencode.json
fix: corregir ruta litellm en start-colmena.sh
docs: documentar error openclaw en pruebas/opencode
```

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
│   ├── opencode-rotate.sh      ← rotar modelos en OpenCode
│   └── ...
│
├── docs/                       ← documentación técnica estable
│   ├── arranque-rapido.md
│   ├── setup-servidor-ssh-wsl.md
│   └── opencode-setup.md
│
├── pruebas/                    ← laboratorio: todo lo que probamos
│   ├── opencode/               ← pruebas con OpenCode
│   ├── ollama/                 ← pruebas con modelos locales
│   ├── agentes/                ← pruebas de agentes
│   └── modelos/                ← comparativas de modelos
│
├── agentes/                    ← agentes documentados y validados
│
├── guias/                      ← guías de setup paso a paso
│
├── config/                     ← configuraciones (opencode.json, litellm-config.yaml)
│
└── opensource/                 ← preparado para publicar a la comunidad
    └── README.md
```

---

## 📏 Reglas de calidad

- **Todo lo que probamos se documenta** — aunque falle, especialmente si falla
- **Los errores son valiosos** — documentar el error exacto y la solución
- **Sin documentar = no existe** — si no está en GitHub no pasó
- **Commits pequeños y frecuentes** — mejor 10 commits pequeños que 1 enorme
- **Nunca modificar opencode.json localmente** — siempre desde GitHub o con `git pull` previo

---

## 🌍 Camino hacia opensource

Cuando algo funciona bien y está documentado:

1. Mover/copiar a `opensource/`
2. Limpiar datos personales (keys, rutas absolutas)
3. Añadir comentarios para la comunidad
4. Actualizar `opensource/README.md`
5. Evaluar si merece repo propia

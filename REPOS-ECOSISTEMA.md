# REPOS-ECOSISTEMA — Inventario de la cuenta

> Medido contra la API de GitHub el **2026-09-10**.
> Total: **25 repositorios** — 10 públicos, 15 privados, 13 archivados.

Este documento se reescribió entero el 2026-09-10. La versión anterior era
del 16 de abril y daba **11 repos**; de aquellos once, **ocho ya no existen
en la cuenta** y el documento seguía ofreciendo `git clone` de todos ellos:

| Repo que listaba | Hoy |
|---|---|
| `thdora` | ❌ no existe (hay `THDORA-PERSONAL`, privado, otro nombre) |
| `personal` | ❌ no existe |
| `unix` | ❌ no existe |
| `ejerciciosbego` | ❌ no existe |
| `python-snippets` | ❌ no existe |
| `ocr-number-adder` | ❌ no existe |
| `AppointmentManager` | ❌ no existe |
| `brunobailosolo` | ❌ no existe |
| `ai-toolkit`, `thea-ia`, `image-calculator` | ✅ siguen |

---

## Nota sobre lo que aquí no se detalla

**Este repositorio es público.** Los repos privados se cuentan pero no se
describen: decir qué contiene un repo privado revela justo lo que se decidió
no publicar. La lista completa está en la propia cuenta de GitHub, que es
donde tiene que estar.

---

## Públicos y activos

| Repo | Qué es | Último empuje |
|------|--------|---------------|
| [bifrost](https://github.com/alvarofernandezmota-tech/bifrost) | Bot de Telegram en producción. Servicio systemd, 179 pruebas, ADRs propios. **Es la pieza más presentable del ecosistema** | 2026-09-10 |
| [ai-toolkit](https://github.com/alvarofernandezmota-tech/ai-toolkit) | Stack de agentes IA (ESTE REPO) | 2026-09-10 |
| [code-temple](https://github.com/alvarofernandezmota-tech/code-temple) | Absorbido en otro repo. **Sigue sin archivar en GitHub** aunque la documentación lo da por archivado | 2026-08-24 |
| [impresion-3d](https://github.com/alvarofernandezmota-tech/impresion-3d) | Impresión 3D | 2026-05-27 |
| [image-calculator](https://github.com/alvarofernandezmota-tech/image-calculator) | OCR + tkinter. MIT | 2026-04-05 |
| [thea-ia](https://github.com/alvarofernandezmota-tech/thea-ia) | **Parado desde el 2026-02-02**, sin usuarios. 217 MB públicos: el 80 % del peso visible de la cuenta. Sin descripción | 2026-02-02 |
| [alvarofernandezmota-tech](https://github.com/alvarofernandezmota-tech/alvarofernandezmota-tech) | El README del perfil. 1 KB, sin tocar desde el 2 de julio | 2026-07-02 |
| [open-webui](https://github.com/alvarofernandezmota-tech/open-webui) | Fork | 2026-08-13 |

## Públicos y archivados

`yggdrasil-dew`, `formacion-tech`, `investigacion-ia`.

`investigacion-ia` pesa **0 KB**: está archivado y vacío.

## Privados

**15 repos**, de los cuales 10 archivados. Se cuentan aquí y no se detallan,
por lo dicho arriba.

Los archivados son, en su mayoría, la familia `yggdrasil-*` congelada en julio
de 2026 y las configuraciones de máquina de la misma época.

---

## Lo que este inventario dice del escaparate

Tres cosas que se ven solas al ordenarlo:

1. **`thea-ia` es el 80 % del peso público de la cuenta** y lleva parado desde
   febrero, sin descripción que lo explique. Archivarlo con una nota de qué se
   aprendió convierte un cementerio en una lección contable en una entrevista.
2. **`code-temple` no está archivado en GitHub** aunque su documentación diga
   que sí. Sigue aceptando issues y PR.
3. **`investigacion-ia` está archivado y vacío.** Un repo de 0 KB en el perfil
   solo resta.

Ninguno de los diez repos públicos tiene **topics**, y ocho no tienen
licencia.

---

## Cómo se mantiene esto al día

Con el mismo comando que lo midió:

```bash
gh repo list alvarofernandezmota-tech --limit 100 \
  --json name,visibility,isArchived,pushedAt,description
```

Si la salida no coincide con esta tabla, manda la salida. Un inventario que
nadie vuelve a medir se convierte en lo que era este documento hasta hoy: una
lista de ocho repos que ya no existen.

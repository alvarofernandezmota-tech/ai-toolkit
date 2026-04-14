# 🔬 Investigación

Experimentos reproducibles y resultados verificados.

## Cómo documentar un experimento

Cada experimento es una carpeta con:
```
investigacion/
└── YYYY-MM-DD-nombre-experimento/
    ├── README.md     ← qué se probó, cómo, resultado
    ├── prompt.md     ← prompt exacto usado
    └── resultado.md  ← output del modelo
```

## Reglas

- Todo experimento debe ser **reproducible** — incluye el prompt exacto y el modelo usado
- Documenta los **fallos** también — saber qué no funciona es igual de valioso
- Incluye la fecha y versión del modelo

---
_Los resultados de investigación alimentan directamente las [guias/](../guias/)._

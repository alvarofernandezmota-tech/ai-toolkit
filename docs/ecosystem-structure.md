# Ecosistema de IA — Estructura Ideal

> Documento base para la arquitectura del ecosistema de agentes IA

## Visión General
Mapa completo de agentes, herramientas y flujos del ecosistema personal de IA. Diseñado para operar con **0€/mes**, bajo consumo de recursos (<1% CPU, ~360MB RAM) y alta modularidad.

## Principios de Diseño
- **Módulo**: Cada agente tiene responsabilidades claramente definidas
- **Escalable**: Componentes desacoplados y fácilmente extensibles
- **Gratis**: Uso exclusivo de servicios gratuitos (Groq, OpenRouter, DuckDuckGo)
- **24/7**: Operación continua con n8n orquestador
- **Auto-documentado**: Generación automática de documentación

## Agentes Principales

### 1. Agente de Código (Terminal)
- **Herramienta**: Aider + Groq
- **Función**: Edita código, crea commits, arregla bugs
- **Modelo**: `groq/llama-3.3-70b-versatile`
- **Alias**: `aider-thdora`
- **Flujo**:
  - `/add <ruta>` para incluir archivos
  - `> fix <issue>` para resolver problemas
  - `/diff` para revisar cambios

### 2. Agente de Arquitectura
- **Herramienta**: Claude Code + OpenRouter
- **Función**: Analiza repos completos, propone diseño estructural
- **Modelo**: `openrouter/free` (selecciona automáticamente el mejor modelo)
- **Comando**: `claude --model openrouter/google/gemini-2.5-pro-exp-03-25`
- **Salida**: Propuestas de mejora, refactorizaciones, documentación

### 3. THDORA — Agente de Vida Personal
- **Herramientas**: Telegram Bot + n8n + DuckDuckGo
- **Funciones**:
  - 📅 Agenda y gestión de citas
  - 💧 Seguimiento de hábitos diarios
  - 🤖 Respuestas en lenguaje natural vía API
  - 🔍 Búsqueda web integrada
- **Modelo Default**: `groq/llama-3.3-70b-versatile`

### 4. Orquestador n8n
- **Función**: Ejecuta workflows autónomos 24/7
- **Componentes**:
  - 📓 Diario nocturno (commit automático)
  - 📈 Resumen semanal (informe cada lunes)
  - ⚠️ Alertas de hábitos (22:00 si no se completan)
  - 📅 Brief de mañana (recordatorio)

## Flujo de Trabajo Diario

```
08:00    n8n → genera brief del día → Telegram
           ↓
Todo el día  THDORA escucha Telegram → responde via API (<1s)
           ↓
22:00    n8n → verifica hábitos → envía alerta si faltan
           ↓
23:00    n8n → diario automático → commit en repo personal
```

## Consumo de Recursos Estable

| Componente          | CPU | RAM   | Ubicación          |
|---------------------|-----|-------|--------------------|
| THDORA Bot          | ~0% | ~50MB | Groq (nube)        |
| THDORA API          | ~0% | ~40MB | — |
| Aider/Claude Code   | ~0% | ~30-60MB | OpenRouter (nube) |
| n8n Docker          | ~0% | ~180MB | Host local         |
| **TOTAL**           | **<1%** | **~360MB** | — |

## Modelos Recomendados (Acceso Gratis)

| Caso de Uso               | Modelo                  | Proveedor        |
|---------------------------|-------------------------|------------------|
| Tareas rápidas (cód.: agentes) | `llama-3.3-70b-versatile` | Groq (gratis)    |
| Arquitectura/refactorización | `DeepSeek R1`/`Qwen3 Coder` | OpenRouter:free  |
| Búsqueda web              | `llama-3.3-70b-versatile` | Groq + DDGS      |

## Estructura de Directorios Recomendada

```
/home/alvaro/projects/ai-toolkit/
├── agentes/        # Implementaciones de agentes
├── guias/          # Documentación de flujos
├── investigacion/  # Experimentos reproducible
├── scripts/        # Automatizaciones
├── setup/          # Instaladores de dependencias
├── docs/           # Documentación técnica
│   └── ecosystem-structure.md  # ← Este archivo
└── personal/       # Memoria privada (no versionada)
```

## Integración con Servicios Externos

- **Groq Console**: [console.groq.com](https://console.groq.com) → claves API gratis
- **OpenRouter**: [openrouter.ai](https://openrouter.ai) → acceso a múltiples modelos
- **DuckDuckGo**: Búsqueda web sin clave requerida
- **Telegram Bot**: Gestión de mensajes vía @BotFather

## 🔑 Requisitos Previos para Arranque

1. Node.js 20+ instalado
2. Claves de [Groq](https://console.groq.com) y [OpenRouter](https://openrouter.ai)
3. Ejecución de `bash setup.sh` (opción completa)
4. Configuración de variables en `~/.bashrc`
5. Instancia n8n en ejecución (`docker run ...`)

---
*Documento generado 15 abril 2026 — versión 1.0*  
Ideal para integrarse con el sistema de memoria persistente del ecosistema personal.
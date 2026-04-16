# Arquitectura Servidor — Decisión 2026-04-17

## Problema actual

OpenCode corre en local con Ollama. Los modelos locales no tienen límites, pero:
- Si queremos hacer commits desde otro sitio, necesitamos acceso remoto
- Si queremos que el agente trabaje mientras nosotros no estamos, necesita un servidor
- Las APIs gratuitas se agotan rápido → dependencia del hardware local

## Arquitectura propuesta: Servidor + Local híbrido

```
┌─────────────────────────────────────────────────────────┐
│                    SERVIDOR (remoto)                     │
│                                                         │
│  ┌─────────────┐    ┌──────────────┐                   │
│  │   Ollama    │    │  LiteLLM     │                   │
│  │  (modelos)  │◄───│  Proxy :8000 │                   │
│  └─────────────┘    └──────────────┘                   │
│                            ▲                            │
│  ┌─────────────┐           │                           │
│  │ Perplexica  │    ┌──────┴───────┐                   │
│  │ (web search)│    │   OpenCode   │                   │
│  └─────────────┘    └──────────────┘                   │
│                            ▲                            │
└────────────────────────────┼────────────────────────────┘
                             │ SSH
┌────────────────────────────┼────────────────────────────┐
│                    LOCAL (nosotros)                      │
│                                                         │
│   git pull/push ──► GitHub ◄── OpenCode trabaja         │
│   revisamos código          en el servidor              │
│   hacemos commits           hace commits también        │
└─────────────────────────────────────────────────────────┘
```

## Flujo de trabajo

1. **Servidor** corre OpenCode + Ollama + LiteLLM 24/7
2. **Nosotros** nos conectamos por SSH cuando queremos revisar
3. **OpenCode** (agente) puede hacer commits directamente a GitHub
4. **Nosotros** hacemos `git pull` en local para revisar lo que hizo el agente
5. **Perplexica** en el servidor da búsqueda web al agente sin APIs externas

## Ventajas

- OpenCode trabaja aunque no estemos delante
- Nosotros controlamos y revisamos los commits
- Los modelos locales corren en el servidor (más GPU/RAM disponible)
- Sin límites de cuota de ningún tipo
- Código siempre en GitHub — nunca se pierde nada

## Opciones de servidor

| Opción | Coste | GPU | Notas |
|--------|-------|-----|-------|
| VPS Hetzner (CAX41) | ~20€/mes | ARM, 16GB RAM | Sin GPU, solo CPU/RAM |
| RunPod | ~0.3$/h | RTX 3090 | Pagar solo cuando se usa |
| WSL actual (local) | 0€ | tu GPU | Ya funciona, sin servidor |
| Oracle Cloud Free | 0€ | ARM 24GB | Free tier permanente |

## Próximos pasos

- [ ] Decidir opción de servidor (Oracle Free o Hetzner recomendados)
- [ ] Configurar SSH según `guias/setup-servidor-ssh-wsl.md`
- [ ] Instalar Perplexica: `docker-compose up perplexica`
- [ ] Mover LiteLLM + Ollama al servidor
- [ ] Conectar OpenCode al LiteLLM del servidor vía SSH tunnel

# Arquitectura Servidor — Decisión 2026-04-17

## Hardware real del ecosistema

| Equipo | CPU | GPU | VRAM | RAM | Rol actual |
|--------|-----|-----|------|-----|------------|
| **PC Sobremesa** | ⏳ pendiente `lscpu` | GTX 1060 | 6GB | 16GB | Servidor principal + Ollama + todo el dev |
| **Acer Aspire A515-45** | Ryzen 5 5500U | Radeon integrada | ❌ | 8GB | Cliente SSH ligero — conseguido 16/04/2026 |

---

## Problema actual

OpenCode corre en local con Ollama. Los modelos locales no tienen límites, pero:
- Si queremos hacer commits desde otro sitio, necesitamos acceso remoto
- Si queremos que el agente trabaje mientras nosotros no estamos, necesita un servidor
- Las APIs gratuitas se agotan rápido → dependencia del hardware local

## Arquitectura propuesta: Servidor + Local híbrido

```
┌───────────────────────────────────────────────────────────┐
│              PC SOBREMESA (servidor local)                  │
│                                                         │
│  ┌─────────────┐    ┌──────────────┐                   │
│  │   Ollama    │    │  LiteLLM     │                   │
│  │  GTX 1060   │◄───│  Proxy :4000 │                   │
│  │  6GB VRAM   │    └──────────────┘                   │
│  └─────────────┘           ↑                           │
│                     ┌─────────┘──────┐                   │
│                     │   OpenCode   │                   │
│                     └──────────────┘                   │
│                            ↑                            │
└───────────────────────────────────────────────────────────┘
                             │ SSH / Tailscale
┌───────────────────────────────────────────────────────────┐
│           ACER ASPIRE (cliente ligero)                   │
│                                                         │
│   VSCode Remote-SSH ────► GitHub ◄── commits desde PC    │
│   revisamos código            agente trabaja en PC       │
└───────────────────────────────────────────────────────────┘
```

## Flujo de trabajo

1. **PC Sobremesa** corre OpenCode + Ollama + LiteLLM 24/7
2. **Acer Aspire** se conecta por SSH cuando queremos trabajar desde fuera
3. **OpenCode** (agente) puede hacer commits directamente a GitHub
4. **Nosotros** hacemos `git pull` en local para revisar lo que hizo el agente
5. **Tailscale** permite conectar desde cualquier sitio sin abrir puertos

## Ventajas

- OpenCode trabaja aunque no estemos delante
- Acer como cliente ligero: batería larga, sin carga computacional
- Los modelos locales corren en el PC con GTX 1060 (6GB VRAM)
- Sin límites de cuota de ningún tipo
- Código siempre en GitHub — nunca se pierde nada

## Modelos locales óptimos (GTX 1060 6GB)

Ver guía completa: [`guias/modelos-por-hardware.md`](guias/modelos-por-hardware.md)

| Modelo | VRAM | Rol |
|--------|------|-----|
| `qwen3:4b` | ~2.5GB | Orquestador rápido |
| `qwen2.5-coder:7b-instruct-q4_K_M` | ~4.5GB | Coding principal |
| `phi-4-mini` | ~2.5GB | Razonamiento |

## Opciones de servidor remoto (si se quiere escalar)

| Opción | Coste | GPU | Notas |
|--------|-------|-----|-------|
| PC Sobremesa (actual) | 0€ | GTX 1060 6GB | ✅ Ya funciona — servidor local |
| Oracle Cloud Free | 0€ | ARM 24GB RAM | Sin GPU, pero CPU potente |
| VPS Hetzner (CAX41) | ~20€/mes | ARM, 16GB RAM | Sin GPU |
| RunPod | ~0.3$/h | RTX 3090 | Pagar solo cuando se usa |

## Próximos pasos

- [ ] PC: `sudo apt install openssh-server`
- [ ] PC: `ip a` → anotar IP local
- [ ] PC: instalar Tailscale
- [ ] PC: `ollama pull qwen2.5-coder:7b-instruct-q4_K_M`
- [ ] PC: `ollama pull qwen3:4b`
- [ ] PC: `nvidia-smi` → verificar VRAM libre
- [ ] Acer: SSH client + VSCode Remote-SSH
- [ ] Desarrollar `agents/agente-benchmark.py`

_Actualizado: 17 abril 2026 — hardware real documentado, arquitectura SSH PC+Acer — por Perplexity AI MCP_

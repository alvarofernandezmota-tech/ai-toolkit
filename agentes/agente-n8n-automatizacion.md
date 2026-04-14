# 🔄 Agente de automatización — n8n (Mayo 2026)

> n8n es el orquestador que conecta todos los demás agentes y los hace correr solos. Una vez configurado, el ecosistema funciona 24/7 sin intervención.

**Fecha objetivo: Mayo 2026.**

---

## Qué automatiza n8n en este ecosistema

```
08:00  → Brief del día (citas de hoy) → Telegram
22:00  → Alerta hábitos pendientes → Telegram
22:00  → Brief de mañana → Telegram  
23:00  → Diario automático → commit en personal repo
Lunes  → Resumen semanal → Telegram
```

Setup técnico completo: [setup/n8n-docker-wsl.md](../setup/n8n-docker-wsl.md)

---

## Workflow 1 — Brief diario (paso a paso en n8n)

### Crear en la interfaz de n8n

1. Abrir `http://localhost:5678`
2. **New Workflow** → nombre: `Brief Diario`
3. Añadir nodo **Schedule Trigger** → `Every Day at 08:00`
4. Añadir nodo **HTTP Request**:
   - URL: `http://localhost:8000/citas/hoy`
   - Method: `GET`
5. Añadir nodo **Code** (JavaScript):
```javascript
const citas = $input.all()[0].json;
if (citas.length === 0) {
  return [{ json: { texto: '📅 Sin citas hoy. Día libre.' } }];
}
const lista = citas.map(c => `• ${c.hora} — ${c.titulo}`).join('\n');
return [{ json: { texto: `📅 Hoy tienes:\n${lista}` } }];
```
6. Añadir nodo **Telegram**:
   - Credential: tu bot token
   - Chat ID: tu chat ID personal
   - Text: `{{ $json.texto }}`
7. **Save** → **Activate**

---

## Workflow 2 — Alerta hábitos (paso a paso)

1. **Schedule Trigger** → `Every Day at 22:00`
2. **HTTP Request** → `GET http://localhost:8000/habitos/hoy`
3. **IF** node:
   - Condition: `{{ $json.pendientes.length }} > 0`
4. **Code** (rama TRUE):
```javascript
const pendientes = $input.all()[0].json.pendientes;
const lista = pendientes.map(h => `• ${h.emoji} ${h.nombre}`).join('\n');
return [{ json: { texto: `⚠️ Hábitos pendientes:\n${lista}` } }];
```
5. **Telegram** → enviar aviso

---

## Workflow 3 — Diario nocturno automático

1. **Schedule Trigger** → `Every Day at 23:00`
2. **HTTP Request** → `GET http://localhost:8000/resumen/hoy`
3. **Code** — generar markdown:
```javascript
const data = $input.all()[0].json;
const hoy = new Date().toISOString().split('T')[0];
const md = `# Diario ${hoy}\n\n## Hábitos\n${data.habitos}\n\n## Citas\n${data.citas}\n`;
return [{ json: { contenido: md, fecha: hoy } }];
```
4. **GitHub** node:
   - Operation: `Create or Update File`
   - Repository: `personal`
   - File Path: `diarios/{{ $json.fecha }}.md`
   - Content: `{{ $json.contenido }}`
   - Commit: `diario automático {{ $json.fecha }}`

---

## Conectar n8n con THDORA API

THDORA necesita tener estos endpoints para que n8n los consuma:

| Endpoint | Método | Qué devuelve |
|---|---|---|
| `/citas/hoy` | GET | Lista de citas de hoy |
| `/citas/manana` | GET | Lista de citas de mañana |
| `/habitos/hoy` | GET | Hábitos del día (marcados y pendientes) |
| `/resumen/hoy` | GET | Resumen completo del día |

> Estos endpoints ya existen o se añaden en la fase de integración con n8n (Mayo 2026).

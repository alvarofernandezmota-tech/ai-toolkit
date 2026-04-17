# Configuración de OpenCode con LiteLLM local

## Problema

OpenCode necesita un `config.json` con una API key válida para conectarse a LiteLLM. Si el archivo no existe, manda `sk-...` como placeholder y LiteLLM devuelve `401 Unauthorized`.

## Solución

### 1. Crear el config de OpenCode

```bash
mkdir -p ~/.config/opencode
cat > ~/.config/opencode/config.json << 'EOF'
{
  "providers": {
    "openai": {
      "apiKey": "sk-colmena-local",
      "baseUrl": "http://localhost:8000/v1"
    }
  }
}
EOF
```

### 2. Opción A — Añadir master_key a LiteLLM (recomendado)

En el yaml de LiteLLM (`~/projects/thdora/litellm_config.yaml` o similar), añadir:

```yaml
general_settings:
  master_key: sk-colmena-local
```

Luego reiniciar LiteLLM.

### 3. Opción B — Desactivar auth en LiteLLM (desarrollo local)

```yaml
general_settings:
  disable_auth: true
```

## Verificar que funciona

```bash
# Con API key
curl -s http://localhost:8000/v1/models \
  -H "Authorization: Bearer sk-colmena-local" | python3 -m json.tool | grep '"id"'

# Sin auth
curl -s http://localhost:8000/v1/models | python3 -m json.tool | grep '"id"'
```

## Diagnóstico rápido

```bash
# Ver si existe el config
ls -la ~/.config/opencode/config.json

# Ver el contenido
cat ~/.config/opencode/config.json

# Ver master_key de LiteLLM
grep -rni "master_key" ~/projects/thdora/ 2>/dev/null | grep -v ".pyc"
```

# OpenClaw
## Models
- qwen3.5:9b
- gemma4:e4b

## Config
### 9Router
```nix
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "9router/oc/deepseek-v4-flash-free"
      }
    }
  },
  "models": {
    "providers": {
      "9router": {
        "baseUrl": "http://127.0.0.1:20128/v1",
        "apiKey": "sk-e698bd61283289ed-tayts9-f4fc5c8b",
        "api": "openai-completions",
        "models": [
          {
            "id": "oc/deepseek-v4-flash-free",
            "name": "deepseek-v4-flash-free"
          },
          {
            "id": "oc/nemotron-3-ultra-free",
            "name": "nemotron-3-ultra-free"
          },
          {
            "id": "oc/north-mini-code-free",
            "name": "north-mini-code-free"
          }
        ]
      }
    }
  }
}
```

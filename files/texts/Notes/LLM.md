LLM Shenanigans on NixOS
========================
# OLLAMA
## Start OLLAMA Server
```sh
podman run \
  --device nvidia.com/gpu=all \
  -v /mnt/AI/ollama:/root/.ollama:Z \
  --network=none \
  ollama/ollama
```
## Run LLM
Find the `<container-name>` via `podman ps`.
```sh
podman exec -it <container-name> ollama run gemma3
```

# Container Management
## Start Container
```sh
podman start <container-name>
```
## Enter Container
```sh
podman exec -it <container-name> bash
```
## Stop Container
```sh
podman stop <container-name>
```
## List Containers
```sh
podman container list
# ... or ...
podman ps
```

Models To-Try
=============
1. **huihui_ai/gemma3-abliterated** - Supposedly Uncensored/Freed Version of Gemma3

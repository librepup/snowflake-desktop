Advanced Modification and Instruction for your LLM
==================================================
Interacting with and Managing your LLM
--------------------------------------
## Serve OLLAMA
```sh
podman run \
  --device nvidia.com/gpu=all \
  -v /mnt/AI/ollama:/root/.ollama:Z \
  --network=none \
  -v /mnt/AI/PuppiesModfileV2:/root/PuppiesModfileV2:Z \
ollama/ollama
```
## Create Model
```sh
podman exec -it <container-name> ollama create master -f /root/PuppiesModfileV2
```
## Run Model
```sh
podman exec -it <container-name> ollama run master
```
## Delete Model
```sh
podman exec -it <container-name> ollama rm master
```

Managing your Podman Container
------------------------------
## Delete Container
```sh
podman rm <container-name>
```
## Start Container
```sh
podman start <container-name>
```
## Stop Container
```sh
podman stop <container-name>
```

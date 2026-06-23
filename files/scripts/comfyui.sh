#!/usr/bin/env bash

comfyui-launch() {
  xdg-open "http://0.0.0.0:8188"
  podman run -it --rm \
    --name comfyui-cu126 \
    --gpus all --device nvidia.com/gpu=all \
    -p 8188:8188 \
    -v /extra/ComfyUI/storage-cache/dot-cache:/root/.cache \
    -v /extra/ComfyUI/storage-cache/dot-config:/root/.config \
    -v /extra/ComfyUI/storage-nodes/dot-local:/root/.local \
    -v /extra/ComfyUI/storage-nodes/custom_nodes:/root/ComfyUI/custom_nodes \
    -v /extra/ComfyUI/storage-models/models:/root/ComfyUI/models \
    -v /extra/ComfyUI/storage-models/hf-hub:/root/.cache/huggingface/hub \
    -v /extra/ComfyUI/storage-models/torch-hub:/root/.cache/torch/hub \
    -v /extra/ComfyUI/storage-user/input:/root/ComfyUI/input \
    -v /extra/ComfyUI/storage-user/output:/root/ComfyUI/output \
    -v /extra/ComfyUI/storage-user/user-profile:/root/ComfyUI/user \
    -v /extra/ComfyUI/storage-user/user-scripts:/root/user-scripts \
    -e CLI_ARGS="--enable-manager" \
    yanwk/comfyui-boot:cu126-slim
}

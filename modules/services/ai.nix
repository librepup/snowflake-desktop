{ config, pkgs, lib, inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.nixified-ai.overlays.comfyui
    inputs.nixified-ai.overlays.models
    inputs.nixified-ai.overlays.fetchers
  ];
  services.comfyui = {
    enable = false;
    package = inputs.nixified-ai.packages.x86_64-linux.comfyui-nvidia;
    host = "0.0.0.0";
    customNodes = with inputs.nixified-ai.packages.x86_64-linux.comfyui-nvidia.pkgs; [
      comfyui-gguf
      comfyui-impact-pack
      comfyui-easy-use
    ];
  };
  services.sillytavern = {
    enable = true;
    port = 8045;
  };
  services.open-webui = {
    enable = true;
    stateDir = "/var/lib/open-webui";
    port = 6967;
    environment = {
      ENABLE_IMAGE_GENERATION = "True";
      ENABLE_WEB_SEARCH = "True";
      USER_PERMISSIONS_CHAT_FILE_UPLOAD = "True";
      ENABLE_MEMORIES = "True";
      DATA_DIR = "/var/lib/open-webui";
      OLLAMA_BASE_URL = "http://127.0.0.1:11434";
    };
  };
  services.ollama = {
    enable = false;
    models = "/mnt/AI/ollama/models";
    acceleration = "vulkan";
    package = pkgs.ollama-vulkan;
  };
  systemd.services = {
    ollama.wantedBy = lib.mkForce [ ];
    ollama-model-loader.wantedBy = lib.mkForce [ ];
    open-webui.wantedBy = lib.mkForce [ ];
    sillytavern.wantedBy = lib.mkForce [ ];
    # comfyui.wantedBy = lib.mkForce [ ];
  };
}

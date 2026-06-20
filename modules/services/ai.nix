{ config, pkgs, lib, inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.nixified-ai.overlays.comfyui
    inputs.nixified-ai.overlays.models
    inputs.nixified-ai.overlays.fetchers
  ];
  # Hermes Agent
  services.hermes-agent = {
    enable = true;
    container.enable = true;
    stateDir = "/extra/hermes/state";
    workingDirectory = "/extra/hermes/workspace";
    addToSystemPackages = true;
    settings = {
      model.default = "ollama/hermes3:8b";
      terminal = {
        cwd = "/extra/hermes/workspace";
        backend = "local";
      };
    };
    environment = {
      OLLAMA_CONTEXT_LENGTH = "32768";
    };
  };
  systemd.tmpfiles.rules = [
    "d /extra/hermes/state 0755 hermes hermes -"
    "d /extra/hermes/workspace 0755 hermes hermes -"
  ];
  # ComfyUI
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
  # SillyTavern
  services.sillytavern = {
    enable = true;
    port = 8045;
  };
  # OpenWeb-UI
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
  # Ollama
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
    comfyui.wantedBy = lib.mkForce [ ];
  };
}

{ config, pkgs, lib, inputs, ... }:
{
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
  systemd.services.ollama.wantedBy = lib.mkForce [ ];
  systemd.services.ollama-model-loader.wantedBy = lib.mkForce [ ];
  systemd.services.open-webui.wantedBy = lib.mkForce [ ];
}

{ config, pkgs, lib, inputs, ... }:
{
  # Enable Overlays for Community AI Modules and Services.
  nixpkgs.overlays = [
    inputs.nixified-ai.overlays.comfyui
    inputs.nixified-ai.overlays.models
    inputs.nixified-ai.overlays.fetchers
  ];
  # Hermes Agent
  services.hermes-agent = {
    enable = false;
    container = {
      enable = true;
      backend = "podman";
      extraOptions = [
        "--gpus" "all"
      ];
    };
    stateDir = "/extra/hermes/state";
    workingDirectory = "/extra/hermes/workspace";
    addToSystemPackages = true;
    settings = {
      model = {
        base_url = "http://localhost:11434/v1";
        default = "hf.co/mradermacher/Huihui-NVIDIA-Nemotron-Nano-9B-v2-abliterated-i1-GGUF:Q4_K_M";
      };
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
    models = "/mnt/AI/ollama/models"; # Model Directory
    # acceleration = "cuda"; # "vulkan";
    syncModels = false;
    environmentVariables = {
      OLLAMA_MODELS = "/mnt/AI/ollama/models"; # Model Directory (Env. Variable)
      CUDA_MODULE_LOADING = "LAZY"; # Helps with VRAM (Grok Suggestion)
    };
    package = pkgs.ollama-cuda; # As opposed to 'pkgs.ollama-vulkan', or use 'pkgs.unstable.ollama-cuda'.
  };
  # Simple Ollama Web UI
  services.nextjs-ollama-llm-ui = {
    enable = true;
  };
  # Disable Services from Automatically Starting.
  systemd.services = {
    ollama.wantedBy = lib.mkForce [ ];
    nextjs-ollama-llm-ui.wantedBy = lib.mkForce [ ];
    ollama-model-loader.wantedBy = lib.mkForce [ ];
    open-webui.wantedBy = lib.mkForce [ ];
    sillytavern.wantedBy = lib.mkForce [ ];
    comfyui.wantedBy = lib.mkForce [ ];
    hermes-agent.wantedBy = lib.mkForce [ ];
  };
}

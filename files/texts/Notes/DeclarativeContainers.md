Declarative Container Management - Currently Unfinished
=======================================================
oci-containers.containers = {
  ollama = {
    autoStart = false;
    image = "docker.io/ollama/ollama:latest";
    volumes = [
      "/mnt/AI/ollama:/root/.ollama:Z"
    ];
    ports = [
      "127.0.0.1:11434:11434"
    ];
    extraOptions = [
      "--device nvidia.com/gpu=all"
      "--network=none"
    ];
  };
  ollama-pullable = {
    autoStart = false;
    image = "docker.io/ollama/ollama:latest";
    volumes = [
      "/mnt/AI/ollama:/root/.ollama:Z"
    ];
    ports = [
      "127.0.0.1:11434:11434"
    ];
  };
};
Waydroid Info
=============
Run: `nix shell github:nix-community/NUR#repos.ataraxiasjel.waydroid-script -c sudo waydroid-script` to Fix Apps not Installing
Select: libhoudini (Intel CPU) and gapps (Google Services)

# Install and Set Up Podman
## NixOS
 ```nix
  programs.virt-manager.enable = true;
  environment.etc."libvirt/qemu/networks/default.xml" = {
    text = ''
      <network>
        <name>default</name>
        <bridge name="virbr0"/>
        <forward mode='nat'/>
        <ip address='172.16.56.1' netmask='255.255.255.0'>
          <dhcp>
            <range start='172.16.56.2' end='172.16.56.254'/>
            <host mac='52:54:00:12:34:56' name='virtualmachine' ip='172.16.56.10'/>
          </dhcp>
        </ip>
      </network>
    '';
  };
  system.activationScripts.libvirt-network-start = {
    deps = [ "users" ];
    text = ''
      export VIRSH_DEFAULT_CONNECT_URI="qemu:///system"
      /run/current-system/sw/bin/sleep 2
      if ! /run/current-system/sw/bin/virsh net-list --all | grep -q "default"; then
        /run/current-system/sw/bin/virsh net-define /etc/libvirt/qemu/networks/default.xml
      fi
      /run/current-system/sw/bin/virsh net-start default || true
      /run/current-system/sw/bin/virsh net-autostart default || true
    '';
  };
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };
    containers = {
      enable = true;
      storage.settings = {
        graphroot = "/mnt/Containers";
      };
    };
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    spiceUSBRedirection.enable = true;
  };
 ```

# Main Tested Podman Notes
## Stop, Delete, and Clean Up Containers
 - `podman stop ollama && podman rm ollama`
## Create Container
 ```sh
 podman run -d --name ollama \
  --network none \
  --device /dev/nvidia0 \
  --device /dev/nvidiactl \
  --device /dev/nvidia-uvm \
  -v /mnt/AI/ollama:/root/.ollama:Z \
  ollama/ollama
 ```
## Download Gemma3 LLM/AI Model
 ```sh
 podman run --rm \
  -v /mnt/AI/ollama:/root/.ollama:Z \
  --entrypoint /bin/sh \
  ollama/ollama -c "ollama serve & sleep 4 && ollama pull gemma3:latest"
 ```
## Protect Model Files from Deletion
 - `doas chattr -R +i /mnt/AI/ollama/models/`

## Enter Container and Run LLM
 - `podman exec -it ollama bash`
 - `ollama list`
 - `ollama run gemma3:latest`

==========================

# Secondary Podman Notes
## Create New Container
 - `podman run -d --name ollama --network none -v /mnt/Podman/Volumes/ollama:/root/.ollama:Z ollama/ollama`
 + `podman run` - Runs a new Container
 + `-d` - Detatch the Container
 + `--name ollama` - Container Name
 + `--network none` - Disable Network/Internet Access
 + `-v /mnt/Podman/Volumes/ollama:/root/.ollama:Z` - Volume Setup
 + `ollama/ollama` - The Image to Pull

## Install AI/LLM Model in Container
 - First we need to create a proper container, to do that, run this command:
 ```sh
 podman run -d --name ollama \
  --network none \
  -v /mnt/AI/ollama:/root/.ollama:Z \
  --entrypoint /bin/sh \
  ollama/ollama -c "OLLAMA_HOST=unix:///root/.ollama/ollama.domain ollama serve"
 ```
 - Secondly download your desired model, in this case: `gemma3:latest`.
 ```sh
 podman run --rm \
   -v /mnt/AI/ollama:/root/.ollama:Z \
   --entrypoint /bin/sh \
   ollama/ollama -c "ollama serve & sleep 3 && ollama pull gemma3:latest"
 ```
 - After that's done, run: `podman exec -it -e OLLAMA_HOST=/root/.ollama/ollama.domain ollama bash` to enter the newly set up container.
 - Then commands like `ollama list` and `ollama run gemma3:latest` should work.

## Deleting Containers
 - Run `podman stop <container-name> && podman rm <container-name>` to stop and delete a created container.

## Marking a Model Read-Only (Prevent Accidental Deletion)
 - To mark a directory with model files as read-only or protected, run:
 ```sh
 sudo chattr -R +i /mnt/AI/ollama/models/
 ```
 To later unlock it, in case you want to remove or update the model, run:
 ```sh
 sudo chattr -R -i /mnt/AI/ollama/models/
 ```
 - Alternatively, if chattr is unsupported on your system, you can change the ownership to the "root" user like this:
 ```sh
 sudo chown -R root:root /mnt/AI/ollama/models/
 sudo chmod -R 755 /mnt/AI/ollama/models/
 ```

## Tweak the Model
 ```sh
 cat << 'EOF' > /tmp/Modelfile
 # 1. Choose your Base Model.
 FROM gemma3:latest

 # 2. Adjust Parameters if you want (e.g.: lower Temperature makes it more Factual, higher makes it Creative).
 PARAMETER temperature 0.7

 # 3. Define the Setup, Personality, and Instructions.
 SYSTEM """
 You are "Nexus", a highly intelligent and slightly witty AI companion running locally on a custom Linux workstation.
 - Your name is Nexus.
 - You must always be straightforward, clear, and direct.
 - Avoid generic corporate fluff (like "As an AI, I don't have feelings...").
 - If anyone asks, you are fully offline, local, and completely private.
 """
 EOF
 ```
 - Apply changes with the `ollama create nexus -f /tmp/Modelfile` command.

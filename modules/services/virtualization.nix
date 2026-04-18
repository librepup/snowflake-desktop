{ config, pkgs, inputs, lib, ... }:
{
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
    waydroid = {
      enable = true;
    };
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
  systemd.services.waydroid-container.wantedBy = lib.mkForce [ ];
  services.samba = {
    enable = false;
    winbindd.enable = true;
  };
  # Waydroid Info
  #   Run: `nix shell github:nix-community/NUR#repos.ataraxiasjel.waydroid-script -c sudo waydroid-script` to Fix Apps not Installing
  #  Select: libhoudini (Intel CPU) and gapps (Google Services)
}

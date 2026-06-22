{ config, pkgs, inputs, lib, ... }:
{
  services = {
    zerotierone = {
      enable = false;
      port = 9993;
      joinNetworks = [
        # Enter Network ID Here as String, e.g.: "YOURIDHERE".
      ];
    };
    yggdrasil = {
      enable = true;
      persistentKeys = false;
      settings = {
        Peers = [
          "tls://n.ygg.yt:443"
          "tls://b.ygg.yt:443"
          "tcp://s-fra-0.sergeysedoy97.ru:65533"
          "tcp://yggdrasil.su:62486"
          "tls://yggdrasil.su:62586"
          "tls://helium.avevad.com:1337"
          "tcp://ygg.mkg20001.io:80"
          "tcp://bode.theender.net:42069"
        ];
      };
    };
    i2pd = {
      enable = true;
      address = "127.0.0.1";
      proto = {
        # 127.0.0.1:4447 on SOCKS5 Firefox Network settings.
        # Leave HTTP and HTTPS Proxies blank.
        http.enable = true;
        socksProxy.enable = true;
        httpProxy.enable = true;
        sam.enable = true;
      };
    };
    tor = {
      enable = true;
      settings = {
        SOCKSPort = [
          {
            addr = "127.0.0.1";
            port = 9050;
            flags = [ "IsolateDestAddr" ];
          }
        ];
        ControlPort = 9051;
        TransPort = 9040;
        DNSPort = 5353;
        AutomapHostsOnResolve = true;
        # VirtualAddrNetworkIPv4 = "198.18.0.0/16";
      };
      client = {
        enable = true;
      };
      torsocks = {
        enable = true;
      };
    };
  };
  systemd.services = {
    i2pd.wantedBy = lib.mkForce [ ];
    tor.wantedBy = lib.mkForce [ ];
    yggdrasil.wantedBy = lib.mkForce [ ];
    zerotierone.wantedBy = lib.mkForce [ ];
  };
  #systemd.services.tor-netns = {
  #  description = "Tor-only Network Namespace";
  #  after = [ "network.target" ];
  #  wantedBy = [ "multi-user.target" ];
  #  serviceConfig = {
  #    Type = "oneshot";
  #    RemainAfterExit = true;
  #  };
  #  script = ''
  #    ${pkgs.iproute2}/bin/ip netns add tor-net || true
  #    if ! ${pkgs.iproute2}/bin/ip link show veth-tor-host >/dev/null 2>&1; then
  #       ${pkgs.iproute2}/bin/ip link add veth-tor-host type veth peer name veth-tor-ns
  #       ${pkgs.iproute2}/bin/ip link set veth-tor-ns netns tor-net || true
  #     fi
  #     ${pkgs.iproute2}/bin/ip addr add 10.0.0.1/24 dev veth-tor-host || true
  #     ${pkgs.iproute2}/bin/ip link set veth-tor-host up || true
  #     ${pkgs.iproute2}/bin/ip netns exec tor-net ${pkgs.iproute2}/bin/ip addr add 10.0.0.2/24 dev veth-tor-ns || true
  #     ${pkgs.iproute2}/bin/ip netns exec tor-net ${pkgs.iproute2}/bin/ip link set veth-tor-ns up || true
  #     ${pkgs.iproute2}/bin/ip netns exec tor-net ${pkgs.iproute2}/bin/ip link set lo up || true
  #     ${pkgs.iproute2}/bin/ip netns exec tor-net ${pkgs.iproute2}/bin/ip route add default via 10.0.0.1 || true
  #     iptables -t nat -C POSTROUTING -s 10.0.0.0/24 -j MASQUERADE 2>/dev/null || \
  #     iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -j MASQUERADE
  #   '';
  # };
}

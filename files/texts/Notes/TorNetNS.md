# Tor NetNS (Sub-Namespace)
```nix
systemd.services.tor-netns = {
  description = "Tor-only Network Namespace";
  after = [ "network.target" ];
  wantedBy = [ "multi-user.target" ];
  serviceConfig = {
    Type = "oneshot";
    RemainAfterExit = true;
  };
  script = ''
    ${pkgs.iproute2}/bin/ip netns add tor-net || true
    if ! ${pkgs.iproute2}/bin/ip link show veth-tor-host >/dev/null 2>&1; then
      ${pkgs.iproute2}/bin/ip link add veth-tor-host type veth peer name veth-tor-ns
      ${pkgs.iproute2}/bin/ip link set veth-tor-ns netns tor-net || true
    fi
    ${pkgs.iproute2}/bin/ip addr add 10.0.0.1/24 dev veth-tor-host || true
    ${pkgs.iproute2}/bin/ip link set veth-tor-host up || true
    ${pkgs.iproute2}/bin/ip netns exec tor-net ${pkgs.iproute2}/bin/ip addr add 10.0.0.2/24 dev veth-tor-ns || true
    ${pkgs.iproute2}/bin/ip netns exec tor-net ${pkgs.iproute2}/bin/ip link set veth-tor-ns up || true
    ${pkgs.iproute2}/bin/ip netns exec tor-net ${pkgs.iproute2}/bin/ip link set lo up || true
    ${pkgs.iproute2}/bin/ip netns exec tor-net ${pkgs.iproute2}/bin/ip route add default via 10.0.0.1 || true
    iptables -t nat -C POSTROUTING -s 10.0.0.0/24 -j MASQUERADE 2>/dev/null || \
    iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -j MASQUERADE
  '';
};
```

```nix
services.tor = {
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
    VirtualAddrNetworkIPv4 = "198.18.0.0/16";
  };
  client = {
    enable = true;
  };
  torsocks = {
    enable = true;
  };
};
```

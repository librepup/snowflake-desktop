{ config, pkgs, inputs, lib, ... }:
{
  services.zerotierone = {
    enable = false;
    port = 9993;
    joinNetworks = [
      "88c5b1f3394e489b"
      "b103a835d294de2a"
    ];
  };
  #systemd.services.zerotierone.wantedBy = lib.mkForce [ ];
  services = {
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
      client = {
        enable = true;
      };
      torsocks = {
        enable = true;
      };
    };
  };
  systemd.services.tor.wantedBy = lib.mkForce [ ];
  systemd.services.i2pd.wantedBy = lib.mkForce [ ];
  systemd.services.yggdrasil.wantedBy = lib.mkForce [ ];
}

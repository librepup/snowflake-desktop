{ config, pkgs, inputs, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    # enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      uniemoji
    ];
  };
}

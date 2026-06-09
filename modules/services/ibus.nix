{ config, pkgs, inputs, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      uniemoji
      typing-booster
    ];
  };
}

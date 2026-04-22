{ config, pkgs, lib, inputs, unstable, ... }:
{
  programs.keepassxc = {
    enable = true;
    settings = {
      Browser.Enabled = true;
      Config = {
        AutoSaveAfterEveryChange = true;
        AutoReloadOnChange = true;
        AutoSaveOnExit = true;
        MinimizeAfterUnlock = true;
      };
      GUI = {
        AdvancedSettings = true;
        ApplicationTheme = "dark";
        CompactMode = false;
        ShowTrayIcon = true;
        TrayIconAppearance = "colorful";
        HidePasswords = true;
        MinimizeToTray = true;
        MinimizeOnClose = true;
      };
      PasswordGenerator = {
        Length = "43";
        SpecialChars = false;
      };
      Security = {
        NoConfirmMoveEntryToRecycleBin = false;
      };
    };
  };
}

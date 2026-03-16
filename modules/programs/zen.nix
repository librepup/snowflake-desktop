{ config, inputs, pkgs, lib, ... }:
let
  extension = shortId: guid: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
    };
  };
  prefs = {
    "extensions.autoDisableScopes" = 0;
    "extensions.pocket.enabled" = false;
    "browser.compactmode.show" = true;
    "browser.tabs.inTitlebar" = 0;
    "browser.tabs.warnOnClose" = true;
    "browser.toolbars.bookmarks.visibility" = "always";
    "browser.translations.neverTranslateLanguages" = "de";
    "font.name.monospace.x-western" = "all-the-icons";
    "font.name.sans-serif.x-western" = "DejaVu Sans Mono";
    "font.name.serif.x-western" = "	DejaVu Sans Mono";
    "media.default_volume" = 0;
    "permissions.default.camera" = 2;
    "permissions.default.desktop-notification" = 2;
    "permissions.default.geo" = 2;
    "permissions.default.microphone" = 2;
    "sidebar.visibility" = "hide-sidebar";
    "ui.key.menuAccessKeyFocuses" = false;
    "zen.view.compact.enable-at-startup" = true;
    "zen.view.use-single-toolbar" = false;
    "zen.view.window.scheme" = 0;
    "zen.workspaces.continue-where-left-off" = true;
    "browser.proton.toolbar.version" = 3;
    "sidebar.old-sidebar.has-used" = true;
    "sidebar.position_start" = false;
    "theme-better_find_bar-enable_custom_background" = false;
    "theme.better_find_bar.custom_background" = "#112233";
    "theme.better_find_bar.hide_find_status" = false;
    "theme.better_find_bar.hide_found_matches" = false;
    "theme.better_find_bar.hide_highlight" = "not_hide";
    "theme.better_find_bar.hide_match_case" = "not_hide";
    "theme.better_find_bar.hide_match_diacritics" = "not_hide";
    "theme.better_find_bar.hide_whole_words" = "not_hide";
    "theme.better_find_bar.horizontal_position" = "default";
    "theme.better_find_bar.instant_animations" = false;
    "theme.better_find_bar.textbox_width" = 800;
    "theme.better_find_bar.transparent_background" = true;
    "theme.better_find_bar.vertical_position" = "default";
    "theme.nosidebarscrollbar.before125b" = false;
    "general.autoScroll" = true;
    "dom.forms.autocomplete.formautofill" = true;
    "browser.download.panel.shown" = true;
    "browser.download.useDownloadDir" = false;
    "browser.engagement.ctrlTab.has-used" = true;
    "browser.engagement.downloads-button.has-used" = true;
    "browser.tabs.closeWindowWithLastTab" = true;
    "browser.uidensity" = 1;
    "extensions.ui.dictionary.hidden" = true;
    "extensions.ui.extension.hidden" = false;
    "extensions.ui.lastCategory" = "addons://list/extension";
    "extensions.ui.locale.hidden" = true;
    "extensions.ui.mlmodel.hidden" = true;
    "extensions.ui.sitepermission.hidden" = true;
    "extensions.webcompat.enable_interventions" = true;
    "extensions.webcompat.enable_shims" = true;
    "intl.locale.requested" = "en-US,de,en-GB";
    "layout.spellcheckDefault" = 0;
    "media.autoplay.default" = 2;
    "zen.glance.activation-method" = "shift";
    "zen.view.compact.hide-tabbar" = true;
    "zen.view.compact.hide-toolbar" = false;
    "zen.view.compact.show-sidebar-and-toolbar-on-hover" = false;

  };
  extensions = [
    (extension "adnauseam" "adnauseam@rednoise.org")
    (extension "auto-referer" "{f6a3df9c-c297-46a1-bb84-d9cb00b314f0}")
    (extension "auto-tab-groups" "{442789cf-4ff6-4a85-bf5b-53aa3282f1a2}")
    (extension "clearurls" "{74145f27-f039-47ce-a470-a662b129930a}")
    (extension "consent-o-matic" "gdpr@cavi.au.dk")
    (extension "decentraleyes" "jid1-BoFifL9Vbdl2zQ@jetpack")
    (extension "dont-track-me-google1" "dont-track-me-google@robwu.nl")
    (extension "facebook-container" "@contain-facebook")
    (extension "google-sign-in-popup-blocker" "{ce25b613-ecd1-47e0-9492-c0260efb633c}")
    (extension "hide-scrollbars" "{a250ed19-05b9-4486-b2c3-535044766b8c}")
    (extension "image-forcer" "img-forcer@zipdox.net")
    (extension "librezam" "Librezam@Librezam")
    (extension "load-reddit-images-directly" "{4c421bb7-c1de-4dc6-80c7-ce8625e34d24}")
    (extension "old-twitter-layout-2024" "oldtwitter@dimden.dev-reupload")
    (extension "privacy-badger17" "jid1-MnnxcxisBPnSXQ@jetpack")
    (extension "reddit-nsfw-spoiler-unblur" "redditNsfwShow@zen")
    (extension "shinigami-eyes" "shinigamieyes@shinigamieyes")
    (extension "show-video-controls-firefox" "showvidcontrolsbydefault@knighto.codeberg.org")
    (extension "togglefonts" "{e7625f06-e252-479d-ac7a-db68aeaff2cb}")
    (extension "instagram-video-control" "{a831defa-a6c9-4ca9-9593-9ccaf98462d9}")
    (extension "video-downloadhelper" "{b9db16a4-6edc-47ec-a1f4-b86292ed211d}")
    (extension "violentmonkey" "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}")
  ];
in
{
  environment.systemPackages = [
    (pkgs.wrapFirefox
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped
    {
      binaryName = "zen-declarative";
      extraPrefs = lib.concatLines (
        lib.mapAttrsToList (
          name: value: ''lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});''
        ) prefs
      );
      extraPolicies = {
        DisableTelemetry = true;
        ExtensionSettings = builtins.listToAttrs extensions;
        SearchEngines = {
          Default = "DuckDuckGo";
          Add = [
            {
              Name = "Nix Package Search";
              URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
              IconURL = "https://wiki.nixos.org/favicon.ico";
              Alias = "search";
            }
            {
              Name = "Nix Options Search";
              URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
              IconURL = "https://wiki.nixos.org/favicon.ico";
              Alias = "options";
            }
            {
              Name = "YT";
              URLTemplate = "https://www.youtube.com/results?search_query={searchTerms}";
              IconURL = "https://youtube.com/favicon.ico";
              Alias = "yt";
            }
            {
              Name = "MyNixOS";
              URLTemplate = "https://mynixos.com/search?q={searchTerms}";
              IconURL = "https://mynixos.com/favicon.ico";
              Alias = "mynix";
            }
            {
              Name = "Proton";
              URLTemplate = "https://www.protondb.com/search?q={searchTerms}";
              IconURL = "https://www.protondb.com/favicon.ico";
              Alias = "proton";
            }
          ];
        };
      };
    })
  ];
}

{config, ...}: let
in {
  programs = {
        firefox = {
          enable = false;
          profiles = {
            ${config.name} = {
              isDefault = true;
              search = {
                default = "ddg";
                force = true;
                privateDefault = "ddg";
              };
              settings = {
                "browser.aboutConfig.showWarning" = false;
                "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
                "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
                "browser.newtabpage.activity-stream.feeds.snippets" = false;
                "browser.newtabpage.activity-stream.feeds.topsites" = false;
                "browser.newtabpage.activity-stream.showSearch" = false;
                "browser.sessionstore.resume_session_once" = true;
                "browser.shell.checkDefaultBrowser" = false;
                "browser.toolbars.bookmarks.visibility" = "never";
                "browser.translations.automaticallyPopup" = false;
                "browser.warnOnQuit" = false;
                "devtools.theme" = "dark";
                "full-screen-api.transition-duration.enter" = "0 0";
                "full-screen-api.transition-duration.leave" = "0 0";
                "full-screen-api.transition.timeout" = 0;
                "general.config.filename" = "mozilla.cfg";
                "general.config.obscure_value" = 0;
                "gfx.webrender.all" = true;
                "media.ffmpeg.low-latency.enabled" = true;
                "media.ffmpeg.vaapi.enabled" = true;
                "media.ffvpx.enabled" = false;
                "media.navigator.mediadatadecoder_vpx_enabled" = true;
                "media.rdd-vpx.enabled" = false;
                "signon.autofillForms" = false;
                "signon.generation.enabled" = false;
                "signon.rememberSignons" = false;
                "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
                "ui.prefersReducedMotion" = 1;
          };
          policies = {
            CaptivePortal = false;
            DisableAppUpdate = true;
            DisableFirefoxAccounts = true;
            DisableFirefoxStudies = true;
            DisablePocket = true;
            DisableSetDesktopBackground = true;
            DisableTelemetry = true;
            FirefoxHome = {
              Pocket = false;
              Snippets = false;
            };
            ShowHomeButton = false;
            UserMessaging = {
              ExtensionRecommendations = false;
              SkipOnboarding = true;
            };
          };
        };
      };
    };
  };
}

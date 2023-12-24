{ ... }:
{
  programs.firefox = {
    enable = true;

    profiles = {
      default = {
        id = 0;
        settings = {
          "media.ffmpeg.vaapi.enabled" = true;
          "media.ffvpx.enabled" = false;
          "media.av1.enabled" = false;
          "gfx.webrender.all" = true;
        };
      };
    };
  };
}

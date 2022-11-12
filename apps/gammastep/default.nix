{config, ...}: {
  services.gammastep = {
    enable = true;
    latitude = 39.9612;
    longitude = -82.9988;
    temperature = {
      day = 6500;
      night = 3000;
    };
  };
}

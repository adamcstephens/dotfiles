{ ... }:
{
  services.pantalaimon = {
    enable = true;
    settings = {
      Default = { };
      local-matrix = {
        Homeserver = "https://matrix.robins.wtf";
      };
    };
  };
}

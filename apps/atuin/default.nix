{ ... }:
{
  programs.atuin = {
    enable = true;

    settings = {
      enter_accept = false;
      update_check = false;
    };
  };
}

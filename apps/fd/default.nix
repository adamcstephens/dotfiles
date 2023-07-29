{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    (inputs.wrapper-manager.lib.build {
      inherit pkgs;
      modules = [
        ({pkgs, ...}: {
          wrappers.fd = {
            basePackage = pkgs.fd;
            flags = [
              "--ignore-case"
              "--hidden"
              "--follow"
            ];
          };
        })
      ];
    })
  ];
}

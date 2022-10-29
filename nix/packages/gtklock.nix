{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs,
  pam,
  scdoc,
  gtk3,
  pkg-config,
  gtk-layer-shell,
  wayland,
  glib,
}:
stdenv.mkDerivation rec {
  pname = "gtklock";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "jovanlanik";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-W+GyeGxlfp1YZtSFEZYXuHmvTVZ8mU1oBcsrWN1yvjU=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    scdoc
    pkg-config
    wayland
  ];
  buildInputs = [
    glib
    gtk-layer-shell
    gtk3
    pam
  ];

  postPatch = ''
    substituteInPlace makefile --replace glib-compile-resources "${lib.getDev glib}/bin/glib-compile-resources"
  '';

  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  meta = with lib; {
    description = "GTK-based lockscreen for Wayland";
    longDescription = ''
      Important note: for gtklock to work you need to set "security.pam.services.gtklock = {};" manually.
    ''; # Following  nixpkgs/pkgs/applications/window-managers/sway/lock.nix
    homepage = "https://github.com/jovanlanik/gtklock";
    license = licenses.gpl3;
    maintainers = with maintainers; [dit7ya];
  };
}

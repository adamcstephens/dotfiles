{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "xgettext-go";
  version = "2.57.1";

  src = fetchFromGitHub {
    owner = "snapcore";
    repo = "snapd";
    rev = "refs/tags/${version}";
    hash = "sha256-icPEvK8jHuJO38q1n4sabWvdgt9tB5b5Lh5/QYjRBBQ=";
  };

  vendorHash = "sha256-e1QFZIleBVyNB0iPecfrPOg829EYD7d3KMHIrOYnA74=";

  subPackages = [ "i18n/xgettext-go" ];

  CGO_ENABLED = 0;
}

{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "rush-parallel";
  version = "0.5.0";

  CGO_ENABLED = 0;

  src = fetchFromGitHub {
    owner = "shenwei356";
    repo = "rush";
    rev = "v${version}";
    hash = "sha256-vN2Jv77H4gnM3VwPfwQRA3FQY6atsjAkZtVsRZjQNZE=";
  };

  vendorSha256 = "sha256-bsQ9YZT66kaypAbUJYPdg4ZhviAlE7NL2BuQkdXuDlA=";

  meta = with lib; {
    description = " A cross-platform command-line tool for executing jobs in parallel ";
    homepage = "https://github.com/shenwei356/rush";
    license = licenses.mit;
    maintainers = with maintainers; [adamcstephens];
  };
}

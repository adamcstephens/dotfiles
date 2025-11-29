# original credit: https://github.com/weriomat/nixos-config/blob/65e904ad678b2e0c2fdda135531750ee74e3988d/pkgs/apple-color-emoji/default.nix#L18
{
  lib,
  stdenv,

  fetchFromGitHub,
  imagemagick,
  nototools,
  pngquant,
  python312Packages,
  which,
  zopfli,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "apple-emoji-linux";
  version = "18.4";

  src = fetchFromGitHub {
    owner = "samuelngs";
    repo = "apple-emoji-linux";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-Cw4zl9Trb+yVjVajdG2KxG/pozti6IHZB2nR89ZUExM=";
  };

  buildInputs = [
    imagemagick
    nototools
    pngquant
    python312Packages.fonttools
    which
    zopfli
  ];

  buildPhase = ''
    make -j
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truefont
    install -Dm644 AppleColorEmoji.ttf -t $out/share/fonts/truefont

    runHook postInstall
  '';

  meta = with lib; {
    description = "Brings Apple's vibrant emojis to your Linux experience";
    homepage = "https://github.com/samuelngs/apple-emoji-linux";
    license = licenses.asl20;
    maintainers = with maintainers; [ adamcstephens ];
    mainProgram = "apple-emoji-linux";
    platforms = platforms.all;
  };
})

{
  lib,
  buildGoModule,
  makeWrapper,
  fetchFromGitHub,
  ffmpeg,
  yt-dlp,
}:
buildGoModule {
  pname = "ydls";
  version = "unstable-2023-11-04";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "ydls";
    rev = "9a9804cfcf2c60e7b16dbb632621507a73533859";
    hash = "sha256-wF5n1MbiZVMVcI9GHChJNNlvwi8cLsl5rFwQIgTvcpg=";
  };

  vendorHash = "sha256-4H862ViDhg0hFeeHE4uidNCocc4nGC//2CSWkKlH63U=";

  ldflags = [
    "-s"
    "-w"
  ];

  buildInputs = [ makeWrapper ];

  # tests need to find the config
  CONFIG = "/build/source/ydls.json";

  postInstall = ''
    wrapProgram $out/bin/ydls --prefix PATH : ${
      lib.makeBinPath [
        ffmpeg
        yt-dlp
      ]
    }
    install -D -m 0444 ydls.json $out/share/ydls/ydls.json
  '';

  meta = with lib; {
    description = "Youtube-dl HTTP download and transcode service";
    homepage = "https://github.com/wader/ydls";
    license = licenses.mit;
    maintainers = with maintainers; [ adamcstephens ];
    mainProgram = "ydls";
  };
}

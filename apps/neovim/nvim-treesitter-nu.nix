{ buildGrammar, src, ... }:
buildGrammar {
  language = "nu";
  version = "0.0.0+rev=${builtins.substring 0 7 src.revision}";
  inherit src;
  meta.homepage = "";
}

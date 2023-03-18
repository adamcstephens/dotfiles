{
  homeConfigurations,
  python3Minimal,
  stdenv,
  writeScriptBin,
}:
writeScriptBin "home-profile-selector" ''
  #!${python3Minimal}/bin/python3

  from socket import gethostname

  hm_profiles = [${builtins.concatStringsSep "," (map (x: "'${x}'") homeConfigurations)}]
  hostname = gethostname()

  if hostname in hm_profiles:
      print(hostname)
  else:
      print("${stdenv.hostPlatform.system}")
''

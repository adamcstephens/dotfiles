{
  homeConfigurations,
  python3Minimal,
  stdenv,
  writeScriptBin,
}:
writeScriptBin "home-profile-selector" ''
  #!${python3Minimal}/bin/python3

  import json
  from os.path import expanduser, exists
  from socket import gethostname

  hm_profiles = [${builtins.concatStringsSep "," (map (x: "'${x}'") homeConfigurations)}]

  config_path = expanduser("~/.config/dotfiles/config.json")
  if exists(config_path):
      try:
          with open(config_path) as f:
              config = json.load(f)
              if "home_profile" in config:
                  print(config["home_profile"])
                  exit(0)
      except (json.JSONDecodeError, IOError):
          pass

  hostname = gethostname()
  if hostname in hm_profiles:
      print(hostname)
  else:
      print("${stdenv.hostPlatform.system}")
''

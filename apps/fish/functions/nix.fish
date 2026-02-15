function nix --wraps nix
    command nix --print-build-logs $argv
end

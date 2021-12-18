function y2j
    curl --location $argv[1] | yq e -o=j
end

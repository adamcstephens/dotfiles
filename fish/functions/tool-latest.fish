function tool-latest
    if [ (count $argv) = 0 ]
        echo "Must pass tool name"
        return 1
    end

    asdf install $argv[1] latest

    asdf local $argv[1] latest
end

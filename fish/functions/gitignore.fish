function gitignore
    [ (count $argv) = 0 ] && echo "missing language to ignore" && return 1

    wget --output-document=.gitignore.tmp "https://raw.githubusercontent.com/github/gitignore/master/$argv[1].gitignore"

    if [ $status = 0 ]
        if [ -e .gitignore ]
            cat .gitignore.tmp >>.gitignore
        else
            mv -v .gitignore.tmp .gitignore
        end
    end

    rm -f .gitignore.tmp
end

function pwgen
    if [ (count $argv) = 0 ]
        set pwargs 20 12
    else
        set pwargs $argv
    end
    command pwgen -csn1 $pwargs
end

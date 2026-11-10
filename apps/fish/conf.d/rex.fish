status is-interactive; and begin
    if command --query rex
        rex completion fish | source
    end
end

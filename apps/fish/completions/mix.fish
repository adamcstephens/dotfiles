# @halostatue/fish-elixir/completions/mix.fish:v2.0.4
# https://raw.githubusercontent.com/halostatue/fish-elixir/refs/heads/main/completions/mix.fish

function _halostatue_fish_elixir_mix_needs_command
    set --function cmd (commandline -opc)
    test (count $cmd) -eq 1 -a $cmd[1] = mix
end

function _halostatue_fish_elixir_mix_tasks
    mix help 2>/dev/null | string replace -f -r '^mix\s+(\S+)\s+#\s+(.*)' '$1\t$2'
end

complete -c mix -n _halostatue_fish_elixir_mix_needs_command -f -a '(_halostatue_fish_elixir_mix_tasks)'

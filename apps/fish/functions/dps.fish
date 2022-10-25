function dps --wraps=docker\ ps\ --format\ \"table\ \{\{.Names\}\}\\t\{\{.Status\}\}\\t\{\{.Ports\}\}\\t\{\{.Command\}\}\\t\{\{.Image\}\}\" --description alias\ dps=docker\ ps\ --format\ \"table\ \{\{.Names\}\}\\t\{\{.Status\}\}\\t\{\{.Ports\}\}\\t\{\{.Command\}\}\\t\{\{.Image\}\}\"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Command}}\t{{.Image}}" $argv
end

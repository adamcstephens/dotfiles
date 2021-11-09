function dclf --wraps='docker-compose logs --tail=100 -f' --description 'alias dclf=docker-compose logs --tail=100 -f'
    docker-compose logs --tail=100 -f $argv
end

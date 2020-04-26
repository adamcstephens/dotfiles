# docker
alias di='docker images '
alias dk='docker kill '
alias drm='docker rm '
alias drmi='docker rmi '
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Command}}\t{{.Image}}"'
function dsh {
  [ -z $1 ] && echo "needs image to run." && return 2
  runimg="$1"
  shift
  if [ -z $1 ]
  then
    runcmd="/bin/bash"
  else
    runcmd="$@"
  fi
  docker run -t -i --rm=true $runimg $runcmd
}
alias docker_rm_all="docker ps -a | grep -vi container | awk '{print $1}' | xargs docker rm -f"

alias dcgc="docker run -ti -v /var/run/docker.sock:/var/run/docker.sock yelp/docker-custodian dcgc "

alias dc="docker-compose "
alias dclf="docker-compose logs --tail=100 -f"

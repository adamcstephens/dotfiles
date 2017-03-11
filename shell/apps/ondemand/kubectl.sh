function dksh {
  [ -z $1 ] && echo "needs image to run." && return 2
  runimg="$1"
  shift
  if [ -z $1 ]
  then
    runcmd="/bin/bash -l"
  else
    runcmd="$@"
  fi
  kubectl run dksh-image --rm --tty -i --image $runimg -- $runcmd
}

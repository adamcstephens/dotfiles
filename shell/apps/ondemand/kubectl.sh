function dksh {
  [ -z $1 ] && echo "needs image to run." && return 2
  runimg="$1"
  shift
  if [ -z $1 ]
  then
    runcmd="/bin/bash"
  else
    runcmd="$@"
  fi
  kubectl run -i --tty dksh-image --rm --image=$runimg --restart=Never --namespace=default -- $runcmd
}

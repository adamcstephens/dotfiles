OS=$(uname)
case $OS in
  'Linux')
    if which pacman &> /dev/null
    then
      export DIST='arch' 
    elif which dpkg &> /dev/null
    then
      export DIST='debian'
    elif which rpm &> /dev/null
    then
      export DIST='redhat'
    elif grep CoreOS /etc/lsb-release &> /dev/null
    then
      export DIST='coreos'
    fi
    ;;
  'Darwin')
    export DIST=$OS
    ;;
  'FreeBSD')
    export DIST=$OS
    ;;
  * )
    echo "Failed to detect OS in os_detect.sh"
    ;;
esac

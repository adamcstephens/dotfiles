OS=$(uname)
case $OS in
  'Linux')
    if [ -e /etc/arch-release ]
    then
      export DIST='arch' 
    elif [ -e /etc/debian_version ]
    then
      export DIST='debian'
    elif [ -e /etc/redhat-release ]
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
  'OpenBSD')
    export DIST=$OS
    alias pfe='sudo vim /etc/pf.conf'
    alias pfr='sudo pfctl -nf /etc/pf.conf && sudo pfctl -f /etc/pf.conf'
    alias pfl='sudo pfctl -sr'
    alias pflog='sudo tcpdump -n -e -ttt -i pflog0'
    ;;
  'AIX')
    export DIST=$OS
    # stick this here for lack of a better place
    export PATH="/opt/freeware/bin:/opt/freeware/sbin:$PATH"
    ;;
  * )
    echo "Failed to detect OS in os_detect.sh"
    ;;
esac

if which pacman > /dev/null 2>&1
then
  export DIST='arch' 
elif which dpkg >/dev/null 2>&1
then
  export DIST='debian'
elif which rpm > /dev/null 2>&1
then
  export DIST='redhat'
fi


function drh_gd_release { 
  filelist=`git status --short | grep $1` 
  modified=`echo $filelist | grep '^ M' | awk '{print $2}'`
  renamed=`echo $filelist | grep '^R'`
  deleted=`echo $filelist | grep '^D'`
  echo $modified | xargs git diff
  echo
  echo $deleted
  echo $renamed
}
function drh_ga_release { 
  filelist=`git status --short | grep $1` 
  modified=`echo $filelist | grep '^ M' | awk '{print $2}'`
  newfiles=`echo $filelist | grep '^??' | awk '{print $2}'`
  renamed=`echo $filelist | grep '^R' | awk '{print $4}'`
  deleted=`echo $filelist | grep '^ D' | awk '{print $2}'`
  echo $modified | xargs git add
  echo $newfiles | xargs git add
  echo $deleted | xargs git rm
  echo $renamed | xargs git add
  git status --short
}

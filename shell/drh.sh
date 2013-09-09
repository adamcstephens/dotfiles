function drh_gd_release { gss | awk '{print $2}' | grep $1 | xargs git diff; }
function drh_ga_release { gss | awk '{print $2}' | grep $1 | xargs git add; }

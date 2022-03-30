function m4b-convert
  docker run -it --rm -u nobody -v /srv/media:/srv/media m4b-tool merge --jobs=16 --output-file="$PWD/$1.m4b" "$PWD/$1"
end

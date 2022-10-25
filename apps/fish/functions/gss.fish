function gss --wraps='git status --short' --description 'alias gss=git status --short'
  git status --short $argv; 
end

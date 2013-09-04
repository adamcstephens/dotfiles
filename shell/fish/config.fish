if status --is-login
	for p in /usr/bin /usr/local/bin ~/bin
		if test -d $p
			set PATH $p $PATH
		end
	end
end

set fish_greeting ""
set -x CLICOLOR 1

function parse_git_branch
	sh -c 'git branch --no-color 2> /dev/null' | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
end

function parse_git_tag
	git describe --tags --always ^/dev/null
end

function parse_git_tag_or_branch
	if [ (parse_git_branch) != "(no branch)" ]
        	parse_git_branch
	else
        	parse_git_tag
	end
end

function git_parse_ahead_of_remote
	git status ^/dev/null | grep 'Your branch is ahead of' | sed -e 's/# Your branch is ahead of .* by \(.*\) commit.*/\1/g'
end

function is_git
	git status >/dev/null ^&1	
	return $status
end


function fish_prompt -d "Write out the prompt"
	printf '%s%s@%s%s' (set_color brown) (whoami) (hostname|cut -d . -f 1) (set_color normal) 

	# Color writeable dirs green, read-only dirs red
	if test -w "."
		printf ' %s%s' (set_color green) (prompt_pwd)
	else
		printf ' %s%s' (set_color red) (prompt_pwd)
	end

        # Print subversion tag or branch
        
	# Print git tag or branch
	if is_git
		printf ' %s%s/%s' (set_color normal) (set_color blue) (parse_git_tag_or_branch)
		set git_ahead_of_remote (git_parse_ahead_of_remote)
		if [ -n "$git_ahead_of_remote" -a "$git_ahead_of_remote" != "0" ]
			printf ' +%s' (git_parse_ahead_of_remote)
		end
	end
	printf '%s> ' (set_color normal)
end


#bind \cr "rake"

## Load custom settings for current hostname
#set HOST_SPECIFIC_FILE ~/.config/fish/(hostname).fish
#if test -f $HOST_SPECIFIC_FILE
#   . $HOST_SPECIFIC_FILE
#else 
#   echo Creating host specific file: $HOST_SPECIFIC_FILE
#   touch $HOST_SPECIFIC_FILE
#end
#   
## Load custom settings for current user
#set USER_SPECIFIC_FILE ~/.config/fish/(whoami).fish
#if test -f $USER_SPECIFIC_FILE
#   . $USER_SPECIFIC_FILE
#else
#   echo Creating user specific file: $USER_SPECIFIC_FILE
#   touch $USER_SPECIFIC_FILE
#end
#
## Load custom settings for current OS
#set PLATFORM_SPECIFIC_FILE ~/.config/fish/(uname -s).fish
#if test -f $PLATFORM_SPECIFIC_FILE
#   . $PLATFORM_SPECIFIC_FILE
#else
#   echo Creating platform specific file: $PLATFORM_SPECIFIC_FILE
#   touch $PLATFORM_SPECIFIC_FILE
#end  

if [ -d $HOME/.rbenv/bin ]
  set -x PATH $HOME/.rbenv/bin $PATH
end
if [ -d $HOME/.rbenv/shims ]
  set -x PATH $HOME/.rbenv/shims $PATH
end
if which rbenv > /dev/null 2>&1
  rbenv rehash >/dev/null ^&1
end

if [ -d $HOME/.pyenv ]
  set -x PATH "$HOME/.pyenv/shims" $PATH
end
if which pyenv > /dev/null 2>&1
  pyenv rehash >/dev/null ^&1
end

if [ -d $HOME/projects/ansible ]
  set HACKING_DIR $HOME/projects/ansible
  set FULL_PATH (python -c "import os; print(os.path.realpath('$HACKING_DIR'))")
  set -x ANSIBLE_HOME $FULL_PATH

  set PREFIX_PYTHONPATH "$ANSIBLE_HOME/lib"
  set PREFIX_PATH "$ANSIBLE_HOME/bin"
  set PREFIX_MANPATH "$ANSIBLE_HOME/docs/man"

  set -x PYTHONPATH $PREFIX_PYTHONPATH $PYTHONPATH
  set -x PATH $PREFIX_PATH $PATH
  set -x ANSIBLE_LIBRARY "$ANSIBLE_HOME/library"
end 


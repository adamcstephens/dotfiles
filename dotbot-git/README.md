[dotbot_repo]: https://github.com/anishathalye/dotbot

## Dotbot ```git``` Plugin

Plugin for [Dotbot][dotbot_repo], that adds ```git``` directive, which allows you to clone or pull git repositories. 

## Installation

1. Simply add this repo as a submodule of your dotfiles repository:
```
git submodule add https://github.com/DrDynamic/dotbot-git.git
```

2. Pass this folder (or directly git.py file) path with corresponding flag to your [Dotbot][dotbot_repo] script:
  - ```-p /path/to/file/git.py```

  or

 - ```--plugin-dir /pato/to/plugin/folder```

## Requirements

This plugin needs git 2.22 or later to be installes.

Also please note, that this plugin clones repositories direcly into the given path. 
No subfolders are created! 

## Properties

| Name | Description | Required |
| --- | --- | --- |
| url | The URL to the remote repository | Required | 
| branch | The branch to checkout after clone (or pull) | optional |
| commit | The commit to checkout after clone (or pull) | optional |
| method | Either clone, pull or clone-or-pull (see **Supported methods**) | optional |
| description | The description of the Repository (only for log output) | optional |

### Supported methods

| Method | Description |
| --- | --- |
| clone | Just clone the repository and checkout the configured branch / commit. Ignore that entry if that is alredy done.|
| pull | Just pull the existing directory. Failes if the directory doesn't exist or isnt a git repository |
| clone-or-pull | DEFAULT - Clones the repository if it doesnt exist or pulls changes if it does. |

## Supported task variants



```yaml
...
- git: 
    '/local/path/to/clone/to':
       url: <url to repository> 
       branch: <name of the branch>
       commit: <commit hash>
       method: <clone|pull|clone-or-pull> 
       description: <name of the repository or something like that>
    ...
...
```

## Usage

### Example config
```yaml
...
- git:
    '~/.oh-my-zsh/custom/plugins/zsh-autosuggestions':
        url: 'https://github.com/zsh-users/zsh-autosuggestions'
        description: 'oh my zsh - autosuggestions'
    '~/.oh-my-zsh/custom/themes/powerlevel10k':
        url: 'https://github.com/romkatv/powerlevel10k.git'
        description: 'oh my zsh - powerlevel10k'
    ...
...
```

### Execution
```bash
"~/.dotfiles/bin/dotbot" -d "~/.dotfiles" -c "~/.dotfiles/packages.yaml" -p "~/.dotfiles/plugins/dotbot-git/git.py"
```

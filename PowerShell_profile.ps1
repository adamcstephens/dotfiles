Invoke-Expression (&starship init powershell)
$ENV:STARSHIP_CONFIG = "$HOME\.dotfiles\starship.toml"

$SSHPath = (Get-Command -Name 'ssh.exe').Source
$ENV:GIT_SSH = $SSHPath

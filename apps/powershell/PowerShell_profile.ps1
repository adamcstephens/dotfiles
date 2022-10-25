Invoke-Expression (&starship init powershell)
$ENV:STARSHIP_CONFIG = "$HOME\.dotfiles\starship.toml"

$SSHPath = (Get-Command -Name 'ssh.exe').Source
$ENV:GIT_SSH = $SSHPath

Set-PSReadlineKeyHandler -Key ctrl+d -Function ViExit

Set-PSReadLineOption -PredictionSource history
# Set-PSReadLineOption -Colors @{ InlinePrediction = '#000055'}
Set-PSReadLineKeyHandler -chord Ctrl+e -function ForwardChar

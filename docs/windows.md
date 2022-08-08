# windows

## bootstrap

```
winget install Git.Git
# add C:\Program Files\Git\usr\bin to path
# download/unzip https://github.com/go-task/task/releases
mkdir -p 'C:\Program Files\go-task\bin'
cd 'C:\Program Files\go-task\bin'
cp C:\Users\Adam\Downloads\task_windows_amd64\task.exe .
[Environment]::SetEnvironmentVariable("PATH", $Env:PATH + ";C:\Program Files\go-task\bin;C:\Program Files\Git\usr\bin", [EnvironmentVariableTarget]::Machine)
```

## group policies

Computer Configuration > Administrative Templates > Windows Components

> Windows Update > Windows Update for Business
> Manage preview builds
> Select when Preview Builds and Feature Updates are received.
> Data Collection and Preview Builds
> Allow Telemetry

## features

```ps1
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
wsl --set-default-version 2
```

Visit [kernel page](https://aka.ms/wsl2kernel) and download kernel

## packages

```ps1
winget install 1password
winget install git
winget install mozilla.firefox
winget install sonos.s1controller
winget install 'telegram desktop'
winget install 'visual studio code'
winget install Microsoft.WindowsTerminalPreview
```

## jetbrains mono

[official](https://download.jetbrains.com/fonts/JetBrainsMono-1.0.0.zip?fromGitHub)
[nerd-fonts](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip)

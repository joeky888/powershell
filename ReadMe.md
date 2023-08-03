![PS](https://i.imgur.com/gjjWnCi.png)

Features
=====
* No plugins, just one file
* Fast
* Default startup directory is Desktop
* Git current branch
* Zsh-like Tab-Completion
* Powershell ISE supported
* Depends on Powershell >= 2.0 (Windows XP+)
* UTF-8

The code is under Public-domain licence.

## Install for Windows 8+

Copy all and paste to powershell, then press Enter

```sh
# Install this config, Open powershell (as administrator)
Set-ExecutionPolicy RemoteSigned -Force
New-Item -ItemType file -Force -Path $Profile.CurrentUserAllHosts
Invoke-WebRequest https://raw.githubusercontent.com/joeky888/powershell/master/profile.ps1 -o $Profile.CurrentUserAllHosts
Unblock-File $Profile.CurrentUserAllHosts
```

## Install for Windows XP and Windows 7

Copy all and paste to powershell, then press Enter

```sh
# Open powershell (as administrator)
Set-ExecutionPolicy RemoteSigned -Force
New-Item -ItemType file -Force -Path $Profile.CurrentUserAllHosts
$url = "https://raw.githubusercontent.com/joeky888/powershell/master/profile.ps1"
$path = $Profile.CurrentUserAllHosts

if(!(Split-Path -parent $path) -or !(Test-Path -pathType Container (Split-Path -parent $path))) {
  $targetFile = Join-Path $pwd (Split-Path -leaf $path)
}

(New-Object System.Net.WebClient).DownloadFile($url, $path)
```

#### Install theme

See https://github.com/joeky888/MonoKombat.cmd

#### Install chocolatey and chocolatey packages (Recommended)

```sh
# Open powershell (as administrator)
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install 7zip git miniconda miniconda3 -y
```

#### Install scoop (Recommended)

```sh
Set-ExecutionPolicy Bypass -Scope Process -Force; iwr -useb get.scoop.sh | iex
scoop install neovim wezterm ripgrep fd
```

#### Install Powershell modules (Recommended)

```sh
# Open powershell (as administrator)
PowerShellGet\Install-Module -Scope CurrentUser posh-git
PowerShellGet\Install-Module -Scope CurrentUser posh-docker
```

#### Install either starship or oh-my-posh (Recommended)

```ps1
scoop install starship
# or
scoop install oh-my-posh
```

| Keys           | Action                                   | Description                    |
| -------------- | ---------------------------------------- | ------------------------------ |
| Ctrl A         | Move cursor to the beginning of the line | Just like macOS and terminals  |
| Ctrl E         | Move cursor to the end of the line       | Just like macOS and terminals  |
| Ctrl C         | Copy/Cancel command                      |                                |
| Ctrl X         | Cut                                      |                                |
| Ctrl V         | Paste with url decoding                  | Same with Ctrl-Shift-V         |
| Ctrl D         | Exit                                     |                                |
| Ctrl K         | Kill whole line                          | Just like nano                 |
| Ctrl F         | Run current command forever              |                                |
| Ctrl R         | Search the history backward              | Just like bash                 |
| Ctrl G         | Select all                               |                                |
| Ctrl T         | New Window                               | Open new tab in Powershell ISE |
| Ctrl Z         | Undo                                     |                                |
| Ctrl Y         | Redo                                     |                                |
| Ctrl S         | Search the history forward               | Just like Emacs                |
| Ctrl W         | Close tab                                | Powershell ISE only            |
| Ctrl L         | Clear                                    |                                |
| Ctrl O         | Open file explorer here                  |                                |
| Ctrl →         | Next word                                |                                |
| Ctrl ←         | Previous word                            |                                |
| Shift →        | Select one character right               |                                |
| Shift ←        | Select one character left                |                                |
| ↑              | Previous command in history              |                                |
| ↓              | Next command in history                  |                                |
| Ctrl Backspace | Delete a word backward                   |                                |
| Shift+Insert   | Paste                                    | Paste raw data from clipboard  |

## Extra commands

| Command        | Action                                                  | Description              |
| -------------- | ------------------------------------------------------- | ------------------------ |
| upgradeProfile | Upgrade [this file](profile.ps1)                        |                          |
| upgradeChoco   | Upgrade all installed choco packages                    |                          |
| upgradeModule  | Upgrade all installed Modules from Powershell Gallery   |                          |
| upgradeScoop   | Upgrade all installed Scoop packages                    |                          |
| upgradeConda   | Upgrade all Anaconda/Miniconda packages                 |                          |
| upgradeConda2  | Upgrade all Miniconda2 packages                         | choco install miniconda2 |
| upgradeConda3  | Upgrade all Miniconda3 packages                         | choco install miniconda3 |
| upgradePip     | Upgrade all pip packages                                |                          |
| upgradePip2    | Upgrade all pip2 packages                               | choco install miniconda2 |
| upgradePip3    | Upgrade all pip3 packages                               | choco install miniconda3 |
| upgradeNpm     | Upgrade all npm global packages                         | choco install nodejs     |
| upgradeVimrc   | Upgrade [vimrc](https://github.com/joeky888/vimrc) file |                          |
| python2        | C:\ProgramData\Miniconda2\python.exe                    | choco install miniconda2 |
| python3        | C:\ProgramData\Miniconda3\python.exe                    | choco install miniconda3 |
| conda2         | C:\ProgramData\Miniconda2\Scripts\conda.exe             | choco install miniconda2 |
| conda3         | C:\ProgramData\Miniconda3\Scripts\conda.exe             | choco install miniconda3 |
| pip2           | C:\ProgramData\Miniconda2\Scripts\pip.exe               | choco install miniconda2 |
| pip3           | C:\ProgramData\Miniconda3\Scripts\pip.exe               | choco install miniconda3 |
| Find-RegKey    | Find a key in regedit recursively                       | Find-RegKey "some key"   |
| Find-RegValue  | Find a value in regedit recursively                     | Find-RegKey "some value" |

## Extra aliases

| Command       | Action                                                                   | Example                                                           |
| ------------- | ------------------------------------------------------------------------ | ----------------------------------------------------------------- |
| ..            | `cd ..`                                                                  |                                                                   |
| ...           | `cd ..\..`                                                               |                                                                   |
| ....          | `cd ..\..\..`                                                            |                                                                   |
| url-encode    | Encode a given url                                                       | `url-encode "wikipedia.org/wiki/鬼車_(ライブラリ)"`               |
| url-decode    | Decode a given url                                                       | `url-decode "wikipedia.org/wiki/%E9%AC%BC%E8%BB%8A"`              |
| base64-encode | base64 encode a given string                                             | `base64-encode "hi"`                                              |
| base64-decode | base64 decode a given string                                             | `base64-decode "aGk="`                                            |
| download      | Download a file to a given path                                          | `download https://a.io/a.txt b.txt`                               |
| calc2         | Math calculator, or use `calc` for GUI one                               | `calc2 "[math]::pow(3,2)+1"`                                      |
| cp            | Copy a file/folder from one path to another, using Robocopy.exe          | `cp src dst`                                                      |
| which         | Which command is this                                                    | `which python`                                                    |
| find          | Find a file in current folder, you don't have to input the full name     | `find bun.htm`                                                    |
| grep          | Search a string in current folder or given file names or stdout pipeline | `grep TODO` or `grep TODO ./file1 ./file2` or `echo hi \| grep h` |
| touch         | Create an empty file                                                     | `touch 1.txt`                                                     |
| uname         | System Information                                                       | `uname`                                                           |
| top           | Process table sorted by CPU usage                                        | `top`                                                             |
| pkill         | Kill a process                                                           | `pkill notepad`                                                   |
| reboot        | Restart OS                                                               | `reboot`                                                          |
| poweroff      | Shutdown OS                                                              | `poweroff`                                                        |

## Extra Environment variables

| Variable            | Value                    | Description                   |
| ------------------- | ------------------------ | ----------------------------- |
| `PYTHONIOENCODING`  | `UTF-8`                  | Python2 UTF-8                 |
| `PYTHONUTF8`        | `1`                      | Python3 UTF-8                 |
| `PYTHONHTTPSVERIFY` | `0`                      | Python2 SSL checking disabled |
| `PIP_USE_FEATURE`   | `fast-deps`              | Pip parallel downloading      |
| `JAVA_TOOL_OPTIONS` | ` -Dfile.encoding=UTF8 ` | Java UTF-8                    |

### TODO
* Compatible with upcoming Powershell 6
* Compatible with WindowsFX(LinuxFX)

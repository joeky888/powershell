![PS](https://i.imgur.com/gjjWnCi.png)

[中文說明](ReadMe-zh.md)

Features
=====
* No plugins, just one file
* Fast
* Default startup directory is Desktop
* Git current branch
* Zsh-like Tab-Completion
* Powershell ISE supported
* Runs on Powershell >= 2.0 (Windows XP+)
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

## Install theme

See https://github.com/joeky888/MonoKombat.cmd

## Install chocolatey and chocolatey packages (Recommend)

```sh
# Open powershell (as administrator)
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install 7zip vim-tux.portable git poshgit aria2 miniconda miniconda3 ffmpeg youtube-dl -y
```

## Install Powershell modules from Powershell Gallery, for tab-completion (Recommend)

```sh
# Open powershell (as administrator)
PowerShellGet\Install-Module -Scope CurrentUser posh-git
PowerShellGet\Install-Module -Scope CurrentUser posh-docker
```

| Keys      | Action                                                | Description |
| --------- | ----------------------------------------------------- | ----------- |
| Ctrl A    | Move cursor to the beginning of the line              | Just like macOS and terminals |
| Ctrl E    | Move cursor to the end of the line                    | Just like macOS and terminals |
| Ctrl C    | Copy/Cancel command                                   | |
| Ctrl X    | Cut                                                   | |
| Ctrl V    | Paste                                                 | |
| Ctrl D    | Exit                                                  | |
| Ctrl K    | Kill whole line                                       | Just like nano |
| Ctrl F    | Run current command forever                           | |
| Ctrl R    | Search the history backward                           | Just like bash |
| Ctrl G    | Select all                                            | |
| Ctrl T    | New Window                                            | Open new tab in Powershell ISE |
| Ctrl Z    | Undo                                                  | |
| Ctrl Y    | Redo                                                  | |
| Ctrl S    | Search the history forward                            | Just like Emacs |
| Ctrl W    | Close tab                                             | Powershell ISE only |
| Ctrl L    | Clear                                                 | |
| Ctrl O    | Open file explorer here                               | |
| Ctrl →    | Next word                                             | |
| Ctrl ←    | Previous word                                         | |
| Shift →   | Select one character right                            | |
| Shift ←   | Select one character left                             | |
| ↑         | Previous command in history                           | |
| ↓         | Next command in history                               | |
| Ctrl Backspace    |  Delete a word backward                       | |
| Shift+Insert      |  Paste                                        | Paste raw data from clipboard |

## Extra commands

| Command           | Action                                                                                    | Description |
| ----------------- | ----------------------------------------------------------------------------------------- | ----------- |
| upgradeProfile    | Upgrade [this file](profile.ps1)                                                          | |
| upgradeChoco      | Upgrade all installed choco packages                                                      | |
| upgradeModule     | Upgrade all installed Modules from Powershell Gallery                                     | |
| upgradeScoop      | Upgrade all installed Scooop packages                                                     | |
| upgradeConda      | Upgrade all Anaconda/Miniconda packages                                                   | |
| upgradeConda2     | Upgrade all Miniconda2 packages                                                           | choco install miniconda2 |
| upgradeConda3     | Upgrade all Miniconda3 packages                                                           | choco install miniconda3 |
| upgradePip        | Upgrade all pip packages                                                                  | |
| upgradePip2       | Upgrade all pip2 packages                                                                 | choco install miniconda2 |
| upgradePip3       | Upgrade all pip3 packages                                                                 | choco install miniconda3 |
| upgradeNpm        | Upgrade all npm global packages                                                           | choco install nodejs |
| upgradeVimrc      | Upgrade [vimrc](https://github.com/joeky888/vimrc) file                               | |
| MtuStatus         | Network MTU values                                                                        | |
| MtuForWifiGaming  | Network MTU value for better gaming experience (until next reboot)                        | MTU = 296 |
| MtuForWifiNormal  | Network MTU value reset                                                                   | MTU = 1500 |
| Reset-Networking  | Reset all network cache                                                                   | Useful when internet is broken |
| python2           | C:\ProgramData\Miniconda2\python.exe                                                      | choco install miniconda2 |
| python3           | C:\ProgramData\Miniconda3\python.exe                                                      | choco install miniconda3 |
| conda2            | C:\ProgramData\Miniconda2\Scripts\conda.exe                                               | choco install miniconda2 |
| conda3            | C:\ProgramData\Miniconda3\Scripts\conda.exe                                               | choco install miniconda3 |
| pip2              | C:\ProgramData\Miniconda2\Scripts\pip.exe                                                 | choco install miniconda2 |
| pip3              | C:\ProgramData\Miniconda3\Scripts\pip.exe                                                 | choco install miniconda3 |
| Find-RegKey       | Find a key in regedit recursively                                                         | Find-RegKey "some key" |
| Find-RegValue     | Find a value in regedit recursively                                                       | Find-RegKey "some value" |

## Extra Linux commands

| Command           | Action                                                                                    | Example       |
| ----------------- | ----------------------------------------------------------------------------------------- | ------------- |
| download          | Download a file to a given path                                                           | `download https://a.io/a.txt b.txt` |
| which             | Which command is this                                                                     | `which python` |
| find              | Find a file in current folder, you don't have to input the full name                      | `find bun.htm` |
| grep              | Search a string in current folder or given file names or stdout pipeline                  | `grep TODO` or `grep TODO ./file1 ./file2` or `echo hi \| grep h`  |
| touch             | Create an empty file                                                                      | `touch 1.txt`  |
| uname             | System Information                                                                        | `uname`        |
| top               | Process table sorted by CPU usage                                                         | `top`           |
| pkill             | Kill a process                                                                            | `pkill notepad` |
| restart           | Restart OS                                                                                | `restart` |
| poweroff          | Shutdown OS                                                                               | `poweroff` |

## Extra Environment variables

| Variable              | Value                                     | Description                   |
| --------------------- | ----------------------------------------- | ----------------------------- |
| `PYTHONIOENCODING`    | `UTF-8`                                   | Python2 UTF-8                 |
| `PYTHONHTTPSVERIFY`   | `0`                                       | Python2 SSL checking disabled |
| `JAVA_TOOL_OPTIONS`   | ` -Dfile.encoding=UTF8 `                  | Java UTF-8                    |

### Extra notes

* The best font for Powershell is [Sarasa-Gothic](https://github.com/be5invis/Sarasa-Gothic/releases) (previously [Iosevka](https://github.com/be5invis/Iosevka/releases)), which is made by one of the Microsoft employees. see [this Chinese post](https://www.zhihu.com/question/19637242/answer/41116173)

### TODO
* Compatible with upcoming Powershell 6

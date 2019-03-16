# Python2 UTF8
$env:PYTHONIOENCODING = "UTF-8"
# Java UTF8
$env:JAVA_TOOL_OPTIONS = " -Dfile.encoding=UTF8 "
# Python2 Disable ssl checking
$env:PYTHONHTTPSVERIFY = 0

# Increase history size
$global:MaximumHistoryCount = 10000

try {
  # UTF8
  [Console]::InputEncoding = [Text.UTF8Encoding]::UTF8
  [Console]::OutputEncoding = [Text.UTF8Encoding]::UTF8

  # Increase history in console buffer
  [Console]::BufferHeight = 20000
} catch [Exception] {
  # Older version of powershell does't support [Console]
  chcp 65001
}

if (Get-Command Set-PSReadlineOption -errorAction SilentlyContinue)
{
  # Disable beep
  Set-PSReadlineOption -BellStyle None

  # Bash-like keys
  Set-PSReadlineOption -EditMode Emacs
}

if (Get-Command Set-PSReadlineKeyHandler -errorAction SilentlyContinue)
{
  # Zsh-like completion
  Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

  # Key mappings
  Set-PSReadlineKeyHandler -Key UpArrow   -Function HistorySearchBackward
  Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
  Set-PSReadlineKeyHandler -Chord Ctrl+RightArrow -Function ForwardWord
  Set-PSReadlineKeyHandler -Chord Ctrl+LeftArrow  -Function BackwardWord
  Set-PSReadlineKeyHandler -Chord Ctrl+X -Function Cut
  # Set-PSReadlineKeyHandler -Chord Ctrl+V -Function Paste
  Set-PSReadlineKeyHandler -Chord Ctrl+G -Function SelectAll
  Set-PSReadlineKeyHandler -Chord Ctrl+K -Function DeleteLine
  Set-PSReadlineKeyHandler -Chord Ctrl+Z -Function Undo
  Set-PSReadlineKeyHandler -Chord Ctrl+Y -Function Redo
  Set-PSReadlineKeyHandler -Chord Ctrl+Backspace -Function BackwardKillWord
  Set-PSReadlineKeyHandler -Chord Shift+Insert -Function Paste
  Set-PSReadlineKeyHandler -Chord Ctrl+O -ScriptBlock {
    explorer.exe .
  }
  Set-PSReadlineKeyHandler -Chord Ctrl+T -ScriptBlock {
    # To do
    Invoke-Item $env:USERPROFILE'\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk'
  }
  Set-PSReadlineKeyHandler -Chord Ctrl+L -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("clear")
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
  }
  Set-PSReadlineKeyHandler -Chord Ctrl+F -ScriptBlock {
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert( "while(1){ " + $line + " ; if(`$?){break} }")
  }
  Set-PSReadlineKeyHandler -Chord Ctrl+V -ScriptBlock {
    $clipboard = Get-Clipboard -Raw
    if ($clipboard -match '^\s*(http|ftp|magnet)' -or `
        (Test-Path $clipboard.Trim()) ) {
#       $clipboard = $clipboard -replace "&","``&"
#       $clipboard = $clipboard -replace "\(","``("
#       $clipboard = $clipboard -replace "\)","``)"
#       $clipboard = $clipboard -replace ",","``,"
        $clipboard = $clipboard.Trim()
        $clipboard = "'${clipboard}'"
    }
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($clipboard)
  }
  Set-PSReadlineKeyHandler -Key Enter -ScriptBlock {
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    $line = $line -replace " \\\s*`n"," ```n"
    $line = $line -replace " \\\s*`r"," ```r"
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($line)
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
  }
}


# Set default starting path to Desktop
Set-Location $([Environment]::GetFolderPath("Desktop"))

# Theme
$Host.UI.RawUI.ForegroundColor = "Gray"
# $Host.UI.RawUI.BackgroundColor = "Black"

if (Get-Command Set-PSReadlineOption -errorAction SilentlyContinue)
{
  Set-PSReadlineOption -TokenKind None      -ForegroundColor Red
  Set-PSReadlineOption -TokenKind Comment   -ForegroundColor Gray
  Set-PSReadlineOption -TokenKind Keyword   -ForegroundColor White
  Set-PSReadlineOption -TokenKind String    -ForegroundColor Yellow
  Set-PSReadlineOption -TokenKind Operator  -ForegroundColor White
  Set-PSReadlineOption -TokenKind Variable  -ForegroundColor White
  Set-PSReadlineOption -TokenKind Command   -ForegroundColor Green
  Set-PSReadlineOption -TokenKind Parameter -ForegroundColor White
  Set-PSReadlineOption -TokenKind Type      -ForegroundColor White
  Set-PSReadlineOption -TokenKind Number    -ForegroundColor Cyan
  Set-PSReadlineOption -TokenKind Member    -ForegroundColor White
}

Function Prompt {
  try {
   Write-Host  "$([Char]9581)$([Char]9472)" -NoNewline
  } catch [Exception] { <# Older version of powershell doesn't support special characters #> }

  Write-Host  "$env:username" -NoNewline -ForegroundColor Red

  If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host  "(Admin)" -NoNewline -ForegroundColor Yellow
  }
  Write-Host "@" -NoNewline
  Write-Host "$env:computername" -NoNewline -ForegroundColor Green
  Write-Host " " -NoNewline
  # Use full path since it's easier to understand for newbies
  # Write-Host "$PWD".Replace("$HOME", "~") -ForegroundColor Yellow
  Write-Host "$PWD" -ForegroundColor Cyan -NoNewline
  try {
    if (-not ([string]::IsNullOrEmpty($(git rev-parse --git-dir)))){
        Write-Host " * $(git rev-parse --abbrev-ref HEAD)" -NoNewline -ForegroundColor Yellow
    }
  } catch [Exception] { <# Not in git directory or git is not installed #> }

  Write-Host ""

  try {
    Write-Host  "$([Char]9584)$([Char]9472)" -NoNewline
  } catch [Exception] { <# Older version of powershell doesn't support special characters #> }
  Write-Host ">" -NoNewline -ForegroundColor Red
  Write-Host ">" -NoNewline -ForegroundColor Yellow
  Write-Host ">" -NoNewline -ForegroundColor Green
  Return " "
}

# alias bash/zsh command
If (Test-Path alias:which)  {Remove-Item alias:which}
If (Test-Path alias:cd)     {Remove-Item alias:cd}
If (Test-Path alias:grep)   {Remove-Item alias:grep}
If (Test-Path alias:ls)     {Remove-Item alias:ls}
If (Test-Path alias:rm)     {Remove-Item alias:rm}
If (Test-Path alias:cat)    {Remove-Item alias:cat}

if (Get-Command curl.exe -errorAction SilentlyContinue) {
    If (Test-Path alias:curl)  {Remove-Item alias:curl}
}

Function cat {
  $numOfArgs = $args.Length
  for ($i=0; $i -lt $numOfArgs; $i++) {
    Get-Content -encoding utf8 $($args[$i])
  }
}
Function cd {
  if ($args.count -gt 0) {
    Set-Location $($args)
  } else {
    Set-Location $($env:USERPROFILE)
  }
}
Function find {
  Get-ChildItem -Recurse -Force -Name -Filter "*$args*" | Where-Object { $_.fullname -NotLike "*.git\*" }
}
Function grep {
  $pipeline = $input | Out-String -stream
  $numOfArgs = $args.Length
  if ($pipeline.length -gt 0) { # grep from stdin
    $pipeline | Out-String -stream | Select-String $($args[0]) | Select Path, LineNumber, Line | Format-List
  } elseif (($numOfArgs -gt 1) -and (Test-Path $($args[1]) -PathType Leaf)) { # grep a file
    for ($i=1; $i -lt $numOfArgs; $i++) {
      Select-String -Pattern $($args[0]) -Path $($args[$i]) | Select Path, LineNumber, Line | Format-List
    }
  } else { # grep a folder
    Get-ChildItem -Recurse -Force | Where-Object { $_.fullname -NotLike "*.git\*" } | Select-String $($args[0]) | Select Path, LineNumber, Line | Format-List
  }
}
$env:joekyls = $true
Function ls {
  if (-not $env:joekyls) {
    Get-ChildItem -Force
    return
  }

  $files = Invoke-Expression "Get-ChildItem -Force '$args'"

  ForEach ($file in $files) {
      $isFolder = $file.Mode -match '^d'
      Write-Host $file.Mode -NoNewline -ForegroundColor Cyan
      Write-Host " " -NoNewline
      if ($isFolder) {
        try {
          Write-Host $file.Name -NoNewline -ForegroundColor Green
        } catch [Exception] {
          Write-Host "XXXXXXXXXXXX" -NoNewline -ForegroundColor Green
          $env:joekyls = $false
        }
        Write-Host "/" -NoNewline -ForegroundColor Green

      } else {
        try {
          Write-Host $file.Name -NoNewline -ForegroundColor Gray
        } catch [Exception] {
          Write-Host "XXXXXXXXXXXX" -NoNewline -ForegroundColor Gray
          $env:joekyls = $false
        }
      }
      Write-Host " " -NoNewline
      if(!$isFolder) {
        Write-Host $(Format-FileSize($file.Length)) -NoNewline -ForegroundColor Red
      }
      Write-Host ""
  }

  if ($files.Count -gt 1) {
    Write-Host $files.Count "items in total"
  }
}
Set-Alias l ls
Set-Alias ll ls
Function rm {
  $numOfArgs = $args.Length
  for ($i=0; $i -lt $numOfArgs; $i++) {
    Remove-Item -Recurse -Force $($args[$i])
  }
}
Function touch {
  $numOfArgs = $args.Length
  for ($i=0; $i -lt $numOfArgs; $i++) {
    echo $null >> $($args[$i])
  }
}
Function uname {
  try {
    systeminfo
    Write-Host "All of the Graphics cards Informations " -BackgroundColor DarkRed
    wmic path win32_VideoController get Name
    wmic path win32_VideoController get VideoModeDescription
    wmic path win32_VideoController get CurrentRefreshRate
    wmic path win32_VideoController get MaxRefreshRate
    wmic path win32_VideoController get MinRefreshRate
    wmic path win32_VideoController get DriverDate
    wmic path win32_VideoController get DriverVersion
  } catch [Exception] {
    # Older version of powershell doesn't support Get-CimInstance
    systeminfo
    Get-WmiObject Win32_OperatingSystem
  }
  Get-PSDrive -PSProvider 'FileSystem'
}
Function which {
  $cmd = $args
  try {
    Get-Command -All $cmd
    Get-Command -All -ShowCommandInfo $cmd
  } catch [Exception] {
    # Old version doesn't support -All and -ShowCommandInfo
    Get-Command $cmd
  }
}
Function pkill {
  $cmd = $args
  Get-Process | Where-Object { $_.Name -like "*$cmd*" } | Select-Object -First 1
  Get-Process | Where-Object { $_.Name -like "*$cmd*" } | Select-Object -First 1 | Stop-Process
}
Function top {
#   While(1) {Get-Process | Sort-Object -des cpu | Select-Object -First 15 | Format-Table -a; Start-Sleep 1; Clear-Host}
  $saveY = [console]::CursorTop
  $saveX = [console]::CursorLeft

  while ($true) {
    Get-Process | Sort-Object -Descending CPU | Select-Object -First 25;
    Start-Sleep -Seconds 2;
    [console]::setcursorposition($saveX,$saveY+3)
  }
}
Set-Alias htop top
Function ..() { Set-Location .. }
Function ...() { Set-Location ..\.. }
Function ....() { Set-Location ..\..\.. }
Function .....() { Set-Location ..\..\..\.. }
Function Format-FileSize() {
  Param ([int64]$size)
  If     ($size -gt 1TB) {[string]::Format("{0:0.00} TB", $size / 1TB)}
  ElseIf ($size -gt 1GB) {[string]::Format("{0:0.00} GB", $size / 1GB)}
  ElseIf ($size -gt 1MB) {[string]::Format("{0:0.00} MB", $size / 1MB)}
  ElseIf ($size -gt 1KB) {[string]::Format("{0:0.00} kB", $size / 1KB)}
  ElseIf ($size -gt 0)   {[string]::Format("{0:0.00} B", $size)}
  Else                   {""}
}
Function download {
  if ($args.count -lt 2) {
    Write-Output "donload <URL> <PATH>"
    return
  }

  $url = $args[0]
  $path = "$((Get-Item -Path '.\').FullName)\$($args[1])"

  Set-ExecutionPolicy Bypass -Scope Process -Force
  Write-Output "Saving $url to $path"
  (New-Object System.Net.WebClient).DownloadFile($url, $path)

}
Function restart {
  Restart-Computer -Force
}
Function poweroff {
  Stop-Computer -Force
}
Function Find-RegKey() {
  $key = $args
  Get-ChildItem -path Registry::HKEY_CLASSES_ROOT -Recurse -ErrorAction SilentlyContinue | where { $_.Name -like "*$($key)*" }
  Get-ChildItem -path Registry::HKEY_CURRENT_USER -Recurse -ErrorAction SilentlyContinue | where { $_.Name -like "*$($key)*" }
  Get-ChildItem -path Registry::HKEY_LOCAL_MACHINE -Recurse -ErrorAction SilentlyContinue | where { $_.Name -like "*$($key)*" }
  Get-ChildItem -path Registry::HKEY_USERS -Recurse -ErrorAction SilentlyContinue | where { $_.Name -like "*$($key)*" }
  Get-ChildItem -path Registry::HKEY_CURRENT_CONFIG -Recurse -ErrorAction SilentlyContinue | where { $_.Name -like "*$($key)*" }
}
Function Find-RegValue() {
  $value = $args
  Get-ChildItem -path Registry::HKEY_CLASSES_ROOT -Recurse -ErrorAction SilentlyContinue | where { $_.Property -like "*$($value)*" }
  Get-ChildItem -path Registry::HKEY_CURRENT_USER -Recurse -ErrorAction SilentlyContinue | where { $_.Property -like "*$($value)*" }
  Get-ChildItem -path Registry::HKEY_LOCAL_MACHINE -Recurse -ErrorAction SilentlyContinue | where { $_.Property -like "*$($value)*" }
  Get-ChildItem -path Registry::HKEY_USERS -Recurse -ErrorAction SilentlyContinue | where { $_.Property -like "*$($value)*" }
  Get-ChildItem -path Registry::HKEY_CURRENT_CONFIG -Recurse -ErrorAction SilentlyContinue | where { $_.Property -like "*$($value)*" }
}

# Choco tab completion
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Choco variables
try {
  [Environment]::SetEnvironmentVariable("ChocolateyBinRoot", $env:ALLUSERSPROFILE, [EnvironmentVariableTarget]::Machine)
  [Environment]::SetEnvironmentVariable("ChocolateyToolsLocation", $env:ALLUSERSPROFILE, [EnvironmentVariableTarget]::Machine)
  [Environment]::SetEnvironmentVariable("ChocolateyBinRoot", $env:ALLUSERSPROFILE, [EnvironmentVariableTarget]::User)
  [Environment]::SetEnvironmentVariable("ChocolateyToolsLocation", $env:ALLUSERSPROFILE, [EnvironmentVariableTarget]::User)
} catch [Exception] {
  $env:ChocolateyBinRoot = $env:ALLUSERSPROFILE
  $env:ChocolateyToolsLocation = $env:ALLUSERSPROFILE
}

# Import modules from Powershell Gallery
if (Get-Module -ListAvailable -Name posh-git) {
  Import-Module posh-git
}
if (Get-Module -ListAvailable -Name posh-docker) {
  Import-Module posh-docker
}

# Command to upgrade all chocolatey packages
Function upgradeChoco {
  choco upgrade all -y --pre
}

# Command to upgrade all powershell modules
Function upgradeModule {
  Update-Module
}

Function upgradeScoop {
  scoop update
  scoop update *
  scoop cleanup *
  scoop cache rm *
}

# Command to upgrade all Conda packages
Function upgradeConda {
  conda update -n base conda -y
  conda update --no-channel-priority --all --yes
}
Function upgradeYoutube-dl {
  pip3 install --upgrade https://github.com/rg3/youtube-dl/archive/master.zip
}
Function upgradeYou-get {
  pip3 install --upgrade https://github.com/soimort/you-get/archive/develop.zip
}
Function upgradePip {
  pip install --upgrade pip
  pip freeze -l > requirements.txt
  (Get-Content requirements.txt).replace('==', '>=') | Set-Content requirements.txt
  pip install -r requirements.txt --upgrade
  Remove-Item requirements.txt
  pip install --upgrade https://github.com/pyca/pyopenssl/archive/master.zip
  pip install --upgrade https://github.com/requests/requests/archive/master.zip
}
Function upgradeNpm {
  npm update -g
}
Function upgradeGo {
  go get -insecure -v -u all
}
Function upgradeAnnie {
  go get -insecure -v -u github.com/iawia002/annie
}
Function upgradeProfile {
  $url = "https://raw.githubusercontent.com/joeky888/powershell/master/profile.ps1"
  $path = $Profile.CurrentUserAllHosts

  if(!(Split-Path -parent $path) -or !(Test-Path -pathType Container (Split-Path -parent $path))) {
    $targetFile = Join-Path $pwd (Split-Path -leaf $path)
  }

  (New-Object System.Net.WebClient).DownloadFile($url, $path)
}
Function upgradeVimrc {
  $url = "https://raw.githubusercontent.com/joeky888/vimrc/master/.vimrc"
  $path = "$env:USERPROFILE\.vimrc"

  if(!(Split-Path -parent $path) -or !(Test-Path -pathType Container (Split-Path -parent $path))) {
    $targetFile = Join-Path $pwd (Split-Path -leaf $path)
  }

  (New-Object System.Net.WebClient).DownloadFile($url, $path)
}

Function gvim {
  $Commandvim = ""
  if (Test-Path -Path "$env:ALLUSERSPROFILE\chocolatey\bin\gvim.exe") {
    $Commandvim = "$env:ALLUSERSPROFILE\chocolatey\bin\gvim.exe"
  } elseif (Test-Path -Path "$env:USERPROFILE\scoop\shims\gvim.exe") {
    $Commandvim = "$env:USERPROFILE\scoop\shims\gvim.exe"
  }
  $Parmsvim = ""
  if ($args.count -gt 0) {
    $Parmsvim = "-p --remote-tab-silent $args"
    $Parmsvim = $Parmsvim.Split(" ")
  }
  & "$Commandvim" $Parmsvim
}

$env:DOWNLOADARGS="--continue=true --timeout=20 --connect-timeout=20 --file-allocation=none --content-disposition-default-utf8=true --check-certificate=false --max-tries=2 --max-concurrent-downloads=150 --max-connection-per-server=16 --split=16 --min-split-size=1M --bt-max-peers=0 --bt-request-peer-speed-limit=100M --seed-ratio=0 --bt-detach-seed-only=true --parameterized-uri=true"
Function aria2c {
  Invoke-Expression "aria2c.exe $env:DOWNLOADARGS '$args'"
}
Function youtube-dl {
  youtube-dl.exe -o "%(title)s.%(ext)s" -f "bestvideo[height<=1080][fps<=30]+bestaudio/best" --write-sub --all-subs --embed-subs --ignore-errors --external-downloader aria2c --external-downloader-args $env:DOWNLOADARGS $args
}
Function youtube-dl-mp3 {
  youtube-dl.exe -o "%(title)s.%(ext)s" --extract-audio --audio-format mp3 --write-sub --all-subs --embed-subs --ignore-errors --external-downloader aria2c --external-downloader-args $env:DOWNLOADARGS $args
}
set-alias mp3 youtube-dl-mp3

Function mpv-1080 {
  mpv.exe --ytdl-format="bestvideo[height<=1080][fps<=30]+bestaudio/best" --cache=1048576 $args
}
Function mpv-720 {
  mpv.exe --ytdl-format="bestvideo[height<=720][fps<=30]+bestaudio/best" --cache=600000 $args
}
Function streamlink-mpv-1080 {
  streamlink.exe --verbose-player --player 'mpv --cache=600000' --default-stream 1080p $args
}
Function streamlink-mpv-720 {
  streamlink.exe --verbose-player --player 'mpv --cache=600000' --default-stream 720p $args
}

Function Reset-Networking {
  ipconfig /release
  ipconfig /renew
  arp -d *
  nbtstat -R
  nbtstat -RR
  ipconfig /flushdns
  ipconfig /registerdns
  netsh winsock reset
}
Function Reset-Networking-Per10m {
  while($true) {
    Reset-Networking
    Start-Sleep -s 600
  }
}

Function MtuStatus {
  netsh interface ipv4 show subinterfaces
}
Function MtuForWifiGaming {
  netsh interface ipv4 set subinterface Wi-Fi mtu=296  store=active
}
Function MtuForWifiNormal {
  netsh interface ipv4 set subinterface Wi-Fi mtu=1500 store=persistent
}

if (Test-Path -Path "$env:USERPROFILE\.pythonrc") {
  $env:PYTHONSTARTUP = "$env:USERPROFILE\.pythonrc"
} elseif (Test-Path -Path "$env:USERPROFILE\.pythonrc.py") {
  $env:PYTHONSTARTUP = "$env:USERPROFILE\.pythonrc.py"
}

Function getCondaPath($i)
{
  # choco install miniconda
  $PossiblePrefix = @("C:\ProgramData", "$env:ALLUSERSPROFILE", "$env:USERPROFILE", "$env:LOCALAPPDATA\Continuum", "$env:USERPROFILE\scoop\apps")
  $PossiblePath = @("Miniconda$i", "miniconda$i", "Anaconda$i", "anaconda$i")
  $PossiblePostfix = @("", "\current")
  foreach ($a in $PossiblePrefix) {
    foreach ($b in $PossiblePath) {
      foreach ($c in $PossiblePostfix) {
        if(Test-Path -Path "$a\$b$c\python.exe") {
          return "$a\$b$c"
        }
      }
    }
  }
  return ""
}


$c2 = getCondaPath(2)
if ($c2 -ne "") {
  $env:Path = "$c2;$env:Path"
  $env:Path = "$c2\Scripts;$env:Path"
  Set-Alias pip2 "$c2\Scripts\pip.exe"
  Set-Alias conda2 "$c2\Scripts\conda.exe"
  Set-Alias python2 "$c2\python.exe"
  Function upgradeConda2 {
    Invoke-Expression "$c2\Scripts\conda.exe update -n base conda -y"
    Invoke-Expression "$c2\Scripts\conda.exe update --no-channel-priority --all --yes"
  }
  Function upgradePip2 {
    Invoke-Expression "$c2\Scripts\pip.exe install --upgrade pip"
    Invoke-Expression "$c2\Scripts\pip.exe freeze -l > requirements.txt"
    (Get-Content requirements.txt).replace('==', '>=') | Set-Content requirements.txt
    Invoke-Expression "$c2\Scripts\pip.exe install -r requirements.txt --upgrade"
    Remove-Item requirements.txt
    Invoke-Expression "$c2\Scripts\pip.exe install --upgrade https://github.com/pyca/pyopenssl/archive/master.zip"
    Invoke-Expression "$c2\Scripts\pip.exe install --upgrade https://github.com/requests/requests/archive/master.zip"
  }
}

$c3 = getCondaPath(3)
if ($c3 -ne "") {
  $env:Path = "$c3;$env:Path"
  $env:Path = "$c3\Scripts;$env:Path"
  Set-Alias pip3 "$c3\Scripts\pip.exe"
  Set-Alias conda3 "$c3\Scripts\conda.exe"
  Set-Alias python3 "$c3\python.exe"
  Function upgradeConda3 {
    Invoke-Expression "$c3\Scripts\conda.exe update -n base conda -y"
    Invoke-Expression "$c3\Scripts\conda.exe update --no-channel-priority --all --yes"
  }
  Function upgradePip3 {
    Invoke-Expression "$c3\Scripts\pip.exe install --upgrade pip"
    Invoke-Expression "$c3\Scripts\pip.exe freeze -l > requirements.txt"
    (Get-Content requirements.txt).replace('==', '>=') | Set-Content requirements.txt
    Invoke-Expression "$c3\Scripts\pip.exe install -r requirements.txt --upgrade"
    Remove-Item requirements.txt
    Invoke-Expression "$c3\Scripts\pip.exe install --upgrade https://github.com/pyca/pyopenssl/archive/master.zip"
    Invoke-Expression "$c3\Scripts\pip.exe install --upgrade https://github.com/requests/requests/archive/master.zip"
  }
}

Function Set-EnvPath($path) {
  if((Test-Path -Path "$path") -and ($env:Path -NotLike "*$path*")) {
      $env:Path = "$path;$env:Path"
  }
}

Set-EnvPath("$env:ALLUSERSPROFILE\chocolatey\bin")
Set-EnvPath("$env:ProgramFiles\7-Zip")
Set-EnvPath("$env:ProgramFiles\OpenSSH-Win64")
Set-EnvPath("$env:ProgramFiles\Sublime Text 3")
Set-EnvPath("$env:ProgramFiles\Sublime Text 2")
Set-EnvPath("$env:ProgramFiles\Microsoft VS Code")
Set-EnvPath("$env:ProgramFiles\Microsoft VS Code Insiders")
Set-EnvPath("$env:ProgramFiles\Nmap")
Set-EnvPath("$env:ProgramFiles (x86)\Nmap")
Set-EnvPath("C:\zulu")
Set-EnvPath("$env:ProgramFiles\Oracle\VirtualBox")
Set-EnvPath("$env:USERPROFILE\scoop\shims")
Set-EnvPath("$env:LOCALAPPDATA\Android\sdk\platform-tools")
Set-EnvPath("$env:USERPROFILE\go\bin")

# Move Windows path to end
$winpath=""
$nonwinpath=""
ForEach ($path in ${env:PATH}.Split(';')) {
  if($path -match '.*windows.*') {
    $winpath = $winpath + $path + ";"
  } else {
    $nonwinpath = $nonwinpath + $path + ";"
  }
}
$env:PATH = $nonwinpath + $winpath

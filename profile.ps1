# Python2 UTF8
$env:PYTHONIOENCODING = "UTF-8"
# Python3 UTF8
$env:PYTHONUTF8 = "1"
# Java UTF8
$env:JAVA_TOOL_OPTIONS = " -Dfile.encoding=UTF8 "
# Python2 Disable ssl checking
$env:PYTHONHTTPSVERIFY = 0

# Increase history size
$global:MaximumHistoryCount = 10000

# Clear TERM variable
$env:TERM = ""

# Pipe non-ASCII content with utf8 encoding, this is a fix for ripgrep
$OutputEncoding = [System.Text.UTF8Encoding]::new()

try {
  # UTF8
  [Console]::InputEncoding = [Text.UTF8Encoding]::UTF8
  [Console]::OutputEncoding = [Text.UTF8Encoding]::UTF8
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
  # Set-PSReadlineKeyHandler -Key UpArrow   -Function HistorySearchBackward
  # Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
  Set-PSReadlineKeyHandler -Key UpArrow -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::HistorySearchBackward()
    [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
  }
  Set-PSReadlineKeyHandler -Key DownArrow -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::HistorySearchForward()
    [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
  }
  Set-PSReadlineKeyHandler -Chord Ctrl+RightArrow -Function ForwardWord
  Set-PSReadlineKeyHandler -Chord Ctrl+LeftArrow  -Function BackwardWord
  Set-PSReadlineKeyHandler -Chord Ctrl+X,Ctrl+x -Function Cut
  Set-PSReadlineKeyHandler -Chord Ctrl+C,Ctrl+c -Function CopyOrCancelLine
  # Set-PSReadlineKeyHandler -Chord Ctrl+V -Function Paste
  # Set-PSReadlineKeyHandler -Chord Ctrl+G,Ctrl+g -Function SelectAll
  Set-PSReadlineKeyHandler -Chord Ctrl+K,Ctrl+k -Function DeleteLine
  Set-PSReadlineKeyHandler -Chord Ctrl+Z,Ctrl+z -Function Undo
  Set-PSReadlineKeyHandler -Chord Ctrl+Y,Ctrl+y -Function Redo
  Set-PSReadlineKeyHandler -Chord Ctrl+Backspace -Function BackwardKillWord
  Set-PSReadlineKeyHandler -Chord Shift+Insert -Function Paste
  Set-PSReadlineKeyHandler -Chord Ctrl+O,Ctrl+o -ScriptBlock {
    explorer.exe .
  }
  Set-PSReadlineKeyHandler -Chord Ctrl+L,Ctrl+l -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("clear")
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
  }
  Set-PSReadlineKeyHandler -Chord Ctrl+F,Ctrl+f -ScriptBlock {
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert( "while(1){ " + $line + " ; if(`$?){break} }")
  }
  Set-PSReadlineKeyHandler -Chord Ctrl+G,Ctrl+g -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert( "Get-ChildItem -File -Recurse *.rar | Foreach { echo `$_.fullname }")
  }
  Set-PSReadlineKeyHandler -Chord Ctrl+V,Ctrl+v -ScriptBlock {
    $clipboard = $(Get-Clipboard -Raw).Trim()
    if ($clipboard -match '^(http|ftp|magnet)' -or `
        (Test-Path $clipboard) ) {
        $clipboard = "'" + [uri]::UnescapeDataString(${clipboard})+ "'"
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
  try {
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
  } catch [Exception] {
    # PSReadline 2.0
    Set-PSReadlineOption -Colors @{
      "None"      = [ConsoleColor]::Red
      "Comment"   = [ConsoleColor]::Gray
      "Keyword"   = [ConsoleColor]::White
      "String"    = [ConsoleColor]::Yellow
      "Operator"  = [ConsoleColor]::White
      "Variable"  = [ConsoleColor]::White
      "Command"   = [ConsoleColor]::Green
      "Parameter" = [ConsoleColor]::White
      "Type"      = [ConsoleColor]::White
      "Number"    = [ConsoleColor]::Cyan
      "Member"    = [ConsoleColor]::White
    }
  }
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
    $pipeline | Out-String -stream | Select-String $($args[0]) | Select-Object Path, LineNumber, Line | Format-List
  } elseif (($numOfArgs -gt 1) -and (Test-Path $($args[1]) -PathType Leaf)) { # grep a file
    for ($i=1; $i -lt $numOfArgs; $i++) {
      Select-String -Pattern $($args[0]) -Path $($args[$i]) | Select-Object Path, LineNumber, Line | Format-List
    }
  } else { # grep a folder
    Get-ChildItem -Recurse -Force | Where-Object { $_.fullname -NotLike "*.git\*" } | Select-String $($args[0]) | Select-Object Path, LineNumber, Line | Format-List
  }
}

if (Get-Command robocopy -errorAction SilentlyContinue)
{
  If (Test-Path alias:cp)    {Remove-Item alias:cp}
  Set-Alias cp robocopy
}

Function fd {
  $VCS_FOLDERS = ".bzr,CVS,.git,.hg,.svn"
  $VCS_FOLDERS_MORE = "$VCS_FOLDERS,vendor,node_modules,ohmyzsh,dist,bin"
  Invoke-Expression "fd.exe --hidden --glob --exclude=`"{$VCS_FOLDERS_MORE}`" `"$args`""
}
Function rg {
  $pipeline = $input | Out-String -stream
  $VCS_FOLDERS = ".bzr,CVS,.git,.hg,.svn"
  $VCS_FOLDERS_MORE = "$VCS_FOLDERS,vendor,node_modules,ohmyzsh,dist,bin"
  if ($pipeline.length -gt 0) { # grep from stdin
    $pipeline | Out-String -stream | rg.exe $args
  } else {
    Invoke-Expression "rg.exe --hidden --glob `"!{$VCS_FOLDERS_MORE}`" `"$args`""
  }
}

$env:joekyls = $true
Function ls {
  if (-not $env:joekyls) {
    Get-ChildItem -Force
    return
  }

  $files = Invoke-Expression "Get-ChildItem -Force `"$args`""

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
Set-Alias calc2 Invoke-Expression
Set-Alias l ls
Set-Alias ll ls
Function rm {
  $numOfArgs = $args.Length
  for ($i=0; $i -lt $numOfArgs; $i++) {
    if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
          [Security.Principal.WindowsBuiltInRole] "Administrator")) {
      Remove-Item -Recurse -Force $($args[$i])
    } else {
      Remove-Item -Recurse $($args[$i])
    }
  }
}
Function touch {
  $numOfArgs = $args.Length
  for ($i=0; $i -lt $numOfArgs; $i++) {
    Write-Output $null >> $($args[$i])
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

Function base64-encode {
  [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($args))
}
Function base64-decode {
  [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($args))
}
Function url-encode {
  [uri]::EscapeUriString($args)
}
Function url-decode {
  [uri]::UnescapeDataString($args)
}

Set-Alias htop top
Function curl-status() {
  curl.exe -o $ENV:Temp\curl.tmp -L -s -w "Content Type: %{content_type}\nStatus Code: %{response_code}\nNumber of Redirects: %{num_redirects}\nSize: %{size_download}Bytes\nSpeed of Download: %{speed_download}Bytes/s\nServer IP: %{remote_ip}:%{remote_port}\nServer Final URL: %{url_effective}\n\nDNS Resolve: %{time_namelookup}s\nClient -> Server: %{time_connect}s\nServer Response: %{time_starttransfer}s\nTotal time: %{time_total}s\n" $args
}

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
Function reboot {
  Restart-Computer -Force
}
Function poweroff {
  Stop-Computer -Force
}
Function Find-RegKey() {
  $key = $args
  Get-ChildItem -path Registry::HKEY_CLASSES_ROOT -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*$($key)*" }
  Get-ChildItem -path Registry::HKEY_CURRENT_USER -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*$($key)*" }
  Get-ChildItem -path Registry::HKEY_LOCAL_MACHINE -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*$($key)*" }
  Get-ChildItem -path Registry::HKEY_USERS -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*$($key)*" }
  Get-ChildItem -path Registry::HKEY_CURRENT_CONFIG -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*$($key)*" }
}
Function Find-RegValue() {
  $value = $args
  Get-ChildItem -path Registry::HKEY_CLASSES_ROOT -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Property -like "*$($value)*" }
  Get-ChildItem -path Registry::HKEY_CURRENT_USER -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Property -like "*$($value)*" }
  Get-ChildItem -path Registry::HKEY_LOCAL_MACHINE -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Property -like "*$($value)*" }
  Get-ChildItem -path Registry::HKEY_USERS -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Property -like "*$($value)*" }
  Get-ChildItem -path Registry::HKEY_CURRENT_CONFIG -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Property -like "*$($value)*" }
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

# Import modules from Powershell Gallery
if (Get-Module -ListAvailable -Name posh-git) {
  Import-Module posh-git
  if (Get-Module -ListAvailable -Name oh-my-posh) {
    Import-Module oh-my-posh
    Set-PoshPrompt -Theme Paradox
  }
}
if (Get-Module -ListAvailable -Name posh-docker) {
  Import-Module posh-docker
}

# Command to upgrade all chocolatey packages
Function upgradeChoco {
  choco upgrade all -y
  Remove-Item -Recurse -ErrorAction SilentlyContinue $env:USERPROFILE\AppData\Local\Temp\*
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
  conda update --no-channel-priority --all --yes
}
Function upgradeYt-dlp {
  pip3 install --upgrade --force-reinstall --no-cache-dir https://github.com/yt-dlp/yt-dlp/archive/master.zip
}
Function upgradeYou-get {
  pip3 install --upgrade --force-reinstall --no-cache-dir https://github.com/soimort/you-get/archive/develop.zip
}
Function upgradeStreamlink {
  pip3 install --upgrade --force-reinstall --no-cache-dir https://github.com/streamlink/streamlink/archive/master.zip
}
Function upgradePip {
  pip3 install --upgrade pip setuptools
  pip freeze -l > requirements.txt
  (Get-Content requirements.txt).replace('==', '>=') | Set-Content requirements.txt
  pip3 install -r requirements.txt --upgrade
  Remove-Item requirements.txt
  pip3 install --upgrade https://github.com/pyca/pyopenssl/archive/main.zip
  pip3 install --upgrade https://github.com/requests/requests/archive/main.zip
}
Function upgradeProfile {
  $url = "https://raw.githubusercontent.com/joeky888/powershell/master/profile.ps1"
  $path = $Profile.CurrentUserAllHosts

  (New-Object System.Net.WebClient).DownloadFile($url, $path)
}
Function upgradeVimrc {
  $url = "https://raw.githubusercontent.com/joeky888/vimrc/master/.vimrc"
  $path = "$env:USERPROFILE\.vimrc"

  (New-Object System.Net.WebClient).DownloadFile($url, $path)
}

$env:DOWNLOADARGS="--continue=true --timeout=12 --connect-timeout=12 --file-allocation=none --content-disposition-default-utf8=true --check-certificate=false --max-tries=2 --max-concurrent-downloads=150 --max-connection-per-server=16 --split=16 --min-split-size=1M --http-accept-gzip=true --parameterized-uri=false"
$env:DLARGUMENTS="-o '%(title)s.%(ext)s' --write-sub --all-subs --embed-subs --concurrent-fragments 8 --hls-prefer-native --ignore-errors --downloader aria2c --downloader-args 'aria2c:$env:DOWNLOADARGS'"
$env:TORRENTARGS="--enable-dht=true --bt-enable-lpd=true --bt-max-peers=0 --bt-request-peer-speed-limit=100M --seed-ratio=0 --bt-detach-seed-only=true --seed-time=0 --enable-peer-exchange=true --bt-tracker=$($(curl -s https://raw.githubusercontent.com/XIU2/TrackersListCollection/master/all.txt) -notmatch '^\s*$' -join ',')"
$env:PLAYER_ARGUMENTS='--cache=yes --cache-dir=$ENV:Temp --cache-on-disk=yes --ytdl-raw-options=no-check-certificate=,yes-playlist=,hls-prefer-native=,ignore-errors=,write-auto-sub=,write-sub=,sub-lang="(en|zh).*"'
$env:STREAM_PLAYER_ARGUMENTS='--cache=yes --cache-dir=$ENV:Temp --cache-on-disk=yes'
Function aria2c {
  Invoke-Expression "aria2c.exe $env:DOWNLOADARGS `"$args`""
}
Function aria2c-bt-qBittorrent {
  Invoke-Expression "aria2c.exe $env:DOWNLOADARGS $env:TORRENTARGS --user-agent='qBittorrent/4.1.1' --peer-id-prefix='-qB4110-' `"$args`""
}
Function yt-dlp {
  Invoke-Expression "yt-dlp.exe $env:DLARGUMENTS `"$args`""
}
Function yt-dlp-1080 {
  Invoke-Expression "yt-dlp.exe $env:DLARGUMENTS -f 'bestvideo[height<=1080][vcodec^=avc]+bestaudio/best' `"$args`""
}
Function yt-dlp-720 {
  Invoke-Expression "yt-dlp.exe $env:DLARGUMENTS -f 'bestvideo[height<=720][fps<=30][vcodec^=avc]+bestaudio/best' `"$args`""
}

Function mpv-1080 {
  Invoke-Expression "mpv.com --ytdl-format=`"bestvideo[height<=1080][vcodec^=avc]+bestaudio/best`" $env:PLAYER_ARGUMENTS `"$args`""
}
Function mpv-720 {
  Invoke-Expression "mpv.com --ytdl-format=`"bestvideo[height<=720][fps<=30][vcodec^=avc]+bestaudio/best`" $env:PLAYER_ARGUMENTS `"$args`""
}
Function mpv-480 {
  Invoke-Expression "mpv.com --ytdl-format=`"bestvideo[height<=480][fps<=30][vcodec^=avc]+bestaudio/best`" $env:PLAYER_ARGUMENTS `"$args`""
}
Function mpv-4by3 {
  Invoke-Expression "mpv.com --video-aspect-override=4:3 $env:PLAYER_ARGUMENTS `"$args`""
}
Function mpv-16by9 {
  Invoke-Expression "mpv.com --video-aspect-override=16:9 $env:PLAYER_ARGUMENTS `"$args`""
}
Function mpv-audio {
  Invoke-Expression "mpv.com --no-video $env:PLAYER_ARGUMENTS `"$args`""
}
Function streamlink-mpv-best {
  streamlink.exe --loglevel debug --verbose-player --player 'mpv.com' --player-arg "$env:STREAM_PLAYER_ARGUMENTS" --title '{title}' --default-stream best "$args"
}
Function streamlink-mpv-1080 {
  streamlink.exe --loglevel debug --verbose-player --player 'mpv.com' --player-arg "$env:STREAM_PLAYER_ARGUMENTS" --title '{title}' --default-stream 1080p "$args"
}
Function streamlink-mpv-720 {
  streamlink.exe --loglevel debug --verbose-player --player 'mpv.com' --player-arg "$env:STREAM_PLAYER_ARGUMENTS" --title '{title}' --default-stream 720p "$args"
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
  $env:PATH = "$c2;$env:PATH"
  $env:PATH = "$c2\Scripts;$env:PATH"
  $env:PATH = "$c2\Library\bin;$env:PATH"
  Set-Alias pip2 "$c2\Scripts\pip.exe"
  Set-Alias conda2 "$c2\Scripts\conda.exe"
  Set-Alias python2 "$c2\python.exe"
  Function upgradeConda2 {
    Invoke-Expression "$c2\Scripts\conda.exe update --no-channel-priority --all --yes"
    Invoke-Expression "$c2\Scripts\conda.exe clean --yes --all"
  }
  Function upgradePip2 {
    Invoke-Expression "$c2\Scripts\pip.exe install --upgrade pip setuptools"
    Invoke-Expression "$c2\Scripts\pip.exe freeze -l > requirements.txt"
    (Get-Content requirements.txt).replace('==', '>=') | Set-Content requirements.txt
    Invoke-Expression "$c2\Scripts\pip.exe install -r requirements.txt --upgrade"
    Remove-Item requirements.txt
    Invoke-Expression "$c2\Scripts\pip.exe install --upgrade https://github.com/pyca/pyopenssl/archive/main.zip"
    Invoke-Expression "$c2\Scripts\pip.exe install --upgrade https://github.com/requests/requests/archive/main.zip"
  }
}

$c3 = getCondaPath(3)
if ($c3 -ne "") {
  $env:PATH = "$c3;$env:PATH"
  $env:PATH = "$c3\Scripts;$env:PATH"
  $env:PATH = "$c3\Library\bin;$env:PATH"
  Set-Alias pip3 "$c3\Scripts\pip.exe"
  Set-Alias conda3 "$c3\Scripts\conda.exe"
  Set-Alias python3 "$c3\python.exe"
  Function upgradeConda3 {
    Invoke-Expression "$c3\Scripts\conda.exe update --no-channel-priority --all --yes"
    Invoke-Expression "$c3\Scripts\conda.exe clean --yes --all"
  }
  Function upgradePip3 {
    Invoke-Expression "$c3\Scripts\pip.exe install --upgrade pip setuptools"
    Invoke-Expression "$c3\Scripts\pip.exe freeze -l > requirements.txt"
    (Get-Content requirements.txt).replace('==', '>=') | Set-Content requirements.txt
    Invoke-Expression "$c3\Scripts\pip.exe install -r requirements.txt --upgrade"
    Remove-Item requirements.txt
    Invoke-Expression "$c3\Scripts\pip.exe install --upgrade https://github.com/pyca/pyopenssl/archive/main.zip"
    Invoke-Expression "$c3\Scripts\pip.exe install --upgrade https://github.com/requests/requests/archive/main.zip"
  }
}

if(Test-Path -Path "$env:USERPROFILE\.npmrc") {
  $NPM_PACKAGES="$env:USERPROFILE\.npm-packages"
  $env:PATH="$NPM_PACKAGES;$NPM_PACKAGES\bin;$env:PATH"
  $env:NODE_PATH="$NPM_PACKAGES\lib\node_modules:$NODE_PATH"
  Function upgradeNpm {
    npm install -g npm@latest
    npm update -g
  }
}

Function Set-EnvPath($path) {
  if((Test-Path -Path "$path") -and ($env:PATH -NotLike "*$path*")) {
      $env:PATH = "$path;$env:PATH"
  }
}

Set-EnvPath("$env:ALLUSERSPROFILE\chocolatey\bin")
Set-EnvPath("$env:ProgramFiles\7-Zip")
Set-EnvPath("$env:ProgramFiles\OpenSSH-Win64")
Set-EnvPath("$env:ProgramFiles\Microsoft VS Code")
Set-EnvPath("$env:ProgramFiles\Microsoft VS Code Insiders")
Set-EnvPath("$env:ProgramFiles\VSCodium\bin")
Set-EnvPath("$env:ProgramFiles\Nmap")
Set-EnvPath("$env:ProgramFiles (x86)\Nmap")
Set-EnvPath("$env:USERPROFILE\scoop\shims")
Set-EnvPath("$env:USERPROFILE\scoop\apps\mpv\current")
Set-EnvPath("$env:USERPROFILE\scoop\apps\mpv-git\current")
Set-EnvPath("$env:USERPROFILE\scoop\apps\vscode\current\bin")
Set-EnvPath("$env:LOCALAPPDATA\Android\sdk\platform-tools")
Set-EnvPath("$env:USERPROFILE\go\bin")
Set-EnvPath("$env:ProgramFiles\Docker\Docker\Resources\bin")

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

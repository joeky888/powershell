# Python2 UTF8
$env:PYTHONIOENCODING = "UTF-8"
# Java UTF8
$env:JAVA_TOOL_OPTIONS = " -Dfile.encoding=UTF8 "

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
    $clipboard = $clipboard -replace "&","``&"
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($clipboard)
  }
}


# Set default starting path to USERPROFILE
if (Test-Path("$env:USERPROFILE\\Desktop")) {
  Set-Location $env:USERPROFILE\\Desktop
} else {
  # Windows XP doesn't have Desktop
  Set-Location $env:USERPROFILE
}

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
  } catch [Exception] {
    # Older version of powershell doesn't support special characters
  }
  Write-Host  "$env:username" -NoNewline -ForegroundColor Red
  Write-Host "@" -NoNewline
  Write-Host "$env:computername" -NoNewline -ForegroundColor Green
  Write-Host " " -NoNewline
  # Use full path since it's easier to understand for newbies
#   Write-Host "$PWD".Replace("$HOME", "~") -ForegroundColor Yellow
  Write-Host "$PWD" -ForegroundColor Cyan
  try {
   Write-Host  "$([Char]9584)$([Char]9472)" -NoNewline
  } catch [Exception] {
    # Older version of powershell doesn't support special characters
  }
  Write-Host "$" -NoNewline
  Return " "
}

# alias bash/zsh command
New-Alias which get-command
New-Alias grep select-string
Remove-Item alias:cd
Remove-Item alias:grep
Remove-Item alias:rm
Function cd {
  if ($args.count -gt 0) {
    Set-Location $($args)
  } else {
    Set-Location $($env:USERPROFILE)
  }
}
Function find {
  Get-ChildItem -Recurse -Filter "*$args*"
}
Function grep {
  $pipeline = $input | Out-String -stream
  if ($pipeline.length -gt 0) {
    $pipeline | Out-String -stream | Select-String $args | Select Path, LineNumber, Line | Format-List
  } else {
    Get-ChildItem -recurse | Select-String $args | Select Path, LineNumber, Line | Format-List
  }
}
Function rm {
  Remove-Item -Recurse -Force $args
}
Function touch {
  echo $null >> $args
}
Function uname {
  try {
    $computerSystem = Get-CimInstance CIM_ComputerSystem
    $computerBIOS = Get-CimInstance CIM_BIOSElement
    $computerOS = Get-CimInstance CIM_OperatingSystem
    $computerCPU = Get-CimInstance CIM_Processor
    $computerHDD = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID = 'C:'"

    Write-Host "System Information for: " $computerSystem.Name -BackgroundColor DarkRed
    "Manufacturer: " + $computerSystem.Manufacturer
    "Model: " + $computerSystem.Model
    "Serial Number: " + $computerBIOS.SerialNumber
    "CPU: " + $computerCPU.Name
    "HDD Capacity: "  + "{0:N2}" -f ($computerHDD.Size/1GB) + "GB"
    "HDD Space: " + "{0:P2}" -f ($computerHDD.FreeSpace/$computerHDD.Size) + " Free (" + "{0:N2}" -f ($computerHDD.FreeSpace/1GB) + "GB)"
    "RAM: " + "{0:N2}" -f ($computerSystem.TotalPhysicalMemory/1GB) + "GB"
    "Operating System: " + $computerOS.caption + ", Service Pack: " + $computerOS.ServicePackMajorVersion
    "User logged In: " + $computerSystem.UserName
    "Last Reboot: " + $computerOS.LastBootUpTime
    wmic path win32_VideoController get name
  } catch [Exception] {
    # Older version of powershell doesn't support Get-CimInstance
    Get-WmiObject Win32_OperatingSystem
  }
  Get-PSDrive -PSProvider 'FileSystem'
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

# Command to upgrade all Conda packages
Function upgradeConda {
  conda update -n base conda -y
  conda update --all --yes
}
Function upgradeYoutube-dl {
  pip install --upgrade https://github.com/rg3/youtube-dl/archive/master.zip
}
Function upgradeYou-get {
  pip install --upgrade https://github.com/soimort/you-get/archive/master.zip
}
Function upgradePip {
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
Function upgradeProfile {
  Invoke-WebRequest https://raw.githubusercontent.com/j16180339887/powershell/master/profile.ps1 -o ~/Documents/WindowsPowerShell/profile.ps1
}
Function upgradeVimrc {
  Invoke-WebRequest https://raw.githubusercontent.com/j16180339887/vimrc/master/.vimrc -o ~/.vimrc
}

Function vim {
  if ($args.count -eq 0) {
    vim.exe -u NONE +"syntax enable" +"colo murphy"
  } else {
    vim.exe -u NONE +"syntax enable" +"colo murphy" $args
  }
}

Function gvim {
  $Commandvim = "$env:ALLUSERSPROFILE\chocolatey\bin\gvim.exe"
  $Parmsvim = ""
  if ($args.count -gt 0) {
    $Parmsvim = "-p --remote-tab-silent $args"
    $Parmsvim = $Parmsvim.Split(" ")
  }
  & "$Commandvim" $Parmsvim
}

$env:DOWNLOADARGS="--continue=true --file-allocation=none --check-certificate=false --content-disposition-default-utf8=true --max-tries=0 --max-concurrent-downloads=150 --max-connection-per-server=16 --split=16 --min-split-size=1M --bt-max-peers=0 --bt-request-peer-speed-limit=100M --seed-ratio=0 --bt-detach-seed-only=true --parameterized-uri=true"
Function aria2c {
  Invoke-Expression "aria2c.exe $env:DOWNLOADARGS '$args'"
}
Function aria2c-asus-proxy {
  Invoke-Expression "aria2c.exe $env:DOWNLOADARGS --all-proxy=kungfu:howkungfu@10.78.20.186:3128 --all-proxy-user=kungfu --all-proxy-passwd=howkungfu '$args'"
}
Function aria2c-asus-cert {
  Invoke-Expression "aria2c.exe --check-certificate=true --ca-certificate=$env:USERPROFILE\\Documents\\asus.com.crt -c -s16 -k1M -x16 '$args'"
}
Function youtube-dl {
  youtube-dl.exe -o "%(title)s.%(ext)s" -f "bestvideo[height<=1080][fps<=30]+bestaudio/best" --write-sub --sub-lang zh-TW,zh-Hant,zh-CN,zh-Hans,en,enUS,English --ignore-errors --external-downloader aria2c --external-downloader-args $env:DOWNLOADARGS $args
}
Function youtube-dl-mp3 {
  youtube-dl.exe -o "%(title)s.%(ext)s" --extract-audio --audio-format mp3 --write-sub --sub-lang zh-TW,zh-Hant,zh-CN,zh-Hans,en,enUS,English --ignore-errors --external-downloader aria2c --external-downloader-args $env:DOWNLOADARGS $args
}
set-alias mp3 youtube-dl-mp3

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
  while($true)
  {
    Reset-Networking
    Start-Sleep -s 600
  }
}

Function MtuForWifiGaming {
  netsh interface ipv4 set subinterface Wi-Fi mtu=296  store=persistent
}
Function MtuForWifiNormal {
  netsh interface ipv4 set subinterface Wi-Fi mtu=1500 store=persistent
}

if(Test-Path -Path "$env:ALLUSERSPROFILE\chocolatey\bin*") {
  # Just in case
  if($env:Path -NotLike "*$env:ALLUSERSPROFILE\chocolatey\bin*") {
    $env:Path += ";$env:ALLUSERSPROFILE\chocolatey\bin"
  }
}
if(Test-Path -Path "$env:ALLUSERSPROFILE\Miniconda2*") {
  # choco install miniconda
  if($env:Path -NotLike "*$env:ALLUSERSPROFILE\Miniconda2*") {
    $env:Path = "$env:ALLUSERSPROFILE\Miniconda2;$env:Path"
    $env:Path = "$env:ALLUSERSPROFILE\Miniconda2\Scripts;$env:Path"
  }
  Set-Alias pip2 $env:ALLUSERSPROFILE\Miniconda2\Scripts\pip.exe
  Set-Alias conda2 $env:ALLUSERSPROFILE\Miniconda2\Scripts\conda.exe
  Set-Alias python2 $env:ALLUSERSPROFILE\Miniconda2\python.exe
  Function upgradeConda2 {
    Invoke-Expression "$env:ALLUSERSPROFILE\Miniconda2\Scripts\conda.exe update -n base conda -y"
    Invoke-Expression "$env:ALLUSERSPROFILE\Miniconda2\Scripts\conda.exe update --all --yes"
  }
  Function upgradePip2 {
    Invoke-Expression "$env:ALLUSERSPROFILE\Miniconda2\Scripts\pip.exe freeze -l > requirements.txt"
    (Get-Content requirements.txt).replace('==', '>=') | Set-Content requirements.txt
    Invoke-Expression "$env:ALLUSERSPROFILE\Miniconda2\Scripts\pip.exe install -r requirements.txt --upgrade"
    Remove-Item requirements.txt
    Invoke-Expression "$env:ALLUSERSPROFILE\Miniconda2\Scripts\pip.exe install --upgrade https://github.com/pyca/pyopenssl/archive/master.zip"
    Invoke-Expression "$env:ALLUSERSPROFILE\Miniconda2\Scripts\pip.exe install --upgrade https://github.com/requests/requests/archive/master.zip"
  }
} elseif(Test-Path -Path "C:\ProgramData\Miniconda2*") {
  # choco install miniconda
  if($env:Path -NotLike "*C:\ProgramData\Miniconda2*") {
    $env:Path = "C:\ProgramData\Miniconda2;$env:Path"
    $env:Path = "C:\ProgramData\Miniconda2\Scripts;$env:Path"
  }
  Set-Alias pip2 C:\ProgramData\Miniconda2\Scripts\pip.exe
  Set-Alias conda2 C:\ProgramData\Miniconda2\Scripts\conda.exe
  Set-Alias python2 C:\ProgramData\Miniconda2\python.exe
  Function upgradeConda2 {
    Invoke-Expression "C:\ProgramData\Miniconda2\Scripts\conda.exe update -n base conda -y"
    Invoke-Expression "C:\ProgramData\Miniconda2\Scripts\conda.exe update --all --yes"
  }
  Function upgradePip2 {
    Invoke-Expression "C:\ProgramData\Miniconda2\Scripts\pip.exe freeze -l > requirements.txt"
    (Get-Content requirements.txt).replace('==', '>=') | Set-Content requirements.txt
    Invoke-Expression "C:\ProgramData\Miniconda2\Scripts\pip.exe install -r requirements.txt --upgrade"
    Remove-Item requirements.txt
    Invoke-Expression "C:\ProgramData\Miniconda2\Scripts\pip.exe install --upgrade https://github.com/pyca/pyopenssl/archive/master.zip"
    Invoke-Expression "C:\ProgramData\Miniconda2\Scripts\pip.exe install --upgrade https://github.com/requests/requests/archive/master.zip"
  }
}
if(Test-Path -Path "$env:ALLUSERSPROFILE\Miniconda3*") {
  # choco install miniconda3
  if($env:Path -NotLike "*$env:ALLUSERSPROFILE\Miniconda3*") {
    $env:Path += ";$env:ALLUSERSPROFILE\Miniconda3"
    $env:Path += ";$env:ALLUSERSPROFILE\Miniconda3\Scripts"
  }
  Set-Alias pip3 $env:ALLUSERSPROFILE\Miniconda3\Scripts\pip.exe
  Set-Alias conda3 $env:ALLUSERSPROFILE\Miniconda3\Scripts\conda.exe
  Set-Alias python3 $env:ALLUSERSPROFILE\Miniconda3\python.exe
  Function upgradeConda3 {
    Invoke-Expression "$env:ALLUSERSPROFILE\Miniconda3\Scripts\conda.exe update -n base conda -y"
    Invoke-Expression "$env:ALLUSERSPROFILE\Miniconda3\Scripts\conda.exe update --all --yes"
  }
  Function upgradePip3 {
    Invoke-Expression "$env:ALLUSERSPROFILE\Miniconda3\Scripts\pip.exe freeze -l > requirements.txt"
    (Get-Content requirements.txt).replace('==', '>=') | Set-Content requirements.txt
    Invoke-Expression "$env:ALLUSERSPROFILE\Miniconda3\Scripts\pip.exe install -r requirements.txt --upgrade"
    Remove-Item requirements.txt
    Invoke-Expression "$env:ALLUSERSPROFILE\Miniconda3\Scripts\pip.exe install --upgrade https://github.com/pyca/pyopenssl/archive/master.zip"
    Invoke-Expression "$env:ALLUSERSPROFILE\Miniconda3\Scripts\pip.exe install --upgrade https://github.com/requests/requests/archive/master.zip"
  }
}
if(Test-Path -Path "C:\Program Files\Sublime Text 3*") {
  # choco install sublimetext3
  if($env:Path -NotLike "*C:\Program Files\Sublime Text 3*") {
    $env:Path += ";C:\Program Files\Sublime Text 3"
  }
}
if(Test-Path -Path "C:\Program Files\Sublime Text 2*") {
  # choco install sublimetext2
  if($env:Path -NotLike "*C:\Program Files\Sublime Text 2*") {
    $env:Path += ";C:\Program Files\Sublime Text 2"
  }
}
if(Test-Path -Path "C:\Program Files\Microsoft VS Code*") {
  # VS code insider
  if($env:Path -NotLike "*C:\Program Files\Microsoft VS Code*") {
    $env:Path += ";C:\Program Files\Microsoft VS Code"
  }
}
if(Test-Path -Path "C:\Program Files\Microsoft VS Code Insiders*") {
  # VS code insider
  if($env:Path -NotLike "*C:\Program Files\Microsoft VS Code Insiders*") {
    $env:Path += ";C:\Program Files\Microsoft VS Code Insiders"
  }
}
if(Test-Path -Path "C:\Program Files\Nmap*") {
  # choco install nmap
  if($env:Path -NotLike "*C:\Program Files\Nmap*") {
    $env:Path += ";C:\Program Files\Nmap"
  }
}
if(Test-Path -Path "C:\Program Files (x86)\Nmap*") {
  # choco install nmap
  if($env:Path -NotLike "*C:\Program Files (x86)\Nmap*") {
    $env:Path += ";C:\Program Files (x86)\Nmap"
  }
}
if (Test-Path -Path "C:\zulu"){
  # Download openjdk from Zulu
  $env:JAVA_HOME="C:\zulu"
  if($env:Path -NotLike "*C:\zulu\bin*") {
    $env:Path += ";C:\zulu\bin"
  }
}
if (Test-Path -Path "C:\Program Files\Oracle\VirtualBox"){
  # choco install virtualbox
  if($env:Path -NotLike "*C:\Program Files\Oracle\VirtualBox*") {
    $env:Path += ";C:\Program Files\Oracle\VirtualBox"
  }
}

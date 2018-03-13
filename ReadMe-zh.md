![PS](https://i.imgur.com/onDinT2.png)

中文版的說明比較簡潔，且不會時常更新

特色
=====
* 沒有插件，只有一個檔案需要下載
* 預設啟動的路徑為桌面
* 智慧的 tab 補全
* 支援 Powershell ISE
* 支援 Powershell 2 以上 (Windows XP+)
* UTF-8

## 下載到 Windows 8+ (一行一行複製貼上即可)

```sh
# Install this config, Open powershell (as administrator)
Set-ExecutionPolicy RemoteSigned -Force
New-Item -ItemType file -Force -Path $profile
Invoke-WebRequest https://raw.githubusercontent.com/j16180339887/powershell/master/profile.ps1 -o $profile
Unblock-File $profile
```

## 下載到 Windows XP and Windows 7 (一行一行複製貼上即可)

```sh
# Open powershell (as administrator)
Set-ExecutionPolicy RemoteSigned -Force
New-Item -ItemType file -Force -Path $profile
$url = "https://raw.githubusercontent.com/j16180339887/powershell/master/profile.ps1"
$path = $profile

if(!(Split-Path -parent $path) -or !(Test-Path -pathType Container (Split-Path -parent $path))) {
  $targetFile = Join-Path $pwd (Split-Path -leaf $path)
}

(New-Object System.Net.WebClient).DownloadFile($url, $path)
```

| Keys      | Action                                                | Description |
| --------- | ----------------------------------------------------- | ----------- |
| Ctrl C    | 複製/撤銷 當前指令                                    | |
| Ctrl V    | 貼上                                                  | 自動跳脫 & 符號 |
| Ctrl D    | 關閉 Powershell                                       | |
| Ctrl Z    | Undo                                                  | |
| Ctrl Y    | Redo                                                  | |
| Ctrl L    | 清空                                                  | |
| Ctrl O    | 在當前路徑打開檔案總管                                | |
| ↑         | 前一個指令                                            | |
| ↓         | 下一個指令                                            | |
| Shift+Insert  |  貼上                                             | 直接貼上，無跳脫字元 |

## 額外的指令

| Command           | Action                                                                                    | Description |
| ----------------- | ----------------------------------------------------------------------------------------- | ----------- |
| upgradeProfile    | 升級 [這個檔案](profile.ps1)       | Windows8+ only |

## 額外的 Linux 指令

| Command           | Action                                                                                    | Example       |
| ----------------- | ----------------------------------------------------------------------------------------- | -------------                     |
| which             | 查看指令來源                                                                              | `which python`                    |
| find              | 在當前資料夾搜尋檔案                                                                      | `find bun.htm`                    |
| grep              | 在當前資料夾搜尋字串 / 在 stdout 管線搜尋字串                                             | `grep TODO` 或 `echo hi \| grep h` |
| touch             | 建立一個空檔案                                                                            | `touch 1.txt`                     |
| uname             | 系統資訊                                                                                  | `uname`                           |

### 另外

* 環境變數 `PYTHONIOENCODING` 以及 `JAVA_TOOL_OPTIONS` 已經設定為 UTF-8
* 支援度最好的字體是 [Sarasa-Gothic](https://github.com/be5invis/Sarasa-Gothic/releases) (原本是叫 [Iosevka](https://github.com/be5invis/Iosevka/releases)), 由微軟員工設計的. 詳見 [這篇問答](https://www.zhihu.com/question/19637242/answer/41116173)


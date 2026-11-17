# token-usage installer for Windows (PowerShell)
$ErrorActionPreference = 'Stop'
$src      = Join-Path $PSScriptRoot 'token-usage'
$dest     = Join-Path $env:USERPROFILE '.claude\mods\token-usage'
$settings = Join-Path $env:USERPROFILE '.claude\settings.json'

New-Item -ItemType Directory -Force (Split-Path $dest) | Out-Null
if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
Copy-Item -Recurse $src $dest

if (-not (Test-Path $settings)) { Set-Content $settings '{}' -Encoding utf8 }
Copy-Item $settings "$settings.bak-token-usage" -Force

$j = Get-Content $settings -Raw | ConvertFrom-Json
if (-not $j.PSObject.Properties['env']) { $j | Add-Member -NotePropertyName env -NotePropertyValue ([pscustomobject]@{}) }
$d = $dest -replace '\','/'
$j.env | Add-Member -Force -NotePropertyName CLAUDE_CODE_PLUGIN_DIRS -NotePropertyValue $d
$j.env | Add-Member -Force -NotePropertyName CLAUDE_CODE_PLUGIN_DIR_WATCH -NotePropertyValue '1'
$j | ConvertTo-Json -Depth 20 | Set-Content $settings -Encoding utf8

Write-Host "已安装到 $dest"
Write-Host "设置已更新（备份：$settings.bak-token-usage）"
Write-Host "请完全关闭并重新打开 Claude Desktop 或 VS Code。"

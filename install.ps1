#!/usr/bin/env pwsh
# Copyright 2018-2022 the Deno authors. All rights reserved. MIT license.
# TODO(everyone): Keep this script simple and easily auditable.

$ErrorActionPreference = 'Stop'

if ($v) {
  $Version = "v${v}"
}
if ($Args.Length -eq 1) {
  $Version = $Args.Get(0)
}

$ZcliInstall = $env:ZCLI_INSTALL
$BinDir = if ($ZcliInstall) {
  "${ZcliInstall}\bin"
} else {
  "${Home}\.zerops\bin"
}

$ZcliZip = "$BinDir\zerops.zip"
$ZcliExe = "$BinDir\zcli.exe"
$Target = 'win-x64'

$DownloadUrl = if (!$Version) {
  "https://github.com/zeropsio/zcli/releases/latest/download/zcli-${Target}.exe"
} else {
  "https://github.com/zeropsio/zcli/releases/download/${Version}/zcli-${Target}.exe"
}

if (!(Test-Path $BinDir)) {
  New-Item $BinDir -ItemType Directory | Out-Null
}

curl.exe -Lo $ZcliZip $DownloadUrl

tar.exe xf $ZcliZip -C $BinDir

Remove-Item $ZcliZip

$User = [System.EnvironmentVariableTarget]::User
$Path = [System.Environment]::GetEnvironmentVariable('Path', $User)
if (!(";${Path};".ToLower() -like "*;${BinDir};*".ToLower())) {
  [System.Environment]::SetEnvironmentVariable('Path', "${Path};${BinDir}", $User)
  $Env:Path += ";${BinDir}"
}

Write-Output "Zcli was installed successfully to ${ZcliExe}"
Write-Output "Run 'zcli --help' to get started"
Write-Output "Stuck? Join our Discord https://discord.com/invite/WDvCZ54"

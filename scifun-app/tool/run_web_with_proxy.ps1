$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot

Push-Location $projectRoot
try {
  Write-Host "Starting CORS proxy on http://192.168.11.61 ..."
  $proxy = Start-Process -FilePath "dart" -ArgumentList @("run", "tool/cors_proxy.dart") -PassThru

  Start-Sleep -Seconds 2

  Write-Host "Starting Flutter Web ..."
  flutter run -d chrome
}
finally {
  if ($null -ne $proxy -and -not $proxy.HasExited) {
    Stop-Process -Id $proxy.Id -Force
  }
  Pop-Location
}

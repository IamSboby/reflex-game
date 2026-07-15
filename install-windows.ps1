$ErrorActionPreference = 'Stop'
$Python = Get-Command python -ErrorAction Stop
$Source = Split-Path -Parent $MyInvocation.MyCommand.Path
$Destination = Join-Path $env:LOCALAPPDATA 'ReflexGame'
$Public = Join-Path $Destination 'public'
New-Item -ItemType Directory -Force -Path $Public | Out-Null
Copy-Item (Join-Path $Source 'server.py') $Destination -Force
$Files = 'index.html','app.js','styles.css','effects.css','mobile.css','countdown.css','fixes.css','error-feedback.css','slider-effects.css'
foreach ($File in $Files) { Copy-Item (Join-Path $Source $File) $Public -Force }
$Action = New-ScheduledTaskAction -Execute $Python.Source -Argument "`"$Destination\server.py`"" -WorkingDirectory $Destination
$Trigger = New-ScheduledTaskTrigger -AtLogOn
$Settings = New-ScheduledTaskSettingsSet -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1)
Register-ScheduledTask -TaskName 'ReflexGame' -Action $Action -Trigger $Trigger -Settings $Settings -Force | Out-Null
$env:REFLEX_PORT='8080'; $env:REFLEX_ROOT=$Public
Start-Process -FilePath $Python.Source -ArgumentList "`"$Destination\server.py`"" -WorkingDirectory $Destination -WindowStyle Hidden
Write-Host 'Reflex Game is available at http://localhost:8080/'

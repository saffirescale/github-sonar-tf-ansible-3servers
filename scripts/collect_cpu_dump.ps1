# PowerShell script to collect basic diagnostics on Windows
$now = Get-Date -Format yyyyMMddHHmmss
$out = "C:\cpu_dump_$now"
New-Item -Path $out -ItemType Directory -Force | Out-Null
Get-Process | Sort-Object CPU -Descending | Select-Object -First 50 | Out-File "$out\processes.txt"
Get-Counter -Counter '\Processor(_Total)\% Processor Time' -SampleInterval 1 -MaxSamples 5 | Out-File "$out\cpu_counter.txt"
Get-EventLog -LogName System -Newest 100 | Out-File "$out\system_events.txt"
Compress-Archive -Path $out -DestinationPath "C:\cpu_snapshot_$now.zip"
Write-Output "Saved diagnostics to C:\cpu_snapshot_$now.zip"

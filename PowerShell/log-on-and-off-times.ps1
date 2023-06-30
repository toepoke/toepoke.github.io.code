# See https://toepoke.github.io/2018/08/04/log-on-and-off-times.html
Get-EventLog -LogName System -Source Microsoft-Windows-Power-Troubleshooter,Microsoft-Windows-Kernel-Power -After (Get-Date).AddDays (-5) | Sort-Object Index | Select-Object @{Name='WhenLogged';Expression={Get-Date $_.TimeWritten -Format 'ddd dd-MMM-yy HH:mm'} };

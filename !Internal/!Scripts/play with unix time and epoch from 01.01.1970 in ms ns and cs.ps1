$unixEpochStart = New-Object DateTime 1970,1,1,0,0,0,([DateTimeKind]::Utc)
$now = Get-Date
$EpochMilliSeconds = [int64]((([datetime]$now) - $unixEpochStart).TotalMilliseconds)
$EpochNanoSeconds = [int64]((([datetime]$now) - $unixEpochStart).TotalMilliseconds*1000)
$EpochPicoSeconds = [int64]((([datetime]$now) - $unixEpochStart).TotalMilliseconds*1000000)
$UNIXDateMS = $EpochStart.AddMilliseconds($EpochMilliSeconds)
Write-Host -ForegroundColor Yellow $UNIXDateMS.ToString('dd.MM.yyyy HH:mm:ss:ffff')
$test = [int64](([datetime]::UtcNow)-(get-date "1/1/1970")).TotalMilliseconds
$UNIXDateMS = $EpochStart.AddMilliseconds($test)
$UNIXDateMS
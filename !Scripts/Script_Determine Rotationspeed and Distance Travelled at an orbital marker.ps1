
$OmRadius = 10758000 # FROM GAME FILES
$RotationSpeedInHours = 5.0999999 #2,48 hours decimal, 2hours, 28mins and 48secs FROM GAME FILES
$RotationSpeedInMinutes = $RotationSpeedInHours*60 
$RotationSpeedInSeconds = $RotationSpeedInHours*3600

#Kreisumfang
$Circumference360Degrees = [Math]::PI * 2 * $OMRadius
$Circumference1Degree = $Circumference360Degrees / 360

#Distance travelled
$DistanceTravelledPerSecond = $Circumference360Degrees / $RotationSpeedInSeconds
$DistanceTravelledPerMinute = $Circumference360Degrees / $RotationSpeedInMinutes
$DistanceTravelledPerHour   = $Circumference360Degrees / $RotationSpeedInHours

#Results
$DistanceTravelledPerSecond
$DistanceTravelledPerMinute 
$DistanceTravelledPerHour 
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{  
  $arguments = "& '" +$myinvocation.mycommand.definition + "'"
  Start-Process powershell -Verb runAs -ArgumentList $arguments
  Break
}


$LogfileLauncher = "$env:APPDATA\rsilauncher\log.log"
$CurrentGameDetails = Get-Content -Path $LogfileLauncher | Select-String -Pattern "Launching Star Citizen" | Select-Object -Last 1
$GameDir = ($CurrentGameDetails.Line.split('(').split(')').replace("\\","\"))[1]

$CacheFolders = @(
    "$env:APPDATA\rsilauncher\Cache"
    "$env:APPDATA\rsilauncher\GPUCache"
    "$env:LOCALAPPDATA\Star Citizen"
    "$GameDir\USER\Client\0\shaders\cache"
)

foreach($folder in $CacheFolders){
    Get-ChildItem -Path $folder -Recurse | Foreach-object {Remove-item -Recurse -path $_.FullName }
}
#if($env:TERM_PROGRAM -eq "vscode"){$script:ScriptDir = $psEditor.GetEditorContext().CurrentFile.Path -replace '[^\\]+$'}
#if($env:TERM_PROGRAM -eq "vscode"){$script:ScriptDir = "C:\Users\marcel\Desktop\StarCitizen Tools\Projekt Jericho (3D Navigation)_V6"}
#$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
#if($psISE){$script:ScriptDir = Split-Path -Path $psISE.CurrentFile.FullPath}
#if((Get-Host).Version.Major -gt "5"){$script:ScriptDir = $PSScriptRoot}
#else{$script:ScriptDir = $PSScriptRoot}
Start-Sleep -Seconds 3
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
$ScriptFile = $MyInvocation.MyCommand.Path
Write-Host $test
Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -file $ScriptFile"
Pause
if(!(Get-Module -ListAvailable -Name "PSReadLine")){
	Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
	Install-Module "PSReadLine" -RequiredVersion 2.1.0
}

if ($host.UI.SupportsVirtualTerminal){
	$esc = [char]0x1b
	"Colorcoding${esc}[93m Example${esc}[0m is available. Your Powershell Version"
}
else{
	"no color coding available"
}

if((Get-Host).Version.Major -eq "5"){
	(Get-Host).Version
}
else {
	(Get-Host).Version
}

pause
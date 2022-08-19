#Set Current Script Directory
if($psISE){$script:ScriptDir = Split-Path -Path $psISE.CurrentFile.FullPath}
if((Get-Host).Version.Major -gt "5"){$script:ScriptDir = $PSScriptRoot}else{$script:ScriptDir = $PSScriptRoot}
if($env:TERM_PROGRAM -eq "vscode"){$script:ScriptDir = "C:\Users\marcel\Desktop\StarCitizen Tools\Projekt Jericho (3D Navigation)_V6"}
if($env:TERM_PROGRAM -eq "vscode"){$script:ScriptDir = "C:\Users\marcel\Desktop\StarCitizen Tools\Project The Verse Mapper"}
Set-Location $script:ScriptDir

#RUN CODE AS PS7, SINCE VSCODE ISE CANT RUN AS HASHTABLE
$Content = Get-Content -Raw -Path ".\Data\Database.json" | Out-String
$JsonTable = $Content | ConvertFrom-Json -AsHashtable

#CONTAINERS 
$JsonContainerData = @()
$JsonPOIData = @()

foreach($Container in $JsonTable.Containers.GetEnumerator()){
    #rite-host -ForegroundColor Green $Container.Name 
    #$Container.Value.

    $ContainerData = [PSCustomObject]@{
        Name           = $Container.Name 
        QTMarker       = $Container.Value.QTMarker
        XPos           = $Container.Value.X
        YPos           = $Container.Value.Y
        ZPos           = $Container.Value.Z
        OMRadius       = $Container.Value.'OM Radius'
        BodyRadius     = $Container.Value.'Body Radius'
        ArrivalRadius  = $Container.Value.'Arrival Radius'
        RotSpeed       = $Container.Value.'Rotation Speed'
        RotAdjust      = $Container.Value.'Rotation Adjust'
        OrbSpeed       = $Container.Value.'Orbital Speed'
        OrbAngle       = $Container.Value.'Orbital Angle'
        TimeLines      = $Container.Value.'Time Lines'
        POIS = @(
            $Container.Value.POI.GetEnumerator() 
        )
    }
    $JsonContainerData += $ContainerData

    foreach ($POI in $Container.Value.POI.GetEnumerator()){
        #write-host -ForegroundColor Red $POI.Name
        #$POI.Value | Select-Object Container,Name,x,y,z,QTMarker

        $POIData = [PSCustomObject]@{
            Name           = $POI.Name 
            QTMarker       = $POI.Value.QTMarker
            XPos           = $POI.Value.X
            YPos           = $POI.Value.Y
            ZPos           = $POI.Value.Z
            Container      = $POI.Value.Container
        }
        $JsonPOIData += $POIData
    }
    
}

$JsonContainerData | Sort-Object -Property Name | Format-Table
$JsonPOIData | Sort-Object -Property Container,Name | Format-Table
$JsonPOIData.Count
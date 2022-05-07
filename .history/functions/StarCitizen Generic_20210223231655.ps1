function Get-StarCitizenClipboardAndDate{
    $ClipboardContentRAW = (Get-Clipboard) -replace '(^\s+|\s+$)','' -replace '\s+',' '
    $ClipboardContentSplit = $ClipboardContentRAW.split("x:").split("y:").split("z:") #GET CURRENT COORDS FROM CLIPBOARD
    #CHECK IF CLIPBOARD CONTAINS COORDINATES
    if ($ClipboardContentRAW -like '*Coordinates: x:*'){
        $ClipboardContainsCoordinates = $true 
        $CurrentXPosition = $ClipboardContentSplit[1]
        $CurrentYPosition = $ClipboardContentSplit[2]
        $CurrentZPosition = $ClipboardContentSplit[3]
        if($CurrentXPosition -ne $PreviousXPosition -or $CurrentYPosition -ne $PreviousYPosition -or $CurrentZPosition -ne $PreviousZPosition){
            $NTPServer = "ptbtime1.ptb.de"
            $DateTime = Get-NTPDateTime -sNTPServer $NTPServer
            #Write-Host -ForegroundColor Yellow $DateTime.ToString('HH:mm:ss:ffff')
        }
    }
    return $ClipboardContainsCoordinates, $CurrentXPosition, $CurrentYPosition
}
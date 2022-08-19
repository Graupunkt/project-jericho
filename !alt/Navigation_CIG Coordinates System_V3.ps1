# Script to use CIG Coordinate System with Status Update

##################
### Parameters ###
##################
#SELECT CURRENT POI / DESTINATION FROM HASBTABLE LINE 22
$CurrentDestination = "IMS-Jericho"
$CurrentReference = "MIC-L1-Shallow-Frontier"
$DistanceGreen = "1000"  # Set Distance in meters when values should turn green (1km)
$DistanceYellow = "100000" # Set Distance in meters when values should turn yellow (100km)
#$DistanceGreen = "10000000"  # Set Distance in meters when values should turn green (10.000 km)
#$DistanceYellow = "1000000000000" # Set Distance in meters when values should turn yellow (100.000.00km)

#GLOBAl PARAMETERS
$ClipboardContent = ""
$CurrentXPosition = 0
$CurrentYPosition = 0
$CurrentZPosition = 0

##################
### HASHTABLES ###
##################
# KNOWN DESTINATIONs BY NAME, X COORD, Y COORD, z COORD
$DestinationData = @{
    "IMS-Jericho" = "20196776410.415634;33456387485.680557;2896115.502795"
    "ProcyonWreckSite" = "-19592.19;-10462.193;3056.932"
}

$ObjectContainerData = @{
    "Cellin" = "12905757.636;40955.551;0"
    "MIC-L1" = "20215824.238;33467065.008;0"
    "MIC-L1-Shallow-Frontier" = "20215808582.526974;33466996827.765518;767.452183"
}


##################
### USER INPUT ###
##################

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")  

# Source = https://sysadminemporium.wordpress.com/2012/12/07/powershell-gui-for-your-scripts-episode-3/
# OUTER WINDOW
$Form = New-Object System.Windows.Forms.Form    
$Form.Size = New-Object System.Drawing.Size(250,450)  

# SELECTION BOX1
$groupBox = New-Object System.Windows.Forms.GroupBox
$groupBox.Location = New-Object System.Drawing.Size(20,60) 
$groupBox.size = New-Object System.Drawing.Size(200,200) 
$groupBox.text = "Select Destination:" 
$Form.Controls.Add($groupBox) 

# FIRST BUTTON
$RadioButton1 = New-Object System.Windows.Forms.RadioButton 
$RadioButton1.Location = new-object System.Drawing.Point(5,20) 
$RadioButton1.size = New-Object System.Drawing.Size(190,20) 
$RadioButton1.Checked = $true 
$RadioButton1.Text = "NavyStation - INS-Jericho" 
$groupBox.Controls.Add($RadioButton1) 

# SECOND BUTTON
$RadioButton2 = New-Object System.Windows.Forms.RadioButton 
$RadioButton2.Location = new-object System.Drawing.Point(5,40) 
$RadioButton2.size = New-Object System.Drawing.Size(190,20) 
$RadioButton2.Text = "Wreck Site - Procyon " 
$groupBox.Controls.Add($RadioButton2) 

# THIRD BUTTON
$RadioButton3 = New-Object System.Windows.Forms.RadioButton 
$RadioButton3.Location = new-object System.Drawing.Point(5,60) 
$RadioButton3.size = New-Object System.Drawing.Size(190,20) 
$RadioButton3.Text = "Reserved" 
$groupBox.Controls.Add($RadioButton3) 

# DEFINE SELECT BUTTON
$Button = New-Object System.Windows.Forms.Button 
$Button.Location = New-Object System.Drawing.Size(80,10) 
$Button.Size = New-Object System.Drawing.Size(80,40) 
$Button.Text = "SELECT" 

# ADD FUNCTION THAT CAN BE SELECTED / EXECUTED
$Button.Add_Click({
    if ($RadioButton1.Checked -eq $true) {$CurrentDestination = "IMS-Jericho"}
    if ($RadioButton2.Checked -eq $true) {$CurrentDestination = "ProcyonWreckSite"}
    if ($RadioButton3.Checked -eq $true) {$CurrentDestination = ""}
    write-host "$CurrentDestination selected"
    $form.Close()
}) 

# POPUP FORM
$Form.Controls.Add($Button) 
$Form.Add_Shown({$Form.Activate()})
[void] $Form.ShowDialog()


#################
### FUNCTIONS ###
#################
<#
function SendKeystrokesStarcitizen {
    $wshell = New-Object -ComObject wscript.shell;
    $wshell.AppActivate('Star Citizen')
    $wshell.AppActivate('Dokument - WordPad')
    Sleep 1
    $wshell.SendKeys('{ENTER}')
    $wshell.SendKeys('/showlocation')
    $wshell.SendKeys('{ENTER}')
}

function RegisterHotkey {
    Add-Type -AssemblyName WindowsBase
    Add-Type -AssemblyName PresentationCore

    do
    {   If([bool](
        [Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::LWin) -and 
        [Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::LeftALT)))
            {  
                Write-Host "Keypress registered" -ForegroundColor DarkGray 
                #Start-Process "E:\SCR\PT\Showlocation.exe" -Wait
            }
        Start-Sleep -Milliseconds 100
    } while($true); Start-Sleep -Seconds 1
}
#RegisterHotkey
#>

###############################
### MAIN SCRIPT ###
###############################

#GET DESTINATION COORDINATES FROM HASTABLES, FILTER FOR CURRENT DESTINATION
$SelectedDestination = $DestinationData.GetEnumerator() | Where-Object { $_.Key -eq $CurrentDestination }
$DestCoordData = $SelectedDestination.Value -Split ";"
$DestCoordDataX = $DestCoordData[0]
$DestCoordDataY = $DestCoordData[1]
$DestCoordDataZ = $DestCoordData[2]

#DEBUG, OUTPUT CURRENT SELECTION
<#
Coordinates: x:-18962179048.554125 y:-2648741045.897121 z:-6999924.961668
Coordinates: x:-18961179048.555115 y:-2648341045.898221 z:-6979924.962668
Coordinates: x:-18961189048.556135 y:-2648341045.899321 z:-6979924.963668
#>

#CHECK CLIPBOARD FOR NEW VALUES 

while($true) {
    # Checks for new clipboard conents every 1 Second
    Start-Sleep 1

    #GET CURRENT COORDS FROM CLIPBOARD
    $ClipboardContent = (Get-Clipboard).split(":").Split(" ")

    #CHECK IF CLIPBOARD CONTAINS COORDINATES
    if($ClipboardContent -like "Coordinates"){
        $CurrentXPosition = $ClipboardContent[3]
        $CurrentYPosition = $ClipboardContent[5]
        $CurrentZPosition = $ClipboardContent[7]
    }

    #CHECK IF ANY VALUE X,Y OR Z HAS CHANGED, IF NOT SKIP 
    if($CurrentXPosition -ne $PreviousXPosition -and `
       $CurrentYPosition -ne $PreviousYPosition -and `
       $CurrentZPosition -ne $PreviousZPosition){

    #GET CURRENT TIME AND SAVE PREVIOUS VALUES
    Write-Host (Get-Date)

    #Total Distance Away
    #$PreviousDistanceTotalist = $curdist
    $CurrentDistanceTotal = [math]::Sqrt([math]::pow($CurrentXPosition - $DestCoordDataX,2) + [math]::pow($CurrentYPosition - $DestCoordDataY,2) + [math]::pow($CurrentZPosition - $DestCoordDataZ,2))
    $CurrentDistanceX = [math]::Sqrt([math]::pow($CurrentXPosition - $DestCoordDataX,2))
    $CurrentDistanceY = [math]::Sqrt([math]::pow($CurrentYPosition - $DestCoordDataY,2))
    $CurrentDistanceZ = [math]::Sqrt([math]::pow($CurrentZPosition - $DestCoordDataZ,2))
    
    $CurrentDistanceTotal = [Math]::abs($CurrentDistanceTotal)
    $CurrentDistanceX     = [Math]::abs($CurrentDistanceX)
    $CurrentDistanceY     = [Math]::abs($CurrentDistanceY)
    $CurrentDistanceZ     = [Math]::abs($CurrentDistanceZ)

    #DEFINE STATUS CHANGE FROM LAST RESULT
    switch ($CurrentDistanceTotal){
    {$_ -lt $PreviousDistanceTotal} {$StatusIndicatorT = "+";break} #IF WE GOT FARER AWAY IN TOTAL
    {$_ -gt $PreviousDistanceTotal} {$StatusIndicatorT = "-";break} #IF WE GOT CLOSER IN TOTAL
    {$_ -eq $PreviousDistanceTotal} {$StatusIndicatorT = "=";break}        #IF NOTHING CHANGED
    }

    switch ($CurrentXPosition){
    {$_ -lt $PreviousXPosition} {$StatusIndicatorX = "+";break}
    {$_ -gt $PreviousXPosition} {$StatusIndicatorX = "-";break}
    {$_ -eq $PreviousXPosition} {$StatusIndicatorX = "=";break}
    }

    switch ($CurrentYPosition){
    {$_ -lt $PreviousYPosition} {$StatusIndicatorY = "+";break}
    {$_ -gt $PreviousYPosition} {$StatusIndicatorY = "-";break}
    {$_ -eq $PreviousYPosition} {$StatusIndicatorY = "=";break}
    }

    switch ($CurrentZPosition){
    {$_ -lt $PreviousZPosition} {$StatusIndicatorZ = "+";break}
    {$_ -gt $PreviousZPosition} {$StatusIndicatorZ = "-";break}
    {$_ -eq $PreviousZPosition} {$StatusIndicatorZ = "=";break}
    }

    #GET DIFFERENCE IN DISTANCE
    $CurrentDeltaTotal = $PreviousDistanceTotal - $CurrentDistanceTotal
    $CurrentDeltaX     = $PreviousDistanceX - $CurrentDistanceX
    $CurrentDeltaY     = $PreviousDistanceY - $CurrentDistanceY
    $CurrentDeltaZ     = $PreviousDistanceZ - $CurrentDistanceZ

    #OUTPUT TO USER
    # Distance Indicator KM M Delta
    $Results = @()
    $Total = "" | Select-Object Type,Indicator,Distance,Delta, Spacer1, Spacer2
    $Total.Type = "Full"
    $Total.Indicator = $StatusIndicatorT
    $Total.Distance = $CurrentDistanceTotal
    $Total.Delta = $CurrentDeltaTotal
    $Total.Spacer1 = " "
    $Total.Spacer2 = " "
    $Results += $Total

    $X = "" | Select-Object Type,Indicator,Distance,Delta, Spacer1, Spacer2
    $X.Type = "X-Pos"
    $X.Indicator = $StatusIndicatorX
    $X.Distance = $CurrentDistanceX
    $X.Delta = $CurrentDeltaX
    $X.Spacer1 = " "
    $X.Spacer2 = " "
    $Results += $X

    $Y = "" | Select-Object Type,Indicator,Distance,Delta, Spacer1, Spacer2
    $Y.Type = "Y-Pos"
    $Y.Indicator = $StatusIndicatorY
    $Y.Distance = $CurrentDistanceY
    $Y.Delta = $CurrentDeltaY
    $Y.Spacer1 = " "
    $Y.Spacer2 = " "
    $Results += $Y

    $Z = "" | Select-Object Type,Indicator,Distance,Delta, Spacer1, Spacer2
    $Z.Type = "Z-Pos"
    $Z.Indicator = $StatusIndicatorZ
    $Z.Distance = $CurrentDistanceZ
    $Z.Delta = $CurrentDeltaZ
    $Z.Spacer1 = " "
    $Z.Spacer2 = " "
    $Results += $Z
    
    # GENERATE OUTPUT
    $EscapeCharacter = ([char]27)                                           #EXCAPE CHARACTER TO COLORIZE TABLE
    $Results | Format-Table @{                                             
        Label ="$([char]27)[90mType";
        #Expression ={$_.Type}},
        Expression ={$color = "0";"$EscapeCharacter[${color}m$($_.Type)"}
    },
    @{Label="  ";Expression={$_.Spacer1}},
    @{
        Label = "$([char]27)[90mDistance";                                  #NAME OF RESULTHEADING
        Expression = {switch ($_.Distance){                                 #COLORIZE DISTANCE BY LIMITS
            {$_ -le $DistanceGreen}  { $color = "92"; break }               # When $_ is -1 its lwoer than 0 
            {$_ -le $DistanceYellow} { $color = "93"; break }               #
            default { $color = "91" }                                       #
        }
        $DistanceTKM = ($_.Distance/1000).ToString('N0')+"km"               #CONVERT DISTANCE IN KM
        $DistanceTM = ($_.Distance/1000).ToString('N3').split(',')[1]+"m"   #CONVERT DISTANCE IN M
        "$EscapeCharacter[${color}m$("$DistanceTKM $DistanceTM")"                          #RESULT COLOR FORMAT
        };

        #ALIGN NUMBERS TO THE RIGHT
        align ='right'
    },
    @{Label="  ";Expression={$_.Spacer2}},
    @{
        #Label = 'Delta';
        Label = "$([char]27)[90mDelta";
        Expression = {switch ($_.Delta){
            {$_ -lt 0} { $color = "91"; break }
            {$_ -gt 0} { $color = "92"; break }
            default { $color = "90" }
        }
        $DeltaTotalKM  = ($_.Delta/1000).ToString('N0')+"km "
        $DeltaTotalM   = ($_.Delta/1000).ToString('N3').split(',')[1]+"m"
        "$EscapeCharacter[${color}m$("$DeltaTotalKM $DeltaTotalM")"
        };
        align = 'right'
    }#, 
    <#
    @{
        #Label = 'Indicator';
        Label = "$([char]27)[90mIndicator";
        Expression = {switch ($_.Indicator){
                '+' { $color = "92"; break }
                '-' { $color = "91"; break }
                '=' { $color = "90"; break }
                default { $color = "90" }
            }
            $e = [char]27
           "$e[${color}m$($_.Indicator)${e}[0m"
        };
        align = 'center'}
        #>
    
    ########################################
    ### SHOW DISTANCE TO REFERENCE POINT ###
    ########################################
    $SelectedReferencePoint = $ObjectContainerData.GetEnumerator() | Where-Object { $_.Key -eq $CurrentReference }
    $ReferencePointData = $SelectedReferencePoint.Value -Split ";"
    $ReferencePointDataX = $ReferencePointData[0]
    $ReferencePointDataY = $ReferencePointData[1]
    $ReferencePointDataZ = $ReferencePointData[2]
    $ReferencePointName = $SelectedReferencePoint.Name -Split ";"

    #GET DISTANCES
    $ReferenceDistanceFinal = [math]::Sqrt([math]::pow($ReferencePointDataX - $DestCoordDataX,2) + [math]::pow($ReferencePointDataY - $DestCoordDataY,2) + [math]::pow($ReferencePointDataZ - $DestCoordDataZ,2))
    $RefDistFinalKM = ($ReferenceDistanceFinal/1000).ToString('N0')+"km"               
    $RefDistFinalM  = ($ReferenceDistanceFinal/1000).ToString('N3').split(',')[1]+"m" 

    #CONVERT DISTANCES IN KM AN DM
    $ReferenceDistanceCurrent = [math]::Sqrt([math]::pow($CurrentXPosition - $ReferencePointDataX,2) + [math]::pow($CurrentYPosition - $ReferencePointDataY,2) + [math]::pow($CurrentZPosition - $ReferencePointDataZ,2))
    $RefDistCurrentKM = ($ReferenceDistanceCurrent/1000).ToString('N0')+"km"               
    $RefDistCurrentM  = ($ReferenceDistanceCurrent/1000).ToString('N3').split(',')[1]+"m"   
    switch ($ReferenceDistanceCurrent){                                 #COLORIZE DISTANCE BY LIMITS
        {($ReferenceDistanceFinal - $_) -le $DistanceGreen}  { $Rcolor = "91"; break }               # When $_ is -1 its lwoer than 0 
        {($ReferenceDistanceFinal - $_) -le $DistanceYellow} { $Rcolor = "92"; break }               #
        default { $Rcolor = "93" }                                       #
    }

    #OUTPUT TO USER
    $RefResults = @()
    $RefCurrent = "" | Select-Object Name,Current,Final
    $RefCurrent.Name = "$ReferencePointName"
    $RefCurrent.Current = "$EscapeCharacter[${Rcolor}m$("$RefDistCurrentKM $RefDistCurrentM")"
    $RefCurrent.Final = "     $([char]27)[92m$RefDistFinalKM $RefDistFinalM"
    $RefResults += $RefCurrent
    $RefResults

    ################
    ### xabdiben ###
    ################
    function CalcDistance3d {
        Param ($x1, $y1, $z1, $x2, $y2, $z2)
        #Write-Host "x1 $x1"
        #Write-Host "y1 $y1"
        #Write-Host "z1 $z1"
        #Write-Host "x2 $x2"
        #Write-Host "y2 $y2"
        #Write-Host "z2 $z2"
        Return [math]::Sqrt(($x1 - $x2) * ($x1 - $x2) + ($y1 - $y2) * ($y1 - $y2) + ($z1 - $z2) * ($z1 - $z2) )
        }


    if ($PreviousXPosition -ne $null) {
        $xu = (($DestCoordDataX - $PreviousXPosition) * ($CurrentXPosition - $PreviousXPosition))+(($DestCoordDataY - $PreviousYPosition) * ($CurrentYPosition - $PreviousYPosition))+(($DestCoordDataZ - $PreviousDistanceZ) * ($CurrentZPosition - $PreviousDistanceZ))
        $xab_dist = CalcDistance3d $CurrentXPosition $CurrentYPosition $CurrentZPosition $PreviousXPosition $PreviousYPosition $PreviousZPosition 
        if ($xab_dist -lt 1) {
            $xab_dist=1
        }
        $xu = $xu/($xab_dist * $xab_dist)
        #$closestX = $PreviousXPosition + $xu * ($CurrentXPosition - $PreviousXPosition)
        #$closestY = $PreviousYPosition + $xu * ($CurrentYPosition - $PreviousYPosition)
        #$closestZ = $PreviousZPosition + $xu * ($CurrentZPosition - $PreviousZPosition)
        $closestX = [double]$PreviousXPosition + [double]$xu * ($CurrentXPosition - $PreviousXPosition)
        $closestY = [double]$PreviousYPosition + [double]$xu * ($CurrentYPosition - $PreviousYPosition)
        $closestZ = [double]$PreviousZPosition + [double]$xu * ($CurrentZPosition - $PreviousZPosition)
        # On numbers or called integeres 1 + 1 = 2
        # On variables it add both values together A=1, B=2 than A + B = 12
        #$pathError = CalcDistance3d $DestCoordDataX  $DestCoordDataY  $DestCoordDataZ  $closestX  $closestY  $closestZ 
        $pathError = CalcDistance3d $DestCoordDataX $DestCoordDataY $DestCoordDataZ ([Math]::abs($closestX)) ([Math]::abs($closestY)) ([Math]::abs($closestZ))
        Write-Host "Path Error = $pathError"
    }
    #end xab code

    #STORE PREVIOUS DISTANCES
    $PreviousXPosition     = $CurrentXPosition
    $PreviousYPosition     = $CurrentYPosition
    $PreviousZPosition     = $CurrentZPosition
    $PreviousDistanceTotal = $CurrentDistanceTotal
    $PreviousDistanceX     = $CurrentDistanceX
    $PreviousDistanceY     = $CurrentDistanceY
    $PreviousDistanceZ     = $CurrentDistanceZ
    }
    else{
        #Write-Host "no change"
    }
}

#KEEP LAST RESULTS OPEN, AND EXIT SCRIPT IF USER PRESSES ENTER
Pause

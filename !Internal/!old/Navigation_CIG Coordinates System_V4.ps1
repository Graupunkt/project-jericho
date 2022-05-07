# Script to use CIG Coordinate System with Status Update

##################
### Parameters ###
##################
#SELECT CURRENT POI / DESTINATION FROM HASBTABLE LINE 22
$DistanceGreen = "1000"  # Set Distance in meters when values should turn green (1km)
$DistanceYellow = "100000" # Set Distance in meters when values should turn yellow (100km)
#$DistanceGreen = "10000000"  # Set Distance in meters when values should turn green (10.000 km)
#$DistanceYellow = "1000000000000" # Set Distance in meters when values should turn yellow (100.000.00km)

#GLOBAl PARAMETERS
$CustomCoordsProvided = $false
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
    "ProcyonWreckSite" = "0;0;0"#"-19592.19;-10462.193;3056.932"
}

$ObjectContainerData = @{
    "Cellin" = "12905757.636;40955.551;0"
    "MIC-L1" = "0;0;0"#"20215824.238;33467065.008;0"
    "MIC-L1-Shallow-Frontier" = "20215808582.526974;33466996827.765518;767.452183"
}


##################
### USER INPUT ###
##################

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")  
Add-Type -assembly System.Windows.Forms

# Source = https://sysadminemporium.wordpress.com/2012/12/07/powershell-gui-for-your-scripts-episode-3/
# OUTER WINDOW
$Form = New-Object System.Windows.Forms.Form    
$Form.Size = New-Object System.Drawing.Size(550,450)  

# SELECTION BOX1
$groupBox = New-Object System.Windows.Forms.GroupBox
$groupBox.Location = New-Object System.Drawing.Size(20,100) 
$groupBox.size = New-Object System.Drawing.Size(200,200) 
$groupBox.text = "Select Destination:" 
$Form.Controls.Add($groupBox) 

# SELECTION BOX2
$CheckBox = New-Object System.Windows.Forms.GroupBox
$CheckBox.Location = New-Object System.Drawing.Size(240,100) 
$CheckBox.size = New-Object System.Drawing.Size(200,200) 
$CheckBox.text = "Select References (Optional):" 
$Form.Controls.Add($CheckBox) 

# INPUT BOX3
$TextBox = New-Object System.Windows.Forms.GroupBox
$TextBox.Location = New-Object System.Drawing.Size(240,5) 
$TextBox.size = New-Object System.Drawing.Size(230,90) 
$TextBox.text = "    Custom Coordinates:" 
$Form.Controls.Add($TextBox) 

# BOX1 - SECOND RADIO BUTTON
$RadioButton1 = New-Object System.Windows.Forms.RadioButton 
$RadioButton1.Location = new-object System.Drawing.Point(5,20) 
$RadioButton1.size = New-Object System.Drawing.Size(190,20) 
$RadioButton1.Text = "NavyStation - INS-Jericho" 
$groupBox.Controls.Add($RadioButton1) 


# BOX1 - THIRD RADIO BUTTON
$RadioButton2 = New-Object System.Windows.Forms.RadioButton 
$RadioButton2.Location = new-object System.Drawing.Point(5,40) 
$RadioButton2.size = New-Object System.Drawing.Size(190,20) 
$RadioButton2.ForeColor = [System.Drawing.Color]::Gray
$RadioButton2.Text = "Wreck Site - Procyon" 
$groupBox.Controls.Add($RadioButton2) 

# BOX1 - THIRD RADIO BUTTON
$RadioButton3 = New-Object System.Windows.Forms.RadioButton 
$RadioButton3.Location = new-object System.Drawing.Point(5,60) 
$RadioButton3.size = New-Object System.Drawing.Size(190,20)
$RadioButton3.ForeColor = [System.Drawing.Color]::Gray
$RadioButton3.Text = "Reserved" 
$groupBox.Controls.Add($RadioButton3) 

# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox1 = New-Object System.Windows.Forms.CheckBox
$CheckBox1.Location = new-object System.Drawing.Point(5,20) 
$CheckBox1.size = New-Object System.Drawing.Size(190,20)
$CheckBox1.ForeColor = [System.Drawing.Color]::Gray
$CheckBox1.Text = "Planet ArcCorp" 
$CheckBox.Controls.Add($CheckBox1) 
# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox2 = New-Object System.Windows.Forms.CheckBox
$CheckBox2.Location = new-object System.Drawing.Point(5,20) 
$CheckBox2.size = New-Object System.Drawing.Size(190,20) 
$CheckBox2.ForeColor = [System.Drawing.Color]::Gray
$CheckBox2.Text = "Planet Crusader" 
$CheckBox.Controls.Add($CheckBox2)
# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox3 = New-Object System.Windows.Forms.CheckBox
$CheckBox3.Location = new-object System.Drawing.Point(5,20) 
$CheckBox3.size = New-Object System.Drawing.Size(190,20) 
$CheckBox3.ForeColor = [System.Drawing.Color]::Gray
$CheckBox3.Text = "Planet Microtech" 
$CheckBox.Controls.Add($CheckBox3)
# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox4 = New-Object System.Windows.Forms.CheckBox
$CheckBox4.Location = new-object System.Drawing.Point(5,20) 
$CheckBox4.size = New-Object System.Drawing.Size(190,20) 
$CheckBox4.ForeColor = [System.Drawing.Color]::Gray
$CheckBox4.Text = "Moon Delamar" 
$CheckBox.Controls.Add($CheckBox4) 

# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox5 = New-Object System.Windows.Forms.CheckBox
$CheckBox5.Location = new-object System.Drawing.Point(5,20) 
$CheckBox5.size = New-Object System.Drawing.Size(190,20) 
$CheckBox5.Text = "Lagrange MIC-L1 (Shallow Frontier)" 
$CheckBox.Controls.Add($CheckBox5) 

# BOX3 - FIRST RADIO BUTTON
$CustomButton = New-Object System.Windows.Forms.CheckBox 
$CustomButton.Location = new-object System.Drawing.Point(3,1) 
$CustomButton.size = New-Object System.Drawing.Size(15,15)
#$CustomButton.Checked = $true 
$TextBox.Controls.Add($CustomButton) 

# BOX3 - X LABEL
$TextBoxLabel = New-Object “System.Windows.Forms.Label”;
$TextBoxLabel.Location = new-object System.Drawing.Point(5,28)
$TextBoxLabel.size = New-Object System.Drawing.Size(15,15) 
$TextBoxLabel.Text = "X ="
$TextBox.Controls.Add($TextBoxLabel) 
# BOX3 - X INPUT
$TextBoxX = New-Object System.Windows.Forms.TextBox 
$TextBoxX.Location = new-object System.Drawing.Point(20,25) 
$TextBoxX.size = New-Object System.Drawing.Size(170,20)  
$TextBox.Controls.Add($TextBoxX) 

# BOX3 - Y LABEL
$TextBoxLabel = New-Object “System.Windows.Forms.Label”;
$TextBoxLabel.Location = new-object System.Drawing.Point(5,48)
$TextBoxLabel.size = New-Object System.Drawing.Size(15,15) 
$TextBoxLabel.Text = "Y ="
$TextBox.Controls.Add($TextBoxLabel) 
# BOX3 - Y INPUT
$TextBoxY = New-Object System.Windows.Forms.TextBox 
$TextBoxY.Location = new-object System.Drawing.Point(20,45) 
$TextBoxY.size = New-Object System.Drawing.Size(170,20)  
$TextBox.Controls.Add($TextBoxY) 

# BOX3 - Z LABEL
$TextBoxLabel = New-Object “System.Windows.Forms.Label”;
$TextBoxLabel.Location = new-object System.Drawing.Point(5,68)
$TextBoxLabel.size = New-Object System.Drawing.Size(15,15) 
$TextBoxLabel.Text = "Z ="
$TextBox.Controls.Add($TextBoxLabel) 
# BOX3 - Z INPUT
$TextBoxZ = New-Object System.Windows.Forms.TextBox 
$TextBoxZ.Location = new-object System.Drawing.Point(20,65) 
$TextBoxZ.size = New-Object System.Drawing.Size(170,20)  
$TextBox.Controls.Add($TextBoxZ) 

# DEFINE SELECT BUTTON
$Button = New-Object System.Windows.Forms.Button 
$Button.Location = New-Object System.Drawing.Size(80,30) 
$Button.Size = New-Object System.Drawing.Size(80,40) 
$Button.Text = "SELECT" 


# ADD FUNCTION THAT CAN BE SELECTED / EXECUTED
$CurrentReference = @()
$Button.Add_Click({
    if ($RadioButton1.Checked -eq $true) {$Global:CurrentDestination = "IMS-Jericho"}
    if ($RadioButton2.Checked -eq $true) {$Global:CurrentDestination = "ProcyonWreckSite"}
    if ($RadioButton3.Checked -eq $true) {$Global:CurrentDestination = ""}
    if ($CustomButton.Checked -eq $true) {$Global:CustomCoordsProvided = $true;$Global:CustomDataX = $TextBoxX.Text;$Global:CustomDataY = $TextBoxY.Text;$Global:CustomDataZ = $TextBoxZ.Text}
    if ($CheckBox5.Checked -eq $true) {$global:CurrentReference += "MIC-L1-Shallow-Frontier"}
    if ($CheckBox2.Checked -eq $true) {$global:CurrentReference += "Cellin"}
    $form.Close()
}) 

# POPUP FORM
$Form.Controls.Add($Button) 
$Form.Add_Shown({$Form.Activate()})
[void] $Form.ShowDialog()

$DestCoordDataX = $Global:CustomDataX
$DestCoordDataY = $Global:CustomDataY
$DestCoordDataZ = $Global:CustomDataZ
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
$SelectedDestination = $DestinationData.GetEnumerator() | Where-Object { $_.Key -eq $Global:CurrentDestination }
$DestCoordData = $SelectedDestination.Value -Split ";"
if(!$Global:CustomCoordsProvided){$DestCoordDataX = $DestCoordData[0]}
if(!$Global:CustomCoordsProvided){$DestCoordDataY = $DestCoordData[1]}
if(!$Global:CustomCoordsProvided){$DestCoordDataZ = $DestCoordData[2]}

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
    Write-Host (Get-Date) $SelectedDestination
    $CurrentTime = (Get-Date)

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
    $Total.Type = "Total"
    $Total.Indicator = $StatusIndicatorT
    $Total.Distance = $CurrentDistanceTotal
    $Total.Delta = $CurrentDeltaTotal
    $Total.Spacer1 = " "
    $Total.Spacer2 = " "
    $Results += $Total

    $X = "" | Select-Object Type,Indicator,Distance,Delta, Spacer1, Spacer2
    $X.Type = "X-Axis"
    $X.Indicator = $StatusIndicatorX
    $X.Distance = $CurrentDistanceX
    $X.Delta = $CurrentDeltaX
    $X.Spacer1 = " "
    $X.Spacer2 = " "
    $Results += $X

    $Y = "" | Select-Object Type,Indicator,Distance,Delta, Spacer1, Spacer2
    $Y.Type = "Y-Axis"
    $Y.Indicator = $StatusIndicatorY
    $Y.Distance = $CurrentDistanceY
    $Y.Delta = $CurrentDeltaY
    $Y.Spacer1 = " "
    $Y.Spacer2 = " "
    $Results += $Y

    $Z = "" | Select-Object Type,Indicator,Distance,Delta, Spacer1, Spacer2
    $Z.Type = "Z-Axis"
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
    $RefResults = @()
    foreach ($Reference in $global:CurrentReference){
        $SelectedReferencePoint = $ObjectContainerData.GetEnumerator() | Where-Object { $_.Key -eq $Reference }
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
            {([Math]::abs($ReferenceDistanceFinal) - $_) -lt $DistanceGreen}  { $Rcolor = "91"; break }
            {([Math]::abs($ReferenceDistanceFinal) - $_) -lt $DistanceYellow} { $Rcolor = "92"; break }
            default { $Rcolor = "93" }
        }

        #OUTPUT TO USER
        $RefCurrent = "" | Select-Object Referencepoint,Current,Final
        $RefCurrent.Referencepoint = "$ReferencePointName"
        $RefCurrent.Current = "$EscapeCharacter[${Rcolor}m$("$RefDistCurrentKM $RefDistCurrentM")"
        $RefCurrent.Final = "     $([char]27)[92m$RefDistFinalKM $RefDistFinalM"
        $RefResults += $RefCurrent
    }
    $RefResults | FT


    ################
    ### xabdiben ###
    ################
    function CalcDistance3d {
        Param ($x1, $y1, $z1, $x2, $y2, $z2)
        Return [math]::Sqrt(($x1 - $x2) * ($x1 - $x2) + ($y1 - $y2) * ($y1 - $y2) + ($z1 - $z2) * ($z1 - $z2) )
        }

    $ErrorActionPreference = "Stop"
    if ($PreviousXPosition -ne $null) {
        $xu = (($DestCoordDataX - $PreviousXPosition) * ($CurrentXPosition - $PreviousXPosition))+(($DestCoordDataY - $PreviousYPosition) * ($CurrentYPosition - $PreviousYPosition))+(($DestCoordDataZ - $PreviousZPosition) * ($CurrentZPosition - $PreviousZPosition))

        $xab_dist = CalcDistance3d $CurrentXPosition $CurrentYPosition $CurrentZPosition $PreviousXPosition $PreviousYPosition $PreviousZPosition 

        if ($xab_dist -lt 1) {
            $xab_dist=1
        }

        $xu = $xu/($xab_dist * $xab_dist)

        $closestX = [double]$PreviousXPosition + [double]$xu * ($CurrentXPosition - $PreviousXPosition)
        $closestY = [double]$PreviousYPosition + [double]$xu * ($CurrentYPosition - $PreviousYPosition)
        $closestZ = [double]$PreviousZPosition + [double]$xu * ($CurrentZPosition - $PreviousZPosition)

        $c1 = CalcDistance3d $DestCoordDataX $DestCoordDataY $DestCoordDataZ $PreviousXPosition $PreviousYPosition $PreviousZPosition
        $c2 = CalcDistance3d $DestCoordDataX $DestCoordDataY $DestCoordDataZ $CurrentXPosition $CurrentYPosition $CurrentZPosition


        $pathError = CalcDistance3d $DestCoordDataX $DestCoordDataY $DestCoordDataZ $closestX $closestY $closestZ
        #Write-Host "Path Error = $pathError"
        $perrd = [math]::atan2($pathError, $c2) * 180.0 / 3.1415
        $FinalAngle = [math]::Round($perrd,2)

        switch ($FinalAngle){
            {$_ -le 1} { $FAcolor = "92"; break }
            {$_ -le 3} { $FAcolor = "93"; break }
            {$_ -gt 3} { $FAcolor = "31"; break }
            default { $FAcolor = "35" }
        }
        Write-Host "Course deviation = $EscapeCharacter[${FAcolor}m$("$FinalAngle°")"
        if($CurrentDeltaTotal -gt 0 -OR $CurrentDeltaTotal -lt 0){
            $CurrentETA = $CurrentDistanceTotal/($CurrentDeltaTotal/($CurrentTime - $PreviousTime).TotalSeconds)
        }
        if($CurrentETA -gt 0){
            $ts =  [timespan]::fromseconds($CurrentETA)
            Write-Host "ETA = $($ts.Days) Days $($ts.Hours) Hours $($ts.Minutes) Minutes $($ts.Seconds) Seconds"
            Write-Host " "
        }
    }

    

    #STORE PREVIOUS DISTANCES
    $PreviousXPosition     = $CurrentXPosition
    $PreviousYPosition     = $CurrentYPosition
    $PreviousZPosition     = $CurrentZPosition
    $PreviousDistanceTotal = $CurrentDistanceTotal
    $PreviousDistanceX     = $CurrentDistanceX
    $PreviousDistanceY     = $CurrentDistanceY
    $PreviousDistanceZ     = $CurrentDistanceZ
    $PreviousTime           = $CurrentTime
    }
    else{
        #Write-Host "no change"
    }
}

#KEEP LAST RESULTS OPEN, AND EXIT SCRIPT IF USER PRESSES ENTER
Pause

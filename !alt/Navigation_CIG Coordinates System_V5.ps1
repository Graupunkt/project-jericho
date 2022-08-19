# Script to use CIG Coordinate System with Status Update

##################
### Parameters ###
##################
#SELECT CURRENT POI / DESTINATION FROM HASBTABLE LINE 22
$DistanceGreen = "1000"  # Set Distance in meters when values should turn green (1km)
$DistanceYellow = "100000" # Set Distance in meters when values should turn yellow (100km)
$QMDistanceGreen = "100000"
$QMDistanceYellow = "1000000"

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
    "INS-Jericho" = "20196776410.415634;33456387485.680557;2896115.502795"
    "ProcyonWreckSite" = "20196234302.339825;33456590828.301819;3063800.096146"
    "EverusArmor" = "905032;34562;0"
}

$QuantummarkerData = @{
    "Planet-ArcCorp" = "18587664739.856;-22151916920.3125;0"
    "Planet-Crusader" = "-18962176000;-2664959999.99999;0"
    "Planet-Hurston" = "12850457093;0;0"
    "Planet-Microtech" = "22462016306.0103;37185625645.8346;0"
    "Moon-Delamar" = "-10531703478.4293;18241438663.8409;0"
    "ARC-L1" = "16729134637.3846;-19937006924.8913;8076.625"
    "ARC-L2" = "20446718503.3901;-24367450990.706;8076.625"
    "ARC-L3" = "-25043446883.5029;14458841787.628;8076.625"
    "ARC-L4" = "28478354915.6557;5021502482.91174;8076.625"
    "ARC-L5" = "-9890422516.16967;-27173732225.14;8076.625"
    "CRU-L1" = "-17065957375.9999;-2398463999.99999;0"
    "CRU-L2" = "0;0;0"
    "CRU-L3" = "18962176000;2664960000;0"
    "CRU-L4" = "-7173168639.99999;-17754204160;0"
    "CRU-L5" = "-11789008988.2602;15089246106.7638;0"
    "MIC-L1" = "20215808582.526974;33466996827.765518;767.452183"
    "HUR-L1" = "11565411328;0;0"
    "HUR-L2" = "14135502848;0;0"
    "HUR-L3" = "-12850457600;-1123.42272949218;0"
    "HUR-L4" = "6425228288;11128823808;0"
    "HUR-L5" = "6425227776;11128823808;0"
    "Stanton-Star" = "136049.868;-1294427.422;2923345.358"
}


# RUN SCRIPT WITH ADMIN PERMISSIONS
#If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
#    Start-Process powershell.exe "-noProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
#    Exit
#}

#PREREQUESTS, ASSEMBLIES
try {
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")  
    Add-Type -assembly System.Windows.Forms
}
catch {
    Write-Warning -Message 'Unable to load required assemblies'
    return
}


##################
### USER INPUT ###
##################
# OUTER WINDOW
$Form = New-Object System.Windows.Forms.Form    
$Form.Size = New-Object System.Drawing.Size(1050,650) 
$Form.Text = "Project Jericho"

# SELECTION BOX1
$groupBox = New-Object System.Windows.Forms.GroupBox
$groupBox.Location = New-Object System.Drawing.Size(20,130) 
$groupBox.size = New-Object System.Drawing.Size(200,470) 
$groupBox.text = "Destination" 
$Form.Controls.Add($groupBox) 

# SELECTION BOX2
$CheckBox = New-Object System.Windows.Forms.GroupBox
$CheckBox.Location = New-Object System.Drawing.Size(240,130) 
$CheckBox.size = New-Object System.Drawing.Size(250,470) 
$CheckBox.text = "QuantumMarker (Optional)" 
$Form.Controls.Add($CheckBox) 

##################
### LEGEND BOX ###
##################
$Legend = New-Object System.Windows.Forms.GroupBox
$Legend.Location = New-Object System.Drawing.Size(240,5) 
$Legend.size = New-Object System.Drawing.Size(250,120) 
$Legend.text = "Legend" 
$Form.Controls.Add($Legend)
# LEGEND - FIRST ENTRY
$Legend1 = New-Object System.Windows.Forms.Label 
$Legend1.Location = new-object System.Drawing.Point(21,20) 
$Legend1.size = New-Object System.Drawing.Size(100,20) 
$Legend1.ForeColor = [System.Drawing.Color]::Gray
$Legend1.Text = "No coordinates yet" 
$Legend.Controls.Add($Legend1) 
# 
$Legend2 = New-Object System.Windows.Forms.Label 
$Legend2.Location = new-object System.Drawing.Point(21,38) 
$Legend2.size = New-Object System.Drawing.Size(190,20) 
$Legend2.ForeColor = [System.Drawing.Color]::Blue
$Legend2.Text = "QuantumMarker (starting point)" 
$Legend.Controls.Add($Legend2)
# 
$Legend3 = New-Object System.Windows.Forms.Label 
$Legend3.Location = new-object System.Drawing.Point(21,56) 
$Legend3.size = New-Object System.Drawing.Size(190,20) 
$Legend3.ForeColor = [System.Drawing.Color]::Green
$Legend3.Text = "QuantumMarker (suggested)" 
$Legend.Controls.Add($Legend3) 
# 
$Legend4 = New-Object System.Windows.Forms.CheckBox 
$Legend4.Location = new-object System.Drawing.Point(5,74) 
$Legend4.size = New-Object System.Drawing.Size(170,20) 
$Legend4.Checked = $true 
#$Legend4.Enabled = $false 
$Legend4.AutoCheck = $false 
$Legend4.Text = "QuantumMarker (selected)" 
$Legend.Controls.Add($Legend4) 

#################
### LIMIT BOX ###
#################
$Limits = New-Object System.Windows.Forms.GroupBox
$Limits.Location = New-Object System.Drawing.Size(770,5) 
$Limits.size = New-Object System.Drawing.Size(250,120) 
$Limits.text = "Limits (meters)" 
$Form.Controls.Add($Limits) 

$LabelDistanceGreen = New-Object System.Windows.Forms.Label 
$LabelDistanceGreen.Location = new-object System.Drawing.Point(5,28) 
$LabelDistanceGreen.size = New-Object System.Drawing.Size(100,15) 
$LabelDistanceGreen.ForeColor = [System.Drawing.Color]::Green
$LabelDistanceGreen.Text = "Distance Green" 
$Limits.Controls.Add($LabelDistanceGreen)

$LimitDistanceGreen = New-Object System.Windows.Forms.TextBox 
$LimitDistanceGreen.Location = new-object System.Drawing.Point(150,25) 
$LimitDistanceGreen.size = New-Object System.Drawing.Size(70,20)  
$LimitDistanceGreen.ForeColor = [System.Drawing.Color]::Gray
$LimitDistanceGreen.Text = "{0:n0}" -f [Double]$DistanceGreen
$LimitDistanceGreen.TextAlign = "Right"
$Limits.Controls.Add($LimitDistanceGreen) 

$LabelDistanceYellow = New-Object System.Windows.Forms.Label 
$LabelDistanceYellow.Location = new-object System.Drawing.Point(5,48) 
$LabelDistanceYellow.size = New-Object System.Drawing.Size(100,15) 
$LabelDistanceYellow.ForeColor = [System.Drawing.Color]::Orange
$LabelDistanceYellow.Text = "Distance Yellow" 
$Limits.Controls.Add($LabelDistanceYellow)

$LimitDistanceYellow = New-Object System.Windows.Forms.TextBox 
$LimitDistanceYellow.Location = new-object System.Drawing.Point(150,45) 
$LimitDistanceYellow.size = New-Object System.Drawing.Size(70,10) 
$LimitDistanceYellow.TextAlign = "Right" 
$LimitDistanceYellow.ForeColor = [System.Drawing.Color]::Gray
$LimitDistanceYellow.Text = "{0:n0}" -f [Double]$DistanceYellow 
$Limits.Controls.Add($LimitDistanceYellow) 

$LabelQuantumGreen = New-Object System.Windows.Forms.Label 
$LabelQuantumGreen.Location = new-object System.Drawing.Point(5,68) 
$LabelQuantumGreen.size = New-Object System.Drawing.Size(100,15) 
$LabelQuantumGreen.ForeColor = [System.Drawing.Color]::Green
$LabelQuantumGreen.Text = "QuantumMarker Green" 
$Limits.Controls.Add($LabelQuantumGreen)

$LimitQuantumGreen = New-Object System.Windows.Forms.TextBox 
$LimitQuantumGreen.Location = new-object System.Drawing.Point(150,65) 
$LimitQuantumGreen.size = New-Object System.Drawing.Size(70,10) 
$LimitQuantumGreen.TextAlign = "Right" 
$LimitQuantumGreen.ForeColor = [System.Drawing.Color]::Gray
$LimitQuantumGreen.Text = "{0:n0}" -f [Double]$QMDistanceGreen
$Limits.Controls.Add($LimitQuantumGreen) 

$LabelQuantumYellow = New-Object System.Windows.Forms.Label 
$LabelQuantumYellow.Location = new-object System.Drawing.Point(5,88) 
$LabelQuantumYellow.size = New-Object System.Drawing.Size(100,15) 
$LabelQuantumYellow.ForeColor = [System.Drawing.Color]::Orange
$LabelQuantumYellow.Text = "QuantumMarker Yellow" 
$Limits.Controls.Add($LabelQuantumYellow)

$LimitQuantumYellow = New-Object System.Windows.Forms.TextBox 
$LimitQuantumYellow.Location = new-object System.Drawing.Point(150,85) 
$LimitQuantumYellow.size = New-Object System.Drawing.Size(70,10) 
$LimitQuantumYellow.TextAlign = "Right" 
$LimitQuantumYellow.ForeColor = [System.Drawing.Color]::Gray
$LimitQuantumYellow.Text = "{0:n0}" -f [Double]$QMDistanceYellow
$Limits.Controls.Add($LimitQuantumYellow) 

########################
### INSTRUCTIONS BOX ###
########################
$Instructions = New-Object System.Windows.Forms.GroupBox
$Instructions.Location = New-Object System.Drawing.Size(500,130) 
$Instructions.size = New-Object System.Drawing.Size(520,470) 
$Instructions.text = "Instructions" 
$Form.Controls.Add($Instructions)

$LiveResults = New-Object System.Windows.Forms.Label 
$LiveResults.Location = new-object System.Drawing.Point(21,20) 
$LiveResults.size = New-Object System.Drawing.Size(470,420) 
$LiveResults.ForeColor = [System.Drawing.Color]::Gray
$LiveResults.Text = "No Destination selected" 
$Instructions.Controls.Add($LiveResults) 


##########################
### CUSTOM COORDINATES ###
##########################
$TextBox = New-Object System.Windows.Forms.GroupBox
$TextBox.Location = New-Object System.Drawing.Size(500,5) 
$TextBox.size = New-Object System.Drawing.Size(250,120) 
$TextBox.text = "    Custom Coordinates:" 
$Form.Controls.Add($TextBox) 

# BOX3 - FIRST RADIO BUTTON
$CustomButton = New-Object System.Windows.Forms.CheckBox 
$CustomButton.Location = new-object System.Drawing.Point(3,1) 
$CustomButton.size = New-Object System.Drawing.Size(15,15)
#$CustomButton.Checked = $true 
$TextBox.Controls.Add($CustomButton) 

# X LABEL
$TextBoxLabel = New-Object “System.Windows.Forms.Label”;
$TextBoxLabel.Location = new-object System.Drawing.Point(5,28)
$TextBoxLabel.size = New-Object System.Drawing.Size(15,15) 
$TextBoxLabel.Text = "X ="
$TextBox.Controls.Add($TextBoxLabel) 

# X INPUT
$TextBoxX = New-Object System.Windows.Forms.TextBox 
$TextBoxX.Location = new-object System.Drawing.Point(20,25) 
$TextBoxX.size = New-Object System.Drawing.Size(170,20)  
$TextBox.Controls.Add($TextBoxX) 

# Y LABEL
$TextBoxLabel = New-Object “System.Windows.Forms.Label”;
$TextBoxLabel.Location = new-object System.Drawing.Point(5,48)
$TextBoxLabel.size = New-Object System.Drawing.Size(15,15) 
$TextBoxLabel.Text = "Y ="
$TextBox.Controls.Add($TextBoxLabel) 
# Y INPUT
$TextBoxY = New-Object System.Windows.Forms.TextBox 
$TextBoxY.Location = new-object System.Drawing.Point(20,45) 
$TextBoxY.size = New-Object System.Drawing.Size(170,20)  
$TextBox.Controls.Add($TextBoxY) 

# Z LABEL
$TextBoxLabel = New-Object “System.Windows.Forms.Label”;
$TextBoxLabel.Location = new-object System.Drawing.Point(5,68)
$TextBoxLabel.size = New-Object System.Drawing.Size(15,15) 
$TextBoxLabel.Text = "Z ="
$TextBox.Controls.Add($TextBoxLabel) 
# Z INPUT
$TextBoxZ = New-Object System.Windows.Forms.TextBox 
$TextBoxZ.Location = new-object System.Drawing.Point(20,65) 
$TextBoxZ.size = New-Object System.Drawing.Size(170,20)  
$TextBox.Controls.Add($TextBoxZ) 

#######################
### DESTINATION BOX ###
#######################
# BOX1 - SECOND RADIO BUTTON
$ButtonDestinationHericho = New-Object System.Windows.Forms.RadioButton 
$ButtonDestinationHericho.Location = new-object System.Drawing.Point(5,20) 
$ButtonDestinationHericho.size = New-Object System.Drawing.Size(190,20) 
$ButtonDestinationHericho.Text = "Station - INS-Jericho" 
$groupBox.Controls.Add($ButtonDestinationHericho) 


# BOX1 - THIRD RADIO BUTTON
$RadioButton2 = New-Object System.Windows.Forms.RadioButton 
$RadioButton2.Location = new-object System.Drawing.Point(5,40) 
$RadioButton2.size = New-Object System.Drawing.Size(190,20) 
$RadioButton2.Text = "Wreck - Procyon" 
$groupBox.Controls.Add($RadioButton2) 

# BOX1 - THIRD RADIO BUTTON
$RadioButton3 = New-Object System.Windows.Forms.RadioButton 
$RadioButton3.Location = new-object System.Drawing.Point(5,60) 
$RadioButton3.size = New-Object System.Drawing.Size(190,20)
$RadioButton3.Text = "Everus NPC Armor Printing" 
$groupBox.Controls.Add($RadioButton3) 

# BOX1 - THIRD RADIO BUTTON
$RadioButton4 = New-Object System.Windows.Forms.RadioButton 
$RadioButton4.Location = new-object System.Drawing.Point(5,80) 
$RadioButton4.size = New-Object System.Drawing.Size(190,20)
$RadioButton4.ForeColor = [System.Drawing.Color]::Gray
$RadioButton4.Text = "Reserved" 
$groupBox.Controls.Add($RadioButton4) 

# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox1 = New-Object System.Windows.Forms.CheckBox
$CheckBox1.Location = new-object System.Drawing.Point(5,20) 
$CheckBox1.size = New-Object System.Drawing.Size(240,20)
$CheckBox1.Text = "Planet - ArcCorp" 
$CheckBox.Controls.Add($CheckBox1) 
# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox2 = New-Object System.Windows.Forms.CheckBox
$CheckBox2.Location = new-object System.Drawing.Point(5,40) 
$CheckBox2.size = New-Object System.Drawing.Size(240,20) 
$CheckBox2.Text = "Planet - Crusader" 
$CheckBox.Controls.Add($CheckBox2)
# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox27 = New-Object System.Windows.Forms.CheckBox
$CheckBox27.Location = new-object System.Drawing.Point(5,60) 
$CheckBox27.size = New-Object System.Drawing.Size(240,20) 
$CheckBox27.Text = "Planet - Hurston" 
$CheckBox.Controls.Add($CheckBox27)
# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox3 = New-Object System.Windows.Forms.CheckBox
$CheckBox3.Location = new-object System.Drawing.Point(5,80) 
$CheckBox3.size = New-Object System.Drawing.Size(240,20) 
$CheckBox3.Text = "Planet - Microtech" 
$CheckBox.Controls.Add($CheckBox3)
# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox4 = New-Object System.Windows.Forms.CheckBox
$CheckBox4.Location = new-object System.Drawing.Point(5,100) 
$CheckBox4.size = New-Object System.Drawing.Size(240,20) 
$CheckBox4.Text = "Moon - Delamar" 
$CheckBox.Controls.Add($CheckBox4) 
# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox5 = New-Object System.Windows.Forms.CheckBox
$CheckBox5.Location = new-object System.Drawing.Point(5,120) 
$CheckBox5.size = New-Object System.Drawing.Size(240,20)
$CheckBox5.Text = "ARC-L1 (Wide Forest)" 
$CheckBox.Controls.Add($CheckBox5)
# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox6 = New-Object System.Windows.Forms.CheckBox
$CheckBox6.Location = new-object System.Drawing.Point(5,140) 
$CheckBox6.size = New-Object System.Drawing.Size(240,20) 
$CheckBox6.Text = "ARC-L2 (xxx)" 
$CheckBox.Controls.Add($CheckBox6)
# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox7 = New-Object System.Windows.Forms.CheckBox
$CheckBox7.Location = new-object System.Drawing.Point(5,160) 
$CheckBox7.size = New-Object System.Drawing.Size(240,20) 
$CheckBox7.Text = "ARC-L3 (xxx)" 
$CheckBox.Controls.Add($CheckBox7)
# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox8 = New-Object System.Windows.Forms.CheckBox
$CheckBox8.Location = new-object System.Drawing.Point(5,180) 
$CheckBox8.size = New-Object System.Drawing.Size(240,20) 
$CheckBox8.Text = "ARC-L4 (xxx)" 
$CheckBox.Controls.Add($CheckBox8)
# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox9 = New-Object System.Windows.Forms.CheckBox
$CheckBox9.Location = new-object System.Drawing.Point(5,200) 
$CheckBox9.size = New-Object System.Drawing.Size(240,20) 
$CheckBox9.Text = "ARC-L5 (xxx)" 
$CheckBox.Controls.Add($CheckBox9)
# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox10 = New-Object System.Windows.Forms.CheckBox
$CheckBox10.Location = new-object System.Drawing.Point(5,220) 
$CheckBox10.size = New-Object System.Drawing.Size(240,20) 
$CheckBox10.Text = "CRU-L1 (Ambitous Dream)" 
$CheckBox.Controls.Add($CheckBox10)
# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox11 = New-Object System.Windows.Forms.CheckBox
$CheckBox11.Location = new-object System.Drawing.Point(5,240) 
$CheckBox11.size = New-Object System.Drawing.Size(240,20) 
$CheckBox11.Text = "CRU-L2 (xxx)" 
$CheckBox11.ForeColor = [System.Drawing.Color]::Gray
$CheckBox.Controls.Add($CheckBox11)
# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox12 = New-Object System.Windows.Forms.CheckBox
$CheckBox12.Location = new-object System.Drawing.Point(5,260) 
$CheckBox12.size = New-Object System.Drawing.Size(240,20) 
$CheckBox12.Text = "CRU-L3 (xxx)" 
$CheckBox.Controls.Add($CheckBox12)
# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox13 = New-Object System.Windows.Forms.CheckBox
$CheckBox13.Location = new-object System.Drawing.Point(5,280) 
$CheckBox13.size = New-Object System.Drawing.Size(240,20) 
$CheckBox13.Text = "CRU-L4 (Shallow Fields)" 
$CheckBox.Controls.Add($CheckBox13)
# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox14 = New-Object System.Windows.Forms.CheckBox
$CheckBox14.Location = new-object System.Drawing.Point(5,300) 
$CheckBox14.size = New-Object System.Drawing.Size(240,20) 
$CheckBox14.Text = "CRU-L5 (Beautiful Glen)" 
$CheckBox.Controls.Add($CheckBox14)
# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox15 = New-Object System.Windows.Forms.CheckBox
$CheckBox15.Location = new-object System.Drawing.Point(5,320) 
$CheckBox15.size = New-Object System.Drawing.Size(240,20) 
$CheckBox15.Text = "HUR-L1 (Green Glade)" 
$CheckBox.Controls.Add($CheckBox15)
# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox16 = New-Object System.Windows.Forms.CheckBox
$CheckBox16.Location = new-object System.Drawing.Point(5,340) 
$CheckBox16.size = New-Object System.Drawing.Size(240,20) 
$CheckBox16.Text = "HUR-L2 (Faithful Dream)" 
$CheckBox.Controls.Add($CheckBox16)
# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox17 = New-Object System.Windows.Forms.CheckBox
$CheckBox17.Location = new-object System.Drawing.Point(5,360) 
$CheckBox17.size = New-Object System.Drawing.Size(240,20) 
$CheckBox17.Text = "HUR-L3 (Thundering Express)" 
$CheckBox.Controls.Add($CheckBox17)
# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox18 = New-Object System.Windows.Forms.CheckBox
$CheckBox18.Location = new-object System.Drawing.Point(5,380) 
$CheckBox18.size = New-Object System.Drawing.Size(240,20) 
$CheckBox18.Text = "HUR-L4 (Melodic Fields)" 
$CheckBox.Controls.Add($CheckBox18)
# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox19 = New-Object System.Windows.Forms.CheckBox
$CheckBox19.Location = new-object System.Drawing.Point(5,400) 
$CheckBox19.size = New-Object System.Drawing.Size(240,20) 
$CheckBox19.Text = "HUR-L5 (High Course)" 
$CheckBox.Controls.Add($CheckBox19)
# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox20 = New-Object System.Windows.Forms.CheckBox
$CheckBox20.Location = new-object System.Drawing.Point(5,420) 
$CheckBox20.size = New-Object System.Drawing.Size(240,20) 
$CheckBox20.Text = "MIC-L1 (Shallow Frontier)" 
$CheckBox.Controls.Add($CheckBox20)
# BOX2 - FIRST MULTICHOICE BUTTON
$CheckBox26 = New-Object System.Windows.Forms.CheckBox
$CheckBox26.Location = new-object System.Drawing.Point(5,440) 
$CheckBox26.size = New-Object System.Drawing.Size(240,20) 
$CheckBox26.ForeColor = [System.Drawing.Color]::Gray
$CheckBox26.Text = "Stanton Star" 
$CheckBox.Controls.Add($CheckBox26)

# DEFINE RUN BUTTON
$Button = New-Object System.Windows.Forms.Button 
$Button.Location = New-Object System.Drawing.Size(30,10) 
$Button.Size = New-Object System.Drawing.Size(80,40) 
$Button.Text = "RUN" 
$Form.Controls.Add($Button)


#DEFINE LOAD DESTINATION BUTTON
$Button2 = New-Object System.Windows.Forms.Button 
$Button2.Location = New-Object System.Drawing.Size(130,10) 
$Button2.Size = New-Object System.Drawing.Size(80,40) 
$Button2.Text = "Show QM" 
$Form.Controls.Add($Button2)

# DEFINE LOAD INSTRUCTIONS BUTTON
$ButtonReserved = New-Object System.Windows.Forms.Button 
$ButtonReserved.Location = New-Object System.Drawing.Size(30,60) 
$ButtonReserved.Size = New-Object System.Drawing.Size(80,40) 
$ButtonReserved.ForeColor = [System.Drawing.Color]::Gray
$ButtonReserved.Text = "Reserved" 
$Form.Controls.Add($ButtonReserved)

#DEFINE RESERVED BUTTON
$ButtonLoadInstructions = New-Object System.Windows.Forms.Button 
$ButtonLoadInstructions.Location = New-Object System.Drawing.Size(130,60) 
$ButtonLoadInstructions.Size = New-Object System.Drawing.Size(80,40) 
$ButtonLoadInstructions.ForeColor = [System.Drawing.Color]::Gray
$ButtonLoadInstructions.Text = "Load Instructions"
$Form.Controls.Add($ButtonLoadInstructions)

# ADD FUNCTION THAT CAN BE SELECTED / EXECUTED
$global:CurrentQuantumMarker = @()
$Button2.Add_Click({
    if ($ButtonDestinationHericho.Checked -eq $true) {
        $CheckBox4.ForeColor  = [System.Drawing.Color]::Green #Delamar
        $CheckBox7.ForeColor  = [System.Drawing.Color]::Green #ARC-L3
        $CheckBox8.ForeColor  = [System.Drawing.Color]::Green #ARC-L4
        $CheckBox20.ForeColor = [System.Drawing.Color]::Blue  #MIC-l1
    }
    if ($RadioButton2.Checked -eq $true) {
        $CheckBox4.ForeColor  = [System.Drawing.Color]::Green #Delamar
        $CheckBox7.ForeColor  = [System.Drawing.Color]::Green #ARC-L3
        $CheckBox8.ForeColor  = [System.Drawing.Color]::Green #ARC-L4
        $CheckBox20.ForeColor = [System.Drawing.Color]::Blue  #MIC-l1
    }

    
})
$Button.Add_Click({
    if ($ButtonDestinationHericho.Checked -eq $true) {$Global:CurrentDestination = "INS-Jericho"}
    if ($RadioButton2.Checked -eq $true) {$Global:CurrentDestination = "ProcyonWreckSite"}
    if ($RadioButton3.Checked -eq $true) {$Global:CurrentDestination = "EverusArmor"}
    if ($RadioButton4.Checked -eq $true) {$Global:CurrentDestination = ""}
    if ($CustomButton.Checked -eq $true) {$Global:CustomCoordsProvided = $true;$Global:CustomDataX = $TextBoxX.Text;$Global:CustomDataY = $TextBoxY.Text;$Global:CustomDataZ = $TextBoxZ.Text}

    if ($CheckBox1.Checked  -eq $true) {$global:CurrentQuantumMarker += "Planet-ArcCorp"}
    if ($CheckBox2.Checked  -eq $true) {$global:CurrentQuantumMarker += "Planet-Crusader"}
    if ($CheckBox27.Checked -eq $true) {$global:CurrentQuantumMarker += "Planet-Hurston"}
    if ($CheckBox3.Checked  -eq $true) {$global:CurrentQuantumMarker += "Planet-Microtech"}
    if ($CheckBox4.Checked  -eq $true) {$global:CurrentQuantumMarker += "Moon-Delamar"}
    if ($CheckBox5.Checked  -eq $true) {$global:CurrentQuantumMarker += "ARC-L1"}
    if ($CheckBox6.Checked  -eq $true) {$global:CurrentQuantumMarker += "ARC-L2"}
    if ($CheckBox7.Checked  -eq $true) {$global:CurrentQuantumMarker += "ARC-L3"}
    if ($CheckBox8.Checked  -eq $true) {$global:CurrentQuantumMarker += "ARC-L4"}
    if ($CheckBox9.Checked  -eq $true) {$global:CurrentQuantumMarker += "ARC-L5"}
    if ($CheckBox10.Checked -eq $true) {$global:CurrentQuantumMarker += "CRU-L1"}
    if ($CheckBox11.Checked -eq $true) {$global:CurrentQuantumMarker += "CRU-L2"}
    if ($CheckBox12.Checked -eq $true) {$global:CurrentQuantumMarker += "CRU-L3"}
    if ($CheckBox13.Checked -eq $true) {$global:CurrentQuantumMarker += "CRU-L4"}
    if ($CheckBox14.Checked -eq $true) {$global:CurrentQuantumMarker += "CRU-L5"}
    if ($CheckBox15.Checked -eq $true) {$global:CurrentQuantumMarker += "HUR-L1"}
    if ($CheckBox16.Checked -eq $true) {$global:CurrentQuantumMarker += "HUR-L2"}
    if ($CheckBox17.Checked -eq $true) {$global:CurrentQuantumMarker += "HUR-L3"}
    if ($CheckBox18.Checked -eq $true) {$global:CurrentQuantumMarker += "HUR-L4"}
    if ($CheckBox19.Checked -eq $true) {$global:CurrentQuantumMarker += "HUR-L5"}
    if ($CheckBox20.Checked -eq $true) {$global:CurrentQuantumMarker += "MIC-L1"}
    if ($CheckBox26.Checked -eq $true) {$global:CurrentQuantumMarker += "Stanton-Star"}
    $form.Close()
}) 
$ButtonLoadInstructions.Add_Click({
    if ($ButtonDestinationHericho.Checked -eq $true) {
        $Global:CurrentDestination = "INS-Jericho"
        $form.Close()
        $global:ReloadForm = $true
    }
})
if ($ButtonReserved.Checked -eq $true) {

}

# POPUP FORM
$Form.Add_Shown({$Form.Activate()})
[void] $Form.ShowDialog()

#STORE USER INPUT INTO VARIABLES
$DestCoordDataX = $Global:CustomDataX
$DestCoordDataY = $Global:CustomDataY
$DestCoordDataZ = $Global:CustomDataZ


#################
### FUNCTIONS ###
#################
<#
function SendKeystrokesStarcitizen {
    Sleep 3
    $wshell = New-Object -ComObject wscript.shell;
    $wshell.AppActivate('Star Citizen')
    #$wshell.AppActivate('Dokument - WordPad')
    Sleep 1
    $wshell.SendKeys('{F1}')
    $wshell.SendKeys('{ENTER}')
    $wshell.SendKeys('/showlocation')
    $wshell.SendKeys('{ENTER}')
}
SendKeystrokesStarcitizen
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
    Write-Host "$(Get-Date) (Current Destination: $($SelectedDestination.Name))"
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
    
    #######################
    ### GENERATE OUTPUT ###
    #######################

    $EscapeCharacter = ([char]27)                                           #EXCAPE CHARACTER TO COLORIZE TABLE
    #DEFINE VIRTUAL TERMINAL SEQUENZCE COLOR
    $VTFontRed = "91"         #Light Red
    $VTFontDarkRed = "31"     #Dark Red
    $VTFontYellow = "93"      
    $VTFontDarkYellow = "33"  
    $VTFontGreen = "92"
    $VTFontDarkGreen = "32"
    $VTFontBlue = "94"
    $VTFontDarkBlue = "34"
    $VTFontGray = "38"        #Gray, Named as Extened Colour
    $VTFontDefault = "0"      #White Text Color
    $VTFontBolt = "1"
    $VTFontExtened = "38"
    $VTFontDarkGray = "90"
    #$Testcolor = $VTFontDarkGray
    #"$EscapeCharacter[${Testcolor}mTest"


    $Results | Format-Table @{                                             
        Label ="$([char]27)[90mType";
        #Expression ={$_.Type}},
        Expression ={$color = "0";"$EscapeCharacter[${color}m$($_.Type)"}
    },
    @{Label="  ";Expression={$_.Spacer1}},
    @{
        Label = "$([char]27)[90mDistance";                                  #NAME OF RESULTHEADING
        Expression = {switch ($_.Distance){                                 #COLORIZE DISTANCE BY LIMITS
            {$_ -le $DistanceGreen}  { $color = $VTFontGreen; break }               # When $_ is -1 its lwoer than 0 
            {$_ -le $DistanceYellow} { $color = $VTFontYellow; break }               #
            default { $color = $VTFontRed }                                       #
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
            {$_ -lt 0} { $color = $VTFontRed; break }     # COLOR RED IF WE GOT MORE FAR WAY
            {$_ -gt 0} { $color = $VTFontGreen; break }   # COLOR GREEN IF WE GOT CLOSER
            default { $color = $VTFontDarkGray }          # COLOR GRAY IF NOTHING CHANGED
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
    ### SHOW DISTANCE TO QUaNTUM MARKERS ###
    ########################################
    $QMResults = @()
    foreach ($Marker in $global:CurrentQuantumMarker){
        $SelectedQuantumMarker = $QuantummarkerData.GetEnumerator() | Where-Object { $_.Key -eq $Marker }
        $QuantumMarkerCoords = $SelectedQuantumMarker.Value -Split ";"
        $QuantumMarkerDataX = $QuantumMarkerCoords[0]
        $QuantumMarkerDataY = $QuantumMarkerCoords[1]
        $QuantumMarkerDataZ = $QuantumMarkerCoords[2]
        $QuantumMarkerName = $SelectedQuantumMarker.Name -Split ";"

        #GET DISTANCES
        $QMDistanceFinal = [math]::Sqrt([math]::pow($QuantumMarkerDataX - $DestCoordDataX,2) + [math]::pow($QuantumMarkerDataY - $DestCoordDataY,2) + [math]::pow($QuantumMarkerDataZ - $DestCoordDataZ,2))
        $QMDistFinalKM = ($QMDistanceFinal/1000).ToString('N0')+"km"               
        $QMDistFinalM  = ($QMDistanceFinal/1000).ToString('N3').split(',')[1]+"m" 

        #CONVERT DISTANCES IN KM AN DM
        $QMDistanceCurrent = [math]::Sqrt([math]::pow($CurrentXPosition - $QuantumMarkerDataX,2) + [math]::pow($CurrentYPosition - $QuantumMarkerDataY,2) + [math]::pow($CurrentZPosition - $QuantumMarkerDataZ,2))
        $QMDistCurrentKM = ($QMDistanceCurrent/1000).ToString('N0')+"km"               
        $QMDistCurrentM  = ($QMDistanceCurrent/1000).ToString('N3').split(',')[1]+"m"   
        switch ($QMDistanceCurrent){                                 #COLORIZE DISTANCE BY LIMITS
            {([Math]::abs($QMDistanceFinal) - $_) -lt $QMDistanceGreen}  { $QMcolor = $VTFontGreen; break }
            {([Math]::abs($QMDistanceFinal) - $_) -lt $QMDistanceYellow} { $QMcolor = $VTFontYellow; break }
            default { $QMcolor = $VTFontRed }
        }

        #OUTPUT TO USER
        $QMCurrent = "" | Select-Object QuantumMarker,Current,Final
        $QMCurrent.QuantumMarker = "$QuantumMarkerName"
        $QMCurrent.Current = "$EscapeCharacter[${Rcolor}m$("$QMDistCurrentKM $QMDistCurrentM")"
        $QMCurrent.Final = "     $([char]27)[92m$QMDistFinalKM $QMDistFinalM"
        $QMResults += $QMCurrent
    }
    $QMResults | Format-Table


    ################
    ### xabdiben ###
    ################
    function CalcDistance3d {
        Param ($x1, $y1, $z1, $x2, $y2, $z2)
        Return [math]::Sqrt(($x1 - $x2) * ($x1 - $x2) + ($y1 - $y2) * ($y1 - $y2) + ($z1 - $z2) * ($z1 - $z2) )
        }

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
            {$_ -le 0.1} { $FAcolor = $VTFontBlue; break }
            {$_ -le 3} { $FAcolor = $VTFontGreen; break }
            {$_ -le 10} { $FAcolor = $VTFontYellow; break }
            {$_ -gt 10} { $FAcolor = $VTFontRed; break }
            default { $FAcolor = $VTFontGray }
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
        else {
            Write-Host "ETA = Wrong way Pilot, turn around."
        }
    }

    ####################
    ### INSTRUCTIONS ###
    ####################
    #GET DISTANCES FROM ALL AVAIlABLE QM
    $AllQMResults = @()
    $FinalCoordArray = @{}
    $Selection = @{}
    $Selection = $DestinationData.GetEnumerator() | Where-Object {$_.Name -contains $SelectedDestination.Name}
    $FinalCoordArray += $QuantummarkerData 
    $FinalCoordArray +=@{$Selection.Name = $Selection.Value}

    #GET ALL COORDS FROM ALL QUNATUM MARKER AND SELECTED DESTINATION
    foreach ($QMEntry in $FinalCoordArray.GetEnumerator()){
        $InstQuantumMarkerCoords = $QMEntry.Value -Split ";"
        $InstQuantumMarkerDataX  = $InstQuantumMarkerCoords[0]
        $InstQuantumMarkerDataY  = $InstQuantumMarkerCoords[1]
        $InstQuantumMarkerDataZ  = $InstQuantumMarkerCoords[2]

        $InstQMCurrent = "" | Select-Object QuantumMarker,X,Y,Z
        $InstQMCurrent.QuantumMarker = $QMEntry.Name
        $InstQMCurrent.X = $InstQuantumMarkerDataX
        $InstQMCurrent.Y = $InstQuantumMarkerDataY
        $InstQMCurrent.Z = $InstQuantumMarkerDataZ
        $AllQMResults += $InstQMCurrent
    }

    #CALCULATE DISTANCES BETWEEN ALLE ENTRIES FROM PREVIOUS ARRAY
    $AllQMDistances = @()
    foreach ($QMEntry in $AllQMResults.GetEnumerator()){
        foreach ($Entry in $AllQMResults.GetEnumerator()){
            $DistanceBetweenQM = [math]::Sqrt([math]::pow($QMEntry.X - $Entry.X,2) + [math]::pow($QMEntry.Y - $Entry.Y,2) + [math]::pow($QMEntry.Z - $Entry.Z,2))
            $DistanceBetweenQMX = [math]::Sqrt([math]::pow($QMEntry.X - $Entry.X,2))
            $DistanceBetweenQMY = [math]::Sqrt([math]::pow($QMEntry.Y - $Entry.Y,2))
            $DistanceBetweenQMZ = [math]::Sqrt([math]::pow($QMEntry.Z - $Entry.Z,2))
            $CurrentQMDistance = "" | Select-Object QuantumMarkerFrom,QuantumMarkerTo,Distance,DistanceX,DistanceY,DistanceZ
            $CurrentQMDistance.QuantumMarkerFrom = $QMEntry.QuantumMarker
            $CurrentQMDistance.QuantumMarkerTo = $Entry.QuantumMarker
            $CurrentQMDistance.Distance = $DistanceBetweenQM
            $CurrentQMDistance.DistanceX = $DistanceBetweenQMX
            $CurrentQMDistance.DistanceY = $DistanceBetweenQMY
            $CurrentQMDistance.DistanceZ = $DistanceBetweenQMZ
            $AllQMDistances += $CurrentQMDistance
        }
        
    }

    #FILTER FOR CLOSEST QM TO START FROM
    $AllQMDistancesSorted = $AllQMDistances | Where-Object {$_.Distance -ne 0} 
    $QMDistancesCurrent = $AllQMDistancesSorted | Where-Object {$_.QuantumMarkerFrom -contains $SelectedDestination.Name} 
    $ClosestQMStart = $QMDistancesCurrent | Sort-Object -Property DistanceX | Select-Object -First 1
    $ClosestQMX = $QMDistancesCurrent | Where-Object {$_.QuantumMarkerTo -NotContains $ClosestQMStart.QuantumMarkerTo} | Sort-Object -Property DistanceX | Select-Object -First 1 
    $ClosestQMY = $QMDistancesCurrent | Where-Object {$_.QuantumMarkerTo -NotContains $ClosestQMStart.QuantumMarkerTo} | Where-Object {$_.QuantumMarkerTo -NotContains $ClosestQMY.QuantumMarkerTo} | Sort-Object -Property DistanceY | Select-Object -First 1 
    $ClosestQMZ = $QMDistancesCurrent | Where-Object {$_.QuantumMarkerTo -NotContains $ClosestQMStart.QuantumMarkerTo} | Where-Object {$_.QuantumMarkerTo -NotContains $ClosestQMY.QuantumMarkerTo} | Where-Object {$_.QuantumMarkerTo -NotContains $ClosestQMZ.QuantumMarkerTo}| Sort-Object -Property DistanceZ | Select-Object -First 1 

    #$QMXDistanceFinal = [math]::Sqrt([math]::pow($ClosestQMX.DistanceX - $DestCoordDataX,2) + [math]::pow($ClosestQMX.DistanceY - $DestCoordDataY,2) + [math]::pow($ClosestQMX.DistanceZ - $DestCoordDataZ,2))
    #$QMYDistanceFinal = [math]::Sqrt([math]::pow($ClosestQMY.DistanceX - $DestCoordDataX,2) + [math]::pow($ClosestQMY.DistanceY - $DestCoordDataY,2) + [math]::pow($ClosestQMY.DistanceZ - $DestCoordDataZ,2))
    #$QMZDistanceFinal = [math]::Sqrt([math]::pow($ClosestQMZ.DistanceX - $DestCoordDataX,2) + [math]::pow($ClosestQMZ.DistanceY - $DestCoordDataY,2) + [math]::pow($ClosestQMZ.DistanceZ - $DestCoordDataZ,2))

    $InstructionDistanceQMX = ($ClosestQMX.Distance/1000).ToString('N0')+"km" 
    $InstructionDistanceQMY = ($ClosestQMY.Distance/1000).ToString('N0')+"km" 
    $InstructionDistanceQMZ = ($ClosestQMZ.Distance/1000).ToString('N0')+"km" 

    $FinalInstructions = "1. jump to $($ClosestQMStart.QuantumMarkerTo)`n2. Jump to $($ClosestQMX.QuantumMarkerTo) and stop at $InstructionDistanceQMX`n3. Jump to $($ClosestQMY.QuantumMarkerTo) and stop at $InstructionDistanceQMY`n4. Jump to $($ClosestQMZ.QuantumMarkerTo) and stop at $InstructionDistanceQMZ`n5. Fly towards $($SelectedDestination.Name) using the course diavation"
    $FinalInstructions

    #STORE PREVIOUS DISTANCES
    $PreviousXPosition     = $CurrentXPosition
    $PreviousYPosition     = $CurrentYPosition
    $PreviousZPosition     = $CurrentZPosition
    $PreviousDistanceTotal = $CurrentDistanceTotal
    $PreviousDistanceX     = $CurrentDistanceX
    $PreviousDistanceY     = $CurrentDistanceY
    $PreviousDistanceZ     = $CurrentDistanceZ
    $PreviousTime          = $CurrentTime

    #RELOAD FORM TO REFRESH
    if ($global:ReloadForm){
        $LiveResults.Text = $FinalInstructions
        $Form.Add_Shown({$Form.Activate()})
        [void] $Form.ShowDialog()
        $global:ReloadForm = $false
    }

    }
    else{
        #Write-Host "no change"
    }
}

#KEEP LAST RESULTS OPEN, AND EXIT SCRIPT IF USER PRESSES ENTER
Pause

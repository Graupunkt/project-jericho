# PARAMETERS
$DropdownWidth = 100 #Width of Filter DropDown
$FormAndGridWidth = 1600
$datagridview = 

#Import CustomFont
<#
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

Write-Host "$($OrangeForeColor)- Pre Loading POI Selection Screen"
Write-Host "$($OrangeForeColor)- Loading Fonts"
$fontBytes  = [Convert]::FromBase64String([Convert]::ToBase64String((get-content $FontHeader -AsByteStream)))
$fontPtr = [System.Runtime.InteropServices.Marshal]::AllocCoTaskMem($fontBytes.Count)
[System.Runtime.InteropServices.Marshal]::Copy($fontBytes, 0, $fontPtr, $fontBytes.Count)
$privateFonts = [System.Drawing.Text.PrivateFontCollection]::new()
$privateFonts.AddMemoryFont($fontPtr, $fontBytes.Count)
[System.Runtime.InteropServices.Marshal]::FreeCoTaskMem($fontPtr)
####
#$global:TextBoxResults.Font = [System.Drawing.Font]::new($privateFonts.Families[0],12)

$fontBytes2  = [Convert]::FromBase64String([Convert]::ToBase64String((get-content $FontData -AsByteStream)))
$fontPtr2 = [System.Runtime.InteropServices.Marshal]::AllocCoTaskMem($fontBytes2.Count)
[System.Runtime.InteropServices.Marshal]::Copy($fontBytes2, 0, $fontPtr2, $fontBytes2.Count)
#$privateFonts = [System.Drawing.Text.PrivateFontCollection]::new()
$privateFonts.AddMemoryFont($fontPtr2, $fontBytes2.Count)
[System.Runtime.InteropServices.Marshal]::FreeCoTaskMem($fontPtr2)
$FontJericho = [System.Drawing.Font]::new($privateFonts.Families[1],12)

#$privateFonts.Families[0]
#>

#GET ALL VARIABLES (ARRAYS) THAT CONTAIN DATAGROUP IN THEIR NAME 
$AllDGVariables = Get-Variable -Include "DataGroup*"
$FinalGroupsForForm = @()
foreach ($DGVariable in $AllDGVariables){
    $FinalGroupsForForm += New-Object psobject -Property @{
        Groups = $DGVariable.Name.Replace("DataGroup","")
        #Options = $DGVariable.Value
        Options = $DGVariable.Value.Name
        Comment = $DGVariable.Value.Comment
        System = $DGVariable.Value.System
        ObjectContainer = $DGVariable.Value.ObjectContainer
        Name = $DGVariable.Value.Name
        Type = $DGVariable.Value.Type
        XCoord = $DGVariable.Value."Planetary X-Coord"
        YCoord = $DGVariable.Value."Planetary Y-Coord"
        ZCoord = $DGVariable.Value."Planetary Z-Coord"
        Date = $DGVariable.Value.Date
    }
}

#Count max Options
[System.Collections.ArrayList]$ListOfOptions = @()
foreach ($FormGroup in $FinalGroupsForForm){
    $ListOfOptions.add($FormGroup.Options.Count) | Out-Null
}

#Create Final Border
$global:PoiSelectionForm = New-Object System.Windows.Forms.Form                                    # Create new object
$global:PoiSelectionForm_Drawing_Size = New-Object System.Drawing.Size
$global:PoiSelectionForm_Drawing_Size.Width = $FormAndGridWidth + 50
$global:PoiSelectionForm_Drawing_Size.Height = 680
$global:PoiSelectionForm.Size = $global:PoiSelectionForm_Drawing_Size
$global:PoiSelectionForm.Text = "Project Jericho - POI Selection Screen"    
#$global:PoiSelectionForm.FormBorderStyle = "None"
$global:PoiSelectionForm.StartPosition = 'CenterScreen'                                            # Position on Screen
$global:PoiSelectionForm.BackColor = [System.Drawing.Color]::FromArgb(32,32,32)
$global:PoiSelectionForm.KeyPreview = $true

#Count Current Options to adjust GroupBox Size
$OptionCounter = 0
foreach ($Group in $FinalGroupsForForm){
    #$ListOfGroupOptions = $Group.Options.Count
    foreach ($Option in $Group.Options){
        $OptionCounter++
    }
}

#Checkboxes

$DistanceLabel = New-Object System.Windows.Forms.Label 
$DistanceLabel.Location = new-object System.Drawing.Point(215,58) 
$DistanceLabel.size = New-Object System.Drawing.Size(150,20) 
$DistanceLabel.ForeColor = [System.Drawing.Color]::Gray
$DistanceLabel.Text = "Load Distances (+1 sec)" 
$global:PoiSelectionForm.Controls.Add($DistanceLabel) 

$ChechboxDistances = New-Object System.Windows.Forms.CheckBox 
$ChechboxDistances.Location = New-Object System.Drawing.Size(200,60) 
$ChechboxDistances.size = New-Object System.Drawing.Size(15,15) 
$ChechboxDistances.ForeColor = [System.Drawing.Color]::FromArgb(255,140,0)
$global:PoiSelectionForm.Controls.Add($ChechboxDistances)
$ChechboxDistances.Add_Click({
    if($ChechboxDistances.Checked -eq $true){$DistanceLabel.ForeColor = [System.Drawing.Color]::Gray}else{$DistanceLabel.ForeColor = [System.Drawing.Color]::Red}
})

$DayConditionLabel = New-Object System.Windows.Forms.Label 
$DayConditionLabel.Location = new-object System.Drawing.Point(215,78) 
$DayConditionLabel.size = New-Object System.Drawing.Size(150,20) 
$DayConditionLabel.ForeColor = [System.Drawing.Color]::Red
$DayConditionLabel.Text = "Load Day Conditions" 
$global:PoiSelectionForm.Controls.Add($DayConditionLabel) 

$ChechboxConditions = New-Object System.Windows.Forms.CheckBox 
$ChechboxConditions.Location = New-Object System.Drawing.Size(200,80) 
$ChechboxConditions.size = New-Object System.Drawing.Size(15,15) 
$ChechboxConditions.ForeColor = [System.Drawing.Color]::FromArgb(255,140,0)
$global:PoiSelectionForm.Controls.Add($ChechboxConditions)
$ChechboxConditions.Add_Click({
    if($ChechboxConditions.Checked -eq $true){$DayConditionLabel.ForeColor = [System.Drawing.Color]::Gray}else{$DayConditionLabel.ForeColor = [System.Drawing.Color]::Red}
})

$NextPOILabel = New-Object System.Windows.Forms.Label 
$NextPOILabel.Location = new-object System.Drawing.Point(215,98) 
$NextPOILabel.size = New-Object System.Drawing.Size(150,20) 
$NextPOILabel.ForeColor = [System.Drawing.Color]::Gray
$NextPOILabel.Text = "Load Next Beacon (+3 sec)" 
$global:PoiSelectionForm.Controls.Add($NextPOILabel) 

$ChechboxNextPOI = New-Object System.Windows.Forms.CheckBox 
$ChechboxNextPOI.Location = New-Object System.Drawing.Size(200,100) 
$ChechboxNextPOI.size = New-Object System.Drawing.Size(15,15) 
$ChechboxNextPOI.ForeColor = [System.Drawing.Color]::FromArgb(255,140,0)
$global:PoiSelectionForm.Controls.Add($ChechboxNextPOI)
$ChechboxNextPOI.Add_Click({
    if($ChechboxNextPOI.Checked -eq $true){$NextPOILabel.ForeColor = [System.Drawing.Color]::Gray}else{$NextPOILabel.ForeColor = [System.Drawing.Color]::Red}
})

$ShowPOIBeaconLabel = New-Object System.Windows.Forms.Label 
$ShowPOIBeaconLabel.Location = new-object System.Drawing.Point(215,118) 
$ShowPOIBeaconLabel.size = New-Object System.Drawing.Size(150,20) 
$ShowPOIBeaconLabel.ForeColor = [System.Drawing.Color]::Red
$ShowPOIBeaconLabel.Text = "POIs with Beacons" 
$global:PoiSelectionForm.Controls.Add($ShowPOIBeaconLabel) 

$ChechboxPOIBeacon = New-Object System.Windows.Forms.CheckBox 
$ChechboxPOIBeacon.Location = New-Object System.Drawing.Size(200,120) 
$ChechboxPOIBeacon.size = New-Object System.Drawing.Size(15,15) 
$ChechboxPOIBeacon.ForeColor = [System.Drawing.Color]::FromArgb(255,140,0)
$global:PoiSelectionForm.Controls.Add($ChechboxPOIBeacon)
$ChechboxPOIBeacon.Add_Click({
    if($ChechboxPOIBeacon.Checked -eq $true){$ShowPOIBeaconLabel.ForeColor = [System.Drawing.Color]::Gray}else{$ShowPOIBeaconLabel.ForeColor = [System.Drawing.Color]::Red}
})

<#
$ShowDistancesGMLabel = New-Object System.Windows.Forms.Label 
$ShowDistancesGMLabel.Location = new-object System.Drawing.Point(215,138) 
$ShowDistancesGMLabel.size = New-Object System.Drawing.Size(150,20) 
$ShowDistancesGMLabel.ForeColor = [System.Drawing.Color]::Red
$ShowDistancesGMLabel.Text = "Distance in GM" 
$global:PoiSelectionForm.Controls.Add($ShowDistancesGMLabel) 

$ChechboxDistanceGM = New-Object System.Windows.Forms.CheckBox 
$ChechboxDistanceGM.Location = New-Object System.Drawing.Size(200,140) 
$ChechboxDistanceGM.size = New-Object System.Drawing.Size(15,15) 
$ChechboxDistanceGM.ForeColor = [System.Drawing.Color]::FromArgb(255,140,0)
$global:PoiSelectionForm.Controls.Add($ChechboxDistanceGM)
$ChechboxDistanceGM.Add_Click({
    if($ChechboxDistanceGM.Checked -eq $true){$ShowDistancesGMLabel.ForeColor = [System.Drawing.Color]::Gray}else{$ShowDistancesGMLabel.ForeColor = [System.Drawing.Color]::Red}
})

#>
$ShowDistancesGMLabel = New-Object System.Windows.Forms.Label 
$ShowDistancesGMLabel.Location = new-object System.Drawing.Point(400,60) 
$ShowDistancesGMLabel.Size = New-Object System.Drawing.Size(100,20) 
$ShowDistancesGMLabel.ForeColor = [System.Drawing.Color]::gray
$ShowDistancesGMLabel.Text = "Distance Scale" 
$global:PoiSelectionForm.Controls.Add($ShowDistancesGMLabel) 

$global:ComboboxDistanceGM = New-Object System.Windows.Forms.ComboBox 
$global:ComboboxDistanceGM.Location = New-Object System.Drawing.Size(500,58) 
$global:ComboboxDistanceGM.Size = New-Object System.Drawing.Size(100,20)
$global:ComboboxDistanceGM.DropDownHeight = 200 
$global:ComboboxDistanceGM.Items.Add("Meters")
$global:ComboboxDistanceGM.Items.Add("Kilometers")
$global:ComboboxDistanceGM.Items.Add("Megameters")
$global:ComboboxDistanceGM.Items.Add("Gigameters")
#$global:ComboboxDistanceGM.ForeColor = [System.Drawing.Color]::FromArgb(255,140,0)
$global:PoiSelectionForm.Controls.Add($global:ComboboxDistanceGM)
$global:ComboboxDistanceGM.Add_TextChanged({
    Update-Datagrid
})

#LISTBOX SYSTEM
$Systemlabel = New-Object System.Windows.Forms.Label 
$Systemlabel.Location = new-object System.Drawing.Point(20,60) 
$Systemlabel.size = New-Object System.Drawing.Size(60,20) 
$Systemlabel.Font= [System.Drawing.Font]::new('Dungeon', '12.75')
#$Systemlabel.Font = [System.Drawing.Font]::new($privateFonts.Families[0],12)
$Systemlabel.ForeColor = [System.Drawing.Color]::Gray

$Systemlabel.Text = "System" 
$global:PoiSelectionForm.Controls.Add($Systemlabel) 
$Systemlist = $FinalGroupsForForm.System | Select-Object -Unique | Sort-Object 
$SystemListComboBox = New-Object System.Windows.Forms.ComboBox #creating the dropdown list
$SystemListComboBox.Location = New-Object System.Drawing.Point(80,60) #location of the drop down (px) in relation to the primary window's edges (length, height)
$SystemListComboBox.Size = New-Object System.Drawing.Size($DropdownWidth,20) #the size in px of the drop down box (length, height)
$SystemListComboBox.DropDownHeight = 200 
$SystemListComboBox.Items.Add("all")
$global:SystemType = "all"
$global:PoiSelectionForm.Controls.Add($SystemListComboBox)
foreach ($System in $Systemlist) {
    $SystemListComboBox.Items.Add($System) | Out-Null
}

$SystemListComboBox = New-Object System.Windows.Forms.ComboBox #creating the dropdown list
$SystemListComboBox.Location = New-Object System.Drawing.Point(80,60) #location of the drop down (px) in relation to the primary window's edges (length, height)
$SystemListComboBox.Size = New-Object System.Drawing.Size($DropdownWidth,20) #the size in px of the drop down box (length, height)
$SystemListComboBox.DropDownHeight = 200 
$SystemListComboBox.Items.Add("all")
$global:SystemType = "all"
$global:PoiSelectionForm.Controls.Add($SystemListComboBox)
foreach ($System in $Systemlist) {
    $SystemListComboBox.Items.Add($System) | Out-Null
}

#LISTBOX TYPE
$Typelabel = New-Object System.Windows.Forms.Label 
$Typelabel.Location = new-object System.Drawing.Point(20,90) 
$Typelabel.size = New-Object System.Drawing.Size(60,20) 
$Typelabel.ForeColor = [System.Drawing.Color]::Gray
$Typelabel.Text = "Type" 
$global:PoiSelectionForm.Controls.Add($Typelabel) 
$TypeList = $FinalGroupsForForm.Type | Select-Object -Unique | Sort-Object 

$TypeListComboBox = New-Object System.Windows.Forms.ComboBox #creating the dropdown list
$TypeListComboBox.Location = New-Object System.Drawing.Point(80,90) #location of the drop down (px) in relation to the primary 
$TypeListComboBox.DropDownHeight = 200 
$TypeListComboBox.Size = New-Object System.Drawing.Size($DropdownWidth,20)
$global:PoiSelectionForm.Controls.Add($TypeListComboBox)
$TypeListComboBox.Items.Add("all")
$global:FilterType = "all"
foreach ($Type in $TypeList) {
    $TypeListComboBox.Items.Add($Type) | Out-Null
}

#LISTBOX PARENT
$Parentlabel = New-Object System.Windows.Forms.Label 
$Parentlabel.Location = new-object System.Drawing.Point(20,120) 
$Parentlabel.size = New-Object System.Drawing.Size(60,20) 
$Parentlabel.ForeColor = [System.Drawing.Color]::Gray
$Parentlabel.Text = "Parent" 
$global:PoiSelectionForm.Controls.Add($Parentlabel) 
$Parentlist = $FinalGroupsForForm.ObjectContainer | Select-Object -Unique | Sort-Object 

$ParentListComboBox = New-Object System.Windows.Forms.ComboBox #creating the dropdown list
$ParentListComboBox.Location = New-Object System.Drawing.Point(80,120) #location of the drop down (px) in relation to the primary window's edges (length, height)
$ParentListComboBox.Size = New-Object System.Drawing.Size($DropdownWidth,20) #the size in px of the drop down box (length, height)
$ParentListComboBox.DropDownHeight = 260 
$global:PoiSelectionForm.Controls.Add($ParentListComboBox)
$ParentListComboBox.Items.Add("all")
$global:FilterParent = "all"
foreach ($Parent in $Parentlist) {
    $ParentListComboBox.Items.Add($Parent) | Out-Null
}
$ParentListComboBox.SelectedIndex = 0

#LISTBOX PARENT
$Searchlabel = New-Object System.Windows.Forms.Label 
$Searchlabel.Location = new-object System.Drawing.Point(20,150) 
$Searchlabel.size = New-Object System.Drawing.Size(60,20) 
$Searchlabel.ForeColor = [System.Drawing.Color]::Gray
$Searchlabel.Text = "Search" 
$global:PoiSelectionForm.Controls.Add($Searchlabel)
$TextBoxSearch = New-Object System.Windows.Forms.TextBox 
$TextBoxSearch.Location = new-object System.Drawing.Point(80,150) 
$TextBoxSearch.size = New-Object System.Drawing.Size($DropdownWidth,20)  
$global:PoiSelectionForm.Controls.Add($TextBoxSearch) 

#ResultsHeader
$global:TextBoxResults = New-Object System.Windows.Forms.Label 
$global:TextBoxResults.Location = New-Object System.Drawing.Size(20,180) 
$global:TextBoxResults.Size = New-Object System.Drawing.Size(180,20) 
$global:TextBoxResults.Font = [System.Drawing.Font]::new('Dungeon', '12.75')
#$global:TextBoxResults.Font = [System.Drawing.Font]::new($privateFonts.Families[0],12)
$global:TextBoxResults.ForeColor = [System.Drawing.Color]::FromArgb(255,140,0)
$global:TextBoxResults.Text = "Results" 
$global:PoiSelectionForm.Controls.Add($TextBoxResults) 

# DATAGRID VIEW
$dataGridView = New-Object System.Windows.Forms.DataGridView
$dataGridView.Location = New-Object System.Drawing.Size(15,210)
$dataGridView.Size=New-Object System.Drawing.Size($FormAndGridWidth,400)

$dataGridView.MultiSelect = $false
$dataGridView.ReadOnly = $true
$dataGridView.AllowUserToAddRows = $false
$global:PoiSelectionForm.Controls.Add($dataGridView)
$dataGridView.ColumnCount = 12
$dataGridView.ColumnHeadersVisible = $true
$dataGridView.SelectionMode = 'FullRowSelect'
#$dataGridView.HeaderCell.Style.Alignment = 'MiddleRight' does not exists ?
$dataGridView.Columns[0].Name = "System"
$dataGridView.Columns[1].Name = "Parent"
$dataGridView.Columns[2].Name = "Type"
$dataGridView.Columns[3].Name = "Point of Interest"
$dataGridView.Columns[4].Name = "Distance (km)"
$dataGridView.Columns[4].DefaultCellStyle.Alignment = 'middleright'
$dataGridView.Columns[5].Name = "Next Beacon"
$dataGridView.Columns[5].DefaultCellStyle.Alignment = 'middleright'
$dataGridView.Columns[6].Name = "Condition"
$dataGridView.Columns[7].Name = "Next Rise"
$dataGridView.Columns[8].Name = "Next Set"
$dataGridView.Columns[9].Name = "Quantum Beacon"
$dataGridView.Columns[10].Name = "Comment"
$dataGridView.Columns[11].Name = "Date added"



#Fill Grid with All POIs
function Update-Datagrid{
    #Remove Contents of Datagrid to apply filters on results
    #Keep sorting after update
    #$DGSortOrder = $datagridview.DataSource.DefaultView.Sort #DefaultView does not exists
    $dataGridView.Rows.Clear()
    
    if($ChechboxDistances.Checked -eq $true){
        $ElapsedUTCTimeSinceSimulationStart = New-Timespan -End ($global:DateTime.ToUniversalTime()) -Start ([DateTime]"01.01.2020 00:00:00")     # GET ELPASED TIME BETWEEN SIMULATION TIME AND CURRENT TIME
        #
        $ClipboardContentRAW = (Get-Clipboard) -replace '(^\s+|\s+$)','' -replace '\s+',' '
        #CHECK IF CLIPBOARD CONTAINS COORDINATES
        if($ClipboardContentRAW -like '*Coordinates: x:*'){
                $ClipboardContainsCoordinates = $true 
                $ClipboardContentSplit = $ClipboardContentRAW.split("x:").split("y:").split("z:")
                [decimal]$CurrentXPosition = $ClipboardContentSplit[3]
                [decimal]$CurrentYPosition = $ClipboardContentSplit[5]
                [decimal]$CurrentZPosition = $ClipboardContentSplit[7]
                if(!$CurrentZPosition){
                    [decimal]$CurrentXPosition = $ClipboardContentSplit[1]
                    [decimal]$CurrentYPosition = $ClipboardContentSplit[2]
                    [decimal]$CurrentZPosition = $ClipboardContentSplit[3]
                }
        }
    }
    #####
    switch($ComboboxDistanceGM.SelectedItem){
        "Meters"     {[decimal]$DistancScale = 1         ;$PrecisionCount = 0; $dataGridView.Columns[4].Name = "Distance to Player (m)"}
        "Kilometers" {[decimal]$DistancScale = 1000      ;$PrecisionCount = 1; $dataGridView.Columns[4].Name = "Distance to Player (km)"}
        "Megameters" {[decimal]$DistancScale = 1000000   ;$PrecisionCount = 3; $dataGridView.Columns[4].Name = "Distance to Player (Mm)"}
        "Gigameters" {[decimal]$DistancScale = 1000000000;$PrecisionCount = 3; $dataGridView.Columns[4].Name = "Distance to Player (Gm)"}
    }
    #Filter Buttons
    foreach ($Group in $FinalGroupsForForm){
        $OptionCounter = 0
        foreach ($Option in $Group.Options){
            #################### PRE CALCULATIONS FOR PLAYER TO POI DISTANCE
            if($ChechboxDistances.Checked -eq $true -AND $CurrentXPosition -ne ""){
                $PoiCoordDataPlanet = $Group.ObjectContainer[$OptionCounter]
                $SelectedPlanet = $ObjectContainerData.GetEnumerator() | Where-Object { $_.Name -eq $PoiCoordDataPlanet}
                [decimal]$PlanetCoordDataX = $SelectedPlanet.'X-Coord'/1000
                [decimal]$PlanetCoordDataY = $SelectedPlanet.'Y-Coord'/1000
                [decimal]$PlanetCoordDataZ = $SelectedPlanet.'Z-Coord'/1000
                [decimal]$PlanetRotationSpeed = $SelectedPlanet.RotationSpeedX
                [decimal]$PlanetRotationStart = $SelectedPlanet.RotationAdjustmentX
                [decimal]$LengthOfDayDecimal = [decimal]$PlanetRotationSpeed * 3600 / 86400  
                [decimal]$JulianDate = $ElapsedUTCTimeSinceSimulationStart.TotalDays        
                [decimal]$TotalCycles = $JulianDate / $LengthOfDayDecimal                   
                [decimal]$CurrentCycleDez = $TotalCycles%1
                [decimal]$CurrentCycleDeg = $CurrentCycleDez * 360
                if (($CurrentCycleDeg + $PlanetRotationStart) -lt 360){[decimal]$CurrentCycleAngle = $PlanetRotationStart + $CurrentCycleDeg}else{[decimal]$CurrentCycleAngle = [decimal]$CurrentCycleDeg}
                [decimal]$PoiRotationValueX = [decimal]$Group.XCoord[$OptionCounter] * ([math]::Cos($CurrentCycleAngle/180*[System.Math]::PI)) - [decimal]$Group.YCoord[$OptionCounter] * ([math]::Sin($CurrentCycleAngle/180*[System.Math]::PI))
                [decimal]$PoiRotationValueY = [decimal]$Group.XCoord[$OptionCounter] * ([math]::Sin($CurrentCycleAngle/180*[System.Math]::PI)) + [decimal]$Group.YCoord[$OptionCounter] * ([math]::Cos($CurrentCycleAngle/180*[System.Math]::PI))
                [decimal]$DestCoordDataX = ($PlanetCoordDataX + $PoiRotationValueX) * 1000
                [decimal]$DestCoordDataY = ($PlanetCoordDataY + $PoiRotationValueY) * 1000
                [decimal]$DestCoordDataZ = ($PlanetCoordDataZ + $PoiCoordDataZ) * 1000



                $DGDistance =  [math]::Round([math]::Sqrt([math]::pow(($CurrentXPosition - $DestCoordDataX),2) + [math]::pow(($CurrentYPosition - $DestCoordDataY),2) + [math]::pow(($CurrentZPosition - $DestCoordDataZ),2))/$DistancScale,$PrecisionCount)
            }else{
                $DGDistance = "no Player coordinates"
            }
            if($ChechboxDistances.Checked -eq $false){$DGDistance = "enable checkbox"}
            #################### PRE CALCULATIONS FOR NEXT POIS
            $DGNextPOI  = "enable Checkbox"
            if($ChechboxNextPOI.Checked -eq $true){
                $PoisOnSamePlanet = @()
                $PoisOnSamePlanet = $DBPOI | Where-Object {$_.Container -contains $Group.ObjectContainer[$OptionCounter]}
                $PoisOnSamePlanet | Add-Member -MemberType NoteProperty "DistanceNextPOI" -Value "" -Force
                foreach($PoiEntry in $PoisOnSamePlanet){
                    $DistanceNextPOI = [math]::Sqrt([math]::pow([double]$PoiEntry.XPos - [decimal]$Group.XCoord[$OptionCounter],2) + [math]::pow([double]$PoiEntry.YPos - [decimal]$Group.YCoord[$OptionCounter],2) + [math]::pow([double]$PoiEntry.ZPos - [decimal]$Group.ZCoord[$OptionCounter],2))
                    $PoiEntry.DistanceNextPOI = [math]::Round($DistanceNextPOI,3)
                } 
                $NextPOI = $PoisOnSamePlanet | Sort-Object DistanceNextPOI | Where-Object {$_.DistanceNextPOI -gt 0.010} | Where-Object {$_.Name -Notlike "OM-*"} | Where-Object {$_.QTMarker -eq "TRUE"} | Select-Object -First 1
                $DGNextPOI = if($NextPOI){"$($NextPOI.Name) @ $([math]::Round($NextPOI.DistanceNextPOI,1)) km"}
            }else{
                $DGNextPOI  = "no POI in DB found"
            }
            ####################
            if($ChechboxConditions.Checked -eq $true){
                $DGCondition = "WIP"
                $DGRise = "WIP"
                $DGSet = "WIP"
            }
            else{
                $DGCondition = "WIP"
                $DGRise = "WIP"
                $DGSet = "WIP"
            }


            $DGType     =  $Group.Type[$OptionCounter]
            $DGSystem   =  $Group.System[$OptionCounter]
            $DGParent   =  $Group.ObjectContainer[$OptionCounter]
            $DGDate     =  $Group.Date[$OptionCounter]
            $DGComment  =  $Group.Comment[$OptionCounter]
            $DGQB       = "WIP"

            if($DGSystem -match $global:SystemType -OR $global:SystemType -eq "all"){ #FIlter Systems
                if($DGType -match $global:FilterType -OR $global:FilterType -eq "all"){ #Filter Type
                    if($DGParent -match $global:FilterParent -OR $global:FilterParent -eq "all"){ #Filter Parent /
                        if("" -ne $TextBoxSearch.Text){ #check if search contains data / SEARCH
                            switch -Wildcard ($TextBoxSearch.Text){
                                {$DGType -match $_}     {$dataGridView.Rows.Add($DGSystem,$DGParent,$DGType,$Option,$DGDistance,$DGNextPOI,$DGCondition,$DGRise,$DGSet,$DGQB,$DGComment,$DGDate) | Out-Null; Break}
                                {$DGSystem -match $_}   {$dataGridView.Rows.Add($DGSystem,$DGParent,$DGType,$Option,$DGDistance,$DGNextPOI,$DGCondition,$DGRise,$DGSet,$DGQB,$DGComment,$DGDate) | Out-Null; Break}
                                {$DGParent -match $_}   {$dataGridView.Rows.Add($DGSystem,$DGParent,$DGType,$Option,$DGDistance,$DGNextPOI,$DGCondition,$DGRise,$DGSet,$DGQB,$DGComment,$DGDate) | Out-Null; Break}
                                {$DGComment -match $_}  {$dataGridView.Rows.Add($DGSystem,$DGParent,$DGType,$Option,$DGDistance,$DGNextPOI,$DGCondition,$DGRise,$DGSet,$DGQB,$DGComment,$DGDate) | Out-Null; Break}
                                {$Option -match $_}     {$dataGridView.Rows.Add($DGSystem,$DGParent,$DGType,$Option,$DGDistance,$DGNextPOI,$DGCondition,$DGRise,$DGSet,$DGQB,$DGComment,$DGDate) | Out-Null; Break}
                                Default {break}
                            }
                        }else{ #if search is empty add entry to datagrid
                            $dataGridView.Rows.Add($DGSystem,$DGParent,$DGType,$Option,$DGDistance,$DGNextPOI,$DGCondition,$DGRise,$DGSet,$DGQB,$DGComment,$DGDate) | Out-Null
                        }
                        
                    }
                }
            }
            $OptionCounter++
        }
        
    }
    $dataGridView.AutoSizeColumnsMode = 'AllCells'
    $DatagridEntries = $DataGridView.Rows.GetRowCount([System.Windows.Forms.DataGridViewElementStates]::Visible)
    $TextBoxResults.Text = "Results ($DatagridEntries)" 
    #restore sortorder
    #$datagridview.DataSource.DefaultView.Sort = $DGSortOrder
}


#
$SystemListComboBox.Add_TextChanged({
    $global:SystemType = $SystemListComboBox.Text
    Update-Datagrid
})
$SystemListComboBox.SelectedIndex = 0



$TypeListComboBox.Add_TextChanged({
    $global:FilterType = $TypeListComboBox.Text
    Update-Datagrid
})
$TypeListComboBox.SelectedIndex = 0

$ParentListComboBox.Add_TextChanged({
    $global:FilterParent = $ParentListComboBox.Text
    Update-Datagrid
})

#Gives the user some time to enter his text in searchbox, each change resets the timer
$TextBoxSearch.Add_TextChanged({
    if(($TextBoxSearch.Text).length -ge 3){
        $global:TextBoxResults.Text = "Results (Searching)" 
        Update-Datagrid
    }
})





# DEFINE RUN BUTTON
$RunButton = New-Object System.Windows.Forms.Button 
$RunButton.Location = New-Object System.Drawing.Size(20,10) 
$RunButton.Size = New-Object System.Drawing.Size(80,40) 
$RunButton.Text = "Select Destination" 
$RunButton.ForeColor = [System.Drawing.Color]::FromArgb(255,140,0)
$global:PoiSelectionForm.Controls.Add($RunButton)
$RunButton.Add_Click({
    $global:CurrentDestination = $dataGridView.SelectedRows.Cells[3].Value
    Unregister-Event MyTimer -ErrorAction Ignore 
    $global:PoiSelectionForm.Close()
})





#$PoiSelectionForm.ShowDialog()

# DEFINE LOAD BUTTON, TO GIVE PREREQUESTS
$SearchButton = New-Object System.Windows.Forms.Button 
$SearchButton.Location = New-Object System.Drawing.Size(105,10) 
$SearchButton.Size = New-Object System.Drawing.Size(80,40) 
$SearchButton.Text = "Update" 
$SearchButton.ForeColor = [System.Drawing.Color]::FromArgb(255,140,0)
$global:PoiSelectionForm.Controls.Add($SearchButton)
$SearchButton.Add_Click({
    #Start-Process "msg" -ArgumentList "* box content = $($ComboboxDistanceGM.SelectedItem)"
    Update-Datagrid
})

##################
### LEGEND BOX ###
##################
$Legend = New-Object System.Windows.Forms.GroupBox
$Legend.Location = New-Object System.Drawing.Size(950,5) 
$Legend.size = New-Object System.Drawing.Size(200,120) 
$Legend.Name = "Legend"
$Legend.text = "Legend" 
$Legend.ForeColor = [System.Drawing.Color]::FromArgb(255,140,0)

# LEGEND - FIRST ENTRY
$Legend1 = New-Object System.Windows.Forms.Label 
$Legend1.Location = new-object System.Drawing.Point(21,20) 
$Legend1.size = New-Object System.Drawing.Size(150,20) 
$Legend1.ForeColor = [System.Drawing.Color]::Gray
$Legend1.Text = "No coordinates available" 
$Legend.Controls.Add($Legend1) 
# 
$Legend2 = New-Object System.Windows.Forms.Label 
$Legend2.Location = new-object System.Drawing.Point(21,38) 
$Legend2.size = New-Object System.Drawing.Size(150,20) 
$Legend2.ForeColor = [System.Drawing.Color]::Red
$Legend2.Text = "currently not ingame" 
$Legend.Controls.Add($Legend2)
# 
$Legend3 = New-Object System.Windows.Forms.Label 
$Legend3.Location = new-object System.Drawing.Point(21,56) 
$Legend3.size = New-Object System.Drawing.Size(150,20) 
$Legend3.ForeColor = [System.Drawing.Color]::Green
$Legend3.Text = "recent additions" 
$Legend.Controls.Add($Legend3) 
# 
$Legend4 = New-Object System.Windows.Forms.Label 
$Legend4.Location = new-object System.Drawing.Point(21,74) 
$Legend4.size = New-Object System.Drawing.Size(150,20) 
$Legend4.ForeColor = [System.Drawing.Color]::White
$Legend4.Text = "default entries" 
$Legend.Controls.Add($Legend4) 
$global:PoiSelectionForm.Controls.Add($Legend)

##########################
### CUSTOM COORDINATES ###
##########################
$CustomCoordsTextbox = New-Object System.Windows.Forms.GroupBox
$CustomCoordsTextbox.Location = New-Object System.Drawing.Size(650,5) 
$CustomCoordsTextbox.size = New-Object System.Drawing.Size(250,120) 
$CustomCoordsTextbox.text = "    Custom Global Coordinates:" 
$CustomCoordsTextbox.Name = "Custom Global Coordinates"
$CustomCoordsTextbox.ForeColor = [System.Drawing.Color]::FromArgb(255,140,0)


# BOX3 - FIRST RADIO BUTTON
$CustomButton = New-Object System.Windows.Forms.CheckBox 
$CustomButton.Location = new-object System.Drawing.Point(3,1) 
$CustomButton.size = New-Object System.Drawing.Size(15,15)
#$CustomButton.Checked = $true 
$CustomCoordsTextbox.Controls.Add($CustomButton) 

# X LABEL
$TextBoxLabel = New-Object System.Windows.Forms.Label
$TextBoxLabel.Location = new-object System.Drawing.Point(5,28)
$TextBoxLabel.size = New-Object System.Drawing.Size(15,15) 
$TextBoxLabel.Text = "X ="
$CustomCoordsTextbox.Controls.Add($TextBoxLabel) 

# X INPUT
$TextBoxX = New-Object System.Windows.Forms.TextBox 
$TextBoxX.Location = new-object System.Drawing.Point(20,25) 
$TextBoxX.size = New-Object System.Drawing.Size(170,20)  
$CustomCoordsTextbox.Controls.Add($TextBoxX) 

# Y LABEL
$TextBoxLabel = New-Object System.Windows.Forms.Label
$TextBoxLabel.Location = new-object System.Drawing.Point(5,48)
$TextBoxLabel.size = New-Object System.Drawing.Size(15,15) 
$TextBoxLabel.Text = "Y ="
$CustomCoordsTextbox.Controls.Add($TextBoxLabel) 
# Y INPUT
$TextBoxY = New-Object System.Windows.Forms.TextBox 
$TextBoxY.Location = new-object System.Drawing.Point(20,45) 
$TextBoxY.size = New-Object System.Drawing.Size(170,20)  
$CustomCoordsTextbox.Controls.Add($TextBoxY) 

# Z LABEL
$TextBoxLabel = New-Object System.Windows.Forms.Label
$TextBoxLabel.Location = new-object System.Drawing.Point(5,68)
$TextBoxLabel.size = New-Object System.Drawing.Size(15,15) 
$TextBoxLabel.Text = "Z ="
$CustomCoordsTextbox.Controls.Add($TextBoxLabel) 
# Z INPUT
$TextBoxZ = New-Object System.Windows.Forms.TextBox 
$TextBoxZ.Location = new-object System.Drawing.Point(20,65) 
$TextBoxZ.size = New-Object System.Drawing.Size(170,20)  
$CustomCoordsTextbox.Controls.Add($TextBoxZ) 

$global:PoiSelectionForm.Controls.Add($CustomCoordsTextbox) 

#Preset Checkboxes
$ChechboxDistances.Checked = $true
$ChechboxConditions.Checked = $false
$ChechboxNextPOI.Checked = $true
$ChechboxPOIBeacon.Checked = $false
$global:ComboboxDistanceGM.SelectedIndex = 1

Update-Datagrid
<#
$PoiSelectionForm.ShowDialog()
#>
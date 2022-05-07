# Shows FrontEnd to User
Function Show-Frontend {
    $script:MainForm.Add_Shown({$Form.Activate()})
    [void]$script:MainForm.ShowDialog() | Out-Null
}

# DYNAMIC FRONTEND
# 
function New-DynamicFormMainframe{
    
    # LOAD PRERQUESTS FOR SYSTEM WINDOWS FORMS
    try {
        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")  
        Add-Type -assembly System.Windows.Forms
    }
    catch {
        Write-Warning -Message 'Unable to load required assemblies'
        return
    }
    if(!$script:MainForm -eq $null){Clear-Variable -Name $script:MainForm}
    

    #GET ALL VARIABLES (ARRAYS) THAT CONTAIN DATAGROUP IN THEIR NAME 
    $AllDGVariables = Get-Variable -Include "DataGroup*"
    $FinalGroupsForForm = @()
    foreach ($DGVariable in $AllDGVariables){
        $FinalGroupsForForm += New-Object psobject -Property @{
            Groups = $DGVariable.Name.Replace("DataGroup","")
            Options = $DGVariable.Value
        }
    }
    #$FinalGroupsForForm | FT -Property Groups, Options

    #Count Groups
    $NumberFormGroups = $FinalGroupsForForm.Groups.Count

    #Count max Options
    [System.Collections.ArrayList]$ListOfOptions = @()
    foreach ($FormGroup in $FinalGroupsForForm){
        $ListOfOptions.add($FormGroup.Options.Count) | Out-Null
    }

    #DEFINE SIZE, BORDERS & CO
    $GroupBoxWidth = 250
    $GroupBoxSpacing = 20
    $OptionHeight = 24
    $OptionWidth = 220
    $OptionSpacer = 5
    $CustomWidth = 720
    $CustomHeight = 20
    $script:MainFormVerticalSpace = 150
    $script:MainFormVerticalBorder = 10
    $script:MainFormHorizontalBorder = 10


    $NumberFormMostOptions = $ListOfOptions | Sort-Object -Descending | Select-Object -First 1
    $script:MainFormWidth = $GroupBoxSpacing + $script:MainFormHorizontalBorder + $NumberFormGroups * $GroupBoxWidth + $CustomWidth
    $script:MainFormHeight = $script:MainFormVerticalSpace + $script:MainFormVerticalBorder + $NumberFormMostOptions * $OptionHeight + $CustomHeight
    #CHECK IF GROUPS OR OPTIONS EXCEED SCREENSIZE
    $ScreenResolution = [System.Windows.Forms.Screen]::AllScreens | Where-Object {$_.DeviceName -like "*DISPLAY1"}  #GET MAX SCREEN RESOLUTION
    $MaxFormSizeWidth = $ScreenResolution[0].WorkingArea.Width         #GET MAX WIDTH FROM PRIMARY SCREEN
    $MaxFormSizeHeight = $ScreenResolution[0].WorkingArea.Height       #GET MAX HEIGHT FROM PRIMARY SCREEN

    #IF FORM EXCEEDS SCREEN SIZE
    if ($script:MainFormWidth -gt $MaxFormSizeWidth -OR $script:MainFormHeight -gt $MaxFormSizeHeight){
        Write-Warning "Current form will exceed screen limits $($MaxFormSizeWidth):$($MaxFormSizeHeight) Form $($script:MainFormWidth):$($script:MainFormHeight)"
    }

    #Create Final Border
    $script:MainForm = New-Object System.Windows.Forms.Form                                    # Create new object
    $script:MainForm_Drawing_Size = New-Object System.Drawing.Size
    $script:MainForm_Drawing_Size.Width = $script:MainFormWidth
    $script:MainForm_Drawing_Size.Height = $script:MainFormHeight + $script:MainFormVerticalBorder + $script:MainFormVerticalBorder * 6
    $script:MainForm.Size = $script:MainForm_Drawing_Size
    $script:MainForm.Text = "Project Jericho"                                                  # Window Title
    $script:MainForm.StartPosition = 'CenterScreen'                                            # Position on Screen

    #DYNAMIC BOXES, FOR EACH DATAGROUP ONE BOX TO THE RIGHT
    $GroupBoxCounter = 0
    foreach ($Group in $FinalGroupsForForm){
        $GroupBoxCounter++
        $ListOfGroupOptions = $Group.Options.Count

        #SET GROUPBOX 
        $groupBox = New-Object System.Windows.Forms.GroupBox
        #SET POSITION OF GROUPBOX
        $GroupBox_Drawing_Size = New-Object System.Drawing.Size
        $GroupBox_Drawing_Size.Width = $GroupBoxSpacing + (($GroupBoxCounter -1) * $GroupBoxWidth)
        $GroupBox_Drawing_Size.Height = $script:MainFormVerticalSpace 
        $groupBox.Location = $GroupBox_Drawing_Size
        $groupBox.text = $Group.Groups
        $groupBox.Name = "GroupBox_$($Group.Groups)"
        #SET SIZE OF OF GROUPBOX 
        $GroupBox_Option_Drawing_Size = New-Object System.Drawing.Size
        $GroupBox_Option_Drawing_Size.Width = $OptionWidth + $GroupBoxSpacing
        $GroupBox_Option_Drawing_Size.Height = $GroupBoxSpacing + 2 * $OptionSpacer + ($OptionHeight) * $ListOfGroupOptions
        $groupBox.size = $GroupBox_Option_Drawing_Size
        $script:MainForm.Controls.Add($groupBox)

        #SET OPTIONS
        $OptionCounter = 0
        foreach ($Option in $Group.Options){
            $OptionCounter++
            $script:OptionBox = New-Object System.Windows.Forms.CheckBox
            if($Group.Groups -like "*Destinations"){$script:OptionBox = New-Object System.Windows.Forms.RadioButton}
            #SET POSITION OF OPTION
            $Option_Drawing_Size = New-Object System.Drawing.Size
            $Option_Drawing_Size.Width = $OptionSpacer
            $Option_Drawing_Size.Height = $OptionCounter * $OptionHeight
            $OptionBox.Location = $Option_Drawing_Size
            #SET SIZE OF OPTION
            $OptionBox.size = New-Object System.Drawing.Size($OptionWidth,$OptionHeight) 
            $OptionBox.Text = $Option
            $OptionBox.Name = "Option_$($Option)"
            if($OptionBox.Name -like "*OptionB2"){$OptionBox.ForeColor = [System.Drawing.Color]::Gray}
            $groupBox.Controls.Add($OptionBox) 
        }
    }

    # DEFINE RUN BUTTON
    $RunButton = New-Object System.Windows.Forms.Button 
    $RunButton.Location = New-Object System.Drawing.Size(30,10) 
    $RunButton.Size = New-Object System.Drawing.Size(80,40) 
    $RunButton.Text = "RUN" 
    $MainForm.Controls.Add($RunButton)
    $RunButton.Add_Click({
        $script:StartNavigation = $true
        $MainForm.Close()
    })

    # DEFINE LOAD BUTTON, TO GIVE PREREQUESTS
    $LoadButton = New-Object System.Windows.Forms.Button 
    $LoadButton.Location = New-Object System.Drawing.Size(130,10) 
    $LoadButton.Size = New-Object System.Drawing.Size(80,40) 
    $LoadButton.Text = "LOAD" 
    $MainForm.Controls.Add($LoadButton)
    $LoadButton.Add_Click({
        foreach ($Box in $script:MainForm.Controls){
            foreach ($Checkbox in $Box.Controls){
                if($Checkbox.Name -like "*Lagrange - ARC-L3"){$Checkbox.Checked = $true;$Checkbox.ForeColor  = [System.Drawing.Color]::Green}
                if($Checkbox.Name -like "*Lagrange - MIC-L1"){$Checkbox.Checked = $true;$Checkbox.ForeColor  = [System.Drawing.Color]::Green}
                if($Checkbox.Name -like "*Hurston") {$Checkbox.Checked = $true;$Checkbox.ForeColor  = [System.Drawing.Color]::Green}
            }
        }
    })

    ### PROGRESS BAR ###
    # https://powershell.anovelidea.org/powershell/windows-forms/
    $StatusStrip = New-Object System.Windows.Forms.StatusStrip
    $StatusStrip.Name = 'StatusStrip'
    #$StatusStrip.AutoSize = $true
    $StatusStrip.AutoSize = $false
    $StatusStrip.Left = 0
    $StatusStrip.Visible = $true
    $StatusStrip.Enabled = $true
    $StatusStrip.Dock = [System.Windows.Forms.DockStyle]::Bottom
    $StatusStrip.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left
    #$StatusStrip.LayoutStyle = [System.Windows.Forms.ToolStripLayoutStyle]::Table
    $StatusStrip.LayoutStyle = [System.Windows.Forms.ToolStripLayoutStyle]::HorizontalStackWithOverflow
    #$StatusStrip.BorderSides = "Left"
    $StatusStrip.BorderStyle = "Etched"

    $Copyright = [System.Windows.Forms.ToolStripLabel]::new()
    $Copyright.Name = 'Copyright'
    $Copyright.Text = "© [VORA] Graupunkt, [DSC] Murphy, [IFE] Xabdiben, BigCheese"
    $Copyright.Width = 200
    $Copyright.Visible = $true

    $Progress = [System.Windows.Forms.ToolStripLabel]::new()
    $Progress.Name = 'Progress'
    $Progress.Text = $null
    $Progress.Text = "                                                                                              "
    $Progress.Width = 50
    $Progress.Visible = $true

    $ProgressBar = [System.Windows.Forms.ToolStripProgressBar]::new()
    $ProgressBar.Name = 'ProgressBar'
    $ProgressBar.Width = 50
    $ProgressBar.Visible = $false

    $SupportInfo = [System.Windows.Forms.ToolStripLabel]::new()
    $SupportInfo.Name = 'Copyright'
    $SupportInfo.Text = 'Support and Updates (Deutsch / English) @'
    $SupportInfo.Width = 400
    $SupportInfo.Visible = $true

    $SupportLink = [System.Windows.Forms.ToolStripLabel]::new()
    $SupportLink.Name = 'Support'
    $SupportLink.IsLink = $true
    $SupportLink.LinkBehavior = System.Windows.Forms.LinkBehavior.AlwaysUnderline
    $SupportLink.Text = "https://www.guilded.gg/projectjericho"
    $SupportLink.Tag = "https://www.guilded.gg/projectjericho"
    $SupportLink.Width = 50
    $SupportLink.Visible = $true
    $SupportLink.add_Click={
        [System.Diagnostics.Process]::Start($SupportLink.Text)
    }

    $StatusStrip.Items.AddRange(
        [System.Windows.Forms.ToolStripItem[]]@(
            $Copyright,
            $Progress,
            $ProgressBar,
            $SupportInfo,
            $SupportLink
        )
    )
    $MainForm.Controls.Add($StatusStrip) 

    ##################
    ### LEGEND BOX ###
    ##################
    $Legend = New-Object System.Windows.Forms.GroupBox
    $Legend.Location = New-Object System.Drawing.Size(240,5) 
    $Legend.size = New-Object System.Drawing.Size(250,120) 
    $Legend.text = "Legend" 
    $MainForm.Controls.Add($Legend)
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
    $Limits.Location = New-Object System.Drawing.Size(760,5) 
    $Limits.size = New-Object System.Drawing.Size(250,120) 
    $Limits.text = "Limits (meters)" 
    $MainForm.Controls.Add($Limits) 

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

    #####################
    ### 3RD PARTY BOX ###
    #####################
    $3rdPartyBox = New-Object System.Windows.Forms.GroupBox
    $3rdPartyBox.Location = New-Object System.Drawing.Size(1020,5) 
    $3rdPartyBox.size = New-Object System.Drawing.Size(200,120) 
    $3rdPartyBox.text = "3rd Party Tools Autostart" 
    $MainForm.Controls.Add($3rdPartyBox) 

    # First Tool
    $ToolShowLocation = New-Object System.Windows.Forms.CheckBox
    $ToolShowLocation.Location = new-object System.Drawing.Point(5,20) 
    $ToolShowLocation.size = New-Object System.Drawing.Size(185,20)
    $ToolShowLocation.Text = "Update Location Hotkey" 
    $3rdPartyBox.Controls.Add($ToolShowLocation) 

    # Second Tool
    $ToolAntilogoff = New-Object System.Windows.Forms.CheckBox
    $ToolAntilogoff.Location = new-object System.Drawing.Point(5,40) 
    $ToolAntilogoff.size = New-Object System.Drawing.Size(185,20)
    $ToolAntilogoff.Text = "Anti-Logoff" 
    $3rdPartyBox.Controls.Add($ToolAntilogoff) 

    # Third Tool
    $ToolShowOnTop = New-Object System.Windows.Forms.CheckBox
    $ToolShowOnTop.Location = new-object System.Drawing.Point(5,60) 
    $ToolShowOnTop.size = New-Object System.Drawing.Size(185,20)
    $ToolShowOnTop.Text = "ShowOnTop" 
    $3rdPartyBox.Controls.Add($ToolShowOnTop) 

    # Foruth Tool
    $ToolAutorun = New-Object System.Windows.Forms.CheckBox
    $ToolAutorun.Location = new-object System.Drawing.Point(5,80) 
    $ToolAutorun.size = New-Object System.Drawing.Size(185,20)
    $ToolAutorun.Text = "AutoRun Toggle" 
    $3rdPartyBox.Controls.Add($ToolAutorun) 

    ##########################
    ### CUSTOM COORDINATES ###
    ##########################
    $TextBox = New-Object System.Windows.Forms.GroupBox
    $TextBox.Location = New-Object System.Drawing.Size(500,5) 
    $TextBox.size = New-Object System.Drawing.Size(250,120) 
    $TextBox.text = "    Stanton Coordinates:" 
    $MainForm.Controls.Add($TextBox) 

    # BOX3 - FIRST RADIO BUTTON
    $CustomButton = New-Object System.Windows.Forms.CheckBox 
    $CustomButton.Location = new-object System.Drawing.Point(3,1) 
    $CustomButton.size = New-Object System.Drawing.Size(15,15)
    #$CustomButton.Checked = $true 
    $TextBox.Controls.Add($CustomButton) 

    # X LABEL
    $TextBoxLabel = New-Object System.Windows.Forms.Label
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
    $TextBoxLabel = New-Object System.Windows.Forms.Label
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
    $TextBoxLabel = New-Object System.Windows.Forms.Label
    $TextBoxLabel.Location = new-object System.Drawing.Point(5,68)
    $TextBoxLabel.size = New-Object System.Drawing.Size(15,15) 
    $TextBoxLabel.Text = "Z ="
    $TextBox.Controls.Add($TextBoxLabel) 
    # Z INPUT
    $TextBoxZ = New-Object System.Windows.Forms.TextBox 
    $TextBoxZ.Location = new-object System.Drawing.Point(20,65) 
    $TextBoxZ.size = New-Object System.Drawing.Size(170,20)  
    $TextBox.Controls.Add($TextBoxZ) 

    if ($ToolAntilogoff.Checked   -eq $true){$script:ListOfToolsToStart += "ToolAntilogoff"}
    if ($ToolShowLocation.Checked -eq $true){$script:ListOfToolsToStart += "ToolShowLocation"}
    if ($ToolShowOnTop.Checked    -eq $true){$script:ListOfToolsToStart += "ToolShowOnTop"}
    if ($ToolAutorun.Checked      -eq $true){$script:ListOfToolsToStart += "ToolAutorun"}

    $script:MainForm.ShowDialog()| Out-Null

    #DEFINE VARIABLES AND ACTIONS FOR EACH BUTTON
    foreach ($Box in $script:MainForm.Controls){
        if($Box.Name -like "*Destinations"){
            foreach ($Checkbox in $Box.Controls){
                if($Checkbox.Checked){$script:CurrentDestination = $Checkbox.Name.replace('Option_',"")}
            }
        }
        if($Box.Name -like "*QuantumMarker"){
            foreach ($Checkbox in $Box.Controls){
                if($Checkbox.Checked){$script:CurrentQuantumMarker += $Checkbox.Name.replace('Option_',"")}
            }
        }
    }

}
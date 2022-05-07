# TEST DATA
$DataGroupSettings = @(
    "OptionA1"
    "OptionA2"
)

$DataGroupTools = @(
    "OptionB1"
    "OptionB2"
    "OptionB3"
)

$DataGroupDefaults = @(
    "OptionC1"
)


# Complete Window / Frame
function Create_DynamicFormMainframe{
    
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
    $OptionWidth = 190
    $OptionSpacer = 5
    $script:MainFormVerticalSpace = 150
    $script:MainFormVerticalBorder = 10
    $script:MainFormHorizontalBorder = 10


    $NumberFormMostOptions = $ListOfOptions | Sort-Object -Descending | Select-Object -First 1
    $script:MainFormWidth = $GroupBoxSpacing + $script:MainFormHorizontalBorder + $NumberFormGroups * $GroupBoxWidth
    $script:MainFormHeight = $script:MainFormVerticalSpace + $script:MainFormVerticalBorder + $NumberFormMostOptions * $OptionHeight
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
        $groupBox.Name = "GroupBox$($Group.Groups)"
        #SET SIZE OF OF GROUPBOX 
        $GroupBox_Option_Drawing_Size = New-Object System.Drawing.Size
        $GroupBox_Option_Drawing_Size.Width = $OptionWidth + $GroupBoxSpacing
        $GroupBox_Option_Drawing_Size.Height = $GroupBoxSpacing + ($OptionSpacer + $OptionHeight) * $ListOfGroupOptions 
        $groupBox.size = $GroupBox_Option_Drawing_Size
        $script:MainForm.Controls.Add($groupBox)

        #SET OPTIONS
        $OptionCounter = 0
        foreach ($Option in $Group.Options){
            $OptionCounter++
            $script:OptionBox = New-Object System.Windows.Forms.CheckBox 
            #SET POSITION OF OPTION
            $Option_Drawing_Size = New-Object System.Drawing.Size
            $Option_Drawing_Size.Width = $OptionSpacer
            $Option_Drawing_Size.Height = $OptionCounter * $OptionHeight
            $OptionBox.Location = $Option_Drawing_Size
            #SET SIZE OF OPTION
            $OptionBox.size = New-Object System.Drawing.Size($OptionWidth,$OptionHeight) 
            $OptionBox.Text = $Option
            $OptionBox.Name = "Option$($Option)"

            if($OptionBox.Name -like "*OptionB2"){$OptionBox.ForeColor = [System.Drawing.Color]::Gray}
            $groupBox.Controls.Add($OptionBox) 
        }
    }

    # DEFINE RUN BUTTON
    $Button = New-Object System.Windows.Forms.Button 
    $Button.Location = New-Object System.Drawing.Size(30,10) 
    $Button.Size = New-Object System.Drawing.Size(80,40) 
    $Button.Text = "RUN" 
    $MainForm.Controls.Add($Button)

    #DEFINE ACTIONS
    $Button.Add_Click({
        $MainForm.Close()
    })

    $script:MainForm.ShowDialog()| Out-Null

}


Create_DynamicFormMainframe

#DEBUG - SHOW ALL GORUPBOXES
$script:MainForm.Controls.Name

#DEBUG - SHOW ALL OPTIONS
#$script:MainForm.Controls[0].Controls.Name
#$script:MainForm.Controls[1].Controls.Name
#$script:MainForm.Controls[2].Controls.Name

foreach ($Box in $script:MainForm.Controls){
    foreach ($Checkbox in $Box.Controls){
        $Checkbox.Name
        if($Checkbox.Name -like "*OptionC1")
        {
            Write-Host "test successful"
        }
    }
}


#BUTTONS
foreach ($Box in $script:MainForm.Controls){
    foreach ($Checkbox in $Box.Controls){
        $Checkbox.Name
        if($Checkbox.Name -like "*OptionC1")
        {
            Write-Host "test successful"
        }
    }
}
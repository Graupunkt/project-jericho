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
    $MainForm = Clear("")

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
    $NumberFormMostOptions = $ListOfOptions | Sort-Object -Descending | Select-Object -First 1

    $MainFormWidth = $NumberFormGroups * 230 + 40
    $MainFormVerticalSpace = 150
    $MainFormHeight = $MainFormVerticalSpace + $NumberFormMostOptions * 24
    #CHECK IF GROUPS OR OPTIONS EXCEED SCREENSIZE
    $ScreenResolution = [System.Windows.Forms.Screen]::AllScreens | Where-Object {$_.DeviceName -like "*DISPLAY1"}  #GET MAX SCREEN RESOLUTION
    $MaxFormSizeWidth = $ScreenResolution[0].WorkingArea.Width         #GET MAX WIDTH FROM PRIMARY SCREEN
    $MaxFormSizeHeight = $ScreenResolution[0].WorkingArea.Height -40   #GET MAX HEIGHT FROM PRIMARY SCREEN, COMPENSATE TASKBAR, ADD VERTICAL SPACE

    #IF FORM EXCEEDS SCREEN SIZE
    if ($MainFormWidth -gt $MaxFormSizeWidth -OR $MainFormHeight -gt $MaxFormSizeHeight){
        Write-Warning "Current form will exceed screen limits $($MaxFormSizeWidth):$($MaxFormSizeHeight) Form $($MainFormWidth):$($MainFormHeight)"
    }

    #Create Final Border
    $MainForm = New-Object System.Windows.Forms.Form                                    # Create new object
    $MainForm.Size = New-Object System.Drawing.Size($MainFormWidth,$MainFormHeight)     # Size in Width and Height
    $MainForm_Drawing_Size = New-Object System.Drawing.Size
    $MainForm_Drawing_Size.Width = $MainFormWidth
    $MainForm_Drawing_Size.Height =$MainFormHeight
    $MainForm.Text = "Project Jericho"                                                  # Window Title
    $MainForm.StartPosition = 'CenterScreen'                                            # Position on Screen


    #DYNAMIC BOXES, FOR EACH DATAGROUP ONE BOX TO THE RIGHT
    $GroupBoxCounter = 0
    foreach ($Group in $FinalGroupsForForm){
        $GroupBoxCounter++
        $ListOfGroupOptions = $Group.Options.Count

        $groupBox = New-Object System.Windows.Forms.GroupBox
        #SET GROUPBOX LOCATION
        $GroupBox_Drawing_Size = New-Object System.Drawing.Size
        $GroupBox_Drawing_Size.Width = 20 + (($GroupBoxCounter -1) * 210)
        $GroupBox_Drawing_Size.Height = $MainFormVerticalSpace
        $groupBox.Location = $GroupBox_Drawing_Size

        #SET OPTION LOCATION
        $System_Drawing_Size = New-Object System.Drawing.Size
        $System_Drawing_Size.Width = 190
        $System_Drawing_Size.Height = 24 * $ListOfGroupOptions
        $groupBox.size = $System_Drawing_Size

        #SET GORUPBOX OPTIONS
        $groupBox.text = $Group.Groups
        $groupBox.Name = "GroupBox$($Group.Groups)"
        $MainForm.Controls.Add($groupBox) 

        #$GroupBoxName = "GroupBox" + $Group.Groups
        #New-Variable -Name $GroupBoxName -Value New-Object System.Windows.Forms.GroupBox
    }

    #DYNAMIC OPTIONS, FOR EACH OPTION ONE ENTRY TO THE BOTTOM
    foreach ($Option in $FinalGroupsForForm){
        
    }
    $MainForm.ShowDialog()| Out-Null

}

Create_DynamicFormMainframe
Pause
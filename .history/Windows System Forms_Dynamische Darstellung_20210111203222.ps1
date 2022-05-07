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
    if($MainForm -){Clear-Variable -Name $MainForm}
    

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
    $GroupBoxWidth = 210
    $GroupBoxSpacing = 20
    $OptionHeight = 24
    $OptionWidth = 190
    $MainFormVerticalSpace = 150
    $MainFormVerticalBorder = 10
    $MainFormHorizontalBorder = 10


    $NumberFormMostOptions = $ListOfOptions | Sort-Object -Descending | Select-Object -First 1
    $MainFormWidth = $GroupBoxSpacing + $MainFormHorizontalBorder + $NumberFormGroups * $GroupBoxWidth
    $MainFormHeight = $MainFormVerticalSpace + $MainFormVerticalBorder + $NumberFormMostOptions * $OptionHeight
    #CHECK IF GROUPS OR OPTIONS EXCEED SCREENSIZE
    $ScreenResolution = [System.Windows.Forms.Screen]::AllScreens | Where-Object {$_.DeviceName -like "*DISPLAY1"}  #GET MAX SCREEN RESOLUTION
    $MaxFormSizeWidth = $ScreenResolution[0].WorkingArea.Width         #GET MAX WIDTH FROM PRIMARY SCREEN
    $MaxFormSizeHeight = $ScreenResolution[0].WorkingArea.Height       #GET MAX HEIGHT FROM PRIMARY SCREEN

    #IF FORM EXCEEDS SCREEN SIZE
    if ($MainFormWidth -gt $MaxFormSizeWidth -OR $MainFormHeight -gt $MaxFormSizeHeight){
        Write-Warning "Current form will exceed screen limits $($MaxFormSizeWidth):$($MaxFormSizeHeight) Form $($MainFormWidth):$($MainFormHeight)"
    }

    #Create Final Border
    $MainForm = New-Object System.Windows.Forms.Form                                    # Create new object
    $MainForm_Drawing_Size = New-Object System.Drawing.Size
    $MainForm_Drawing_Size.Width = $MainFormWidth
    $MainForm_Drawing_Size.Height = $MainFormHeight + $MainFormVerticalBorder + 40
    $MainForm.Size = $MainForm_Drawing_Size
    $MainForm.Text = "Project Jericho"                                                  # Window Title
    $MainForm.StartPosition = 'CenterScreen'                                            # Position on Screen

    #DYNAMIC BOXES, FOR EACH DATAGROUP ONE BOX TO THE RIGHT
    $GroupBoxCounter = 0
    foreach ($Group in $FinalGroupsForForm){
        $GroupBoxCounter++
        $ListOfGroupOptions = $Group.Options.Count

        #SET GROUPBOX 
        $groupBox = New-Object System.Windows.Forms.GroupBox
        $GroupBox_Drawing_Size = New-Object System.Drawing.Size
        $GroupBox_Drawing_Size.Width = $GroupBoxSpacing + (($GroupBoxCounter -1) * $GroupBoxWidth)
        $GroupBox_Drawing_Size.Height = $MainFormVerticalSpace
        $groupBox.Location = $GroupBox_Drawing_Size
        $groupBox.text = $Group.Groups
        $groupBox.Name = "GroupBox$($Group.Groups)"
        $MainForm.Controls.Add($groupBox) 
        $GroupBox_Option_Drawing_Size = New-Object System.Drawing.Size
        $GroupBox_Option_Drawing_Size.Width = $OptionWidth
        $GroupBox_Option_Drawing_Size.Height = $OptionHeight * $ListOfGroupOptions
        $groupBox.size = $GroupBox_Option_Drawing_Size

        #SET OPTIONS
        foreach ($Option in $Group.Options){
            $OptionBox = New-Object System.Windows.Forms.CheckBox 
            #$OptionBox.Location = new-object System.Drawing.Point(5,240) 
            $OptionBox.size = New-Object System.Drawing.Size($OptionWidth,$OptionHeight) 
            $OptionBox.Text = $Option
            $groupBox.Controls.Add($OptionBox) 
        }

        #$GroupBoxName = "GroupBox" + $Group.Groups
        #New-Variable -Name $GroupBoxName -Value New-Object System.Windows.Forms.GroupBox
    }


    $MainForm.ShowDialog()| Out-Null

}

Create_DynamicFormMainframe
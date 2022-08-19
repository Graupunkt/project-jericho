# .Net methods for hiding/showing the console in the background
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
function Show-Console
{
    $consolePtr = [Console.Window]::GetConsoleWindow()

    # Hide = 0,
    # ShowNormal = 1,
    # ShowMinimized = 2,
    # ShowMaximized = 3,
    # Maximize = 3,
    # ShowNormalNoActivate = 4,
    # Show = 5,
    # Minimize = 6,
    # ShowMinNoActivate = 7,
    # ShowNoActivate = 8,
    # Restore = 9,
    # ShowDefault = 10,
    # ForceMinimized = 11

    [Console.Window]::ShowWindow($consolePtr, 4)
}

function Hide-Console
{
    $consolePtr = [Console.Window]::GetConsoleWindow()
    #0 hide
    [Console.Window]::ShowWindow($consolePtr, 0)
}
#get dir of script
$scriptDirectory = Split-Path $MyInvocation.MyCommand.Path

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '290,300'
$Form.text                       = "Clock"
$Form.TopMost                    = $false
$Icon                            = New-Object system.drawing.icon ("C:\Users\marcel\Desktop\StarCitizen Tools\Projekt Jericho (3D Navigation)\data\Icon-Project-Jericho.ico")
$Form.Icon                       = $Icon
$form.TopMost = $True

#clock
    $Clocklabel = New-Object 'System.Windows.Forms.Label' 
    $Clocklabel.Font = "Segoe UI, 32pt" 
    $Clocklabel.ForeColor = 'Green' 
    $Clocklabel.Location = '34,190' 
    $Clocklabel.Name = "Clocklabel" 
    $Clocklabel.Size = '200, 63' 
    $Clocklabel.TabIndex = 0 
    $Clocklabel.Text = "Time" 
    $Clocklabel.add_Click($Clocklabel_Click) 
    $Clocklabel_Click={ 
        #TODO: Place custom script here          
    } 
	Function update_time(){
		$Clocklabel.text = (Get-Date).ToString("HH:mm:ss") 
}
	# create timer and set it to call update_time at set interval
    $timer = New-Object System.Windows.Forms.Timer
    $timer.Interval = 1000
    $timer.Enabled = $True 
    $timer.add_tick({ update_time } )
# ===============================================================
$Form.controls.AddRange(@( $Clocklabel))
# Hide console then Start form (GUI)
Hide-Console 
[void]$Form.ShowDialog()
Show-Console
$timer.stop()
$timer.dispose()
$Form.dispose()
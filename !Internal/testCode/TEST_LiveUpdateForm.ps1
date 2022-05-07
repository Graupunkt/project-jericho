$Form = New-Object system.Windows.Forms.Form
$form.MaximizeBox = $true
$form.MinimizeBox = $true
$Form.StartPosition = "Manual"
$Form.Location= New-Object System.Drawing.Size(-2220,1)
$form.Name = "Live Mapping"

$Form.Size= New-Object System.Drawing.Size(1920,1080)

$Form.WindowState = "maximized"
$Form.Visible=$false
$Form.Enabled = $true
$Form.Add_Shown({$Form.Activate()})

[reflection.assembly]::LoadWithPartialName("System.Windows.Forms")
[System.Windows.Forms.Application]::EnableVisualStyles();

#Image TopLeft
$planet = (get-item "$script:ScriptDir\maps\Microtech.jpg")
$img = [System.Drawing.Image]::Fromfile($planet);
$pictureBox = new-object Windows.Forms.PictureBox
$pictureBox.Location = New-Object System.Drawing.Size(0,1)
$pictureBox.Size = New-Object System.Drawing.Size($img.Width,$img.Height)
$pictureBox.Image = $img
$Form.controls.add($pictureBox)

#Image Top Right
$system = (get-item "$script:ScriptDir\maps\Stanton.jpg")
$img2 = [System.Drawing.Image]::Fromfile($system);
$pictureBox2 = new-object Windows.Forms.PictureBox
$pictureBox2.Location = New-Object System.Drawing.Size($img.Width,1)
$pictureBox2.Size = New-Object System.Drawing.Size($img2.Width,$img2.Height)
$pictureBox2.Image = $img2
$Form.controls.add($pictureBox2)
$Form.Topmost = $True

$form.DataBindings.DefaultDataSourceUpdateMode = 0
$form.add_Load($OnLoadForm_StateCorrection)
$form.ShowDialog()| Out-Null

Start-Sleep -s 20

$rs = [Management.Automation.Runspaces.RunspaceFactory]::CreateRunspace()
$rs.Open()
$rs.SessionStateProxy.SetVariable("Form", $Form)
$data = [hashtable]::Synchronized(@{text=""})
$rs.SessionStateProxy.SetVariable("data", $data)
$p = $rs.CreatePipeline({ [void] $Form.ShowDialog()})
$p.Input.Close()
$p.InvokeAsync()

## Enter the rest of your script here while you want the form to display
Start-Sleep -s 20

$Form.close()
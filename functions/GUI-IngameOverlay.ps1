####################################
### FORM CODE FOR INGAME OVERLAY ###
####################################
Add-Type -AssemblyName PresentationFramework, System.Drawing, System.Windows.Forms, WindowsFormsIntegration

$formIngameOverlay = New-Object System.Windows.Forms.Form -Property @{TopMost=$true}
$formIngameOverlay.FormBorderStyle = "None"
$transKey = "#505050"
$formIngameOverlay.TransparencyKey = $transKey
if($debug){$formIngameOverlay.TransparencyKey = "#101010"}
$formIngameOverlay.BackColor = $transKey
$formIngameOverlay.MinimumSize = New-Object System.Drawing.Size(300, 500)
$formIngameOverlay.AutoScaleDimensions = New-Object System.Drawing.SizeF(7.0, 15.0)
$formIngameOverlay.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Font
$formIngameOverlay.ClientSize = New-Object System.Drawing.Size(300, 500)
$formIngameOverlay.ShowIcon = $false
$formIngameOverlay.StartPosition = "manual"
$ScreenResolution = [System.Windows.Forms.Screen]::AllScreens
$PositionXonScreen = ($ScreenResolution[0].WorkingArea.Width - 310)
$formIngameOverlay.Location = "$PositionXonScreen, 0"
$formIngameOverlay.TopMost = $true
$formIngameOverlay.TopLevel = $true


#Make form without frames moveable
<#
$formIngameOverlay.Add_MouseDown( { $global:dragging = $true
    $global:mouseDragX = [System.Windows.Forms.Cursor]::Position.X - $formIngameOverlay.Left
    $global:mouseDragY = [System.Windows.Forms.Cursor]::Position.Y -$formIngameOverlay.Top
})

# move the form while the mouse is depressed (i.e. $global:dragging -eq $true)
$formIngameOverlay.Add_MouseMove( { if($global:dragging) {
        $screen = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
        $currentX = [System.Windows.Forms.Cursor]::Position.X
        $currentY = [System.Windows.Forms.Cursor]::Position.Y
        [int]$newX = [Math]::Min($currentX - $global:mouseDragX, $screen.Right - $formIngameOverlay.Width)
        [int]$newY = [Math]::Min($currentY - $global:mouseDragY, $screen.Bottom - $formIngameOverlay.Height)
        $formIngameOverlay.Location = New-Object System.Drawing.Point($newX, $newY)
    }})

# stop dragging the form
$formIngameOverlay.Add_MouseUp( { $global:dragging = $false })
#>

# Ingame Logo
$LogoMeridian = New-Object 'System.Windows.Forms.PictureBox'
$LogoMeridian.Location = New-Object System.Drawing.Point(($formIngameOverlay.Size.Width - 60), 10)
$LogoMeridian.Size = New-Object System.Drawing.Size(60, 60)
$LogoMeridian.SizeMode = 'StretchImage'
$LogoMeridian.Image = [Drawing.Image]::FromFile("$script:ScriptDir\data\Logo-Blanc.gif")
if($debug){$LogoMeridian.BackColor = [System.Drawing.Color]::Black}

# Label Planetname
$LabelPlanet = New-Object 'System.Windows.Forms.Label'
$LabelPlanet.Location = New-Object System.Drawing.Point(($formIngameOverlay.Size.Width - 200), 40)
$LabelPlanet.Size = New-Object System.Drawing.Size(120, 30)
$LabelPlanet.ForeColor = [System.Drawing.Color]::White 
$LabelPlanet.Font = [System.Drawing.Font]::new('Dungeon', '12.75')
$LabelPlanet.Text = " - "
if($debug){$LabelPlanet.BackColor = [System.Drawing.Color]::Black }

# Label X-POS
$LabelXPos = New-Object 'System.Windows.Forms.Label'
$LabelXPos.Location = New-Object System.Drawing.Point(($formIngameOverlay.Size.Width - 300), 90)
$LabelXPos.Size = New-Object System.Drawing.Size(15, 15)
$LabelXPos.ForeColor = [System.Drawing.Color]::Gray 
$LabelXPos.Font = [System.Drawing.Font]::new('Dungeon', '10.75')
$LabelXPos.Text = 'X:'
if($debug){$LabelXPos.BackColor = [System.Drawing.Color]::Black }

# Label Y-POS
$LabelYPos = New-Object 'System.Windows.Forms.Label'
$LabelYPos.Location = New-Object System.Drawing.Point(($formIngameOverlay.Size.Width - 200), 90)
$LabelYPos.Size = New-Object System.Drawing.Size(15, 15)
$LabelYPos.ForeColor = [System.Drawing.Color]::Gray 
$LabelYPos.Font = [System.Drawing.Font]::new('Dungeon', '10.75')
$LabelYPos.Text = 'Y:'
if($debug){$LabelYPos.BackColor = [System.Drawing.Color]::Black }

# Label Z-POS
$LabelZPos = New-Object 'System.Windows.Forms.Label'
$LabelZPos.Location = New-Object System.Drawing.Point(200, 90)
$LabelZPos.Size = New-Object System.Drawing.Size(15, 15)
$LabelZPos.ForeColor = [System.Drawing.Color]::Gray 
$LabelZPos.Font = [System.Drawing.Font]::new('Dungeon', '10.75')
$LabelZPos.Text = 'Z:'
if($debug){$LabelZPos.BackColor = [System.Drawing.Color]::Black }

# textbox X-POS
$TextboxXPos = New-Object 'System.Windows.Forms.Label'
$TextboxXPos.Location = New-Object System.Drawing.Point(($formIngameOverlay.Size.Width - 280), 90)
$TextboxXPos.Size = New-Object System.Drawing.Size(80, 15)
$TextboxXPos.ForeColor = [System.Drawing.Color]::White 
$TextboxXPos.Font = [System.Drawing.Font]::new('Jericho-Digital', '12.75')
$TextboxXPos.Text = " - "
if($debug){$TextboxXPos.BackColor = [System.Drawing.Color]::Black }

# textbox X-POS
$TextboxYPos = New-Object 'System.Windows.Forms.Label'
$TextboxYPos.Location = New-Object System.Drawing.Point(($formIngameOverlay.Size.Width - 180), 90)
$TextboxYPos.Size = New-Object System.Drawing.Size(80, 15)
$TextboxYPos.ForeColor = [System.Drawing.Color]::White 
$TextboxYPos.Font = [System.Drawing.Font]::new('Jericho-Digital', '12.75')
$TextboxYPos.Text = " - "
if($debug){$TextboxYPos.BackColor = [System.Drawing.Color]::Black }

# textbox X-POS
$TextboxZPos = New-Object 'System.Windows.Forms.Label'
$TextboxZPos.Location = New-Object System.Drawing.Point(($formIngameOverlay.Size.Width - 80), 90)
$TextboxZPos.Size = New-Object System.Drawing.Size(80, 15)
$TextboxZPos.ForeColor = [System.Drawing.Color]::White 
$TextboxZPos.Font = [System.Drawing.Font]::new('Jericho-Digital', '12.75')
$TextboxZPos.Text = " - "
if($debug){$TextboxZPos.BackColor = [System.Drawing.Color]::Black }

# Label Sunrise
$LabelSunrise = New-Object 'System.Windows.Forms.Label'
$LabelSunrise.Location = New-Object System.Drawing.Point(($formIngameOverlay.Size.Width - 300), 120)
$LabelSunrise.Size = New-Object System.Drawing.Size(80, 15)
$LabelSunrise.ForeColor = [System.Drawing.Color]::Gray 
$LabelSunrise.Font = [System.Drawing.Font]::new('Dungeon', '10.75')
$LabelSunrise.Text = 'Sunrise:'
if($debug){$LabelSunrise.BackColor = [System.Drawing.Color]::Black }

# Textbox Sunrise
$TextboxSunrise = New-Object 'System.Windows.Forms.Label'
$TextboxSunrise.Location = New-Object System.Drawing.Point(($formIngameOverlay.Size.Width - 220), 120)
$TextboxSunrise.Size = New-Object System.Drawing.Size(50, 15)
$TextboxSunrise.ForeColor = [System.Drawing.Color]::White 
$TextboxSunrise.Font = [System.Drawing.Font]::new('Jericho-Digital', '12.75')
$TextboxSunrise.Text = " - "
if($debug){$TextboxSunrise.BackColor = [System.Drawing.Color]::Black }

# Label Sunset
$LabelSunset = New-Object 'System.Windows.Forms.Label'
$LabelSunset.Location = New-Object System.Drawing.Point(($formIngameOverlay.Size.Width - 170), 120)
$LabelSunset.Size = New-Object System.Drawing.Size(80, 15)
$LabelSunset.ForeColor = [System.Drawing.Color]::Gray 
$LabelSunset.Font = [System.Drawing.Font]::new('Dungeon', '10.75')
$LabelSunset.Text = 'Sunset:'
if($debug){$LabelSunset.BackColor = [System.Drawing.Color]::Black }

# Textbox Sunset Destination
$TextboxSunset = New-Object 'System.Windows.Forms.Label'
$TextboxSunset.Location = New-Object System.Drawing.Point(($formIngameOverlay.Size.Width - 90), 120)
$TextboxSunset.Size = New-Object System.Drawing.Size(50, 15)
$TextboxSunset.ForeColor = [System.Drawing.Color]::White 
$TextboxSunset.Font = [System.Drawing.Font]::new('Jericho-Digital', '12.75')
$TextboxSunset.Text = " - "
if($debug){$TextboxSunset.BackColor = [System.Drawing.Color]::Black }

# Label Compass
$LabelCompass = New-Object 'System.Windows.Forms.Label'
$LabelCompass.Location = New-Object System.Drawing.Point(($formIngameOverlay.Size.Width - 300), 180)
$LabelCompass.Size = New-Object System.Drawing.Size(80, 15)
$LabelCompass.ForeColor = [System.Drawing.Color]::Gray 
$LabelCompass.Font = [System.Drawing.Font]::new('Dungeon', '10.75')
$LabelCompass.Text = 'Compass:'
if($debug){$LabelCompass.BackColor = [System.Drawing.Color]::Black }

# Textbox Compass
$TextboxCompass = New-Object 'System.Windows.Forms.Label'
$TextboxCompass.Location = New-Object System.Drawing.Point(($formIngameOverlay.Size.Width - 220), 180)
$TextboxCompass.Size = New-Object System.Drawing.Size(50, 15)
$TextboxCompass.ForeColor = [System.Drawing.Color]::White 
$TextboxCompass.Font = [System.Drawing.Font]::new('Jericho-Digital', '12.75')
$TextboxCompass.Text = " - "
if($debug){$TextboxCompass.BackColor = [System.Drawing.Color]::Black }

# Label Distance
$LabelDistance = New-Object 'System.Windows.Forms.Label'
$LabelDistance.Location = New-Object System.Drawing.Point(($formIngameOverlay.Size.Width - 170), 180)
$LabelDistance.Size = New-Object System.Drawing.Size(80, 15)
$LabelDistance.ForeColor = [System.Drawing.Color]::Gray 
$LabelDistance.Font = [System.Drawing.Font]::new('Dungeon', '10.75')
$LabelDistance.Text = 'Distance:'
if($debug){$LabelDistance.BackColor = [System.Drawing.Color]::Black }

# Textbox Distance
$TextboxDistance = New-Object 'System.Windows.Forms.Label'
$TextboxDistance.Location = New-Object System.Drawing.Point(($formIngameOverlay.Size.Width - 90), 180)
$TextboxDistance.Size = New-Object System.Drawing.Size(90, 15)
$TextboxDistance.ForeColor = [System.Drawing.Color]::White 
$TextboxDistance.Font = [System.Drawing.Font]::new('Jericho-Digital', '12.75')
$TextboxDistance.Text = " - "
if($debug){$TextboxDistance.BackColor = [System.Drawing.Color]::Black }

# Label Sunrise Destination
$LabelSunriseD = New-Object 'System.Windows.Forms.Label'
$LabelSunriseD.Location = New-Object System.Drawing.Point(($formIngameOverlay.Size.Width - 300), 210)
$LabelSunriseD.Size = New-Object System.Drawing.Size(80, 15)
$LabelSunriseD.ForeColor = [System.Drawing.Color]::Gray 
$LabelSunriseD.Font = [System.Drawing.Font]::new('Dungeon', '10.75')
$LabelSunriseD.Text = 'Sunrise:'
if($debug){$LabelSunrise.BackColor = [System.Drawing.Color]::Black }

# Textbox Sunrise Destination
$TextboxSunriseD = New-Object 'System.Windows.Forms.Label'
$TextboxSunriseD.Location = New-Object System.Drawing.Point(($formIngameOverlay.Size.Width - 220), 210)
$TextboxSunriseD.Size = New-Object System.Drawing.Size(50, 15)
$TextboxSunriseD.ForeColor = [System.Drawing.Color]::White 
$TextboxSunriseD.Font = [System.Drawing.Font]::new('Jericho-Digital', '12.75')
$TextboxSunriseD.Text = " - "
if($debug){$TextboxSunriseD.BackColor = [System.Drawing.Color]::Black }

# Label Sunset Destination
$LabelSunsetD = New-Object 'System.Windows.Forms.Label'
$LabelSunsetD.Location = New-Object System.Drawing.Point(($formIngameOverlay.Size.Width - 170), 210)
$LabelSunsetD.Size = New-Object System.Drawing.Size(80, 15)
$LabelSunsetD.ForeColor = [System.Drawing.Color]::Gray 
$LabelSunsetD.Font = [System.Drawing.Font]::new('Dungeon', '10.75')
$LabelSunsetD.Text = 'Sunset:'
if($debug){$LabelSunset.BackColor = [System.Drawing.Color]::Black }

# Textbox Sunset Destination
$TextboxSunsetD = New-Object 'System.Windows.Forms.Label'
$TextboxSunsetD.Location = New-Object System.Drawing.Point(($formIngameOverlay.Size.Width - 90), 210)
$TextboxSunsetD.Size = New-Object System.Drawing.Size(50, 15)
$TextboxSunsetD.ForeColor = [System.Drawing.Color]::White 
$TextboxSunsetD.Font = [System.Drawing.Font]::new('Jericho-Digital', '12.75')
$TextboxSunsetD.Text = " - "
if($debug){$TextboxSunsetD.BackColor = [System.Drawing.Color]::Black }

# Label Sunset Destination
$LabelETA = New-Object 'System.Windows.Forms.Label'
$LabelETA.Location = New-Object System.Drawing.Point(($formIngameOverlay.Size.Width - 300), 270)
$LabelETA.Size = New-Object System.Drawing.Size(50, 15)
$LabelETA.ForeColor = [System.Drawing.Color]::Gray 
$LabelETA.Font = [System.Drawing.Font]::new('Dungeon', '10.75')
$LabelETA.Text = 'ETA:'
if($debug){$LabelETA.BackColor = [System.Drawing.Color]::Black }

# Textbox Sunset Destination
$TextboxETA = New-Object 'System.Windows.Forms.Label'
$TextboxETA.Location = New-Object System.Drawing.Point(($formIngameOverlay.Size.Width - 250), 270)
$TextboxETA.Size = New-Object System.Drawing.Size(250, 15)
$TextboxETA.ForeColor = [System.Drawing.Color]::White 
$TextboxETA.Font = [System.Drawing.Font]::new('Jericho-Digital', '12.75')
$TextboxETA.Text = " - "
if($debug){$TextboxETA.BackColor = [System.Drawing.Color]::Black }

#Add Elements
$formIngameOverlay.Controls.Add($LogoMeridian)
$formIngameOverlay.Controls.Add($LabelPlanet)
$formIngameOverlay.Controls.Add($LabelXPos)
$formIngameOverlay.Controls.Add($LabelYPos)
$formIngameOverlay.Controls.Add($LabelZPos)
$formIngameOverlay.Controls.Add($TextboxXPos)
$formIngameOverlay.Controls.Add($TextboxYPos)
$formIngameOverlay.Controls.Add($TextboxZPos)
$formIngameOverlay.Controls.Add($LabelSunrise)
$formIngameOverlay.Controls.Add($TextboxSunrise)
$formIngameOverlay.Controls.Add($LabelSunset)
$formIngameOverlay.Controls.Add($TextboxSunset)
$formIngameOverlay.Controls.Add($LabelCompass)
$formIngameOverlay.Controls.Add($TextboxCompass)
$formIngameOverlay.Controls.Add($LabelDistance)
$formIngameOverlay.Controls.Add($TextboxDistance)
$formIngameOverlay.Controls.Add($LabelSunriseD)
$formIngameOverlay.Controls.Add($TextboxSunriseD)
$formIngameOverlay.Controls.Add($LabelSunsetD)
$formIngameOverlay.Controls.Add($TextboxSunsetD)
$formIngameOverlay.Controls.Add($LabelSunset)
$formIngameOverlay.Controls.Add($LabelETA)
$formIngameOverlay.Controls.Add($TextboxETA)
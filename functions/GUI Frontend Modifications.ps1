### FRONTEND ADDITIONS IMAGES ###
$formProjectJericho.Icon = New-Object system.drawing.icon ("$script:ScriptDir\data\Icon-Project-Jericho.ico")
#$picturebox1.Image = [Drawing.Image]::FromFile("$script:ScriptDir\data\Logo-Meridian.gif")
$picturebox2.Image = [Drawing.Image]::FromFile("$script:ScriptDir\data\Logo-Jericho.gif")

# TRANSPARENCY ON ANIMATED BACKGROUND
$TransHeading = [System.Drawing.Color]::FromARGB(0, [System.Drawing.Color]::FromName("Black"))
$TransGroupBoxes = [System.Drawing.Color]::FromARGB(165, [System.Drawing.Color]::FromName("Black"))
$picturebox7.Image = [Drawing.Image]::FromFile("$script:ScriptDir\data\background-animated-black.gif")
$picturebox8.Image = [Drawing.Image]::FromFile("$script:ScriptDir\data\background-animated-black.gif")
$picturebox9.Image = [Drawing.Image]::FromFile("$script:ScriptDir\data\background-animated-purple.gif")



#HEADER
#$LabelProjectJericho.Parent = $PictureBox2
#$RealTimeNavigationFo.Parent = $PictureBox2
$GroupBox24.BackColor    = $TransHeading
$GroupBox24.Parent       = $formProjectJericho

<#
#MODIFING TABS AND TAB CONTROL
$TabControl1.DrawMode = [System.Windows.Forms.DrawMode]::OwnerDrawFixed
#Background
$TabControl1.Add_DrawItem({
    param( 
        [System.Object] $TabPage, 
        [System.Windows.Forms.DrawItemEventArgs] $e 
        )

    #Background left, bottom and right
    $BackgroundColorBrush2 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(32,32,32)) 
    $e.Graphics.FillRectangle($BackgroundColorBrush2, (new-object Drawing.Rectangle (-1, 22, 1165, 706))) # X Pos, Y-Pos, Width, Height
    $e.DrawFocusRectangle()
    #background right of next to tabs
    $BackgroundColorBrush3 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(32,32,32)) 
    $e.Graphics.FillRectangle($BackgroundColorBrush3, (new-object Drawing.Rectangle (765, 0, 840, 35))) # X Pos, Y-Pos, Width, Height
    $e.DrawFocusRectangle()
    #Cleanup 
    $BackgroundColorBrush2.Dispose()
    $BackgroundColorBrush3.Dispose()
})


#Tabs

$TabControl1.Add_DrawItem({
param( 
    [System.Object] $TabPage, 
    [System.Windows.Forms.DrawItemEventArgs] $e 
    )
    $Page=$TabPage.TabPages[$e.Index]
    ### BackgroundColor of Tabs
    $BackgroundColorBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(32,32,32))           
    ###TextColor of Tabs
    $PageColor = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255,140,0)) 
    #if($Page -eq 4){$PageColor = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(65,65,65)) }
    $PageFont = [System.Drawing.Font]::new('Dungeon', '9.75')
    #$e.Graphics.FillRectangle($BackgroundColorBrush, $e.Bounds)
    $rectangle = $e.Bounds

    $e.Graphics.FillRectangle($BackgroundColorBrush, $rectangle)
    $e.Graphics.DrawString(" $($Page.text)", $PageFont, $PageColor, (new-object System.Drawing.PointF($e.Bounds.X, $e.Bounds.Y)))
    $e.DrawFocusRectangle()
    #Cleanup 
    $PageColor.Dispose()
    $BackgroundColorBrush.Dispose()
})
#>

################
#### BUTTONS ###
################
#Check if Process is running, if set button color to green
if ($null -ne (Get-Process -Name AntiLogoffScript_V3 -ErrorAction SilentlyContinue))
{
    $buttonAntiLogoffScript.ForeColor = [System.Drawing.Color]::FromArgb(50, 250, 50)
}
if ($null -ne (Get-Process -Name "Script_Showlocation_Hotkey ALT-GR or LEFTCTRL+ALT_RunAsAdmin" -ErrorAction SilentlyContinue))
{
    $buttonShowLocationHotKey.ForeColor = [System.Drawing.Color]::FromArgb(50, 250, 50)
}
if ($null -ne (Get-Process -Name "AutorunToggle" -ErrorAction SilentlyContinue))
{
    $buttonAutoRunToggle.ForeColor = [System.Drawing.Color]::FromArgb(50, 250, 50)
}


############
### MAPS ###
############
$CurrentSystem = "Stanton"
$CurrentLocal = "Hurston_LorvilleCity"
$PictureBox5.BackgroundImage = [system.drawing.image]::FromFile("$script:ScriptDir\maps\systems\$CurrentSystem.jpg")
$SystemImage = [system.drawing.image]::FromFile("$script:ScriptDir\maps\systems\$CurrentSystem.jpg")
$SystemCanvas = New-Object System.Windows.Forms.Panel 
$SystemCanvas.Location = "1,1"
$SystemCanvas.Size = "$($SystemImage.Width),$($SystemImage.Height)"
$SystemCanvas.Size = "1150,501"
$SystemCanvas.BorderStyle = "FixedSingle"
$SystemCanvas.BackgroundImageLayout = "stretch"
$SystemCanvas.BackgroundImage = $SystemImage
$TabPage4.Controls.Add($SystemCanvas)

$PenBlackLines = (new-object Drawing.Pen black)
$PenBlackLines.Width = 1

$color3 = [System.Drawing.Color]::FromArgb(120, 0, 0, 0)
$SystemMarker3 = new-object Drawing.SolidBrush $color3
$SystemMarkerSize3 = 5

#Text
$font = new-object System.Drawing.Font("Dungeon", 14, [Drawing.FontStyle]'Bold' )
$sf = [System.Drawing.StringFormat]::New()
$sf.Alignment = 'Center'
$sf.LineAlignment = 'Center'

#Color for Player
$RGB = (50, 250, 50)
$Opacity = 120
$color = [System.Drawing.Color]::FromArgb($opacity, $RGB[0], $RGB[1], $RGB[2])
$SystemMarker = new-object Drawing.SolidBrush $color
$SystemMarkerSize = 20

#Color for Destination
$RGB2 = (250, 50, 50)
$Opacity2 = 120
$color2 = [System.Drawing.Color]::FromArgb($opacity2, $RGB2[0], $RGB2[1], $RGB2[2])
$SystemMarker2 = new-object Drawing.SolidBrush $color2
$SystemMarkerSize2 = 20

#System Map Ratio
$SystemMapXpixels = $PictureBox5.Width
$SystemMapYpixels = $PictureBox5.Height
$SystemMapCentreX = ($SystemMapXpixels/2)
$SystemMapCentreY = ($SystemMapYpixels/2)
$SystemXPix = $SystemMapXpixels/100000000000
$SystemYPix = $SystemMapYpixels/100000000000

#Planet Map Ratio
#Convert Lat / Long into  pixels
$MarginLeft = 95
$MarginTop = 56
$MarginRight = 96 #1247
$marginBottom = 186 #630
$PlanetMapXpixels = $PictureBox4.Width - $MarginLeft - $MarginRight
$PlanetMapYpixels = $PictureBox4.Height - $MarginTop - $marginBottom
$PlanetMapCentreX = ($PlanetMapXpixels/2) + $MarginLeft
$PlanetMapCentreY = ($PlanetMapYpixels/2) + $MarginTop
$PlanetLongPix = $PlanetMapXpixels/360
$PlanetLatPix = $PlanetMapYpixels/180
#Define Planet LineSettings
$PlanetLine = new-object Drawing.Pen red
$PlanetLine.width = 2
$PlanetDots = new-object Drawing.SolidBrush ("black")
$PlanetDotSize = 7
$PlanetMarker = new-object Drawing.SolidBrush ("green")
$PlanetMarkerSize = 15
$Lastobject = $false

#Line
$Line = new-object Drawing.Pen ([System.Drawing.Color]::FromArgb(120, 50, 250, 50))
$Line.Width = 3
$Line.DashStyle = "Dash" #Solid, Dash, DashDot, DashDotDot, Dot,Custom
$Line.StartCap = "Triangle"
$Line.EndCap = "Triangle"
$Line.DashPattern = (5, 5)

#Settings Auto Update Debug
#$textbox242.ScrollBars = "Vertical" 

$TabControl1.Add_SelectedIndexChanged({
    try{
        <#
        switch($TabControl1.SelectedTab.Text){
            Informations {}
            Navigation {}
            "Orbital Drop" {}
            "System Map" {}
            "Planet Map" {}
            "Local Map" {}
            Versions {}
            Settings {}
            Manual {}
            About {}
        }
        #>
        #Start-Sleep -Milliseconds 50
        #if($TabControl1.SelectedIndex -eq 1){write-host 1}
        #$selectedTab = $TabControl1.SelectedTab.Text
        <#
        if($selectedTab -eq "Settings"){
            [System.Windows.Forms.MessageBox]::Show("Settings selected")
            $textbox242.Text = Get-Content "$script:ScriptDir\debug.log" | Out-String
            $textbox242.Text = "Test"
            $textbox242.Select($textbox242.Text.Length - 1, 1)
            $textbox242.ScrollToCaret()
        }
    
        if($selectedTab -eq "About"){
            $About = Get-Content "$script:ScriptDir\data\About.rtf"
            $richtextbox1.rtf = $About
        }
    
        if($selectedTab -eq "Manual"){
            $Manual = Get-Content "$script:ScriptDir\data\Manual.rtf"
            $richtextbox2.rtf = $Manual
        }
        #>
    }catch{
        msg * "error $($_.Exception.Message)"
    } 
})






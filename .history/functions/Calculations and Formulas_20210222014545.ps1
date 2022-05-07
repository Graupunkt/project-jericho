function CalcEbenenwinkel {
    # Ship Previous, Ship Current, Destination
    # A              B             D
    Param ($ax, $ay, $az, $bx, $by, $bz, $dx , $dy, $dz)
    
    #Ebene 1
    #Vector AB
    $abx = $bx - $ax
    $aby = $by - $ay
    $abz = $bz - $az
    
    #Vector AC (C = Nullpunkt Planet)
    $acx = 0 - $ax
    $acy = 0 - $ay
    $acz = 0 - $az        
    
    #Ebene 2
    #Vector AD
    $adx = $dx - $ax
    $ady = $dy - $ay
    $adz = $dz - $az
    
    #Vector AC siehe oben
    
    
    #normalenvector einer ebene:
    #n1_x = ab_y * ac_z - ab_z * ac_y
    #n1_y = ab_z * ac_x - ab_x * ac_z
    #n1_z = ab_x * ac_y - ab_y * ac_x
    
    $n1x = $aby * $acz - $abz * $acy
    $n1y = $abz * $acx - $abx * $acz
    $n1z = $abx * $acy - $aby * $acx
     # für 2. ebene: ab = ad und ac ist gleich
    $n2x = $ady * $acz - $adz * $acy
    $n2y = $adz * $acx - $adx * $acz
    $n2z = $adx * $acy - $ady * $acx
    
    #Vectorprodukt
    $vectorproduct = $n1x * $n2x + $n1y * $n2y + $n1z * $n2z
    
    #Laenge Normale n1 = wurzel aus ( x^2 + y^2 + z^2)
    $length_n1 = [math]::Sqrt($n1x * $n1x + $n1y *$n1y + $n1z * $n1z)
    
    #Laenge Normale n2
    $length_n2 = [math]::Sqrt($n2x * $n2x + $n2y *$n2y + $n2z * $n2z)
    
    $winkel = [math]::acos(($vectorproduct/($length_n1 * $length_n2)))
    $winkel_degree = ($winkel * 180)/[math]::pi
    Return $winkel_degree
}

function CreateCrosshairOnScreen {
    param ($InputAngleHorizontal, $InputAngleVertical)
    $InputAngleHorizontal = 348
    $InputAngleVertical = 21

    #PRE REQUESTS
    Add-Type -AssemblyName System.Windows.Forms

    #DETERMINE FIELD OF VIEW
    $HorizontalViewAngle = 160 #115° fiedl of view in game settings
    $VerticalViewAngle = 42 * 2 #37° Up and 37° down

    #GET MAIN SCREEN RESOLTUION
    $MainScreenResolution = ([System.Windows.Forms.Screen]::AllScreens)[0]
    $MainScreenWidth = $MainScreenResolution.WorkingArea.Width
    $MainScreenHeight = $MainScreenResolution.WorkingArea.Height

    #CALCULATIONS
    if ($InputAngleHorizontal -gt 180){$InputAngleHorizontal = (360 - $InputAngleHorizontal) * -1}
    $PixelsPerAngleX = $MainScreenWidth  / $HorizontalViewAngle
    $PixelsPerAngleY = $MainScreenHeight / $VerticalViewAngle

    $CenterScreenX = $MainScreenWidth  / 2
    $CenterScreenY = $MainScreenHeight / 2
    #Placement of the Crosshair, where 0,0 is the center of the screen
    $CrosshairXPixels = ($InputAngleHorizontal * $PixelsPerAngleX) + $CenterScreenX
    $CrosshairYPixels = ($InputAngleVertical * -1 * $PixelsPerAngleY) + $CenterScreenY
    $CrosshairXPixels = $CenterScreenX + ($InputAngleHorizontal * $PixelsPerAngleX) + 
    $CrosshairYPixels = $CenterScreenY ($InputAngleVertical * -1 * $PixelsPerAngleY) + 
    $CrosshairXPixels
    $CrosshairYPixels
}
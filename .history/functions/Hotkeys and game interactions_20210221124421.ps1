#REGISTERS KEYPRESS IN POWERSHELL WINDOW
function Test-KeyPress
{
    param
    (
        # submit the key you want to detect
        [Parameter(Mandatory)]
        [ConsoleKey]
        $Key,

        [System.ConsoleModifiers]
        $ModifierKey = 0
    )

    # reading keys is a blocking function. To "unblock" it,
    # let's first check if a key press is available at all:
    if ([Console]::KeyAvailable)
    {
        # since a key was pressed, ReadKey() now is NOT blocking
        # anymore because there is already a pressed key waiting
        # to be picked up
        # submit $true as an argument to consume the key. Else,
        # the pressed key would be echoed in the console window
        # note that ReadKey() returns a ConsoleKeyInfo object
        # the pressed key can be found in its property "Key":
        # write-host "1"
         $pressedKey = [Console]::ReadKey($true)

        # if the pressed key is the key we are after...
        $isPressedKey = $key -eq $pressedKey.Key
        if ($isPressedKey)
        {

            # if you want an EXACT match of modifier keys,
            # check for equality (-eq)
            $pressedKey.Modifiers -eq $ModifierKey
            [Console]::Beep(1800, 200)
            # if you want to ensure that AT LEAST the specified
            # modifier keys were pressed, but you don't care
            # whether other modifier keys are also pressed, use
            # "binary and" (-band). If all bits are set, the result
            # is equal to the tested bit mask:
            # ($pressedKey.Modifiers -band $ModifierKey) -eq $ModifierKey
        }
        else
        {
            # else emit a short beep to let the user know that
            # a key was pressed that was not expected
            # Beep() takes the frequency in Hz and the beep
            # duration in milliseconds:
            #

            # return $false
            $false
        }
    }
}

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

Function Show-Frontend {
    $Form.Add_Shown({$Form.Activate()})
    [void] $Form.ShowDialog()
}
using Jericho;
using System.Text.RegularExpressions;
using System.Windows.Forms;

namespace Jericho
{
    internal class Program
    {
        static OutputState outState = new OutputState()
        {
            PlayerCoordinates = new CoordinateData(),
            Destination = null,
            PreviousCoordinates = null
        };

        static CoordinateData? PlayerCoordinates { get => outState.PlayerCoordinates; }
        static CoordinateData CurrentTarget
        {
            get => outState.Destination;
            set => outState.Destination = value;
        }

        [STAThread]
        public static void Main(string[] args)
        {
            GameData LoadedGameData = GameData.LoadFromFiles();

            bool NewCapture = false;
            bool StartNavigation = true;

            string LastClipboard = null;
            string CurrentTargetName = "Crashed Satelite Lorville";

            CurrentTarget = LoadedGameData.Destinations().FirstOrDefault(ct => ct.Name == CurrentTargetName);

            while (StartNavigation)
            {
                //#Start-Sleep -Milliseconds 1            # IF THIS LINE IS NOT PRESENT, CPU USAGE WILL CONSUME A FULL THREAD, AND SCRIPTS MIGHT GET UNRESPONSIVE 
                //#Get ClipboardContents and Get Current Date/Time

                var clipboardState = GetStarCitizenClipboardAndDate();
                if (!clipboardState.HasCoordinates)
                {
                    Thread.Yield();
                    continue;
                }

                if(clipboardState.RawText != LastClipboard)
                {
                    NewCapture = true;
                    LastClipboard = clipboardState.RawText;

                    outState.UpdateState(LoadedGameData, clipboardState.Coordinates, clipboardState.CoordinateTime);
                }
                else
                {
                    NewCapture = false;
                }

                //#Write-Host CurrentXPosition, CurrentYPosition, CurrentZPosition

                CheckKey();

                // ### KEY TO SAVE CURRENT COORDINATES TO TEXTFILE ###
                if (KeyPress(ConsoleKey.S, ConsoleModifiers.Control))
                {
                    Console.WriteLine("Input the name of the POI: ");
                    var PoiName = Console.ReadLine();
                    string PoiToSave;
                    //#SystemName = Read-Host -Prompt 'Input the Systemname your currently in (Stanton, Pyro, Nyx): '
                    //#SystemName = "Stanton"
                    if (PlayerCoordinates.System != null)
                    { // #IF ON A PLANET
                        PoiToSave = $"{PlayerCoordinates.System};{PlayerCoordinates.ParentContainer.Name};CustomType;{PoiName};{PlayerCoordinates.GlobalPosition?.X};{PlayerCoordinates.GlobalPosition?.Y};{PlayerCoordinates.GlobalPosition?.Z};{clipboardState.CoordinateTime}";
                    }
                    else
                    { // #ELSE IF IN SPACE
                        PoiToSave = $"{PlayerCoordinates.System};Custom POI Type;{PoiName};{PlayerCoordinates.GlobalPosition?.X};{PlayerCoordinates.GlobalPosition?.Y};{PlayerCoordinates.GlobalPosition?.Z};{clipboardState.CoordinateTime}";
                    }
                    File.AppendAllText("Data\\saved_locations.csv", PoiToSave);
                    Console.WriteLine("... saved PoiName to Data\\saved_locations.csv");
                }

                //#ADJUST PLANETARY ROTATION DEVIATION
                if (KeyPress(ConsoleKey.R, ConsoleModifiers.Control))
                {
                    //#CurrentPlanetaryXCoord = ""
                    //#CurrentDetectedOCRadius = ""
                    //#CurrentDetectedOCADX = ""

                    //var Circumference360Degrees = Math.PI * 2 * CurrentTarget.ParentContainer.OrbitalMarkerRadiusM;
                    //#Very high or low values are presented by ps as scientific results, therefore we force the nubmer (decimal) and limit it to 7 digits after comma
                    //#Multiplied by 1000 to convert km into m and invert it to correct the deviation
                    //var RotationSpeedAdjustment = Math.Round((CurrentPlanetaryXCoord * 1000 * 360 / Circumference360Degrees) -as [decimal], 7) * -1;
                    //#GET Adjustment for Rotationspeed 
                    //var FinalRotationAdjustment = (CurrentDetectedOCADX + RotationSpeedAdjustment);
                    //#Write-Host "OMRadius CurrentDetectedOCRadius"
                    //#Write-Host "Circumference Circumference360Degrees "
                    //#Write-Host "Speed RotationSpeedAdjustment"
                    //#Write-Host "Adjustment FinalRotationAdjustment"
                    //#Write-Host "X-Coord CurrentPlanetaryXCoord"
                    //(Get - Content OcCsvPath).replace(CurrentDetectedOCADX, FinalRotationAdjustment) | Set - Content OcCsvPath
                    //Write - Host "Rotation calibrated from (CurrentDetectedOCADX)° to (FinalRotationAdjustment)° by RotationSpeedAdjustment, pls restart script"
                    //Start - Sleep - Seconds 5
                    //return;
                }

                if (KeyPress(ConsoleKey.T, ConsoleModifiers.Control))
                {
                    //UserCommentPrev = Read - Host - Prompt 'Comment the previous updated position: '
                    //   (Get - Content LogFilename - raw) - replace("(?s)(.*)no comment", "`1UserCommentPrev") | Out - File LogFilename
                }


                //#################################################
                //### POI ON ROTATING OBJECT CONTAINER, PLANETS ###
                //#################################################
                if (CurrentTarget != null)
                {
                    // NOTE: This runs every cycle/check, which keeps DestinationRotated up-to-date
                    outState.SetDestination(LoadedGameData, CurrentTarget);
                }
                else
                {
                    outState.Destination = null;
                    outState.DestinationRotated = null;
                    outState.DestinationDistance = 0;
                }

                if (NewCapture)
                {

                    if (outState.Destination != null && outState.PreviousCoordinates != null)
                    {
                        // Deviation Calculation
                        // ################
                        // ### xabdiben ###
                        // ################
                        var xu =
                            (
                                (outState.DestinationRotated.GlobalPosition.X - outState.PreviousCoordinates.GlobalPosition.X) * 
                                (PlayerCoordinates.GlobalPosition.X - outState.PreviousCoordinates.GlobalPosition.X)
                            ) + 
                            (
                                (outState.DestinationRotated.GlobalPosition.Y - outState.PreviousCoordinates.GlobalPosition.Y) * 
                                (PlayerCoordinates.GlobalPosition.Y - outState.PreviousCoordinates.GlobalPosition.Y)
                            ) +
                            (
                                (outState.DestinationRotated.GlobalPosition.Z - outState.PreviousCoordinates.GlobalPosition.Z) * 
                                (PlayerCoordinates.GlobalPosition.Z - outState.PreviousCoordinates.GlobalPosition.Z)
                            );
                        var xab_dist = outState.CurrentVector.Length;

                        if (xab_dist < 1)
                            xab_dist = 1;

                        xu = xu / (xab_dist * xab_dist);

                        var closest = outState.PreviousCoordinates.GlobalPosition + (outState.CurrentVector * xu);

                        // #c1 = CalcDistance3d DestCoordDataX DestCoordDataY DestCoordDataZ PreviousXPosition PreviousYPosition PreviousZPosition
                        var c2 = outState.DestinationRotated.GlobalPosition.DistanceTo(PlayerCoordinates.GlobalPosition);

                        var pathError = outState.DestinationRotated.GlobalPosition.DistanceTo(closest);
                        // # Write-Host "Path Error = pathError"
                        outState.DeviationSpace = Math.Atan2(pathError, c2) * 180.0 / Math.PI;

                        // Local Course Deviation, Only on same container
                        if (outState.PlayerCoordinates.ParentContainer == outState.Destination.ParentContainer)
                        {
                            var XULocal = (
                                    (outState.Destination.LocalPosition.X - outState.PreviousCoordinatesDeRotated.LocalPosition.X) *
                                    (outState.PlayerCoordinatesDeRotated.LocalPosition.X - outState.PreviousCoordinatesDeRotated.LocalPosition.X)
                                ) + (
                                    (outState.Destination.LocalPosition.Y - outState.PreviousCoordinatesDeRotated.LocalPosition.Y) *
                                    (outState.PlayerCoordinatesDeRotated.LocalPosition.Y - outState.PreviousCoordinatesDeRotated.LocalPosition.Y)
                                ) + (
                                    (outState.Destination.LocalPosition.Z - outState.PreviousCoordinatesDeRotated.LocalPosition.Z) *
                                    (outState.PlayerCoordinatesDeRotated.LocalPosition.Z - outState.PreviousCoordinatesDeRotated.LocalPosition.Z)
                                );
                            var localDelta = outState.PlayerCoordinatesDeRotated.LocalPosition - outState.PreviousCoordinatesDeRotated.LocalPosition;
                            var xab_distLocal = localDelta.Length;
                            if (xab_distLocal < 1)
                                xab_distLocal = 1;
                            XULocal = XULocal / (xab_distLocal * xab_distLocal);
                            var closestLocal = outState.PreviousCoordinatesDeRotated.LocalPosition + (localDelta * XULocal);
                            // #c1 = CalcDistance3d DestCoordDataX DestCoordDataY DestCoordDataZ PreviousXPosition PreviousYPosition PreviousZPosition
                            var c2Local = outState.Destination.LocalPosition.DistanceTo(outState.PlayerCoordinatesDeRotated.LocalPosition);
                            var pathErrorLocal = outState.Destination.LocalPosition.DistanceTo(closestLocal);
                            // # Write-Host "Path Error = pathError"
                            outState.DeviationPlanet = Math.Atan2(pathErrorLocal, c2Local) * 180.0 / Math.PI;
                        }
                        else
                        {
                            outState.DeviationPlanet = 0;
                        }
                    }
                    /*
                    CoordinatesSubmitted = true;
                    if (script:CustomCoordsProvided){
                        DestinationName = SelectedDestination.Keys;
                    }
                    else {
                        DestinationName = SelectedDestination.Name;
                    }

                    // # GET CURRENT TIME AND SAVE PREVIOUS VALUES
                    // #DateTime = Get-Date # REPLACE WITH DATETIME
                    if(PreviousTime){
                        LastUpdateRaw1 = DateTime - PreviousTime
                    }
                    else{
                        LastUpdateRaw1 = DateTime
                    }
                    */

                    // # Write-Host -ForegroundColor Yellow DateTime.ToString('HH:mm:ss:ffff')

                    // #################################################################
                    // ### DETERMINE THE CURRENTOBJECT CONTAINER FROM STANTON COORDS ###
                    // #################################################################

                    // # DISPLAY CURRENT COORDS OF STANTON, PLANETARY AND POI
                    // # CONVERT CURRENT RESULTS FROM M OT KM (/1000) AND ROUND COORDINATES TO 3 DIGITS AFTER COMMA

                    // # Total Distance Away
                    // #PreviousDistanceTotalist = curdist
                    if (CurrentTarget != null)
                    {
                        var CurrentDistanceTotal = CurrentTarget.GlobalPosition - outState.PlayerCoordinatesDeRotated.GlobalPosition;
                        if (PlayerCoordinates.ParentContainer?.Type == "Planet")
                        {
                        }
                        else
                        {

                        }

                        // # GET DIFFERENCE IN DISTANCE
                        var CurrentDeltaDistance = outState.CurrentVector;

                        if (outState.CurrentVector.Length > 0)
                        {
                            var velocity = (outState.CurrentVector.Length / outState.UpdateDuration.TotalSeconds);
                            outState.ETA = CurrentDistanceTotal.Length / velocity;
                        }
                    }
                    else
                    {
                        outState.ETA = 0;
                    }

                    // If we have a target on the planet we are on
                    if (CurrentTarget?.ParentContainer?.Type == "Planet" && 
                        outState.PlayerCoordinates.ParentContainer == outState.Destination.ParentContainer)
                    {
                        var ShipOMClosest = outState.PlayerOM.First();
                        var PosShip = outState.PlayerCoordinatesDeRotated.LocalPosition;
                        var PosPoi = outState.Destination.LocalPosition;

                        if (ShipOMClosest.Name == "OM3" || ShipOMClosest.Name == "OM4")
                        {
                            var TriangleYB = PosPoi.Y - PosShip.Y;
                            var TriangleYA = PosPoi.Z - PosShip.Z;
                            var TriangleYC = Math.Sqrt(Math.Pow(TriangleYA, 2) + Math.Pow(TriangleYB, 2));
                            var TriangleYAlpha = Math.Asin(TriangleYA / TriangleYC) * 180 / Math.PI;
                            // #TriangleYAlpha 

                            var TriangleXA = PosShip.X + PosPoi.X;
                            var TriangleXB = PosPoi.Y - PosShip.Y;
                            var TriangleXC = Math.Sqrt(Math.Pow(TriangleXA, 2) + Math.Pow(TriangleXB, 2));
                            if (ShipOMClosest.Name == "OM3")
                                TriangleXA = Math.Sin(TriangleXA / TriangleXC) * 180 / Math.PI * -1;
                            else if (ShipOMClosest.Name == "OM4")
                                TriangleXA = Math.Sin(TriangleXA / TriangleXC) * 180 / Math.PI;
                            if (TriangleXA < 0)
                                TriangleXA = 360 + TriangleXA;

                            outState.HorizontalAngle = Math.Round(TriangleXA);
                            outState.VerticalAngle = Math.Round(TriangleYAlpha);
                            outState.NoseAlignment = "Planet Centre";
                            outState.WingAlignment = "OM5-6";
                            outState.TopAlignment = "OM1";
                        }

                        else if (ShipOMClosest.Name == "OM5" || ShipOMClosest.Name == "OM6")
                        {
                            var TriangleYA = PosPoi.Z - PosShip.Z;
                            if (ShipOMClosest.Name == "OM6"){ TriangleYA = PosPoi.Z - PosShip.Z; }
                            var TriangleYB = PosPoi.X - PosShip.X;
                            var TriangleYC = Math.Sqrt(Math.Pow(TriangleYA, 2) + Math.Pow(TriangleYB, 2));
                            var TriangleYAlpha = Math.Asin(TriangleYA / TriangleYC) * 180 / Math.PI;
                            // #TriangleYAlpha 

                            var TriangleXA = PosPoi.Y - PosShip.Y;
                            var TriangleXB = PosPoi.X - PosShip.X;
                            var TriangleXC = Math.Sqrt(Math.Pow(TriangleXA, 2) + Math.Pow(TriangleXB, 2));
                            var TriangleXAlpha = Math.Asin(TriangleXA / TriangleXC) * 180 / Math.PI;
                            if (ShipOMClosest.Name == "OM5")
                                TriangleXAlpha = Math.Asin(TriangleXA / TriangleXC) * 180 / Math.PI;
                            if (ShipOMClosest.Name == "OM6")
                                TriangleXAlpha = Math.Asin(TriangleXA / TriangleXC) * 180 / Math.PI * -1;
                            if (TriangleXAlpha < 0)
                                TriangleXAlpha = 360 + TriangleXAlpha;
                            // # TriangleXAlpha

                            outState.HorizontalAngle = Math.Round(TriangleXAlpha);
                            outState.VerticalAngle = Math.Round(TriangleYAlpha);
                            outState.NoseAlignment = "Planet Centre";
                            outState.WingAlignment = "OM3-4";
                            outState.TopAlignment = "OM-1";
                        }

                        else if (ShipOMClosest.Name == "OM2" || ShipOMClosest.Name == "OM1")
                        {
                            var TriangleYA = PosPoi.Y - PosShip.Y;
                            var TriangleYB = PosPoi.Z - PosShip.Z;
                            var TriangleYC = Math.Sqrt(Math.Pow(TriangleYA, 2) + Math.Pow(TriangleYB, 2));
                            var TriangleYAlpha = Math.Asin(TriangleYA / TriangleYC) * 180 / Math.PI;
        
                            var TriangleXA = PosPoi.X - PosShip.X;
                            var TriangleXB = PosPoi.Z - PosShip.Z;
                            var TriangleXC = Math.Sqrt(Math.Pow(TriangleXA, 2) + Math.Pow(TriangleXB, 2));
                            if (ShipOMClosest.Name == "OM1")
                                TriangleXA = Math.Asin(TriangleXA / TriangleXC) * 180 / Math.PI;
                            else if (ShipOMClosest.Name == "OM2")
                                TriangleXA = Math.Asin(TriangleXA / TriangleXC) * 180 / Math.PI * -1;
                            if (TriangleXA < 0) TriangleXA = 360 + TriangleXA;

                            outState.HorizontalAngle = Math.Round(TriangleXA);
                            outState.VerticalAngle = Math.Round(TriangleYAlpha);
                            outState.NoseAlignment = "Planet Centre";
                            outState.WingAlignment = "OM5-6";
                            outState.TopAlignment = "OM-3";
                        }

                        // ### GET ANGLE ON A PLANET FOR GROUDN VEHICLES ###
                        // # CODE BY BIGCHEESE
                        // # Write-Host "CalcEbenenwinkel: " +  PreviousPlanetaryXCoord + '; ' + PreviousPlanetaryYCoord + '; ' + PreviousPlanetaryZCoord + '; ' + CurrentPlanetaryXCoord + '; ' + CurrentPlanetaryYCoord + '; ' + CurrentPlanetaryZCoord + '; ' + PosPoi.X + '; ' + PosPoi.Y + '; ' + PosPoi.Z
                        if (outState.PreviousCoordinates != null)
                        {
                            outState.GroundVehicleAngle = Generic.CalcEbenenwinkel(
                                outState.PreviousCoordinatesDeRotated.LocalPosition,
                                outState.PlayerCoordinatesDeRotated.LocalPosition,
                                outState.Destination.LocalPosition); ;
                        }
                        else
                        {
                            outState.GroundVehicleAngle = 0;
                        }

                        outState.Bearing = Generic.CalculateBearing(outState.PlayerCoordinatesDeRotated, outState.Destination);
                    }

                    /*
                    // # OUTPUT TO USER
                    // # Distance Indicator KM M Delta
                    Results = @()
                    Total = "" | Select-Object Type,Distance,Delta # Spacer1, Spacer2
                    Total.Type = "Total"
                    // #Total.Indicator = StatusIndicatorT
                    Total.Distance = CurrentDistanceTotal
                    Total.Delta = CurrentDeltaTotal
                    // #Total.Spacer1 = " "
                    // #Total.Spacer2 = " "
                    if(debug){Results += Total}

                    X = "" | Select-Object Type,Distance,Delta # Spacer1, Spacer2
                    X.Type = "X-Axis"
                    // #X.Indicator = StatusIndicatorX
                    X.Distance = CurrentDistanceX
                    X.Delta = CurrentDeltaX
                    // #X.Spacer1 = " "
                    // #X.Spacer2 = " "
                    if(debug){Results += X}

                    Y = "" | Select-Object Type,Distance,Delta # Spacer1, Spacer2
                    Y.Type = "Y-Axis"
                    // #Y.Indicator = StatusIndicatorY
                    Y.Distance = CurrentDistanceY
                    Y.Delta = CurrentDeltaY
                    // #Y.Spacer1 = " "
                    // #Y.Spacer2 = " "
                    if(debug){Results += Y}

                    Z = "" | Select-Object Type,Distance,Delta # Spacer1, Spacer2
                    Z.Type = "Z-Axis"
                    // #Z.Indicator = StatusIndicatorZ
                    Z.Distance = CurrentDistanceZ
                    Z.Delta = CurrentDeltaZ
                    // #Z.Spacer1 = " "
                    // #Z.Spacer2 = " "
                    if(debug){Results += Z}
                    */

                    ConsoleDisplay.PrintOutput(LoadedGameData, outState);

                    /*
            # FINAL DEBUGGING
            # Write-Host "Rotation Rate ObjectContainerRotSpeed"
            # Write-Host "Length of Day LengthOfDayDecimal"
            # Write-Host "Current Cycle TotalCycles"
            # Write-Host "Julian Date OCJulianDate"
            # Write-Host "Rotation Correction ObjectContainerRotAdjust"
            # Write-Host "Hour Angle"

            ### WRITE EACH UPDATE INTO A LOGFILE, CALLED SLF (StarCitizen Logging Fileformat) FILE, 
            # Key, Systemname, Global X, Global Y, Global Z, Planetname, Local X, Local Y, Local Z, Latitude, Longitude, Height, Lat2d-X, Long2D-Y, Datetime, Playername, Comment

                    EpochTime = Get-Date DateTime -UFormat %s
                    Logindex = 0

                    if (ScriptLoopCount -lt 1) {
            # ADD HEADING TO LOGFILE
                        if(-not(Test-Path -Path LogFilename -PathType Leaf)){
                            LogHeading = "Key, Systemname, Global X (m), Global Y (m), Global Z (m), Planetname, Local X (km), Local Y (km), Local Z (km), Latitude, Longitude, Height (m), Lat2d-X (m), Long2D-Y (m), Date (Epoch), Datetime (UTC), Playername, Comment"
                            LogHeading >> LogFilename
                        }

            # DETERMINE PLAYERNAME
                        <#
                        LogfileLauncher = "env:APPDATA\rsilauncher\log.log"
                        CurrentGameDetails = Get-Content -Path LogfileLauncher | Select-String -Pattern "Launching Star Citizen" | Select-Object -Last 1
                        GameDir = (CurrentGameDetails.Line.split('(').split(')').replace("\\","\"))[1]
                        GameLogLocation = "GameDir\game.log"
                        GameLogDetailsRaw = Get-Content GameLogLocation -Delimiter "<" #| Select-Object -Last 150
                        GameLogDetails = GameLogDetailsRaw.trim("<").trim()
                        (Get-Content GameLogLocation) -replace '^.', ';' | Out-File "GameDir\pre.log"
                        GameLogDetailsRaw = Get-Content "GameDir\pre.log" -Delimiter ";" 
            #GameLogDetailsRaw = ModifiedLog.split(';').Trim('`r')
                        GameLogDetails = GameLogDetailsRaw.trim(";") | Where-Object {_ -gt 0}

                        LogContent = @()
                        GameLogDetails.Count
                        foreach(line in GameLogDetails){

                            nline = line.Split("`n").Split(">").Trim()
                            properties = @{
                                'Date' = nline[0]
                                'Message' = nline[1]
                                'Details1' = nline[2]
                                'Details2' = nline[3]
                                'Details3' = nline[4]
                                'Details4' = nline[5]
                                'Details5' = nline[6]
                            }

                            LogContent += New-Object PSObject -Property properties
                        }
                        PlayernameGF = (LogContent | Where-Object { _.Message -match "User Login Success"}).Message.split("[").split("]")[5]
            #>
                    }


                    if(script:CurrentDetectedObjectContainer){
            #Playername,(DateTime.ToString('yyyy.MM.dd_HH:mm:ss:ffff'))
            #HistoryContent = "CurrentPlanetaryXCoord,CurrentPlanetaryYCoord,CurrentPlanetaryZCoord"

            ### Convert Lat into meters for scale ###
            # FIRST CALC THE CIRCUMFERENCE AND CONVERT IT INTO 1° AND MULTIPLE IT WITH THE READING
                        Circum = (Math.PI * Math.Pow((CurrentDetectedBodyRadius + WgsHeight),2))
                        LatInMeters  = Circum / 180 * WgsLatitude 
                        LongInMeters = Circum / 360 * WgsLongitude

            # LOG CONTENT
                        LogContent = "Logindex,script:CurrentDetectedSystem,CurrentXPosition,CurrentYPosition,CurrentZPosition,CurrentDetectedObjectContainer,CurrentPlanetaryXCoord,CurrentPlanetaryYCoord,CurrentPlanetaryZCoord,WgsLatitude,WgsLongitude,WgsHeight,LatInMeters,LongInMeters,EpochTime,(DateTime.ToString('yyyy.MM.dd_HH:mm:ss:ffff')),PlayernameGF,UserComment"
                        LogContent  >>  LogFilename

            # OUTPUT ALL UPDATES IN HISTORY FILE FOR MAPPING
                        HistoryContent = "LatInMeters,LongInMeters,WgsHeight,Playername"
                        HistoryContent  >>  CsvFilename
                    } #IF ON A PLANET
                    else {
                        LogContent = "Logindex,script:CurrentDetectedSystem,CurrentXPosition,CurrentYPosition,CurrentZPosition,none,none,none,none,none,none,none,none,none,EpochTime,(DateTime.ToString('yyyy.MM.dd_HH:mm:ss:ffff')),PlayernameGF,UserComment"
                        LogContent  >>  LogFilename

                        HistoryContent = "CurrentXPosition,CurrentYPosition,CurrentZPosition,Playername"
                        HistoryContent  >> 'Data\history_global.csv'
                    } #ELSE IF IN SPACE
                    */

                    // # STORE PREVIOUS DISTANCES
                    // # Start-Sleep -Milliseconds 1

                }
                // # DEBUG
                // #else{
                // # Write-Host -NoNewline "."
                // #}
                else
                {
                    /*
                    if(!ClipboardContainsCoordinates -and ScriptLoopCount -lt 2){

                        Clear-Host
                        max = [System.ConsoleColor].GetFields().Count - 1 
                        color = [System.ConsoleColor](Get-Random -Min 1 -Max max)
                        text1 = "Please issue "
                        text2 = "/showlocation "
                        text3 = "command in chat to display results"
                        Milliseconds = 5
                        [char[]]text1 | ForEach-Object{
                            Write-Host -NoNewline -ForegroundColor White _
            # Only break for a non-whitespace character.
                            if(_ -notmatch "\s"){Start-Sleep -Milliseconds Milliseconds}
                        }

                        [char[]]text2 | ForEach-Object{
                            Write-Host -NoNewline -ForegroundColor color _
            # Only break for a non-whitespace character.
                            if(_ -notmatch "\s"){Start-Sleep -Milliseconds Milliseconds}
                        }

                        [char[]]text3 | ForEach-Object{
                            Write-Host -NoNewline -ForegroundColor White _
            # Only break for a non-whitespace character.
                            if(_ -notmatch "\s"){Start-Sleep -Milliseconds Milliseconds}
                        }
                        Write-Host " "
            #if (WaitCount -eq 5){}
            #WaitCount++
                        Start-Sleep -Milliseconds 1500
                    }
                    */
                }

                outState.PreviousCoordinates = outState.PlayerCoordinates?.Copy();
                outState.PreviousCoordinatesDeRotated = outState.PlayerCoordinatesDeRotated?.Copy();
                outState.PreviousDeviationPlanet = outState.DeviationPlanet;
                outState.PreviousDeviationSpace = outState.DeviationSpace;
                outState.PreviousDestinationDistance = outState.DestinationDistance;
                outState.PreviousVector = outState.CurrentVector;
                outState.PreviousUpdateDuration = outState.UpdateDuration;
                outState.PreviousGroundVehicleAngle = outState.GroundVehicleAngle;
                outState.LastUpdated = outState.Updated;
            }
        }

        static (ConsoleKey PressedKey, ConsoleModifiers Modifiers)? _pressedKey;

        static void CheckKey()
        {
            if (Console.KeyAvailable)
            {
                var consoleKey = Console.ReadKey();
                _pressedKey = (consoleKey.Key, consoleKey.Modifiers);
            }
            else
                _pressedKey = null;
        }
        static bool KeyPress(ConsoleKey Key, ConsoleModifiers Modifiers)
        {
            return _pressedKey?.PressedKey == Key && _pressedKey?.Modifiers == Modifiers;
        }

        static (bool HasCoordinates, string RawText, Vector3 Coordinates, DateTime CoordinateTime) 
            GetStarCitizenClipboardAndDate(TimeSpan? PCClockDrift = null)
        {
            var clipText = Clipboard.GetText();
            var coordMatch = Regex.Match(clipText, @"Coordinates: x:([-\.\d]+) y:([-\.\d]+) z:([-\.\d]+)");
            if (coordMatch.Success)
            {
                return (true, clipText, new Vector3(
                    double.Parse(coordMatch.Groups[1].Value),
                    double.Parse(coordMatch.Groups[2].Value),
                    double.Parse(coordMatch.Groups[3].Value)),
                    DateTime.Now + (PCClockDrift ?? TimeSpan.Zero));
            }
            else
                return (false, null, new Vector3(), DateTime.Now);
        }
    }
}

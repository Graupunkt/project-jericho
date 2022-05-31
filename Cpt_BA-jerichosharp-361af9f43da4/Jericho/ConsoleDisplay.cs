using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Jericho
{
    internal class ConsoleDisplay
    {
        internal static void ColoredWrite(string Text, 
            ConsoleColor Foreground = ConsoleColor.White, 
            ConsoleColor Background = ConsoleColor.Black)
        {
            Console.BackgroundColor = Background;
            Console.ForegroundColor = Foreground;
            Console.Write(Text);
        }

        internal static void ResetColors()
        {
            Console.BackgroundColor = ConsoleColor.Black;
            Console.ForegroundColor = ConsoleColor.White;
        }

        public static void PrintOutput(GameData LoadedGameData, OutputState state)
        {
            // #######################
            // ### GENERATE OUTPUT ###
            // #######################

            /*
            if (debug)
            {
                Results | Format - Table @{
                    Label = "(VTDefault)Type";
                    Expression ={ "(VTDefault)(_.Type)      "}
                },
            @{
                    Label = "(VTDefault)Distance";                                  #NAME OF RESULTHEADING
                Expression = {
                        switch (_.Distance)
                        {                                 #COLORIZE DISTANCE BY LIMITS
                    { _ - le DistanceGreen}
                        { color = VTGreen; break }               # When _ is -1 its lwoer than 0 
                    { _ - le DistanceYellow}
                        { color = VTYellow; break }               #
                    default { color = VTRed }                                       #
                }
                    DistanceTKM = Math.Truncate(_.Distance / 1000).ToString('N0') + "km"   #CONVERT DISTANCE IN KM
                DistanceTM = (_.Distance / 1000).ToString('N3').split(',')[1] + "m "   #CONVERT DISTANCE IN M
                "(color)("DistanceTKM DistanceTM")"                          #RESULT COLOR FORMAT
                };

# ALIGN NUMBERS TO THE RIGHT
                align = 'right';
                width = 20
                },
            @{
# Label = 'Delta';
                Label = "(VTDefault)Delta";
                Expression = {
                    switch (_.Delta)
                    {
                    { _ - lt 0}
                    { color = VTRed; break }     # COLOR RED IF WE GOT MORE FAR WAY
                    { _ - gt 0}
                    { color = VTGreen; break }   # COLOR GREEN IF WE GOT CLOSER
                    default { color = VTDefault }          # COLOR GRAY IF NOTHING CHANGED
                }
                DeltaTotalKM = Math.Truncate(_.Delta / 1000).ToString('N0') + "km"
                DeltaTotalM = (_.Delta / 1000).ToString('N3').split(',')[1] + "m "
                "    (color)("DeltaTotalKM DeltaTotalM")"
                };
            align = 'right'
            }
    }
            */

            Console.Clear();

            string LastUpdateString = "";
            if (state.UpdateDuration.Hours > 0)
                LastUpdateString = $"{state.UpdateDuration.Hours:N2}h {state.UpdateDuration.Minutes:N2}min {state.UpdateDuration.Seconds}sec";
            else if (state.UpdateDuration.Minutes > 0)
                LastUpdateString = $"{state.UpdateDuration.Minutes:N2}min {state.UpdateDuration.Seconds}sec";
            else if (state.UpdateDuration.Seconds > 0)
                LastUpdateString = $"{state.UpdateDuration.Seconds}sec";
            
            ColoredWrite("Updated:".PadLeft(12), ConsoleColor.DarkGray);
            ColoredWrite(state.Updated.ToString("HH:mm:ss").PadLeft(9));

            ColoredWrite("last update:".PadLeft(15), ConsoleColor.DarkGray);
            ColoredWrite(LastUpdateString.PadLeft(6));
            ColoredWrite("Destination: ".PadLeft(15), ConsoleColor.DarkGray);
            ColoredWrite(state.DestinationName);

            ColoredWrite("\n");

            // ####################
            // ### INSTRUCTIONS ###
            // ####################
            // # GET DISTANCES FROM ALL AVAIlABLE QM

            // Actual printing begins

            // # REWORK PADDING
            var SpacingLeftColumns = 15;
            var SpacingRightColumns = 17;

            
            //Coordinate Section
            //Row 1: Legend
            var o_Legend = "COORDINATES :".PadRight(SpacingLeftColumns) +
                "X (+OM5/-OM6)".PadLeft(SpacingRightColumns) +
                "Y (+OM3/-OM4)".PadLeft(SpacingRightColumns) +
                "Z (+OM1/-OM2)".PadLeft(SpacingRightColumns) + 
                "\n";
            ColoredWrite(o_Legend, ConsoleColor.DarkGray); 


            //Row 2: System Info
            var o_System = $"{(state.PlayerCoordinates.System ?? "").PadRight(SpacingLeftColumns - 4)} : " +
                (Math.Round(state.PlayerCoordinates.GlobalPosition.X, 3)).ToString().PadLeft(SpacingRightColumns) +
                (Math.Round(state.PlayerCoordinates.GlobalPosition.Y, 3)).ToString().PadLeft(SpacingRightColumns) +
                (Math.Round(state.PlayerCoordinates.GlobalPosition.Z, 3)).ToString().PadLeft(SpacingRightColumns) + 
                "\n";
            ColoredWrite(o_System); 

            
            // # WGS Lat Long Height Conversion
            // # CurrentXPosition = 100;CurrentYPosition = 200;CurrentZPosition = 300;CurrentDetectedBodyRadius = 380
            // # CurrentXPosition = -140700;CurrentYPosition = 287920;CurrentZPosition = -116690;CurrentDetectedBodyRadius = 340830
            // # = Lat: -20.008°  Long: 26.044°  Height: 214
            // # RadialDistance = Math.Sqrt([double]CurrentXPosition * [double]CurrentXPosition + [double]CurrentYPosition * [double]CurrentYPosition + [double]CurrentZPosition * [double]CurrentZPosition)
            
            var (WgsLatitude, WgsLongitude, WgsHeight) = Generic.CoordinatesToLatLon(state.PlayerCoordinatesDeRotated);

            //Row 3: Planet Lat/Lon
            ColoredWrite("Planet/Moon : ".PadRight(SpacingRightColumns)); 
            ColoredWrite("Lat: ", ConsoleColor.DarkGray);
            ColoredWrite($"{WgsLatitude}°".PadRight(SpacingRightColumns));
            ColoredWrite("Long:", ConsoleColor.DarkGray);
            ColoredWrite($"{WgsLongitude}°".PadRight(SpacingRightColumns));
            ColoredWrite("Height:", ConsoleColor.DarkGray);
            ColoredWrite($"{WgsHeight}".PadRight(SpacingRightColumns));
            ColoredWrite("\n");


            //Row 4: Planet Local Coordinates
            if (state.PlayerCoordinates.ParentContainer != null)
            {
                var playerCoordKM = state.PlayerCoordinatesDeRotated.LocalPosition / 1000;

                var o_LocalStatus = "Planet/Moon :".PadRight(SpacingLeftColumns - 7) +
                    state.PlayerCoordinates.ParentContainer.Name.PadRight(SpacingLeftColumns - 5) +
                    playerCoordKM.X.ToString("0.000").PadLeft(SpacingRightColumns - 9) +
                    playerCoordKM.Y.ToString("0.000").PadLeft(SpacingRightColumns) +
                    playerCoordKM.Z.ToString("0.000").PadLeft(SpacingRightColumns);

                ColoredWrite(o_LocalStatus);
            } else {
                ColoredWrite("Planet/Moon : ");
                ColoredWrite("in Space", ConsoleColor.Red);
            }
            ColoredWrite("\n");

            //Row 3: Destination Coordinates
            string o_Destination = "Destination: No Destination Set";
            Vector3 o_DestinationKM = state.Destination.LocalPosition;
            if (state.Destination != null)
            {
                switch (state?.Destination?.CoordType)
                {
                    case CoordinateType.PlanetaryPOI:
                        o_Destination = "Destination :".PadRight(SpacingLeftColumns - 7) +
                            state.Destination.ParentContainer.Name.PadRight(SpacingLeftColumns - 8) +
                            o_DestinationKM.X.ToString("0.000").PadLeft(SpacingRightColumns - 8) +
                            o_DestinationKM.Y.ToString("0.000").PadLeft(SpacingRightColumns) +
                            o_DestinationKM.Z.ToString("0.000").PadLeft(SpacingRightColumns);
                        break;
                    case CoordinateType.SpacePOI:
                        o_Destination = "Destination :".PadRight(SpacingLeftColumns - 7) +
                            "Space".PadRight(SpacingLeftColumns - 8) +
                            o_DestinationKM.X.ToString("0.000").PadLeft(SpacingRightColumns - 6) +
                            o_DestinationKM.Y.ToString("0.000").PadLeft(SpacingRightColumns) +
                            o_DestinationKM.Z.ToString("0.000").PadLeft(SpacingRightColumns);
                        break;
                    case CoordinateType.CustomCoordinates:
                        o_Destination = "Destination :".PadRight(SpacingLeftColumns - 7) +
                            "Custom".PadRight(SpacingLeftColumns - 8) +
                            o_DestinationKM.X.ToString("0.000").PadLeft(SpacingRightColumns - 6) +
                            o_DestinationKM.Y.ToString("0.000").PadLeft(SpacingRightColumns) +
                            o_DestinationKM.Z.ToString("0.000").PadLeft(SpacingRightColumns);
                        break;
                }
            }
            ColoredWrite(o_Destination);
            ColoredWrite("\n");


            //Row 4: Local OM Distances
            ColoredWrite("OM Distance : ");
            if (state.PlayerOM != null)
            {
                for (int i = 0; i < 6; i++)
                {
                    // NOTE: OM's here are sorted by distance, not indexed OM1-6
                    var matchingOM = state.PlayerOM.First(om => om.Name == $"OM{i+1}");
                    // Need to calculate current-time position of OM's
                    var currentOMPosition = state.PlayerCoordinates.ParentContainer.RotateCoordinateByTime(matchingOM, state.GetJulianDelta());
                    var distance = currentOMPosition.LocalPosition.DistanceTo(state.PlayerCoordinates.LocalPosition);
                    ColoredWrite($"{(i != 0 ? "," : "")}OM{i + 1}:", ConsoleColor.DarkGray);
                    ColoredWrite($"{distance / 1000:N2}");
                }
            }
            else
                ColoredWrite("in Space", ConsoleColor.Red);
            ColoredWrite("\n");

            
            //Row 5 Destination OM Distances
            ColoredWrite("Destination : ");
            if (state.DestinationOM != null)
            {
                for (int i = 0; i < 6; i++)
                {
                    // NOTE: OM's here are sorted by distance, not indexed OM1-6
                    var matchingOM = state.DestinationOM.First(om => om.Name == $"OM{i+1}");
                    var currentOMPosition = state.DestinationRotated.ParentContainer.RotateCoordinateByTime(matchingOM, state.GetJulianDelta());
                    var distance = currentOMPosition.LocalPosition.DistanceTo(state.DestinationRotated.LocalPosition);
                    ColoredWrite($"{(i != 0 ? "," : "")}OM{i + 1}:", ConsoleColor.DarkGray);
                    ColoredWrite($"{distance / 1000:N2}");
                }
            }
            else
                ColoredWrite("in Space", ConsoleColor.Red);
            ColoredWrite("\n");
            ColoredWrite("\n");
            
            /*
            //### PREDICTION OF SUNRISE AND SUNSET ###
            // # NEEDED VARIABLES
            // # The location of the star in the current detected solarsystem
            var CurrentStar = LoadedGameData.ObjectContainerData
                .First(oc => oc.System == state.PlayerCoordinates.System && oc.Type == "Star");
            
            // # HCHF (HCHF - heliocentric / helio fixed) Coordinates of the current object container
            script: CurrentDetectedOCX #BX = Body X
            script:CurrentDetectedOCY #BY
            script:CurrentDetectedOCZ #BZ
            // # Quaternion Rotation of the current object container 
            script:CurrentDetectedOCADW #QW = Quaternion W
            script:CurrentDetectedOCADX #QX = Quaternion X
            script:CurrentDetectedOCADY #QY
            script:CurrentDetectedOCADZ #QZ
            // # CALCULATIONS
            // # CONVERT SYSTEM COORDINATES FROM STANTON STAR TOWARDS PLANET RELATIVE COORDINATES (ECEF - earth centered / earth fixed), THINK OF PLANET CENTRE HAS SYSTEM COORDINATES OF 0,0,0
            if (state.PlayerCoordinates.ParentContainer != null) {

                // # bsx
                StarRelXCoord = (((1 - Math.Pow(2 * script:CurrentDetectedOCADY, 2)) - Math.Pow(2 * script:CurrentDetectedOCADZ, 2)) * (StarXCoord - script:CurrentDetectedOCX)) +(((2 * script:CurrentDetectedOCADX* script:CurrentDetectedOCADY)-(2 * script:CurrentDetectedOCADZ* script:CurrentDetectedOCADW))*(StarYCoord - script:CurrentDetectedOCY)) +(((2 * script:CurrentDetectedOCADX* script:CurrentDetectedOCADZ)+(2 * script:CurrentDetectedOCADY* script:CurrentDetectedOCADW)) *(StarZCoord - script:CurrentDetectedOCZ))
                // # bsy
                StarRelYCoord = (((2 * script:CurrentDetectedOCADX* script:CurrentDetectedOCADY)+(2 * script:CurrentDetectedOCADZ* script:CurrentDetectedOCADW)) *(StarXCoord - script:CurrentDetectedOCX)) +((1 - Math.Pow(2 * script:CurrentDetectedOCADX, 2) - Math.Pow(2 * script:CurrentDetectedOCADZ, 2)) * (StarYCoord - script:CurrentDetectedOCY)) +(((2 * script:CurrentDetectedOCADY* script:CurrentDetectedOCADZ) -(2 * script:CurrentDetectedOCADX* script:CurrentDetectedOCADW)) *(StarZCoord - script:CurrentDetectedOCZ))
                // # bsz
                //#StarRelZCoord =
                    //#(((2 * qx * qz) - (2 * qy * qw)) * (sx - bx)) + (((2 * qy * qz) + (2 * qx * qw)) * (sy - by)) + ((1 - (2 * qx ^ 2) - (2 * qy ^ 2)) * (sz - bz))
            }
            */


            // # CALCUALTE LOCAL COURSE DIAVATION
            
            // # OUTPUT COURSE
            ConsoleColor CurrentDistanceColor, CurrentDeltaColor;
            // #COLORIZE DISTANCE BY LIMITS
            if (state.DestinationDistance < Constants.DistanceGreen)
                CurrentDistanceColor = ConsoleColor.Green;
            else if (state.DestinationDistance > Constants.DistanceYellow)
                CurrentDistanceColor = ConsoleColor.Yellow;
            else
                CurrentDistanceColor = ConsoleColor.Red;

            // #COLORIZE DISTANCE BY LIMITS
            if (state.CurrentVector.Length < Constants.QMDistanceGreen)
                CurrentDeltaColor = ConsoleColor.Green;
            else if (state.CurrentVector.Length < Constants.QMDistanceYellow)
                CurrentDeltaColor = ConsoleColor.Yellow;
            else
                CurrentDeltaColor = ConsoleColor.Red;

            // # COLOR CODEING FOR ANGLES
            ConsoleColor AngleColor = ConsoleColor.Gray;
            if (state.DeviationSpace < 0.1) AngleColor = ConsoleColor.Blue;
            else if (state.DeviationSpace < 3) AngleColor = ConsoleColor.Green;
            else if (state.DeviationSpace < 10) AngleColor = ConsoleColor.Green;
            else if (state.DeviationSpace > 10) AngleColor = ConsoleColor.Red;

            ConsoleColor LocalAngleColor = ConsoleColor.Gray;
            if (state.DeviationPlanet < 0.1) LocalAngleColor = ConsoleColor.Blue;
            else if (state.DeviationPlanet < 3) LocalAngleColor = ConsoleColor.Green;
            else if (state.DeviationPlanet < 10) LocalAngleColor = ConsoleColor.Green;
            else if (state.DeviationPlanet > 10) LocalAngleColor = ConsoleColor.Red;


            int DistanceTKM = (int)Math.Truncate(state.DestinationDistance / 1000);
            int DistanceTM = (int)(state.DestinationDistance % 1000);
            int DistanceDKM = (int)Math.Truncate(state.CurrentVector.Length / 1000);
            int DistanceDM = (int)(state.CurrentVector.Length % 1000);

            //Navigation Seaction
            int SpacingToLeft2 = 20;
            ColoredWrite("NAVIGATION", ConsoleColor.DarkGray);
            ColoredWrite("CURRENT".PadLeft(SpacingToLeft2), ConsoleColor.DarkGray);
            ColoredWrite("DELTA/PREVIOUSlY".PadLeft(SpacingToLeft2), ConsoleColor.DarkGray);
            ColoredWrite("\n");

            ColoredWrite("Distance");
            ColoredWrite($"({DistanceTKM}km {DistanceTM}m)".PadLeft(SpacingToLeft2 + 7), CurrentDistanceColor);
            ColoredWrite($"({DistanceDKM}km {DistanceDM}m)".PadLeft(SpacingToLeft2 + 4));
            ColoredWrite("\n");

            ColoredWrite("Deviation Space");
            ColoredWrite($"{state.DeviationSpace:N2}°".PadLeft(SpacingToLeft2), AngleColor);
            ColoredWrite($"{state.PreviousDeviationSpace:N2}°".PadLeft(SpacingToLeft2 + 4));
            ColoredWrite("\n");

            ColoredWrite("Deviation Planet");
            ColoredWrite($"{state.DeviationPlanet:N2}°".PadLeft(SpacingToLeft2 - 1), LocalAngleColor);
            ColoredWrite($"{state.PreviousDeviationPlanet:N2}°".PadLeft(SpacingToLeft2 + 4));
            ColoredWrite("\n");

            ColoredWrite("\n");


            //ETA Section
            ColoredWrite("ETA", ConsoleColor.DarkGray);
            ColoredWrite("\n");

            if (state.ETA > 0)
            {
                var ts = TimeSpan.FromSeconds(state.ETA);
                ColoredWrite($"{ts.Days} Days, {ts.Hours} Hours, {ts.Minutes} Minutes, {ts.Seconds}");
            }
            else
            {
                ColoredWrite("Wrong way Pilot, turn around.", ConsoleColor.Red);
            }
            ColoredWrite("\n");
            ColoredWrite("\n");

            // # Write-Host ""


            // #########################################
            // ### SET ANGLE AN ALIGNMENT FOR ANGLES ###
            // #########################################
            // # CONVERT CURRENT STANTON XYZ INTO PLANET XYZ
            //var X2 = state.PlayerCoordinatesDeRotated.LocalPosition.X;
            //var Y2 = state.PlayerCoordinatesDeRotated.LocalPosition.Y;

            // # HARDCODED PLANET VIA DESTINATION
            //var A2 = (state.Destination.LocalPosition.X - X2);
            //var B2 = (state.Destination.LocalPosition.Y - Y2);

            //var ReversedAngle = 360.0 - CurrentCycleAngle;
            //var AngleRadian = ReversedAngle / 180.0 * Math.PI;

            //var ShipRotationValueX1 = (A2 * (Math.Cos(AngleRadian)) - B2 * (Math.Sin(AngleRadian))) *-1;
            //var ShipRotationValueY1 = (A2 * (Math.Sin(AngleRadian)) + B2 * (Math.Cos(AngleRadian))) * -1;
            // #ShipRotationValueZ1 = CurrentZPosition / 1000


            // # DETERMINE CLOST CURRENT OM FOR ANGLE CALCULATIONS
            // # PlanetOMRadius = (HashtableOmRadius.GetEnumerator() | Where-Object {_.Name -eq "CurrentPlanet"}).Value

            // # GET CLOSEST ORBITAL MARKER

            // #ClosestQM = QMDistancesCurrent | Where-Object {_.QuantumMarkerTo -NotContains ClosestQMStart.QuantumMarkerTo} | Sort-Object -Property Distance | Select-Object -First 1 
            if (state.Destination?.ParentContainer?.Type == "Planet")
            {
                ColoredWrite("DIRECTION", ConsoleColor.DarkGray);
                ColoredWrite("ANGLE".PadLeft(10), ConsoleColor.DarkGray);
                ColoredWrite("\n");

                ColoredWrite("Horizontal");
                ColoredWrite($"{state.HorizontalAngle}°".PadLeft(18), ConsoleColor.Green);
                ColoredWrite("\n");

                ColoredWrite("Vertical");
                ColoredWrite($"{state.VerticalAngle}°".PadLeft(20), ConsoleColor.Green);
                ColoredWrite("\n");

                // # Write-Host "Ship Position","{VTGreen}OM3/4".padLeft(11)
                // # Write-Host "Planet: {VTGreen}(SelectedPlanet.Name){VTDefault}, Orbital Marker: {VTGreen}ShipOMClosest{VTDefault}, Alignment: {VTGreen}Planet Centre"

                ColoredWrite("Alignment");
                ColoredWrite("Nose: ");
                ColoredWrite(state.NoseAlignment, ConsoleColor.Green);
                ColoredWrite(", Wings: ");
                ColoredWrite(state.WingAlignment, ConsoleColor.Green);
                ColoredWrite(", Top: ");
                ColoredWrite(state.TopAlignment, ConsoleColor.Green);
                ColoredWrite("\n");

                /*
                ### CREATE CROSSHAIR OVERLAY ###
                if (script:HudCrosshair) {
                    Set - CrosshairOnScreen FinalHorizontalAngle FinalVerticalAngle
                }
                */
                ColoredWrite("\n");
            }

            
            if (state.Destination?.CoordType == CoordinateType.PlanetaryPOI)
            {
                ColoredWrite("GROUND VEHICLES", ConsoleColor.DarkGray);
                ColoredWrite("VALUE".PadLeft(14), ConsoleColor.DarkGray);
                ColoredWrite("TENDENCY".PadLeft(10), ConsoleColor.DarkGray);
                ColoredWrite("\n");

                ColoredWrite("Angle".PadLeft(5));
                ColoredWrite($"{state.GroundVehicleAngle:N2}".PadLeft(24));
                if (state.GroundVehicleAngle < state.PreviousGroundVehicleAngle)
                    ColoredWrite("good".PadLeft(19), ConsoleColor.Green);
                else
                    ColoredWrite("bad".PadLeft(19), ConsoleColor.Red);
                ColoredWrite("\n");

                ConsoleColor DistanceGVColor;

                if(state.DestinationDistance < Constants.DistanceGreen)
                    DistanceGVColor = ConsoleColor.Green;
                else if(state.DestinationDistance < Constants.DistanceYellow)
                    DistanceGVColor = ConsoleColor.Yellow;
                else
                    DistanceGVColor = ConsoleColor.Red;

                ColoredWrite("Distance".PadLeft(8));
                ColoredWrite($"{DistanceTKM:N0}km {DistanceTM:N0}m".PadLeft(26), DistanceGVColor);

                if (state.DestinationDistance < state.PreviousDestinationDistance)
                    ColoredWrite("closer".PadLeft(19), ConsoleColor.Green);
                else if (state.DestinationDistance < state.PreviousDestinationDistance)
                    ColoredWrite("further".PadLeft(19), ConsoleColor.Red);
                else
                    ColoredWrite("no change".PadLeft(19), ConsoleColor.DarkGray);
                ColoredWrite("\n");



                // # doabigcheese Bearing Berechnung  
                ColoredWrite("Compass : ".PadRight(SpacingRightColumns + 4));
                ColoredWrite($" {state.Bearing}° (Bearing)");
                ColoredWrite("\n");

                // # Minign Area 141
                // # H   V       Status
                // # OM1    359 15      Correct, Correct #2
                // # OM2    6   43      Correct, Correct #2
                // # OM3    4   -43     Correct, Correct #2
                // # OM4    359 -21     Correct, Correct #2
                // # OM5    22  -26     Correct (2° Diavation Vert), Correct #2 (2° Diavation Vert)
                // # OM6    336 -27     Correct (2° Diavation Vert), Correct #2 (2° Diavation Hori, (4° Diavation Vert))
                /*
                // ##################################
                // ### ANGLES FOR GROUND VEHICLES ###
                // ##################################
                // # a = total distance travelled between current and last point
                // # Delta between previous and current ship location (planetary coords)
                var TriangleGroundA = 100 * Math.Sqrt((Math.Pow(PerviousShipRotationValueX1, 2) - Math.Pow(ShipRotationValueX1, 2)) + (Math.Pow(PerviousShipRotationValueY1, 2) - Math.Pow(ShipRotationValueY1, 2)) + (Math.Pow(PerviousShipRotationValueZ1, 2) - Math.Pow(ShipRotationValueZ1, 2)));
                var TriangleGroundB = Math.Sqrt(Math.Abs((Math.Pow(PoiRotationValueX, 2) - Math.Pow(ShipRotationValueX1, 2)) + (Math.Pow(PoiRotationValueY, 2) - Math.Pow(ShipRotationValueY1, 2)) + (Math.Pow(PoiRotationValueZ, 2) - Math.Pow(ShipRotationValueZ1, 2))));
                var TriangleGroundC = Math.Sqrt(Math.Pow(TriangleGroundA, 2) + Math.Pow(TriangleGroundB, 2));
                // #100 * Math.Sqrt((Math.Pow(PerviousShipRotationValueX1,2) - Math.Pow(ShipRotationValueX1,2)) + (Math.Pow(PerviousShipRotationValueY1,2) - Math.Pow(ShipRotationValueY1,2)) + (Math.Pow(PerviousShipRotationValueZ1,2) - Math.Pow(ShipRotationValueZ1,2))) 

                var AlphaPurple = Math.Acos((Math.Pow(TriangleGroundB, 2) + Math.Pow(TriangleGroundC, 2) - Math.Pow(TriangleGroundA, 2)) / (2 * TriangleGroundB * TriangleGroundC))
                var BetaPurple =  Math.Acos((Math.Pow(TriangleGroundC, 2) + Math.Pow(TriangleGroundA, 2) - Math.Pow(TriangleGroundB, 2)) / (2 * TriangleGroundC * TriangleGroundA))
                var GammaPurple = Math.Acos((Math.Pow(TriangleGroundA, 2) + Math.Pow(TriangleGroundB, 2) - Math.Pow(TriangleGroundC, 2)) / (2 * TriangleGroundA * TriangleGroundB))
                #GroundVehicleAlpha = Math.Round(Math.ASin(TriangleGroundA / TriangleGroundC) * 180 / [System.Math]::PI,2)
                var GroundVehicleAlpha = Math.Round(AlphaPurple * 180 / [System.Math]::PI, 2);
                var GroundVehicleBeta = BetaPurple * 180 / [System.Math]::PI;
                var GroundVehicleGamma = GammaPurple * 180 / [System.Math]::PI;
                // # Write-Host "Course Diavation: {VTGreen}GroundVehicleAlpha {VTDefault}(Ground)"
                // # Write-Host "Course Diavation: {VTGreen}GroundVehicleBeta {VTDefault}(Ground)"
                // # Write-Host "Course Diavation: {VTGreen}GroundVehicleGamma {VTDefault}(Ground)"
                // # Write-Host "A Delta POI Total TriangleGrounda" 
                // # Write-Host "B Diavation Total TriangleGroundB" 
                // # Write-Host "C Movement Total TriangleGroundC"

                // # now subtract the vertical angle diavation, to get only the x angle
                // # planet x y z
                Previous_AngleGroundVehicles = AngleGroundVehicles
                Write - Host ""
                */
            }

            /*
             * Quantum Instructions
             * 

            #ClosestQMX = QMDistancesCurrent | Where-Object {_.QuantumMarkerTo -NotContains ClosestQMStart.QuantumMarkerTo} | Sort-Object -Property DistanceX | Select-Object -First 1 
            #ClosestQMY = QMDistancesCurrent | Where-Object {_.QuantumMarkerTo -NotContains ClosestQMStart.QuantumMarkerTo} | Where-Object {_.QuantumMarkerTo -NotContains ClosestQMY.QuantumMarkerTo} | Sort-Object -Property DistanceY | Select-Object -First 1 
            #ClosestQMZ = QMDistancesCurrent | Where-Object {_.QuantumMarkerTo -NotContains ClosestQMStart.QuantumMarkerTo} | Where-Object {_.QuantumMarkerTo -NotContains ClosestQMY.QuantumMarkerTo} | Where-Object {_.QuantumMarkerTo -NotContains ClosestQMZ.QuantumMarkerTo}| Sort-Object -Property DistanceZ | Select-Object -First 1 
            # CLOSEST QM MARKER ON X AXIS
            ClosestQMX = QMDistancesCurrent | Sort - Object - Property DistanceX | Select - Object - First 1
            # CLOSEST QM MARKER ON Y AXIS
            ClosestQMY = QMDistancesCurrent | Sort - Object - Property DistanceY | Select - Object - First 1
            # CLOSEST QM MARKER ON Z AXIS
            ClosestQMZ = QMDistancesCurrent | Sort - Object - Property DistanceZ | Select - Object - First 1

            #QMXDistanceFinal = Math.Sqrt(Math.Pow(DestCoordDataX - ClosestQMX.DistanceX,2) + Math.Pow(DestCoordDataY - ClosestQMX.DistanceY,2) + Math.Pow(DestCoordDataZ - ClosestQMX.DistanceZ,2))
            #QMYDistanceFinal = Math.Sqrt(Math.Pow(ClosestQMY.DistanceX - DestCoordDataX,2) + Math.Pow(ClosestQMY.DistanceY - DestCoordDataY,2) + Math.Pow(ClosestQMY.DistanceZ - DestCoordDataZ,2))
            #QMZDistanceFinal = Math.Sqrt(Math.Pow(ClosestQMZ.DistanceX - DestCoordDataX,2) + Math.Pow(ClosestQMZ.DistanceY - DestCoordDataY,2) + Math.Pow(ClosestQMZ.DistanceZ - DestCoordDataZ,2))

            #InstructionDistanceQMX = Math.Truncate(ClosestQMX.Distance/1000).ToString('N0')+"km" 
            #InstructionDistanceQMY = Math.Truncate(ClosestQMY.Distance/1000).ToString('N0')+"km" 
            #InstructionDistanceQMZ = Math.Truncate(ClosestQMZ.Distance/1000).ToString('N0')+"km" 

            if (script:PlanetaryPoi)
            {
                FinalInstructions = @()
                StartingPoint =  [ordered]@{ Step = "1."; Type = "Start"; Direction = "from"; QuantumMarker = PoiCoordDataPlanet; Distance = "-"; TargetDistance = Math.Truncate(ClosestQMStart.Distance / 1000).ToString('N0') + "km"}
                FirstStep =       [ordered]@{ Step = "2."; Type = "Jump"; Direction = "to"; QuantumMarker = OMGSStart; Distance = "-"; TargetDistance = Math.Truncate(OMGSDistanceToDestination / 1000).ToString('N0') + "km"}
                SecondStep =      [ordered]@{ Step = "3."; Type = "Fly"; Direction = "to"; QuantumMarker = "(SelectedDestination.Name)"; Distance = Math.Truncate(CurrentDistanceTotal / 1000).ToString('N0') + "km"; TargetDistance = "0 m"}
                # SecondStep =      [ordered]@{Step = "3.";Type = "Fly";Direction = "to";QuantumMarker = "(SelectedDestination.Name)";Distance = Math.Truncate(CurrentDistanceTotal/1000).ToString('N0')+"km";TargetDistance = Math.Truncate(CurrentDistanceTotal/1000).ToString('N0')+"km"}
                FinalInstructions += New - Object - Type PSObject - Property StartingPoint
                FinalInstructions += New - Object - Type PSObject - Property FirstStep
                FinalInstructions += New - Object - Type PSObject - Property SecondStep
                Write - Host "QUANTUM NAVIGATION" - NoNewline - ForegroundColor DarkGray
                Write - Host - ForegroundColor White(FinalInstructions | Format - Table - Property @{ Name = "Step"; Expression ={ _.Step}; Align = "Center"},Type,Direction,QuantumMarker,<#@{Name="Distance"; Expression={"   (_.Distance)"}; Align="Right"},#>@{Name="Final Distance"; Expression={_.TargetDistance}; Align="Right"} | Out-String)
                #LiveResults.Text = (FinalInstructions | Format-Table -Property @{Name="Step"; Expression={_.Step}; Align="Center"},Type,Direction,QuantumMarker,@{Name="Distance"; Expression={_.Distance}; Align="Right"},@{Name="TargetDistance"; Expression={_.TargetDistance}; Align="Right"} | Out-String)
            }
            else
            {
                FinalInstructions = @()
                StartingPoint =  [ordered]@{ Step = "1."; Type = "Start"; Direction = "from"; QuantumMarker = "MIC-L1-STATION (Shallow Frontier)"; JumpDistance = "-"; TargetDistance = "0 m"}
                FirstStep =       [ordered]@{ Step = "2."; Type = "Jump"; Direction = "to"; QuantumMarker = "MIC-L1"; JumpDistance = "5.961 km"; TargetDistance = "6.782 km"}
                SecondStep =      [ordered]@{ Step = "3."; Type = "Jump"; Direction = "to"; QuantumMarker = "Hurston"; JumpDistance = "689 km"; TargetDistance = "34.269.072 km"}
                ThirdStep =       [ordered]@{ Step = "4."; Type = "Jump"; Direction = "to"; QuantumMarker = "ARC-L3"; JumpDistance = "27.127 km"; TargetDistance = "49.067.144 km"}
                FourthStep =      [ordered]@{ Step = "5."; Type = "Fly"; Direction = "to"; QuantumMarker = "(SelectedDestination.Name)"; JumpDistance = "-"; TargetDistance = "-"}
                FinalInstructions += New - Object - Type PSObject - Property StartingPoint
                FinalInstructions += New - Object - Type PSObject - Property FirstStep
                FinalInstructions += New - Object - Type PSObject - Property SecondStep
                FinalInstructions += New - Object - Type PSObject - Property ThirdStep
                FinalInstructions += New - Object - Type PSObject - Property FourthStep
                Write - Host "QuaNTUM NaVIGATION" - NoNewline - ForegroundColor Darkgray
                Write - Host - ForegroundColor White(FinalInstructions | Format - Table - Property @{ Name = "Step"; Expression ={ _.Step}; Align = "Center"},Type,Direction,QuantumMarker,@{ Name = "JumpDistance"; Expression ={ _.JumpDistance}; Align = "Right"},@{ Name = "Final Distance"; Expression ={ _.TargetDistance}; Align = "Right"} | Out - String)
                #LiveResults.Text = (FinalInstructions | Format-Table -Property @{Name="Step"; Expression={_.Step}; Align="Center"},Type,Direction,QuantumMarker,@{Name="JumpDistance"; Expression={_.JumpDistance}; Align="Right"},@{Name="TargetDistance"; Expression={_.TargetDistance}; Align="Right"} | Out-String)
            }
            */
        }
    }
}

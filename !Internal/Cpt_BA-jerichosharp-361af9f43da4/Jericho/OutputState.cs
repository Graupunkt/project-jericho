using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Jericho
{
    internal class OutputState
    {
        public DateTime Updated { get; set; }
        public DateTime LastUpdated { get; set; }
        public string? DestinationName { get => Destination?.Name; }
        public TimeSpan UpdateDuration { get; set; }
        public TimeSpan PreviousUpdateDuration { get; set; }

        public Vector3 CurrentVector { get; set; } = Vector3.Zero;
        public Vector3 PreviousVector { get; set; } = Vector3.Zero;

        public CoordinateData? PlayerCoordinates { get; set; }
        public CoordinateData? Destination { get; set; }
        public CoordinateData? PreviousCoordinates { get; set; }

        public CoordinateData? PlayerCoordinatesDeRotated { get; set; } = null;
        public CoordinateData? PreviousCoordinatesDeRotated { get; set; } = null;
        public CoordinateData? DestinationRotated { get; set; } = null;

        public CoordinateData[]? PlayerOM { get; set; }
        public CoordinateData[]? DestinationOM { get; set; }

        
        public double DestinationDistance { get; set; }
        public double PreviousDestinationDistance { get; set; }

        public double DeviationSpace { get; set; }
        public double PreviousDeviationSpace { get; set; }

        public double DeviationPlanet { get; set; }
        public double PreviousDeviationPlanet { get; set; }

        //public double CurrentDeltaTotal { get; set; }
        public double ETA { get; set; }

        public double HorizontalAngle { get; set; }
        public double VerticalAngle { get; set; }
        
        public double Bearing { get; set; }

        public double GroundVehicleAngle { get; set; }
        public double PreviousGroundVehicleAngle { get; set; }

        public string NoseAlignment { get; set; }
        public string WingAlignment { get; set; }
        public string TopAlignment { get; set; }

        public TimeSpan GetJulianDelta()
        {
            return Generic.GetElapsedUTCServerTime(Updated);
        }

        public void UpdateState(GameData LoadedGameData, Vector3 NewPlayerCoordinates, DateTime CoordinateTime)
        {
            PlayerCoordinates = new CoordinateData()
            {
                GlobalPosition = NewPlayerCoordinates,
                Rotation = Vector3.Zero,
                RotationSpeed = Vector3.Zero,
                CoordType = CoordinateType.PlayerPosition
            };
            Updated = CoordinateTime;

            var parent = LoadedGameData.FindParentContainer(PlayerCoordinates.GlobalPosition);
            if (parent != null)
            {
                PlayerCoordinates.SetRelativeTo(parent);

                if (parent.Type == "Planet")
                    PlayerCoordinatesDeRotated = parent.RotateCoordinateByTime(PlayerCoordinates, GetJulianDelta(), true);
                else
                    PlayerCoordinatesDeRotated = PlayerCoordinates.Copy();
            }
            else
                PlayerCoordinatesDeRotated = PlayerCoordinates.Copy();

            if (PreviousCoordinates != null)
            {
                CurrentVector = PlayerCoordinates.GlobalPosition - PreviousCoordinates.GlobalPosition;
            }
            if (LastUpdated != default)
                UpdateDuration = Updated - LastUpdated;

            PlayerOM = PlayerCoordinates.ParentContainer?.GetOMCoordinates()
                ?.OrderBy(om => om.GlobalPosition.DistanceTo(PlayerCoordinatesDeRotated.GlobalPosition))
                ?.ToArray();
        }

        public void SetDestination(GameData LoadedGameData, CoordinateData NewDestination)
        {
            // # USE CUSTOM 3D SPACE COORDINATES IF PROVIDED
            if (NewDestination.CoordType == CoordinateType.CustomCoordinates)
            {
                /*
                if (TextBoxX.Text - and TextBoxY.Text - and TextBoxZ.Text){
                    //#SET DESTINATION TO CUSTOM COORDINATES
                    SelectedDestination = @{ "Custom" = "(TextBoxX.Text);(TextBoxY.Text);(TextBoxZ.Text)"}
                    DestCoordData = SelectedDestination.Value - Split ";"
                       DestCoordDataX = TextBoxX.Text
                       DestCoordDataY = TextBoxY.Text
                       DestCoordDataZ = TextBoxZ.Text
                   }
                else
                {
                    //#IF COORDINATES ARE ENTERED WRONG
                    ErrorMessageCustomCoords = "Custom coordinates are missing correct values"
                    Write - Host - ForegroundColor Red ErrorMessageCustomCoords
                    //#LiveResults.Text = ErrorMessageCustomCoords
                    //#Show-Frontend
                }
                */
            }
            else if (NewDestination.CoordType == CoordinateType.PlanetaryPOI)
            {
                //#GET UTC SERVER TIME, ROUND MILLISECONDS IN 166ms steps (6 to 1 second conversion)
                //#Function currently prevents script from continuing
                //#ErrorActionPreference = "SilentlyContinue"

                //#ElapsedUTCTimeSinceSimulationStart.TotalDays
                //#GET ORBITAL COORDINATES

                //#GET THE PLANETS COORDS IN STANTON
                //#SelectedPlanet = ObjectContainerData.GetEnumerator() | Where-Object { _.Key -eq CurrentPlanet}
                var SelectedPlanet = NewDestination.ParentContainer;
                //#SelectedPlanet = ObjectContainerData.GetEnumerator() | Where-Object { _.Key -eq script:CurrentDetectedObjectContainer}

                Destination = NewDestination.Copy();
                DestinationRotated = SelectedPlanet.RotateCoordinateByTime(Destination, GetJulianDelta());
                //# ToDo
                //# RE CALCULATE PREIOUS VALUES BASED ON ROTATION
                //# CURRENTLY COURSE DIAVATION SHOWS 35° WHEN HEADING DIRECTLY TO THE TARGET. THIS IS CAUSED BY THE ROTATION AND THE PREVIOUS LOCATION NOT RECALCULATE ON ROTATIO
            }
            //# GET DESTINATION COORDINATES FROM HASTABLES, FILTER FOR CURRENT DESTINATION
            else
            {
                //# SELECT DESTINATION FROM EXISTING TABLE
                //#SelectedDestination = PointsOfInterestInSpaceData.GetEnumerator() | Where-Object { _.Key -eq script:CurrentDestination } #UNCOMMENT AGAIN !!!!!!!!!!!!!!!!!!!!!!!!
                Destination = NewDestination.Copy();
                DestinationRotated = Destination.Copy();
            }
            DestinationDistance = DestinationRotated.GlobalPosition.DistanceTo(PlayerCoordinates.GlobalPosition);
            DestinationOM = DestinationRotated?.ParentContainer?.GetOMCoordinates()
                ?.OrderBy(om => om.GlobalPosition.DistanceTo(DestinationRotated.GlobalPosition))
                ?.ToArray();
        }
    }
}

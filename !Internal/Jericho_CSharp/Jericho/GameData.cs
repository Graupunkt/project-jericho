using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Jericho
{
    public class GameData
    {
        public List<ObjectContainer> ObjectContainerData { get; private set; } = new List<ObjectContainer>();
        public List<PlanetPOI> PointsOfInterestOnPlanetsData { get; private set; } = new List<PlanetPOI>();
        public List<SpacePOI> PointsOfInterestInSpace { get; private set; } = new List<SpacePOI>();

        public IEnumerable<CoordinateData> Destinations()
        {
            foreach (var poi in PointsOfInterestOnPlanetsData)
                yield return poi.Position;
            foreach (var poi in PointsOfInterestInSpace)
                yield return poi.Position;
        }

        public static GameData LoadFromFiles()
        {
            var ObjectContainerData = Generic.LoadCSVFile(Constants.OcCsvPath)
                .Select(ObjectContainer.ReadFromcCSV)
                .ToList();
            var PointsOfInterestOnPlanetsData = Generic.LoadCSVFile(Constants.PoiPlanetsCsvPath)
                .Select(poi => PlanetPOI.ReadFromcCSV(ObjectContainerData, poi))
                .ToList();
            var PointsOfInterestInSpace = Generic.LoadCSVFile(Constants.PoiSpaceCsvPath)
                .Select(poi => SpacePOI.ReadFromcCSV(ObjectContainerData, poi))
                .ToList();

            var gd = new GameData()
            {
                ObjectContainerData = ObjectContainerData,
                PointsOfInterestOnPlanetsData = PointsOfInterestOnPlanetsData,
                PointsOfInterestInSpace = PointsOfInterestInSpace
            };

            return gd;
        }

        public ObjectContainer GetObjectContainer(string ObjectContainerName)
        {
            return ObjectContainerData.FirstOrDefault(oc => oc.Name == ObjectContainerName);
        }

        public ObjectContainer FindParentContainer(Vector3 ToPosition)
        {
            foreach(var oc in ObjectContainerData)
            {
                var distanceToOC = oc.Position.GlobalPosition.DistanceTo(ToPosition);
                if(distanceToOC < oc.OrbitalMarkerRadiusM)
                {
                    return oc;
                }
            }
            return null;
        }
    }

    [DebuggerDisplay("Object Container: {Name}/{InternalName} ({Type})")]
    public class ObjectContainer
    {
        public string System { get; set; }
        public string Type { get; set; }
        public string Name { get; set; }
        public string InternalName { get; set; }
        private double XCoord { get; set; }
        private double YCoord { get; set; }
        private double ZCoord { get; set; }
        private double RotationSpeedX { get; set; }
        private double RotationSpeedY { get; set; }
        private double RotationSpeedZ { get; set; }
        private double RotationAdjustmentX { get; set; }
        private double RotationAdjustmentY { get; set; }
        private double RotationAdjustmentZ { get; set; }
        public double BodyRadiusM { get; set; }
        public double OrbitalMarkerRadiusM { get; set; }
        public double GRIDRadius { get; set; }

        public CoordinateData Position { get; set; }

        public Vector3 Pos
        {
            get { return new Vector3(XCoord, YCoord, ZCoord); }
        }

        public Vector3 RotAdjust
        {
            get { return new Vector3(RotationAdjustmentX, RotationAdjustmentY, RotationAdjustmentZ); }
        }

        public Vector3 RotSpeed
        {
            get { return new Vector3(RotationSpeedX, RotationSpeedY, RotationSpeedZ); }
        }

        public CoordinateData LocalToGlobal(Vector3 LocalPosition, CoordinateType POIType, string? CoordName = null)
        {
            //TODO: Add rotation calcluation
            return new CoordinateData(this, LocalPosition)
            {
                System = System,
                Name = CoordName ?? Name,
                CoordType = POIType
            };
        }

        public CoordinateData[] GetOMCoordinates()
        {
            return new CoordinateData[]
            {
                LocalToGlobal(Vector3.UnitZ * OrbitalMarkerRadiusM, CoordinateType.OrbitalMarker, "OM1"),
                LocalToGlobal(Vector3.UnitZ * -OrbitalMarkerRadiusM, CoordinateType.OrbitalMarker, "OM2"),
                LocalToGlobal(Vector3.UnitY * OrbitalMarkerRadiusM, CoordinateType.OrbitalMarker, "OM3"),
                LocalToGlobal(Vector3.UnitY * -OrbitalMarkerRadiusM, CoordinateType.OrbitalMarker, "OM4"),
                LocalToGlobal(Vector3.UnitX * OrbitalMarkerRadiusM, CoordinateType.OrbitalMarker, "OM5"),
                LocalToGlobal(Vector3.UnitX * -OrbitalMarkerRadiusM, CoordinateType.OrbitalMarker, "OM6"),
            };
        }

        public CoordinateData RotateCoordinateByTime(CoordinateData inputCoord, TimeSpan serverTime, bool reverse=false)
        {
            var LengthOfDayDecimal = RotSpeed.X * 3600.0 / 86400.0;      //#CORRECT
            var JulianDate = serverTime.TotalDays;        //#CORRECT
            var TotalCycles = JulianDate / LengthOfDayDecimal;                    //#CORRECT
            var CurrentCycleDez = TotalCycles % 1;
            var CurrentCycleDeg = CurrentCycleDez * 360;
            var CurrentCycleAngle = RotAdjust.X + CurrentCycleDeg;
            if (reverse)
            {
                CurrentCycleAngle = 360 - CurrentCycleAngle;
            }
            var CurrentCycleRadians = CurrentCycleAngle / 180 * Math.PI;

            return inputCoord.RotateAroundContainerZ(CurrentCycleRadians);
        }

        public static ObjectContainer ReadFromcCSV(Dictionary<string, string> csvRow)
        {
            var oc = new ObjectContainer()
            {
                System = csvRow["System"],
                Type = csvRow["Type"],
                Name = csvRow["Name"],
                InternalName = csvRow["InternalName"],
                XCoord = double.Parse(csvRow["X-Coord"]),
                YCoord = double.Parse(csvRow["Y-Coord"]),
                ZCoord = double.Parse(csvRow["Z-Coord"]),
                RotationSpeedX = double.Parse(csvRow["RotationSpeedX"]),
                RotationSpeedY = double.Parse(csvRow["RotationSpeedY"]),
                RotationSpeedZ = double.Parse(csvRow["RotationSpeedZ"]),
                RotationAdjustmentX = double.Parse(csvRow["RotationAdjustmentX"]),
                RotationAdjustmentY = double.Parse(csvRow["RotationAdjustmentY"]),
                RotationAdjustmentZ = double.Parse(csvRow["RotationAdjustmentZ"]),
                OrbitalMarkerRadiusM = double.Parse(csvRow["OrbitalMarkerRadius"]),
            };

            if(double.TryParse(csvRow["BodyRadius"], out var bodyRadius)) oc.BodyRadiusM = bodyRadius;
            if(double.TryParse(csvRow["GRIDRadius"], out var gridRadius)) oc.GRIDRadius = gridRadius;

            oc.Position = new CoordinateData()
            {
                GlobalPosition = oc.Pos,
                Rotation = oc.RotAdjust,
                RotationSpeed = oc.RotSpeed,
                Name = oc.Name,
                System = oc.System,
                CoordType = CoordinateType.ObjectContainer
            };

            return oc;
        }
    }

    [DebuggerDisplay("Planet POI: {Name} ({Type})")]
    public class PlanetPOI
    {
        public string System { get; set; } = "";
        public string ObjectContainer { get; set; } = "";
        public string Type { get; set; } = "";
        public string Name { get; set; } = "";
        private double LocalXCoord { get; set; }
        private double LocalYCoord { get; set; }
        private double LocalZCoord { get; set; }

        public ObjectContainer? ParentContainer { get; private set; } = null;
        public CoordinateData Position { get; private set; }

        private Vector3 LocalPos
        {
            get { return new Vector3(LocalXCoord, LocalYCoord, LocalZCoord); }
        }

        public static PlanetPOI ReadFromcCSV(List<ObjectContainer> containers, Dictionary<string, string> csvRow)
        {
            var poi = new PlanetPOI()
            {
                System = csvRow["System"],
                ObjectContainer = csvRow["ObjectContainer"],
                Type = csvRow["Type"],
                Name = csvRow["Name"],
                LocalXCoord = double.Parse(csvRow["Planetary X-Coord"]) * 1000,
                LocalYCoord = double.Parse(csvRow["Planetary Y-Coord"]) * 1000,
                LocalZCoord = double.Parse(csvRow["Planetary Z-Coord"]) * 1000,
                ParentContainer = containers.FirstOrDefault(oc => oc.Name == csvRow["ObjectContainer"])
            };

            poi.Position = new CoordinateData(poi.ParentContainer, poi.LocalPos)
            {
                Name = poi.Name,
                System = poi.System,
                CoordType = CoordinateType.PlanetaryPOI,
            };

            return poi;
        }
    }

    [DebuggerDisplay("SpacePOI: {Name} ({Type})")]
    public class SpacePOI
    {
        public string System { get; set; } = "";
        public string ObjectContainer { get; set; } = "";
        public string Type { get; set; } = "";
        public string Name { get; set; } = "";
        private double XCoord { get; set; }
        private double YCoord { get; set; }
        private double ZCoord { get; set; }

        public ObjectContainer? ParentContainer { get; private set; } = null;
        public CoordinateData Position { get; private set; }

        private Vector3 LocalPos
        {
            get { return new Vector3(XCoord, YCoord, ZCoord); }
        }

        public static SpacePOI ReadFromcCSV(List<ObjectContainer> containers, Dictionary<string, string> csvRow)
        {
            var poi = new SpacePOI()
            {
                System = csvRow["System"],
                Type = csvRow["POI Type"],
                Name = csvRow["Name"],
                XCoord = double.Parse(csvRow["Stanton X-Coord"]),
                YCoord = double.Parse(csvRow["Stanton Y-Coord"]),
                ZCoord = double.Parse(csvRow["Stanton Z-Coord"]),
            };

            poi.Position = new CoordinateData(poi.ParentContainer, poi.LocalPos)
            {
                Name = poi.Name,
                System = poi.System,
                CoordType = CoordinateType.SpacePOI,
            };

            return poi;
        }
    }
}

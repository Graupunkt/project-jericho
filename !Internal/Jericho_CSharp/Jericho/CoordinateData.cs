using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Jericho
{
    public class CoordinateData
    {
        public CoordinateData() { }
        public CoordinateData(ObjectContainer Parent, Vector3 LocalPosition)
        {
            if(Parent == null)
                GlobalPosition = LocalPosition;
            else
                GlobalPosition = Parent.Position.GlobalPosition + (LocalPosition);
            SetRelativeTo(Parent);
        }

        public ObjectContainer ParentContainer { get; private set; } = null;

        public string System { get; set; }
        public string Name { get; set; }

        // NOTE: GlobalPosition is in (!KILO!)meters
        public Vector3 GlobalPosition { get; set; }
        // NOTE: LocalPosition is in meters
        public Vector3 LocalPosition { get; private set; }

        public Vector3 Rotation { get; set; }
        public Vector3 RotationSpeed { get; set; }

        public CoordinateType CoordType { get; set; }

        public void SetRelativeTo(ObjectContainer Parent)
        {
            ParentContainer = Parent;
            System = Parent?.System;
            // Convert between global km and local m
            if (Parent != null)
                LocalPosition = (this.GlobalPosition - Parent.Position.GlobalPosition);
            else
                LocalPosition = Vector3.Zero;
        }

        public CoordinateData Copy()
        {
            return new CoordinateData()
            {
                System = System,
                Name = Name,
                ParentContainer = ParentContainer,
                GlobalPosition = GlobalPosition,
                LocalPosition = LocalPosition,
                Rotation = Rotation,
                RotationSpeed = RotationSpeed,
                CoordType = CoordType
            };
        }

        public CoordinateData RotateAroundContainerZ(double RotationRadians)
        {
            if (ParentContainer == null)
                return this;

            var NewX = (LocalPosition.X * Math.Cos(RotationRadians) - LocalPosition.Y * Math.Sin(RotationRadians));
            var NewY = (LocalPosition.X * Math.Sin(RotationRadians) + LocalPosition.Y * Math.Cos(RotationRadians));
            var NewZ = LocalPosition.Z;

            return new CoordinateData(ParentContainer, new Vector3(NewX, NewY, NewZ))
            {
                System = System,
                Name = Name,
                Rotation = Vector3.Zero,
                RotationSpeed = RotationSpeed,
                CoordType = CoordType
            };
        }
    }

    public enum CoordinateType
    {
        ObjectContainer,
        OrbitalMarker,
        PlanetaryPOI,
        SpacePOI,
        CustomCoordinates,
        PlayerPosition
    }
}

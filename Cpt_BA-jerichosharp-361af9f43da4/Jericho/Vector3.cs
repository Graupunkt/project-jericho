using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Jericho
{
    public class Vector3
    {
        public double X { get; set; }
        public double Y { get; set; }
        public double Z { get; set; }

        public static readonly Vector3 Zero = new Vector3();
        public static readonly Vector3 One = new Vector3(1, 1, 1);
        public static readonly Vector3 UnitX = new Vector3(1, 0, 0);
        public static readonly Vector3 UnitY = new Vector3(0, 1, 0);
        public static readonly Vector3 UnitZ = new Vector3(0, 0, 1);

        public Vector3() { }
        public Vector3(double X, double Y, double Z)
        {
            this.X = X;
            this.Y = Y;
            this.Z = Z;
        }

        public double Length
        {
            get => DistanceTo(Vector3.Zero);
        }

        public double DistanceTo(Vector3 Other)
        {
            return Math.Sqrt(
                Math.Pow(this.X - Other.X, 2) +
                Math.Pow(this.Y - Other.Y, 2) +
                Math.Pow(this.Z - Other.Z, 2));
        }

        public Vector3 Abs()
        {
            return new Vector3(
                Math.Abs(X),
                Math.Abs(Y),
                Math.Abs(Z));
        }

        public static Vector3 Min(Vector3 A, Vector3 B)
        {
            return new Vector3(
                Math.Min(A.X, B.X),
                Math.Min(A.Y, B.Y),
                Math.Min(A.Z, B.Z));
        }

        public static Vector3 Max(Vector3 A, Vector3 B)
        {
            return new Vector3(
                Math.Max(A.X, B.X),
                Math.Max(A.Y, B.Y),
                Math.Max(A.Z, B.Z));
        }

        public static Vector3 Add(Vector3 A, Vector3 B)
        {
            return new Vector3(A.X + B.X, A.Y + B.Y, A.Z + B.Z);
        }

        public static Vector3 Subtract(Vector3 A, Vector3 B)
        {
            return new Vector3(A.X - B.X, A.Y - B.Y, A.Z - B.Z);
        }

        public static Vector3 Multiply(Vector3 A, Vector3 B)
        {
            return new Vector3(A.X * B.X, A.Y * B.Y, A.Z * B.Z);
        }

        public static Vector3 operator +(Vector3 a, Vector3 b) => Add(a, b);
        public static Vector3 operator -(Vector3 a, Vector3 b) => Subtract(a, b);
        public static Vector3 operator *(Vector3 a, Vector3 b) => Multiply(a, b);
        public static Vector3 operator *(Vector3 a, double value) => new Vector3(a.X * value, a.Y * value, a.Z * value);
        public static Vector3 operator /(Vector3 a, double value) => new Vector3(a.X / value, a.Y / value, a.Z / value);
    }

    public class Vector4
    {
        public double X { get; set; }
        public double Y { get; set; }
        public double Z { get; set; }
        public double W { get; set; }

        public Vector4() { }
        public Vector4(double X, double Y, double Z, double W)
        {
            this.X = X;
            this.Y = Y;
            this.Z = Z;
            this.W = W;
        }
    }
}

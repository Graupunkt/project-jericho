using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Jericho
{
    internal class Generic
    {
        public static TimeSpan GetElapsedUTCServerTime(DateTime playerDate)
        {
            var utcDate = playerDate.ToUniversalTime();
            var simulationStartUTC = new DateTime(2020, 1, 1, 0, 0, 0);
            return utcDate - simulationStartUTC;
        }

        public static List<Dictionary<string, string>> LoadCSVFile(string fileName, string separator = ";")
        {
            string[] lines = File.ReadAllLines(fileName);
            var csvRows = new List<Dictionary<string, string>>();
            var headers = lines.First().Split(separator);
            foreach (string line in lines.Skip(1))
            {
                var lineParts = line.Split(separator);
                var item = new Dictionary<string, string>();
                for (int i = 0; i < lineParts.Length; i++)
                    item.Add(headers[i], lineParts[i]);
                csvRows.Add(item);
            }
            return csvRows;
        }

        public static (double Lat, double Lon, double Height)
            CoordinatesToLatLon(CoordinateData position)
        {
            var RadialDistance = position.LocalPosition.DistanceTo(Vector3.Zero);
            var WgsHeight = Math.Round(RadialDistance - position.ParentContainer.BodyRadiusM, 0);
            var WgsLatitude = Math.Round(Math.Asin(position.LocalPosition.Z / RadialDistance) * 180 / Math.PI, 6);
            var WgsLongitude = Math.Round(Math.Atan2(position.LocalPosition.X, position.LocalPosition.Y) * 180 / Math.PI, 6) * -1;

            return (Lat: WgsLatitude, Lon: WgsLongitude, Height: WgsHeight);
        }

        public static double CalculateBearing(CoordinateData position, CoordinateData targetPosition)
        {
            var (WgsLatitude, WgsLongitude, WgsHeight) = CoordinatesToLatLon(position);
            var (WgsLatitude_Destination, WgsLongitude_Destination, WgsHeight_Destination) = CoordinatesToLatLon(targetPosition);

            WgsLatitude_Destination = WgsLatitude_Destination * Math.PI / 180;
            WgsLongitude_Destination = WgsLongitude_Destination * Math.PI / 180;
            WgsLatitude = WgsLatitude * Math.PI / 180;
            WgsLongitude = WgsLongitude * Math.PI / 180;

            var bearingX = Math.Cos(WgsLatitude_Destination) * Math.Sin(WgsLongitude_Destination - WgsLongitude);
            var bearingY = Math.Cos(WgsLatitude) * Math.Sin(WgsLatitude_Destination) - Math.Sin(WgsLatitude) * Math.Cos(WgsLatitude_Destination) * Math.Cos(WgsLongitude_Destination - WgsLongitude);
            var bearing = Math.Round(Math.Atan2(bearingX, bearingY) * 180 / Math.PI, 0);
            return (bearing + 360) % 360;
        }

        public static double CalcEbenenwinkel(Vector3 Previous, Vector3 Current, Vector3 Destination)
        {
            // # Ship Previous, Ship Current, Destination
            // # A              B             D

            //#Ebene 1
            //#Vector AB
            var abx = Current.X - Previous.X;
            var aby = Current.Y - Previous.Y;
            var abz = Current.Z - Previous.Z;

            // #Vector AC (C = Nullpunkt Planet)
            var acx = 0 - Previous.X;
            var acy = 0 - Previous.Y;
            var acz = 0 - Previous.Z;

            // #Ebene 2
            // #Vector AD
            var adx = Destination.X - Previous.X;
            var ady = Destination.Y - Previous.Y;
            var adz = Destination.Z - Previous.Z;

            // #Vector AC siehe oben

            // #normalenvector einer ebene:
            // #n1_x = ab_y * ac_z - ab_z * ac_y
            // #n1_y = ab_z * ac_x - ab_x * ac_z
            // #n1_z = ab_x * ac_y - ab_y * ac_x

            var n1x = aby * acz - abz * acy;
            var n1y = abz * acx - abx * acz;
            var n1z = abx * acy - aby * acx;
            // # für 2. ebene: ab = ad und ac ist gleich
            var n2x = ady * acz - adz * acy;
            var n2y = adz * acx - adx * acz;
            var n2z = adx * acy - ady * acx;

            // #Vectorprodukt
            var vectorproduct = n1x * n2x + n1y * n2y + n1z * n2z;

            // #Laenge Normale n1 = wurzel aus ( x^2 + y^2 + z^2)
            var length_n1 = Math.Sqrt(n1x * n1x + n1y * n1y + n1z * n1z);

            // #Laenge Normale n2
            var length_n2 = Math.Sqrt(n2x * n2x + n2y * n2y + n2z * n2z);

            var winkel = Math.Acos((vectorproduct / (length_n1 * length_n2)));
            var winkel_degree = (winkel * 180) / Math.PI;
            return winkel_degree;
        }
    }
}

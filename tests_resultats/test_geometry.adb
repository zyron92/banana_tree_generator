with Parseur_Temp, Geometry_Helpers, Ada.Text_Io, Ada.Integer_Text_Io;
use Parseur_Temp, Geometry_Helpers, Ada.Text_Io, Ada.Integer_Text_Io;

procedure Test_Geometry is
    P1,P2,P3,P4,P5 : Coord_Point;
begin
   P1 := (0.0,0.0);
   P4 := (-1.0,-1.0);
   P2 := (0.0,2.0);
   P3:= (1.0,-1.0);
   P5 := (1.0,-1.0);
   
   Put_Line("1-2,1-3 : "&Float'Image(Angle_Intersection_Arrete(Vecteur(P1,P2),Vecteur(P1,P3),P1,P2,P3,true)));
   --Put_Line("1-2,1-4 : "&Float'Image(Angle_Intersection_Arrete(Vecteur(P1,P2),Vecteur(P1,P4),P1,P2,P4)));
   --Put_Line("1-2,1-5 : "&Float'Image(Angle_Intersection_Arrete(Vecteur(P1,P2),Vecteur(P1,P5),P1,P2,P5)));
   
   --Res:=Projection(P4,P5,P5);
   --Put_Line("Voila : "&Float'Image(Res.X)&" "&Float'Image(Res.Y));
   
end Test_Geometry;

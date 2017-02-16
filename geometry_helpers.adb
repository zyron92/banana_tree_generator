with Ada.Numerics.Generic_Elementary_Functions;

package body Geometry_Helpers is

   package Math is new Ada.Numerics.Generic_Elementary_Functions(Float);
   
   --Retourne la racine carrée de (A carré plus B carré)
   function Racine_Pythagore(A,B: Float) return Float is
   begin
      return Math.Sqrt(A * A + B * B);
   end Racine_Pythagore;
   
   function Milieu (P1,P2: in Coord_Point) return Coord_Point is
   begin
      return ( (0.5*(P1.X+P2.X)) , (0.5*(P1.Y+P2.Y)) );
   end Milieu;
   
   function Longueur_Arrete(Coord_S_D, Coord_S_A: in Coord_Point) return Float is
   begin
      return Racine_Pythagore((Coord_S_A.X-Coord_S_D.X),(Coord_S_A.Y-Coord_S_D.Y));
   end Longueur_Arrete;

   function A_Droite (P1,P2: Coord_Point) return Boolean is
   begin
      return (P1.X > P2.X);
   end A_Droite;

   function En_Haut (P1,P2: Coord_Point) return Boolean is
   begin
      return (P1.Y > P2.Y);
   end En_Haut;

   function Angle_Incident_Arrete(Coord_S_D, Mid: in Coord_Point; Longueur: in Float) return Float is
   begin
      if (Coord_S_D.X=Mid.X) then
         return Ada.Numerics.Pi/2.0;
      else
         return (abs Math.Arctan((Coord_S_D.Y-Mid.Y)/(Coord_S_D.X-Mid.X)));
      end if;
   end Angle_Incident_Arrete;

   function Oppose(Angle1, Angle2, Hypotenus : in Float) return Float is
   begin
      return Math.Sin(Angle1-Angle2)*(Hypotenus);
   end Oppose;

   function Adjacent(Angle1, Angle2, Hypotenus : in Float) return Float is
   begin
      return Math.Cos(Angle1-Angle2)*(Hypotenus);
   end Adjacent;
   
   function En_Radian(Deg: in Float) return Float is
   begin
      return (Deg/180.0*Ada.Numerics.Pi);
   end En_Radian;
   
   --Conversion d'un angle de radians vers degrés
   function En_Degre(Rad: in Float) return Float is
   begin
      return (Rad*180.0/Ada.Numerics.Pi);
   end En_Degre;

   function Vecteur(P1,P2: in Coord_Point) return Coord_Point is
   begin
      return (P2.X-P1.X , P2.Y-P1.Y);
   end Vecteur;
   
   --Retourne le point projeté par le point A sur la ligne droite P1->P2
   --En utilisant l'équation de droite
   function Projection(P1,P2, A: in Coord_Point) return Coord_Point is
      M,C : Float;
   begin
      --On assure que P1.X n'est pas égal à P2.X
      M:= (P1.Y - P2.Y) / (P1.X - P2.X);
      C:= P1.Y - (M * P1.X);
      return (A.X , M*A.X+C);
   end Projection;
   
   function Angle_Intersection_Arrete(V1,V2, P1,P2,P3: in Coord_Point; Sens_Trigo: in Boolean) return Float is
      Val_Formule, Res: Float;
   begin
      --La loi de cos
      Val_Formule := (V1.X * V2.X + V1.Y * V2.Y) / ( Racine_Pythagore(V1.X, V1.Y) * Racine_Pythagore(V2.X, V2.Y) );
      
      --Si la valeur à utiliser n'est pas définie en compte dans la fonction arccos
      if Val_Formule > 1.0 then
	 Val_Formule := 1.0;
      elsif Val_Formule < -1.0 then
	 Val_Formule := -1.0;
      end if;
      
      --si segment(P2->P3) se trouve perpendiculaire à l'axe de X (abscisse) 
      if (P2.X = P3.X) then
	 if A_Droite(P2,P1) then
	    if En_Haut(P2,P3) then
	       Res := En_Degre( Math.Arccos(Val_Formule) );
	    else
	       Res := 360.0 - En_Degre( Math.Arccos(Val_Formule) );
	    end if;
	 else
	    if En_Haut(P2,P3) then
	       Res := 360.0 - En_Degre( Math.Arccos(Val_Formule) );
	    else
	       Res := En_Degre( Math.Arccos(Val_Formule) );
	    end if;
	 end if;
	 --Si (P2 est à droite des P1 et P3) ou (P1,P2,P3 sont dans l'ordre) ou bien (si P1 et P2 se trouve dans la même axe de X et que P1 se trouve à droite des autres)
      elsif ((A_Droite(P1,P2) and A_Droite(P3,P2)) or (A_Droite(P2,P1) and A_Droite(P3,P2)) or (P1.X=P2.X and A_Droite(P3,P1))) then
	 if En_Haut(Projection(P2,P3,P1),P1) then
	    Res := En_Degre( Math.Arccos(Val_Formule) );
	 else
	    Res := 360.0 - En_Degre( Math.Arccos(Val_Formule) );
	 end if;
      else
	 if En_Haut(Projection(P2,P3,P1),P1) then
	    Res := 360.0 - En_Degre( Math.Arccos(Val_Formule) );
	 else
	    Res := En_Degre( Math.Arccos(Val_Formule) );
	 end if;
      end if;
      
      --Pour tester differents sens
      if Sens_Trigo then
	 return Res;
      else
	 return 360.0 - Res;
      end if;
      
   end Angle_Intersection_Arrete;
   
   function Meme_Point(P1,P2: in Coord_Point) return Boolean is
   begin
      if (P1.X = P2.X) and then (P1.Y=P2.Y) then
	 return True;
      end if;
      return False;
   end Meme_Point;
   
end Geometry_Helpers;

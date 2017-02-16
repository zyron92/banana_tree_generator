with Parseur;
use Parseur;

package Geometry_Helpers is
   
   
   function Milieu (P1, P2: in Coord_Point) return Coord_Point;
   --Retourne le milieu de deux points
   
   function Longueur_Arrete(Coord_S_D, Coord_S_A: in Coord_Point) return Float;
   --Retourne la longueur de l'arète (en générale, segment)
   
   function A_Droite (P1,P2: Coord_Point) return Boolean;
   --Retourne Vrai si Point1 se situe à droite du Point2
   
   function En_Haut (P1,P2: Coord_Point) return Boolean;
   --Retourne Vrai si Point1 se situe au dessus du Point2 (sur le plan svg le visuel est inversé)
   
   function Angle_Incident_Arrete(Coord_S_D, Mid: in Coord_Point; Longueur: in Float) return Float;
   --Retourne L'angle incident de l'arète à l'axe X sur le plan svg
   
   function Oppose(Angle1, Angle2, Hypotenus : in Float) return Float;
   --Retourne l'opposé du triangle-rectangle en donnant l'angle entre l'hypotenuse et l'adjacent, et l'hypotenuse
   
   function Adjacent(Angle1, Angle2, Hypotenus : in Float) return Float;
   
   --Retourne l'adjacent du triangle-rectangle en donnant l'angle entre l'hypotenuse et l'adjacent, et l'hypotenuse
   
   function En_Radian(Deg: in Float) return Float;
   --Conversion d'un angle de degré vers radian
   
   function Vecteur(P1,P2: in Coord_Point) return Coord_Point;      
   --Retourne le vecteur(P1,P2) (autrement dit, de Point1 vers Point2) sous coordonnées x,y 
   
   function Angle_Intersection_Arrete(V1,V2, P1,P2,P3: in Coord_Point; Sens_Trigo: in Boolean) return Float;
   --Retourne l'angle d'intersection (en degré) entre Vecteur1(Arète1,P1->P2) et Vecteur2(Arète2,P1->P3) 
   
   function Meme_Point(P1,P2: in Coord_Point) return Boolean;
   --Retourne True si P1 et P2 se trouve aux mêmes coordonnées
   
end Geometry_Helpers;

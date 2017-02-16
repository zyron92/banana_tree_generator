with Parseur, Ada.Text_Io, Ada.Integer_Text_Io;
use Parseur, Ada.Text_Io, Ada.Integer_Text_Io;

package Svg_Helpers is
   
   type RGB is record
      R,G,B : Natural;
   end record;
   
   procedure Header(Width, Height: in Float; Fichier: in File_type);

   procedure Footer(Fichier: in File_Type);

   --Translation de l'image pour qu'elle reste toujours visible car nous pouvons avoir des points avec des coordonnées négatives
   procedure Translation_Image(Coord_X, Coord_Y: in Float; Fichier: in File_type);

   --Application d'une couleur et d'une épaisseur pour l'ensemble des lignes droites ou des courbes 
   procedure Appliquer_Couleur_Epaisseur(Est_Arrete: in Boolean; Couleur: in RGB; Epaisseur: in String; Fichier: in File_type);

   procedure Fin_Couleur_Translation(Fichier: in File_type);
   
   --Tracé du segment entre P1 et P2
   procedure Tracer_Ligne_Droite(P1,P2: in Coord_Point; Fichier: in File_type);

   --Tracé de la courbe de bézier
   procedure Tracer_Courbe(Point_Dep,Ctl_Dep,Ctl_Arv,Point_Arv: in Coord_Point; Fichier: in File_type);
   
   --Calcul de la taille (largeur x hauteur) de fichier rendu SVG et de la translation de la figure grâce aux informations sur les coordonnées des sommets 
   procedure Taille_SVG_Translation(W,H,Translat_X,Translat_Y: out Float);

end Svg_Helpers;

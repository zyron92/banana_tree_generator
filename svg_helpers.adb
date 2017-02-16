with Ada.Float_Text_IO;
use Ada.Float_Text_IO;

package body Svg_Helpers is

   procedure Header(Width, Height: in Float; Fichier: in File_type) is
   begin
      --Nous optons pour une dimension de valeur naturelle pour le fichier svg
      Put(Fichier,"<svg width=""");
      Put(Fichier, Integer(Width), Width=>1);
      Put(Fichier,""" height=""");
      Put(Fichier, Integer(Height), Width=>1);
      Put_Line(Fichier,""" version=""1.1"" xmlns=""http://www.w3.org/2000/svg"">");
   end Header;
   
   procedure Footer (Fichier: in File_Type) is
   begin
      Put_Line(Fichier,"</svg>");
   end Footer;
   
   procedure Translation_Image(Coord_X, Coord_Y: in Float; Fichier: in File_type) is
   begin
      Put(Fichier,"<g id=""all"" transform=""translate(");
      Put(Fichier, Coord_X, EXP=>0, FORE=>1);
      Put(Fichier,",");      
      Put(Fichier, Coord_Y, EXP=>0, FORE=>1);
      Put_Line(Fichier,")"">");
   end Translation_Image;
   
   procedure Appliquer_Couleur_Epaisseur(Est_Arrete: in Boolean; Couleur: in RGB; Epaisseur: in String; Fichier: in File_type) is
   begin
      if Est_Arrete then
	 Put(Fichier,"<g id=""arretes"" style=""stroke: rgb(");
	 Put(Fichier, Couleur.R, Width=>1);
	 Put(Fichier,",");
	 Put(Fichier, Couleur.G, Width=>1);
	 Put(Fichier,",");
	 Put(Fichier, Couleur.B, Width=>1);
	 Put_Line(Fichier,") ; stroke-width: "&Epaisseur&""">");
      else --sinon noueds
	 Put_Line(Fichier,"<g id=""noeud"" style=""stroke: rgb("&Natural'Image(Couleur.R)&","&Natural'Image(Couleur.G)&","&Natural'Image(Couleur.B)&") ; fill: none ; stroke-width: "&Epaisseur&""">");
      end if;
   end Appliquer_Couleur_Epaisseur;
   
   procedure Fin_Couleur_Translation(Fichier: in File_type) is
   begin 
      Put_Line(Fichier,"</g>");
   end Fin_Couleur_Translation;
   
   procedure Tracer_Ligne_Droite(P1,P2: in Coord_Point; Fichier: in File_type) is
   begin
      Put(Fichier,"<line x1=""");
      Put(Fichier, P1.X, EXP=>0, FORE=>1);
      Put(Fichier,""" y1=""");
      Put(Fichier, P1.Y, EXP=>0, FORE=>1);
      Put(Fichier,""" x2=""");
      Put(Fichier, P2.X, EXP=>0, FORE=>1);
      Put(Fichier,""" y2=""");
      Put(Fichier, P2.Y, EXP=>0, FORE=>1);
      Put_Line(Fichier,"""/>");
   end Tracer_Ligne_Droite ;
   
   procedure Tracer_Courbe(Point_Dep,Ctl_Dep,Ctl_Arv,Point_Arv: in Coord_Point; Fichier: in File_type) is
   begin
      Put(Fichier,"<path d=""M ");
      Put(Fichier, Point_Dep.X, EXP=>0, FORE=>1);
      Put(Fichier," ");
      Put(Fichier, Point_Dep.Y, EXP=>0, FORE=>1);
      Put(Fichier," C ");
      Put(Fichier, Ctl_Dep.X, EXP=>0, FORE=>1);
      Put(Fichier," ");
      Put(Fichier, Ctl_Dep.Y, EXP=>0, FORE=>1);
      Put(Fichier," ");
      Put(Fichier, Ctl_Arv.X, EXP=>0, FORE=>1);
      Put(Fichier," ");
      Put(Fichier, Ctl_Arv.Y, EXP=>0, FORE=>1);
      Put(Fichier," ");
      Put(Fichier, Point_Arv.X, EXP=>0, FORE=>1);
      Put(Fichier," ");
      Put(Fichier, Point_Arv.Y, EXP=>0, FORE=>1);
      Put_Line(Fichier,"""/>");
   end Tracer_Courbe;
   

   procedure Taille_SVG_Translation(W,H,Translat_X,Translat_Y: out Float) is
   begin
      --En utilisant les variables globales
      W := abs(Max_X-Min_X)+2.5;
      H := abs(Max_Y-Min_Y)+2.5;
      Translat_X := -1.0*Min_X+1.5;
      Translat_Y := -1.0*Min_Y+1.5;
   end Taille_SVG_Translation;
   
end Svg_Helpers;

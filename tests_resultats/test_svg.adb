with Parseur_Temp,Svg_Helpers,Ada.Text_IO, Ada.Integer_Text_IO;
use Parseur_Temp,Svg_Helpers,Ada.Text_IO, Ada.Integer_Text_IO;

procedure Test_Svg is
   Fichier : File_Type;
   P1: Coord_Point := (X=>-2.5, Y=>-4.33012701892219);
   P2: Coord_Point := (X=>-0.492608180923429, Y=>-6.55956149535438);
begin
   Create(Fichier,Out_File,"test_svg_OK.svg");
   Header(14.5190978224269,14.5190978224269,Fichier);
   Translation_Image(6.43444280220142,7.92820323027551,Fichier);
   
   Appliquer_Couleur_Epaisseur(True,0,0,0,"0.1",Fichier);
   Tracer_Ligne_Droite(P1,P2,Fichier);
   Fin_Couleur_Translation(Fichier);
   
   Appliquer_Couleur_Epaisseur(False,255,0,0,"0.1",Fichier);
   Tracer_Courbe(-1.49630409046171,-5.44484425713829,-1.41780015609729,-3.94689995500642,-1.66723373785405,-5.12039269405429,-1.1296818135361,-3.72002205430849, Fichier);
   Fin_Couleur_Translation(Fichier);
   
   Fin_Couleur_Translation(Fichier);
   Footer(Fichier);
   Close (Fichier);
end Test_Svg;

with Svg_Helpers, Parseur, Ada.Text_Io, Ada.Integer_Text_Io;
use Svg_Helpers, Parseur, Ada.Text_Io, Ada.Integer_Text_Io;

package Traceur_Final is

   --Génération du fichier svg du tracé final avec ou sans le tracé intermédiaire
   procedure Generer_Trace_Final (Nom_Fichier: in string; Couleur_Trait: in RGB; Epaisseur: in string; G: in Graphe; Avec_Intermediaire,Mode_Min: in Boolean);

end Traceur_Final;

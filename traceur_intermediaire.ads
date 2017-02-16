with Svg_Helpers, Parseur, Ada.Text_Io, Ada.Integer_Text_Io;
use Svg_Helpers, Parseur, Ada.Text_Io, Ada.Integer_Text_Io;

package Traceur_Intermediaire is
   
   --Tracé des arètes et des points de contrôle (ou mise à jours des points de contrôle sans tracer)
   procedure Tracer_Arretes_Controls(G: in Graphe; Fichier: in File_Type; Tracer: in Boolean);

   --Génération du fichier svg du tracé intermédiaire (avec ou sans le tracé)
   procedure Generer_Trace_Intermediaire (Nom_Fichier: in string; Couleur_Trait: in RGB; Epaisseur: in string; G: in Graphe);
   
   --Les entêtes du fichier SVG
   procedure Le_Debut(Fichier: in File_Type);
   
   --Les queues & Fermetures du fichier SVG
   procedure La_Fin(Fichier: in File_Type);
   
end Traceur_Intermediaire;

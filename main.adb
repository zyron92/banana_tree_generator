with Ada.Command_Line, Ada.Text_IO, Ada.Integer_Text_IO, Parseur, Traceur_Intermediaire, Traceur_Final;
use Ada.Command_Line, Ada.Text_IO, Ada.Integer_Text_IO, Parseur, Traceur_Intermediaire, Traceur_Final;

procedure Main is
   Nombre_Sommets: Natural;
   
   --Conversion des caractères 0,1 en format boolean
   function Valeur_Boolean(C: in Character) return Boolean is
   begin
      case C is
	 when '0' => return False;
	 when '1' => return True;
	 when others => raise Erreur_Option;
      end case;
   end Valeur_Boolean;
   
begin
   if Argument_Count /= 4 then
      Put_Line(Standard_Error, "Utilisation : ./main Fichier_Graphe.kn Trace.svg Option[1:que trace intermediare, 2:trace_final_avec_Intermediaire, 3:trace_final_sans_Intermediare] Angle[Minimale:1/Maximale:0]");
      return;
   end if;

   --Arg1 => fichier d'entrée
   --Arg2 => fichier de sortie
   --Arg3 => option

   --Lecture du fichier d'entrée pour identifier le nombre des sommets
   Lecture_En_Tete(Argument(1), Nombre_Sommets);

   declare
      G : Graphe(1..Nombre_Sommets);
   begin
      --Lecture du fichier d'entrée pour construire le graphe et remplir le tableau contenant les informations sur les sommets
      Lecture(Argument(1), G);

      --Selon les options, nous générons le tracé
      case Argument(3)(1) is
         when '1' => Generer_Trace_Intermediaire (Argument(2), (R=>0,G=>0,B=>0), "0.1", G);
         when '2' => Generer_Trace_Final (Argument(2), (R=>255,G=>0,B=>0), "0.1", G, True, Valeur_Boolean(Argument(4)(1)));
         when '3' => Generer_Trace_Final (Argument(2), (R=>255,G=>0,B=>0), "0.1", G, False, Valeur_Boolean(Argument(4)(1)));
         when others => raise Erreur_Option;
      end case;
   end;

exception
   when Erreur_Lecture_Config
     => Put_Line(Standard_Error, "Arrêt du programme");
   when Erreur_Option
     => Put_Line(Standard_Error, "Les arguments entrés ne sont pas valides");
end Main;

with Ada.Text_IO;
use Ada.Text_IO;

package Parseur is
   Erreur_Lecture_Config,Erreur_Option,Fichier_Trop_Long : exception;   
   Max_X, Max_Y:Float:=Float'first;
   Min_X, Min_Y : Float:=Float'Last;
   
   type Arrete_Adj;
   type Ptr_Liste_Arretes_Adj is access Arrete_Adj;
   
   type Coord_Point is record
      X,Y: Float;
   end record;

   --Définition d'un sommet avec ses arètes adjacentes
   type Sommet is record
      Id_Sommet : Natural;
      Coord_Sommet : Coord_Point;
      Liste_Arr_Adj : Ptr_Liste_Arretes_Adj;
   end record;

   --Défintion d'une arète
   type Arrete is record
      Id_SomDepart,Id_SomArrive: Natural;
      PMilieu : Coord_Point;
      PCtl_T,PCtl_I : Coord_Point; --Points de contrôle du sommet
      EstTrace_PCtl_T, EstTrace_PCtl_I : Boolean; 
   end record;

   --Liste chainée des arètes adjacentes
   type Arrete_Adj is record
      Arr : Arrete;
      Arr_Adj_Suiv : Ptr_Liste_Arretes_Adj;
   end record;

   --Tableau des listes chainées des arètes adjacentes par rapport au sommet i (i étant l'indice de la case)
   --Ce tableau répresente le graphe
   type Graphe is array (Positive range <>) of sommet;
   
   
   
   procedure Tester_Max_Min (P: in Coord_Point);
   
   procedure Lecture_En_Tete(Nom_Fichier_Entree: in String; Nombre_Sommets: out Natural);
   
   procedure Lecture(Nom_Fichier_Entree: in String; G: out Graphe);

   
end;

with Ada.Text_Io, Ada.Unchecked_Deallocation;
use Ada.Text_Io;
package body Parseur is
   
   procedure Tester_Max_Min (P : in Coord_Point) is
      --Cette fonction met à jour les coordonnées des points aux extremités du
      --dessin (variables globales Max_X, Max_Y, Min_X, Min_Y)
   begin
      
      if P.X>Max_X then
	 Max_X:=P.X;
      elsif P.X<Min_X then
	 Min_X:=P.X;
      end if;
      
      if P.Y>Max_Y then
	 Max_Y:=P.Y;
      elsif P.Y<Min_Y then
	 Min_Y:=P.Y;
      end if;
      
   end;
   
   
   procedure Lecture_En_Tete (Nom_Fichier_Entree: in String; Nombre_Sommets: out natural) is
      F: File_Type;
   begin
      Open(File => F, Mode => In_File, Name => Nom_Fichier_Entree); 
      declare
         Ligne: String := Get_Line(F);
      begin
	 Close(F);
	 Nombre_sommets:=Positive'Value(Ligne);
      end;     
      
   exception
      when NAME_ERROR=>
	 Put_Line("Le fichier n'existe pas");
	 raise Erreur_Lecture_Config;
	 
      when END_ERROR=>
	 Put_Line ("Le fichier est vide");
	 raise Erreur_Lecture_Config;	 
	 
      when  CONSTRAINT_ERROR=>
	 --Cette erreur se produit si Ligne n'a pas la forme d'un natural
	 Put_Line("La première ligne du fichier est mal formée");
	 raise Erreur_Lecture_Config;
	 
	 
   end Lecture_En_Tete;
   
   procedure Extraire_Coord (Ligne : in String; C : out Coord_Point) is
      I:Natural:=Ligne'First;
      
   begin
      --On repère la position de l'espace qui sépare les 2 coordonnées
      while Ligne(I)/=' ' loop
	 I:=I+1;
      end loop;
      
      C.X:=Float'Value(Ligne(Ligne'First..I-1));
      C.Y:=Float'Value(Ligne(I+1..Ligne'Last));
      
   exception 
      when CONSTRAINT_ERROR=>
	 Put ("La ligne n'est pas formée de 2 coordonnées valides");
	 raise Erreur_Lecture_Config;
   end;
   
   procedure Extraire_Sommets  (Ligne : in String; Nb : in Natural ; Ptr : out Ptr_Liste_Arretes_Adj ; Sommet_Dep : in natural) is
      --Cette procédure extrait les sommets adjacents au sommet en cours de traitement (Sommet_Dep) et les range dans la liste Ptr;
      procedure Liberer is new Ada.Unchecked_Deallocation(Arrete_Adj,Ptr_Liste_Arretes_Adj) ;
      
      Fin,Debut:Natural:=Ligne'First;
      Tete,Cour:Ptr_Liste_Arretes_Adj;
   begin
      
      Cour:=new Arrete_Adj;      
      Tete:=Cour;      
      
      --Pour chaque sommet adjacent
      for I in 1..Nb loop
	 
	 --On repère la sous-chaine qui correspond à ce sommet
	 while Ligne(Fin)/=' ' and Fin/=Ligne'Last loop
	    Fin:=Fin+1;
	 end loop;
	 
	 --On crée une nouvelle liste
	 Cour.Arr_Adj_Suiv:=new Arrete_Adj;
	 Cour:=Cour.Arr_Adj_Suiv;
	 
	 --On range dans le champ Arr de la liste le sommet adjacent, ainsi que le sommet de départ Sommet_dep
	 Cour.Arr.Id_SomArrive:=Positive'Value(Ligne(debut..fin));
	 Cour.Arr.Id_SomDepart:=Sommet_Dep;
	 Cour.Arr_Adj_Suiv:=null; --Pour s'assurer la liste à la fin sera bien terminée par null
	 
	 Fin:=Fin+1;
	 Debut:=Fin;
	 
      end loop;
      Ptr:=Tete.Arr_Adj_Suiv;
      Liberer(Tete);
      
      
   exception 
      when CONSTRAINT_ERROR=>
	 Put ("La ligne n'est pas formée de " & natural'image(Nb) & " numéros valides");
	 raise Erreur_Lecture_Config;
	 
	 --Si la ligne n'est pas limitée à Nb entiers, les caractères supplémentaires sont ignorés	 
   end;
   

   procedure Lecture (Nom_Fichier_Entree: in String; G: out Graphe) is
      F: File_Type;
      NumLig:Positive:=1;
      Nb_Aretes:Natural;

   begin
      Open(File => F, Mode => In_File, Name => Nom_Fichier_Entree);
      Set_Line (File => F, To => 2);
      
      for I in G'range loop
	 declare
	    --On récupère les lignes 3 par 3
	    Ligne1: String := Get_Line(F); 
	    Ligne2: String := Get_Line(F);
	    Ligne3: String := Get_Line(F);		    
	    
	 begin
	    G(I).Id_Sommet:=I;
	    NumLig:=NumLig+1;	
	    
	    Extraire_Coord(Ligne1,G(I).Coord_Sommet);
	    
	    --Mise a jour des coordonnées des  points extrêmes
	    Tester_Max_Min(G(I).Coord_Sommet);      
	    
	    NumLig:=NumLig+1;
	    Nb_Aretes:=Natural'Value(Ligne2);	    
	    
	    NumLig:=NumLig+1;
	    Extraire_Sommets(Ligne3,Nb_Aretes,G(I).Liste_Arr_Adj,I);
	 end;
      end loop;
      
      if not End_Of_File(F) then
	 raise Fichier_Trop_Long;
      end if;
      
      Close(F);
      
   exception 
      when Fichier_Trop_Long =>
	 --on laisse l'exécution se poursuivre malgré tout
	 Put_Line("Attention : Le fichier contient des lignes superflues");
	 
      when CONSTRAINT_ERROR=>
	 --exception qui peut se manifester au moment du passage de Ligne2 en natural
	 Put_Line("La ligne ne correspond pas à un entier naturel - ligne" & Positive'Image(NumLig));
	 raise Erreur_Lecture_config;
	 
      when END_ERROR=>
	 Put_Line ("Le fichier est trop court");
	 raise Erreur_Lecture_config;
	 
      when Erreur_Lecture_config=>
	 Put_Line(" - ligne" & Positive'Image(NumLig));
	 raise Erreur_Lecture_config;
   end;

end;

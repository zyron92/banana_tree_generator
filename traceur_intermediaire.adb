with Geometry_Helpers, Ada.Numerics.Generic_Elementary_Functions;
use Geometry_Helpers;
package body Traceur_Intermediaire is

   --Calcul des 2 points de contrôle du côté du sommet de départ
   procedure Calcul_Point_Control(Coord_S_D, Mid: in Coord_Point; Longueur: in Float; Ctl_T, Ctl_I: out Coord_Point) is
      Angle_Inc : Float := Angle_Incident_Arrete(Coord_S_D,Mid,Longueur);
      Angle_Croix : Float := En_Radian(45.0);
   begin
      --Ctl_T.X => Point Controle Trigo du coté du sommet de départ
      --Ctl_T.Y => Point Controle Inverse du coté du sommet de départ
      if A_Droite(Coord_S_D, Mid) then
         if En_Haut(Coord_S_D, Mid) then
            -->> Arète en direction nord-ouest (sur le plan svg)
            Ctl_T.X := Mid.X - Oppose(Angle_Inc,Angle_Croix,Longueur);
            Ctl_T.Y := Mid.Y + Adjacent(Angle_Inc,Angle_Croix,Longueur);
            Ctl_I.X := Mid.X + Adjacent(Angle_Inc,Angle_Croix,Longueur);
            Ctl_I.Y := Mid.Y + Oppose(Angle_Inc,Angle_Croix,Longueur);
         else
            -->>Arète en direction sud-ouest (sur le plan svg)
            Ctl_T.X := Mid.X + Adjacent(Angle_Inc,Angle_Croix,Longueur);
            Ctl_T.Y := Mid.Y - Oppose(Angle_Inc,Angle_Croix,Longueur);
            Ctl_I.X := Mid.X - Oppose(Angle_Inc,Angle_Croix,Longueur);
            Ctl_I.Y := Mid.Y - Adjacent(Angle_Inc,Angle_Croix,Longueur);
         end if;
      else
	 -->>Arète en direction nord-est (sur le plan svg)
         if En_Haut(Coord_S_D, Mid) then
            Ctl_T.X := Mid.X - Adjacent(Angle_Inc,Angle_Croix,Longueur);
            Ctl_T.Y := Mid.Y + Oppose(Angle_Inc,Angle_Croix,Longueur);
            Ctl_I.X := Mid.X + Oppose(Angle_Inc,Angle_Croix,Longueur);
            Ctl_I.Y := Mid.Y + Adjacent(Angle_Inc,Angle_Croix,Longueur);
            -->>Arrete en direction sud-est (sur le plan svg)
         else
            Ctl_T.X := Mid.X + Oppose(Angle_Inc,Angle_Croix,Longueur);
            Ctl_T.Y := Mid.Y - Adjacent(Angle_Inc,Angle_Croix,Longueur);
            Ctl_I.X := Mid.X - Adjacent(Angle_Inc,Angle_Croix,Longueur);
            Ctl_I.Y := Mid.Y - Oppose(Angle_Inc,Angle_Croix,Longueur);
         end if;
      end if;
   end Calcul_Point_Control;

   --Mise à jour des champs des points de contrôle et du point de millieu de l'arète
   procedure Mise_A_Jour_Control_Milieu(Ctl_T, Ctl_I, Mid: Coord_Point; Ptr_Arr: in Ptr_Liste_Arretes_Adj) is   
   begin
      Ptr_Arr.all.Arr.PCtl_T := Ctl_T;
      Ptr_Arr.all.Arr.PCtl_I := Ctl_I;
      Ptr_Arr.all.Arr.PMilieu := Mid;
      
      --Trouver les points les plus loin dans le dessin svg pour faciliter la génération de l'entête du fichier svg
      Tester_Max_Min(Ctl_T);
      Tester_Max_Min(Ctl_T);
   end Mise_A_Jour_Control_Milieu;

   procedure Tracer_Arretes_Controls(G: in Graphe; Fichier: in File_Type; Tracer: in Boolean) is
      Cour: Ptr_Liste_Arretes_Adj;
      Coord_S_D, Coord_S_A, Mid, Ctl_T, Ctl_I: Coord_Point;
      Longueur: Float;
   begin
      --D étant l'ID de sommet de départ
      --Nous parcourons tous les sommets
      for S in G'Range loop
	 --Nous parcourons toutes les arètes adjacentes au sommet S
         Cour:=G(S).Liste_Arr_Adj;
         while Cour /= null loop
            --Coord_S_D : Coordonnées du sommet de départ & Coord_S_A : celles d'arrivée
            Coord_S_D := G(S).Coord_Sommet;
            Coord_S_A := G(Cour.all.Arr.Id_SomArrive).Coord_Sommet;

            --Tracé d'une arète (un sommet de départ vers un sommet d'arrivée)
            --si l'ID de sommet d'arrivé est plus grand que celui de départ pour ne pas redessiner l'arète
            if Cour.all.Arr.Id_SomArrive > S and Tracer then
               Tracer_Ligne_Droite(Coord_S_D, Coord_S_A, Fichier);
            end if;

            Mid := Milieu(Coord_S_D, Coord_S_A);
	    Longueur:= Longueur_Arrete(Coord_S_D, Coord_S_A);
	    
	    --Nous avons choisi la moitié de la longueur de l'arête pour la longueur d'un trait du croix
            Calcul_Point_Control(Coord_S_D, Mid, Longueur/2.0, Ctl_T, Ctl_I);
            Mise_A_Jour_Control_Milieu(Ctl_T, Ctl_I, Mid, Cour);

            --Tracé des segments reliant chaque point contrôle du côté du sommet de départ avec le point du milieu de l'arète
            --en utilisant les champs dans l'arète qui viennent d'être mis-a-jour pour s'assurer la mise-à-jour est bonne.
            if Tracer then
               Tracer_Ligne_Droite(Cour.all.Arr.PCtl_T, Cour.all.Arr.PMilieu, Fichier);
               Tracer_Ligne_Droite(Cour.all.Arr.PCtl_I, Cour.all.Arr.PMilieu, Fichier);
            end if;

            --Nous passons à l'arète adjacente au sommet de départ suivante
            Cour := Cour.all.Arr_Adj_Suiv;
         end loop;
      end loop;
   end Tracer_Arretes_Controls;

   procedure Generer_Trace_Intermediaire (Nom_Fichier: in string; Couleur_Trait: in RGB; Epaisseur: in string; G: in Graphe) is
      Fichier : File_Type;
   begin
      --Création et entêtes du fichier SVG
      Create(Fichier,Out_File,Nom_Fichier);
      Le_Debut(Fichier);

      --Le tracé intermédiaire
      Appliquer_Couleur_Epaisseur(True,Couleur_Trait,Epaisseur,Fichier);
      Tracer_Arretes_Controls(G,Fichier,True);
      Fin_Couleur_Translation(Fichier);

      --Les queues & Fermeture du fichier SVG
      La_Fin(Fichier);
      Close(Fichier);
   end;
   
   procedure Le_Debut(Fichier: in File_Type) is
      W,H,Translat_X,Translat_Y : Float;
   begin
      Taille_SVG_Translation(W,H,Translat_X,Translat_Y);
      Header(W,H,Fichier);
      Translation_Image(Translat_X,Translat_Y,Fichier);
   end Le_Debut;

   procedure La_Fin(Fichier: in  File_Type) is
   begin
      Fin_Couleur_Translation(Fichier);
      Footer(Fichier);
   end La_Fin;

end Traceur_Intermediaire;

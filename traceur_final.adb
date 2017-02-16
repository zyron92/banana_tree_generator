with Geometry_Helpers, Traceur_Intermediaire;
use Geometry_Helpers, Traceur_Intermediaire;

package body Traceur_Final is
   
   --Chercher l'arète suivante selon l'angle et le sens
   function Chercher_Arete(Arete_Cour: in Ptr_Liste_Arretes_Adj; G: in Graphe; Sens_Trigo,Mode_Min: in Boolean) return Ptr_Liste_Arretes_Adj is
      Cour,Arete_Suiv : Ptr_Liste_Arretes_Adj;
      P1,P2,P3 : Coord_Point;
      Angle_Suiv,Angle_Min,Angle_Max : Float;
   begin
      --Si on n'a pas d'autres arètes
      Arete_Suiv := Arete_Cour;
      --Valeurs initiales de l'angle à comparer
      Angle_Min := 360.0;
      Angle_Max := 0.0;
      
      Cour := G(Arete_Cour.all.Arr.Id_SomDepart).Liste_Arr_Adj;
      P1 := G(Arete_Cour.all.Arr.Id_SomDepart).Coord_Sommet;
      P2 := G(Arete_Cour.all.Arr.Id_SomArrive).Coord_Sommet;
      
      --Nous parcourons la liste d'adjacents appartenants au sommet de départ pour trouver l'arrète souhaité selon l'angle souhaité
      while Cour/=null loop
	 --Nous traitons les arètes adjacentes qui ne sont pas l'arète_cour (pour ne pas tester les deux arètes identiques) 
	 if Cour.all.Arr.Id_SomArrive /= Arete_Cour.all.Arr.Id_SomArrive then
	    P3 := G(Cour.all.Arr.Id_SomArrive).Coord_Sommet;
	    Angle_Suiv := Angle_Intersection_Arrete(Vecteur(P1,P2),Vecteur(P1,P3), P1,P2,P3, Sens_Trigo);
	    if Mode_Min and then Angle_Suiv < Angle_Min then
	       Angle_Min := Angle_Suiv;
	       Arete_Suiv := Cour;
	    elsif (not Mode_Min) and then Angle_Suiv > Angle_Max then
	       Angle_Max := Angle_Suiv;
	       Arete_Suiv := Cour;
	    end if;
	 end if;
	 Cour := Cour.all.Arr_Adj_Suiv;
      end loop;
      return Arete_Suiv;
   end Chercher_Arete;
   
   --Tracé de la courbe bézier d'un morceau du noeud depuis une arète vers une autre
   procedure Tracer_Arete(Arete_Cour,Arete_Suiv: in Ptr_Liste_Arretes_Adj; Sens_Trigo: in Boolean; Fichier: in File_Type) is
      AC, AS : Arrete;
   begin
      AC := Arete_Cour.all.Arr;
      AS := Arete_Suiv.all.Arr;
      if Sens_Trigo then
	 --Nous traçons si ce n'est pas encore tracé
	 if ((not AC.EstTrace_PCtl_T) and then (not AS.EstTrace_PCtl_I)) then
	    Tracer_Courbe(AC.PMilieu, AC.PCtl_T, AS.PCtl_I, AS.PMilieu, Fichier);
	    --Souvenir que nous avons tracé
	    Arete_Cour.all.Arr.EstTrace_PCtl_T := True;
	    Arete_Suiv.all.Arr.EstTrace_PCtl_I := True;
	 end if;	 
      else
	 --Nous traçons si ce n'est pas encore tracé
	 if ((not AC.EstTrace_PCtl_I) and then (not AS.EstTrace_PCtl_T)) then
	    Tracer_Courbe(AC.PMilieu, AC.PCtl_I, AS.PCtl_T, AS.PMilieu, Fichier);
	    --Souvenir que nous avons tracé
	    Arete_Cour.all.Arr.EstTrace_PCtl_I := True;
	    Arete_Suiv.all.Arr.EstTrace_PCtl_T := True;
	 end if;
      end if;
   end Tracer_Arete;
   
   --L'algo principal de tracé du noeud
   procedure Tracer_Final(G:in Graphe; Fichier: in File_Type; Mode_Min: in Boolean) is
      Arete_Cour, Arete_Suiv : Ptr_Liste_Arretes_Adj;
   begin
      --Nous parcourons tous les sommets (y compris les sommets dans le sous-graphe non-connecté (non-connexe) s'il existe)
      for S in G'Range loop
	 --Nous parcourons toutes les arêtes adjacentes au sommet 'S'.
	 Arete_Cour := G(S).Liste_Arr_Adj;
	 while Arete_Cour /= null loop
	    --Le tracé à partir du point contrôle sens Trigo de côté sommet de départ se trouvant sur l'arête courante
	    Arete_Suiv := Chercher_Arete(Arete_Cour, G, True, Mode_Min);
	    Tracer_Arete(Arete_Cour, Arete_Suiv, True, Fichier);
	    --Le tracé à partir du point contrôle sens Inverse de côté sommet de départ se trouvant sur l'arête courante
	    Arete_Suiv := Chercher_Arete(Arete_Cour, G, False, Mode_Min);
	    Tracer_Arete(Arete_Cour, Arete_Suiv, False, Fichier);
	    --Nous avançons sur l'élement suivant de la liste
	    Arete_Cour := Arete_Cour.all.Arr_Adj_Suiv;
	 end loop;
      end loop;
   end Tracer_Final;

   --Générer le fichier svg du tracé final avec ou sans le tracé intermédiaire
   procedure Generer_Trace_Final (Nom_Fichier: in string; Couleur_Trait: in RGB; Epaisseur: in string; G: in Graphe; Avec_Intermediaire,Mode_Min: in Boolean) is
      Fichier : File_Type;
   begin
      --Création et Les entêtes du fichier SVG
      Create(Fichier,Out_File,Nom_Fichier);
      Le_Debut(Fichier);

      --Le tracé intermédiaire
      if Avec_Intermediaire then
	 Appliquer_Couleur_Epaisseur(True,(R=>0,G=>0,B=>0),Epaisseur,Fichier);
         Tracer_Arretes_Controls(G,Fichier,True);
	 Fin_Couleur_Translation(Fichier);
      else
         Tracer_Arretes_Controls(G,Fichier,False);
      end if;
      
      --Le tracé final
      Appliquer_Couleur_Epaisseur(False,Couleur_Trait,Epaisseur,Fichier);
      Tracer_Final(G,Fichier,Mode_Min);
      Fin_Couleur_Translation(Fichier);

      --Les queues & Fermeture du fichier SVG
      La_Fin(Fichier);
      Close(Fichier);
   end Generer_Trace_Final;

end Traceur_Final;

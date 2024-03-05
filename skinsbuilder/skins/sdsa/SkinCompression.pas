unit SkinCompression;
//----------------------------------------------------------------
interface
//----------------------------------------------------------------
uses classes,sysutils,windows;
//----------------------------------------------------------------
procedure SkinCompresse(Source,Destination:TStream);
procedure SkinDecompresse(Source,Destination:TStream);
//----------------------------------------------------------------
implementation
//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
type
        //les noeud du dico
        PNoeud=^TNoeud;
        TNoeud=record
                        suite:array[byte] of PNoeud; //descendance
                        valeur:byte;                 //valeur ascii
                        parent:PNoeud;               //noeud pere
                        rang:integer;                //place dans l'index
        end;
        //le dico
        PDico=^TDico;
        TDico=record
                        racine:PNoeud;  //racine de l'arbre d'exploration alphabetique
                        index:Tlist;    //index de l'exploration par reference
                        bit:byte;       //nombre de bit necessaire a l'indexation
        end;
        //entier a taille variable
        TEntierVariable=record
                        //nombre de bit utilise
                        nombre:byte;
                        //valeur (sur le bit de poids faible)
                        valeur:integer;
        end;
        TBuffer=record
                taille:word;
                tampon:array[word] of byte;
        end;
//----------------------------------------------------------------
//Cree un dico initialise
function  NouveauDico():PDico;forward;
//Cree un noeud initialise
function  NouveauNoeud():PNoeud;forward;
//Effacement memoire d'un dico (Soyons propre !!)
procedure EffacerDico(var Dico:PDico);forward;
//Ecriture sur flux d'un noeud, retourne l'indice du premier caractere de la chaine
function EcrireNoeud(noeud:PNoeud;var buffer:TBuffer;Destination:TStream):integer;forward;
//Ecriture sur flux d'un TEntierVariable
procedure EcrireBinaire(valeur:TEntierVariable;var etat:TEntierVariable;S:TStream);forward;
//Alignement du fichier de sorti sur un nombre d'entier rond
//(sert donc aussi a vider le tampon d'ecriture binaire)
procedure AlignerBinaire(var etat:TEntierVariable;S:TStream);forward;
//Lecture sur flux d'un TEntierVariable
function  LireBinaire(bit:byte;var etat:TEntierVariable;S:TStream):TEntierVariable;forward;
//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
procedure SkinCompresse(Source,Destination:TStream);
var     Dico:PDico;
        noeud:PNoeud;
        i,nb:integer;
        buffer:array[word] of byte;
        entier,etat:TEntierVariable;
begin
        //buffeur d'ecriture binaire vide
        etat.nombre:=0;
        etat.valeur:=0;
        //creation et initialisation d'un dico
        Dico:=NouveauDico();
        //pointer sur la racine du dico
        noeud:=Dico.racine;
        //je commence en haut du fichier
        Source.Seek(0,soFromBeginning);
        //je lit un bloc
        nb:=Source.Read(buffer,65536);
        //tant que le bloc lu n'est pas vide
        while nb<>0 do
        begin
                //pour chaque element du bloc
                for i:=0 to nb-1 do
                begin
                        //sequence deja rencontrer ?
                        if noeud.suite[buffer[i]]=nil then
                        begin
                                //non
                                //on ajoute au dico
                                noeud.suite[buffer[i]]:=NouveauNoeud();
                                noeud.suite[buffer[i]].parent:=noeud;
                                noeud.suite[buffer[i]].valeur:=buffer[i];
                                noeud.suite[buffer[i]].rang:=Dico.index.Count;
                                Dico.index.Add(noeud.suite[buffer[i]]);
                                //on ecrit sur le fichier destination
                                entier.valeur:=noeud.rang;
                                entier.nombre:=Dico.bit;
                                EcrireBinaire(entier,etat,Destination);  //ancien mot
                                //on reevalue le nombre de bit necessaire pour ecrire un rang
                                if (1 shl Dico.bit)+1=Dico.index.Count then
                                        inc(Dico.bit);
                                //le dico est trop grand ?
                                if Dico.bit=17 then
                                begin
                                        //oui
                                        //signal de changement de dico
                                        entier.valeur:=1;
                                        entier.nombre:=Dico.bit;
                                        EcrireBinaire(entier,etat,Destination);
                                        //liberation memoire
                                        EffacerDico(Dico);
                                        //creation et initialisation d'un nouveau dico
                                        Dico:=NouveauDico();
                                end;

                                //on repart de la racine
                                noeud:=Dico.racine.suite[buffer[i]];
                        end
                        else
                                //oui
                                //on parcourt le dico
                                noeud:=noeud.suite[buffer[i]];

                end;
                //je lit un nouveau bloc
                nb:=Source.Read(buffer,65536);
        end;
        //tout est ecrit ?
        if (noeud<>Dico.racine) then
        begin
                //non
                //on ecrit sur le fichier destination
                entier.valeur:=noeud.rang;
                entier.nombre:=Dico.bit;
                EcrireBinaire(entier,etat,Destination);
        end;
        //signal de fermeture
        entier.valeur:=0;
        entier.nombre:=Dico.bit;
        EcrireBinaire(entier,etat,Destination);


        //j'aligne le fichier sur un nombre entier d'octet
        AlignerBinaire(etat,Destination);

        //liberation memoire
        EffacerDico(Dico);
end;
//----------------------------------------------------------------
procedure SkinDeCompresse(Source,Destination:TStream);
var     Dico:PDico;
        fini:boolean;
        entier,etat:TEntierVariable;
        buffer:TBuffer;
        noeud:PNoeud;
        noeudPrecedant:PNoeud;
        valeurPrecedante:byte;
        index:integer;
begin
        //creation et initialisation d'un dico
        Dico:=NouveauDico();

        //tampon d'ecriture vide
        buffer.taille:=0;

        //tamponde lecture vide
        etat.nombre:=0;
        etat.valeur:=0;

        //pas de noeud precedant
        NoeudPrecedant:=nil;
        //ni de valeur (juste pour pas avoir de warning)
        valeurprecedante:=0;

        //c'est pas encore fini, normal on a pas commencé ;)
        fini:=false;

        //tant qu'on a pas fini
        while not fini do
        begin
                //on lit le mot
                entier:=LireBinaire(Dico.bit,etat,Source);
                //if entier.valeur=607 then
                //        beep(440,200);
                case entier.valeur of
                0:    //code fin
                        fini:=true;
                1:    //code reset dico
                        begin
                                EffacerDico(Dico);
                                Dico:=NouveauDico();
                                //pas de noeud precedant
                                NoeudPrecedant:=nil;
                        end;
                else
                        //le noeud est deja dans le dico ?
                        if entier.valeur<Dico.index.count then
                        begin
                                //oui
                                //je le charge
                                noeud:=PNoeud(Dico.index.Items[entier.valeur]);
                                //je l'ecrit, et note le premier caractere
                                index:=EcrireNoeud(noeud,buffer,Destination);
                                //y'avait t'il un precedant
                                if noeudprecedant<>nil then
                                begin
                                        //oui
                                        //maintenant on sait comment il finissait

                                        //on cree le fils du noeud precedant
                                        noeudprecedant.suite[index]:=NouveauNoeud();
                                        noeudprecedant.suite[index].parent:=noeudprecedant;
                                        //il finissait donc par index
                                        noeudprecedant.suite[index].valeur:=index;
                                        valeurprecedante:=index;
                                        //et on l'ajoute au dico
                                        noeudprecedant.suite[index].rang:=Dico.index.Count;
                                        Dico.index.Add(noeudprecedant.suite[index]);
                                end;
                        end
                        else
                        begin
                                //*******************************
                                //        cas particulier
                                //*******************************
                                //le noeud est celui qu'on doit cree
                                //ce coup si
                                //
                                //donc on cree dabord on
                                //on charge ensuite
                                //*******************************
                                index:=valeurprecedante;
                                //on cree le noeud
                                noeudprecedant.suite[index]:=NouveauNoeud();
                                noeudprecedant.suite[index].parent:=noeudprecedant;
                                noeudprecedant.suite[index].valeur:=index;
                                valeurprecedante:=index;
                                //et on l'ajoute au dico
                                noeudprecedant.suite[index].rang:=Dico.index.Count;
                                Dico.index.Add(noeudprecedant.suite[index]);
                                //on peut enfin charge le noeud
                                noeud:=PNoeud(Dico.index.Items[entier.valeur]);
                                //et l'ecrire
                                EcrireNoeud(noeud,buffer,Destination);
                        end;
                        noeudprecedant:=noeud;
                        //on reevalue le nombre de bit necessaire pour ecrire un rang
                        if (1 shl Dico.bit)=Dico.index.Count then
                                inc(Dico.bit);
                end;
        end;
        //tampon vide ?
        if buffer.taille<>0 then
                //non alors j'ecrit ce qui reste a ecrire
                Destination.Write(buffer.tampon,buffer.taille);

        //liberation memoire
        EffacerDico(Dico);
end;
//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
procedure EcrireBinaire(valeur:TEntierVariable;var etat:TEntierVariable;S:TStream);
begin
        //encore un truc a ecire ?
        while valeur.nombre<>0 do
        begin
                //un bit de moins a ecrire
                dec (valeur.nombre);
                //un bit de plus dans le tampon
                inc (etat.nombre);
                //je place la valeur du bit dans le tampon
                etat.valeur:=(etat.valeur shl 1) or ((valeur.valeur shr valeur.nombre) and 1);
                //le tampon est plein ?
                if etat.nombre=8*sizeof(integer) then
                begin
                        //Alors je l'ecrit dans le fichier
                        S.Write(etat.valeur,sizeof(integer));
                        //et je vide le tampon
                        etat.nombre:=0;
                end;
        end;
end;
//----------------------------------------------------------------
procedure AlignerBinaire(var etat:TEntierVariable;S:TStream);
var valeur:TEntierVariable;
begin
        //le tampon est-il vide ?
        if etat.nombre<>0 then
        begin
                //non
                //je cree ce qui manque avec des zero
                valeur.nombre:=8*sizeof(integer)-etat.nombre;
                valeur.valeur:=0;
                //et je l'ecrit
                EcrireBinaire(valeur,etat,S);
        end;
end;
//----------------------------------------------------------------
function LireBinaire(bit:byte;var etat:TEntierVariable;S:TStream):TEntierVariable;
begin
        //j'initialise le resultat
        Result.valeur:=0;
        Result.nombre:=0;

        //tant qu'il y a des bits a lire
        while bit<>0 do
        begin
                //le tampon est vide ?
                if etat.nombre=0 then
                begin
                        //oui alors je le rempli
                        S.Read(etat.valeur,sizeof(integer));
                        etat.nombre:=8*sizeof(integer);
                end;
                //un bit de moins a lire
                dec(bit);
                //un bit de moins dans le tampon
                dec(etat.nombre);
                //un bit de plus dans le resultat
                inc(Result.nombre);
                //je decale le resultat et je copie la valeur du bit a droite
                //(conservation des bit utiles a droite)
                Result.valeur:=(Result.valeur shl 1) or ((etat.valeur shr etat.nombre) and 1);
        end;
end;
//----------------------------------------------------------------
function  NouveauDico():PDico;
var     i:integer;
begin
        new(Result);
        Result.index:=TList.create;

        new(Result.racine);
        Result.racine.parent:=nil;

        Result.index.Add(nil); //correspond a code fin
        Result.index.Add(nil); //correspond a code reset dico

        //dico initialise avec toutes les valeurs ascii
        for i:=0 to 255 do
        begin
                Result.racine.suite[i]:=NouveauNoeud();
                Result.racine.suite[i].valeur:=i;
                Result.racine.suite[i].parent:=Result.racine;
                Result.racine.suite[i].rang:=Result.index.Count;
                Result.index.Add(Result.racine.suite[i]);
        end;

        //258 valeur possible au depart : 8bit
        Result.bit:=9;

end;
//----------------------------------------------------------------
function  NouveauNoeud():PNoeud;
var     i:integer;
begin
        New(Result);
        //sans descendant
        for i:=0 to 255 do
                Result.suite[i]:=nil;
end;
//----------------------------------------------------------------
procedure EffacerDico(var Dico:PDico);
var     i:integer;
begin
        //on efface tout les noeuds
        for i:=0 to Dico.index.Count-1 do
                dispose(PNoeud(Dico.index.Items[i]));

        //on efface racine et index
        dispose(Dico.racine);
        Dico.index.Free;

        //et on n'oublie pas de s'effacer
        dispose(Dico);
        Dico:=nil;
end;
//----------------------------------------------------------------
function EcrireNoeud(noeud:PNoeud;var buffer:TBuffer;Destination:TStream):integer;
begin
        //je suis sur la racine ?
        if noeud.parent<>nil then
        begin
                //non
                //ecriture des parents
                Result:=EcrireNoeud(noeud.parent,buffer,Destination);
                //si le pere c'est la racine
                if Result=-1 then
                        //je suis le premier caractere de la chaine
                        //almors je renvoie ma valeur
                        Result:=noeud.valeur;

                buffer.tampon[buffer.taille]:=noeud.valeur;
                inc(buffer.taille);
                //tampon plein ?
                //      (tampon de la taille d'un word donc pas besoin)
                //      (de reinitialise taille a 0                   )
                if buffer.taille=0 then
                        Destination.Write(buffer.tampon,65536);
        end
        else
                Result:=-1;
end;
//----------------------------------------------------------------
end.


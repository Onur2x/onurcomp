unit SnapForm;

interface

uses
  SysUtils, Classes, Forms, Messages, Types, windows, controls;

type
  TSnapForm = class(TComponent)
  private
    FActive : boolean; // Détermine l'activation de la magnétisation
    FStickActive : Boolean;  // Détermine l'activation de la colle
    FFormParent : TForm; // Fiche propriétaire du composant
    FStickForm : TForm; // Fiche en cours qui est collée à la fiche parent
    Fsticked : boolean; // La fiche est-elle collée ?
    FFormSnap : TList; // Liste des fiches magnétisantes
    FSnapStrenght : integer; // force de la magnétisation
    FSnapScreenBorder : boolean; // Détermine si les bords de l'écran doivent être magnétisés
    FOldWindowProc: TWndMethod; // Pointeur pour sauvegarder l'ancienne gestion des messages de la fiche parent
    FOldStickWindowProc: TWndMethod;// Pointeur pour sauvegarder l'ancienne gestion des messages de la fiche collée
    FScreenRect: TRect; // Position des 4 coins de l'écran
    procedure SetScreenRect; //Enregistre la position des 4 coins de l'écran ou de la surface MDI visible dans FScreenRect
    procedure WMMoving(var Msg: TWMWindowPosMsg); message WM_WINDOWPOSCHANGING; // Procédure apellée lors du déplacement de la fenêtre parente
    procedure WMMovingStick(var Msg: TWMWindowPosMsg); // Procédure appelée lors du déplacement de la fenêtre collée
    procedure HookStickForm; // Procédure initialisant la capture du message windows de déplacement de la fenêtre parente
    procedure UnHookStickForm; // Procédure supprimant la capture du message windows de déplacement de la fenêtre collée
    procedure HookForm; // Procédure initialisant la capture du message windows de déplacement de la fenêtre parente
    procedure UnhookForm; // Procédure supprimant la capture du message windows de déplacement de la fenêtre parente
    procedure WndProcForm(var AMsg: TMessage); // Gestion des messages de la fenêtre parente
    procedure WndProcStickForm(var AMsg: TMessage); // Gestion des messages de la fenêtre collée
    procedure SetActive(value : boolean); // Procédure activant ou non la magnétisation de la fenêtre parente
    procedure SetStickActive(value : boolean); // Procédure activant ou non le collage de la fenêtre magnétisée
    procedure SetSnapScreenBorder(value : boolean); // Procédure activant ou non le magnétisme du bord de l'écran
    { Déclarations privées }
  protected
    { Déclarations protégées }
  public
    constructor create(AOwner : TCOmponent); override;
    procedure AddFormSnap(SnapForm : TForm); // Ajoute une fiche pour la magnétisation
    procedure DelFormSnap(SnapForm : TForm); // Supprime une fiche magnétisée
    function  CountFormSnap: Integer; // Renvoie le nombre de Forms à magnétiser
    function  GetFormSnap(Pos : Integer): TForm; // Renvoie la Form située à la position Pos de la liste FFormSnap
    destructor Destroy; override;
    { Déclarations publiques }
  published
    property Active : boolean read Factive write SetActive;
    property SnapStrenght : integer read FSnapStrenght write FSnapStrenght;
    property ActiveStick : boolean read FStickActive write SetStickActive;
    property SnapScreenBorder : boolean read FSnapScreenBorder write SetSnapScreenBorder;
    { Déclarations publiées }
  end;

procedure Register;

implementation
// Enregistrement du composant dans la palette Exemples
procedure Register;
begin
  RegisterComponents('Onur', [TSnapForm]);
end;

// Donne les coordonnées de la fenêtre du bureau ou de la MDI parente
procedure TSnapForm.SetScreenRect;
begin
  If FFormParent.FormStyle = fsMDIChild Then
    GetClientRect(Application.MainForm.ClientHandle, FScreenRect)
  else begin
    FScreenRect.Top    := 1;
    FScreenRect.Left   := 1;
    FScreenRect.Right  := GetSystemMetrics(SM_CXFULLSCREEN);
    FScreenRect.Bottom := GetSystemMetrics(SM_CYFULLSCREEN);
  end;
end;

// Positionne la propriété Active du collage
procedure TSnapForm.SetStickActive(Value : boolean);
begin
  FStickActive:=value;
  if value=true then
    begin
    HookStickForm; // Capture des messages de la fenêtre collée
    // L'instruction suivante permet de forcer le collage de la fenêtre, sinon il ne se fait pas
    // tant qu'il n'a pas recu un message windows de déplacement.
    SetWindowPos(FFormParent.Handle,0,FFormParent.Left,FFormParent.Top,0,0,(SWP_NOSIZE or SWP_NOZORDER));
    end
  else
    UnhookStickForm;
end;

// Positionne la propriété Active de la magnétisation
procedure TSnapForm.SetActive(value : boolean);
begin
  if value=true then // Magnétisation activée ?
    HookForm // Si oui, on capture la fille des messages Windows sur la fenêtre parente
  else
    UnhookForm;  // Si non, on relache la capture des messages Windows sur la fenêtre parente
  Factive:=value;
end;

// Procédure activant ou non le magnétisme du bord de l'écran
procedure TSnapForm.SetSnapScreenBorder(value : boolean);
begin
  SetScreenRect;
  FSnapScreenBorder:=value;
end;

// Paramêtre SnapForm : nom de la fenêtre que l'on veut supprimer
procedure TSnapForm.DelFormSnap(SnapForm : TForm);
var
  z: Integer;
begin
  For z := 0 to FFormSnap.Count-1 do
    If AnsiCompareText(SnapForm.Name, TForm(FFormSnap[z]).Name)<>0 Then
      FFormSnap.Delete(z); // Recherche et supprime la fenêtre passée en paramêtre
end;

// Procédure supprimant la capture du message windows de déplacement de la fenêtre collée
procedure TSnapForm.HookStickForm;
begin
  if csDesigning in ComponentState then     // Mode conception ?
    Exit; // Si oui, on sort

  if Assigned(FStickForm) and FStickForm.HandleAllocated then  // La fenêtre à coller est-elle définie ?
  begin
    if not (csDesigning in ComponentState) then // et si nous ne sommes pas en mode conception
    begin
      FOldStickWindowProc := FStickForm.WindowProc; // Alors on sauvegarde la fonction de gestion des messages de cette fenêtre
      FStickForm.WindowProc := WndProcStickForm; // Et on la remplace par la notre
      FSticked:=true; // La fenêtre est collée.
    end;
  end;
end;

// Procédure supprimant la capture du message windows de déplacement de la fenêtre collée
procedure TSnapform.UnhookStickForm;
begin
  if csDesigning in ComponentState then // Mode conception ?
    Exit; // si oui, on sort

  if (FStickForm <> nil) and (FStickForm.HandleAllocated) then // La fiche collée existe t'elle ?
    FStickForm.WindowProc := FOldStickWindowProc; // Si oui, on rétablit l'ancienne gestion des messages
  FOldStickWindowProc := nil; // On remet à zéro les valeurs de collage
  FStickForm          := nil;
end;

// Procédure initialisant la capture du message windows de déplacement de la fenêtre parente
procedure TSnapform.HookForm;
begin
  if csDesigning in ComponentState then  // Mode conception ?
    Exit;  // si oui, on sort

  if Assigned(FFormParent) and FFormParent.HandleAllocated then
  begin
    if not (csDesigning in ComponentState) then
    begin
      FOldWindowProc         := FFormParent.WindowProc;  // Alors on sauvegarde la fonction de gestion des messages de cette fenêtre
      FFormParent.WindowProc := WndProcForm; // Et on la remplace par la notre
    end;
  end;
end;

procedure TSnapform.UnhookForm;
begin
  if csDesigning in ComponentState then  // Mode conception ?
    Exit; // si oui, on sort
    
  if (FFormParent <> nil) and (FFormParent.HandleAllocated) then  // La fiche parent est-elle définie ?
    FFormParent.WindowProc := FOldWindowProc; // Si oui, on restaure l'ancienne gestion des messages windows
  FOldWindowProc := nil; // On réinitialise les variables internes
//  FFormParent    := nil;
end;

// Procédure de gestion des messages windows d'une fenêtre collée, AMsg : Message windows
procedure TSnapForm.WndProcStickForm(var AMsg: TMessage);
begin
  if FStickActive then // Si l'option colle est activée
  begin // Alors
    if AMsg.Msg=WM_WINDOWPOSCHANGING then // Si le message est WM_WINDOWPOSCHANGING (message generée lors d'un déplacement/resize/activation d'une fenêtre)
      WMMovingStick(TWMWindowPosMsg(AMsg)) // Alors on appelle notre procédure de déplacement+collage de fenêtre
    else
      FOldStickWindowProc(AMsg); // Sinon on appelle l'ancienne procédure de messages windows de la fenêtre
  end;
end;

// Procédure de gestion des messages windows de la fenêtre parent, AMsg : Message windows
procedure TSnapform.WndProcForm(var AMsg: TMessage);
begin
  if FActive then // Si l'option magnétique est activée
  begin // Alors
    if AMsg.Msg=WM_WINDOWPOSCHANGING then // Si le message est WM_WINDOWPOSCHANGING (message generée lors d'un déplacement/resize/activation d'une fenêtre)
      WMMoving(TWMWindowPosMsg(AMsg)); // Alors on appelle notre procédure de déplacement de la fenêtre parente
  end;
  FOldWindowProc(AMsg); // Sinon on appelle l'ancienne procédure de messages windows de la fenêtre parente
end;

// Constructeur
constructor TSnapform.create(AOwner : TComponent);
begin
  inherited create(AOwner);
  if (AOwner is TForm) then // On s'assure que le parent est bien de type TForm
  begin
    SystemParametersInfo(SPI_SETDRAGFULLWINDOWS, Ord(true), nil, 0); // Paramêtre système permettant d'afficher le contenu de la fenêtre lors d'un déplacement
    FFormParent:=AOwner as TForm; // La fiche parente est propriétaire du composant
    FFormSnap:=TList.create; // On crée la liste devant contenir les fiches magnétiques
    Factive:=false; // Le composant magnétique n'est pas actif par défaut
    FSticked:=false; // Le composant colle n'est pas actif par défaut
    FSnapScreenBorder:=false; // La form ne colle pas les bords de l'écran par défaut
  end;
  FSnapStrenght:=20; // La force d'attraction est définie à 20 pixels
  SetScreenRect; // Enregistre la position des bords de l'écran
end;

// Destructeur
destructor TSnapform.Destroy;
begin
  UnHookStickForm; // On remet toute les procédures de gestion messages d'origines
  UnhookForm;
  FFormSnap.Free;
  inherited Destroy;
end;

// Procédure appelée lors du déplacement de la fenêtre collée
procedure TSnapForm.WMMovingStick(var Msg: TWMWindowPosMsg);
begin
  // Attention compliqué : si la fiche collante, l'option collante, fiche magnetisée, et le paramètre du message cohérent sont activés
  if (assigned(FStickForm) and (FStickActive) and (FSticked) and (Msg.WindowPos^.hwndInsertAfter=0)) then
  begin
    // Alors on modifie les coordonnées de la fiche parente pour refléter le delta de déplacement de la fiche collante
    // Mais auparavant on désactive la procédure de gestion de la fenêtre collée
    UnhookForm;
    FFormParent.top:=FFormParent.top+(Msg.WindowPos^.y-FStickForm.Top);
    FFormParent.left:=FFormParent.left+(Msg.WindowPos^.x-FStickForm.left);
    // On réactive la procédure de gestion de la fenêtre collée
    HookForm;
  end;
inherited;
end;

// Procédure appelée lors du déplacement de la fenêtre parente
procedure TSnapForm.WMMoving(var Msg: TWMWindowPosMsg);
var
  FForm : TForm;
  r, s : TRect; // Coordonnées de la fiche magnétisante
  sticky : boolean; // La fiche est-elle collée ?
  Compteur : integer; // Nombre de fiches magnétisantes définies dans le composant
begin
  if assigned(FFormSnap) then // Si la fiche parente est définie
  begin // alors
    sticky:=false; // Il n'y a plus de fenêtre collée
    with Msg.WindowPos^ do // Avec les coordonnées du message
    begin
      s.Left := x;
      s.Top := y;
      s.Right := x+FFormParent.Width;
      s.Bottom := y+FFormParent.Height;
    end;
    for Compteur:=0 to FFormSnap.Count-1 do // On répête pour chaque fenêtre magnétisante enregistrée
    begin
      FForm := TForm(FFormSnap[Compteur]); // on crée les coordonnées de la fiche magnétisante
      r.Top := FForm.Top;
      r.Left := FForm.Left;
      r.Right := FForm.Left+FForm.Width;
      r.Bottom := FForm.Top+FForm.Height;
      // Si les coordonnées (x,y) de la fiche parente sont proches (de la force d'attraction) des coordonnées de la fiche magnétisante alors
      // On déplace la fiche parente pour coller sur la fiche magnetisante
      // On en profite pour signaler par sticky que nous avons collé la fiche
      if ((s.Top <= r.Bottom + FSnapStrenght) and (s.Top >= r.Bottom-FSnapStrenght)) and
         ((s.Right >= r.Left) and (s.Left <= r.Right)) then
      begin
        s.Top := r.Bottom;
        sticky:=true;
      end;
      if ((s.Right <= r.left + FSnapStrenght) and (s.Right >= r.left-FSnapStrenght)) and
         ((s.Bottom >= r.Top) and (s.Top <= r.Bottom)) then
      begin
        s.Left := r.left-FFormParent.Width;
        sticky:=true;
      end;
      if ((s.Left >= r.right - FSnapStrenght) and (s.Left <= r.right+FSnapStrenght)) and
         ((s.Bottom >= r.Top) and (s.Top <= r.Bottom)) then
      begin
        s.Left := r.right;
        sticky:=true;
      end;
      if ((s.Bottom <= r.top + FSnapStrenght) and (s.Bottom >= r.top-FSnapStrenght)) and
         (s.Right >= r.Left) and (s.Left <= r.Right) then
      begin
        s.Top := r.top-FFormParent.Height;
        sticky:=true;
      end;
      with Msg.WindowPos^ do // Avec les coordonnées du message
      begin
        x := s.Left;
        y := s.Top;
      end;
      if FStickActive then // Si l'option collage est activée
      begin // Alors
      // Si il n'y a pas collage (sticky) mais que la fenêtre collante est définie
      // Cela veut dire que la fenêtre collante s'est déplacée suffisamment pour décoller la fiche parente
      // Donc on rétablit la gestion des messages de la fenêtre collante pour décollerer ses déplacements
      // de la fenêtre parente
        if ((FStickForm<>nil) and (not sticky) and (Msg.WindowPos^.hwndInsertAfter=0)) then
          UnHookStickForm;
      // Si il y'a collage (sticky) et que la fenêtre collante n'est pas définie
      // Cela veut dire que la fenêtre parente vient de se coller à la fenêtre collante
      // Donc on capture les messages de la fenêtre collante pour répercuter ses déplacements sur la
      // fenêtre parente
        if ((FStickForm=nil) and (sticky)) then
        begin
          FStickForm := TForm(FFormSnap[Compteur]);
          HookStickForm;
        end;
      end;
    end;
    if FSnapScreenBorder then
    begin
      if (s.Top <= FScreenRect.Top+FSnapStrenght) and (s.Top >= FScreenRect.Top-FSnapStrenght) then s.Top := FScreenRect.Top;
      if (s.Left <= FScreenRect.Left+FSnapStrenght) and (s.Left >= FScreenRect.Left-FSnapStrenght) then s.Left := FScreenRect.Left;
      if (s.Right >= FScreenRect.Right-FSnapStrenght) and (s.Right <= FScreenRect.Right+FSnapStrenght) then s.Left := FScreenRect.Right-FFormParent.Width;
      if (s.Bottom >= FScreenRect.Bottom-FSnapStrenght) and (s.Bottom <= FScreenRect.Bottom+FSnapStrenght) then s.Top := FScreenRect.Bottom-FFormParent.Height;
    end;
    with Msg.WindowPos^ do // Avec les coordonnées du message
    begin
      x := s.Left;
      y := s.Top;
    end;
  end;
  inherited;
end;

// Ajoute la fenêtre dans la liste des fenêtres magnétiques
procedure TSnapForm.AddFormSnap(SnapForm : TForm);
var
  z, Count: Integer;
begin
  Count:=0;
  For z := 0 to FFormSnap.Count-1 do
    If AnsiCompareText(SnapForm.Name, TForm(FFormSnap[z]).Name)=0 Then inc(Count);
  If Count > 0 Then Exit;
  FFormSnap.Add(Pointer(SnapForm));
end;

// Renvoie le nombre de Forms à magnétiser
function TSnapForm.CountFormSnap: Integer;
begin
  result:=FFormSnap.Count;
end;

// Renvoie la Form située à la position Pos de la liste FFormSnap
function TSnapForm.GetFormSnap(Pos : Integer): TForm;
begin
  result:=TForm(FFormSnap[Pos]);
end;

end.


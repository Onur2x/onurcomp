unit SnapForm;

interface

uses
  SysUtils, Classes, Forms, Messages, Types, windows, controls;

type
  TSnapForm = class(TComponent)
  private
    FActive : boolean; // D�termine l'activation de la magn�tisation
    FStickActive : Boolean;  // D�termine l'activation de la colle
    FFormParent : TForm; // Fiche propri�taire du composant
    FStickForm : TForm; // Fiche en cours qui est coll�e � la fiche parent
    Fsticked : boolean; // La fiche est-elle coll�e ?
    FFormSnap : TList; // Liste des fiches magn�tisantes
    FSnapStrenght : integer; // force de la magn�tisation
    FSnapScreenBorder : boolean; // D�termine si les bords de l'�cran doivent �tre magn�tis�s
    FOldWindowProc: TWndMethod; // Pointeur pour sauvegarder l'ancienne gestion des messages de la fiche parent
    FOldStickWindowProc: TWndMethod;// Pointeur pour sauvegarder l'ancienne gestion des messages de la fiche coll�e
    FScreenRect: TRect; // Position des 4 coins de l'�cran
    procedure SetScreenRect; //Enregistre la position des 4 coins de l'�cran ou de la surface MDI visible dans FScreenRect
    procedure WMMoving(var Msg: TWMWindowPosMsg); message WM_WINDOWPOSCHANGING; // Proc�dure apell�e lors du d�placement de la fen�tre parente
    procedure WMMovingStick(var Msg: TWMWindowPosMsg); // Proc�dure appel�e lors du d�placement de la fen�tre coll�e
    procedure HookStickForm; // Proc�dure initialisant la capture du message windows de d�placement de la fen�tre parente
    procedure UnHookStickForm; // Proc�dure supprimant la capture du message windows de d�placement de la fen�tre coll�e
    procedure HookForm; // Proc�dure initialisant la capture du message windows de d�placement de la fen�tre parente
    procedure UnhookForm; // Proc�dure supprimant la capture du message windows de d�placement de la fen�tre parente
    procedure WndProcForm(var AMsg: TMessage); // Gestion des messages de la fen�tre parente
    procedure WndProcStickForm(var AMsg: TMessage); // Gestion des messages de la fen�tre coll�e
    procedure SetActive(value : boolean); // Proc�dure activant ou non la magn�tisation de la fen�tre parente
    procedure SetStickActive(value : boolean); // Proc�dure activant ou non le collage de la fen�tre magn�tis�e
    procedure SetSnapScreenBorder(value : boolean); // Proc�dure activant ou non le magn�tisme du bord de l'�cran
    { D�clarations priv�es }
  protected
    { D�clarations prot�g�es }
  public
    constructor create(AOwner : TCOmponent); override;
    procedure AddFormSnap(SnapForm : TForm); // Ajoute une fiche pour la magn�tisation
    procedure DelFormSnap(SnapForm : TForm); // Supprime une fiche magn�tis�e
    function  CountFormSnap: Integer; // Renvoie le nombre de Forms � magn�tiser
    function  GetFormSnap(Pos : Integer): TForm; // Renvoie la Form situ�e � la position Pos de la liste FFormSnap
    destructor Destroy; override;
    { D�clarations publiques }
  published
    property Active : boolean read Factive write SetActive;
    property SnapStrenght : integer read FSnapStrenght write FSnapStrenght;
    property ActiveStick : boolean read FStickActive write SetStickActive;
    property SnapScreenBorder : boolean read FSnapScreenBorder write SetSnapScreenBorder;
    { D�clarations publi�es }
  end;

procedure Register;

implementation
// Enregistrement du composant dans la palette Exemples
procedure Register;
begin
  RegisterComponents('Onur', [TSnapForm]);
end;

// Donne les coordonn�es de la fen�tre du bureau ou de la MDI parente
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

// Positionne la propri�t� Active du collage
procedure TSnapForm.SetStickActive(Value : boolean);
begin
  FStickActive:=value;
  if value=true then
    begin
    HookStickForm; // Capture des messages de la fen�tre coll�e
    // L'instruction suivante permet de forcer le collage de la fen�tre, sinon il ne se fait pas
    // tant qu'il n'a pas recu un message windows de d�placement.
    SetWindowPos(FFormParent.Handle,0,FFormParent.Left,FFormParent.Top,0,0,(SWP_NOSIZE or SWP_NOZORDER));
    end
  else
    UnhookStickForm;
end;

// Positionne la propri�t� Active de la magn�tisation
procedure TSnapForm.SetActive(value : boolean);
begin
  if value=true then // Magn�tisation activ�e ?
    HookForm // Si oui, on capture la fille des messages Windows sur la fen�tre parente
  else
    UnhookForm;  // Si non, on relache la capture des messages Windows sur la fen�tre parente
  Factive:=value;
end;

// Proc�dure activant ou non le magn�tisme du bord de l'�cran
procedure TSnapForm.SetSnapScreenBorder(value : boolean);
begin
  SetScreenRect;
  FSnapScreenBorder:=value;
end;

// Param�tre SnapForm : nom de la fen�tre que l'on veut supprimer
procedure TSnapForm.DelFormSnap(SnapForm : TForm);
var
  z: Integer;
begin
  For z := 0 to FFormSnap.Count-1 do
    If AnsiCompareText(SnapForm.Name, TForm(FFormSnap[z]).Name)<>0 Then
      FFormSnap.Delete(z); // Recherche et supprime la fen�tre pass�e en param�tre
end;

// Proc�dure supprimant la capture du message windows de d�placement de la fen�tre coll�e
procedure TSnapForm.HookStickForm;
begin
  if csDesigning in ComponentState then     // Mode conception ?
    Exit; // Si oui, on sort

  if Assigned(FStickForm) and FStickForm.HandleAllocated then  // La fen�tre � coller est-elle d�finie ?
  begin
    if not (csDesigning in ComponentState) then // et si nous ne sommes pas en mode conception
    begin
      FOldStickWindowProc := FStickForm.WindowProc; // Alors on sauvegarde la fonction de gestion des messages de cette fen�tre
      FStickForm.WindowProc := WndProcStickForm; // Et on la remplace par la notre
      FSticked:=true; // La fen�tre est coll�e.
    end;
  end;
end;

// Proc�dure supprimant la capture du message windows de d�placement de la fen�tre coll�e
procedure TSnapform.UnhookStickForm;
begin
  if csDesigning in ComponentState then // Mode conception ?
    Exit; // si oui, on sort

  if (FStickForm <> nil) and (FStickForm.HandleAllocated) then // La fiche coll�e existe t'elle ?
    FStickForm.WindowProc := FOldStickWindowProc; // Si oui, on r�tablit l'ancienne gestion des messages
  FOldStickWindowProc := nil; // On remet � z�ro les valeurs de collage
  FStickForm          := nil;
end;

// Proc�dure initialisant la capture du message windows de d�placement de la fen�tre parente
procedure TSnapform.HookForm;
begin
  if csDesigning in ComponentState then  // Mode conception ?
    Exit;  // si oui, on sort

  if Assigned(FFormParent) and FFormParent.HandleAllocated then
  begin
    if not (csDesigning in ComponentState) then
    begin
      FOldWindowProc         := FFormParent.WindowProc;  // Alors on sauvegarde la fonction de gestion des messages de cette fen�tre
      FFormParent.WindowProc := WndProcForm; // Et on la remplace par la notre
    end;
  end;
end;

procedure TSnapform.UnhookForm;
begin
  if csDesigning in ComponentState then  // Mode conception ?
    Exit; // si oui, on sort
    
  if (FFormParent <> nil) and (FFormParent.HandleAllocated) then  // La fiche parent est-elle d�finie ?
    FFormParent.WindowProc := FOldWindowProc; // Si oui, on restaure l'ancienne gestion des messages windows
  FOldWindowProc := nil; // On r�initialise les variables internes
//  FFormParent    := nil;
end;

// Proc�dure de gestion des messages windows d'une fen�tre coll�e, AMsg : Message windows
procedure TSnapForm.WndProcStickForm(var AMsg: TMessage);
begin
  if FStickActive then // Si l'option colle est activ�e
  begin // Alors
    if AMsg.Msg=WM_WINDOWPOSCHANGING then // Si le message est WM_WINDOWPOSCHANGING (message gener�e lors d'un d�placement/resize/activation d'une fen�tre)
      WMMovingStick(TWMWindowPosMsg(AMsg)) // Alors on appelle notre proc�dure de d�placement+collage de fen�tre
    else
      FOldStickWindowProc(AMsg); // Sinon on appelle l'ancienne proc�dure de messages windows de la fen�tre
  end;
end;

// Proc�dure de gestion des messages windows de la fen�tre parent, AMsg : Message windows
procedure TSnapform.WndProcForm(var AMsg: TMessage);
begin
  if FActive then // Si l'option magn�tique est activ�e
  begin // Alors
    if AMsg.Msg=WM_WINDOWPOSCHANGING then // Si le message est WM_WINDOWPOSCHANGING (message gener�e lors d'un d�placement/resize/activation d'une fen�tre)
      WMMoving(TWMWindowPosMsg(AMsg)); // Alors on appelle notre proc�dure de d�placement de la fen�tre parente
  end;
  FOldWindowProc(AMsg); // Sinon on appelle l'ancienne proc�dure de messages windows de la fen�tre parente
end;

// Constructeur
constructor TSnapform.create(AOwner : TComponent);
begin
  inherited create(AOwner);
  if (AOwner is TForm) then // On s'assure que le parent est bien de type TForm
  begin
    SystemParametersInfo(SPI_SETDRAGFULLWINDOWS, Ord(true), nil, 0); // Param�tre syst�me permettant d'afficher le contenu de la fen�tre lors d'un d�placement
    FFormParent:=AOwner as TForm; // La fiche parente est propri�taire du composant
    FFormSnap:=TList.create; // On cr�e la liste devant contenir les fiches magn�tiques
    Factive:=false; // Le composant magn�tique n'est pas actif par d�faut
    FSticked:=false; // Le composant colle n'est pas actif par d�faut
    FSnapScreenBorder:=false; // La form ne colle pas les bords de l'�cran par d�faut
  end;
  FSnapStrenght:=20; // La force d'attraction est d�finie � 20 pixels
  SetScreenRect; // Enregistre la position des bords de l'�cran
end;

// Destructeur
destructor TSnapform.Destroy;
begin
  UnHookStickForm; // On remet toute les proc�dures de gestion messages d'origines
  UnhookForm;
  FFormSnap.Free;
  inherited Destroy;
end;

// Proc�dure appel�e lors du d�placement de la fen�tre coll�e
procedure TSnapForm.WMMovingStick(var Msg: TWMWindowPosMsg);
begin
  // Attention compliqu� : si la fiche collante, l'option collante, fiche magnetis�e, et le param�tre du message coh�rent sont activ�s
  if (assigned(FStickForm) and (FStickActive) and (FSticked) and (Msg.WindowPos^.hwndInsertAfter=0)) then
  begin
    // Alors on modifie les coordonn�es de la fiche parente pour refl�ter le delta de d�placement de la fiche collante
    // Mais auparavant on d�sactive la proc�dure de gestion de la fen�tre coll�e
    UnhookForm;
    FFormParent.top:=FFormParent.top+(Msg.WindowPos^.y-FStickForm.Top);
    FFormParent.left:=FFormParent.left+(Msg.WindowPos^.x-FStickForm.left);
    // On r�active la proc�dure de gestion de la fen�tre coll�e
    HookForm;
  end;
inherited;
end;

// Proc�dure appel�e lors du d�placement de la fen�tre parente
procedure TSnapForm.WMMoving(var Msg: TWMWindowPosMsg);
var
  FForm : TForm;
  r, s : TRect; // Coordonn�es de la fiche magn�tisante
  sticky : boolean; // La fiche est-elle coll�e ?
  Compteur : integer; // Nombre de fiches magn�tisantes d�finies dans le composant
begin
  if assigned(FFormSnap) then // Si la fiche parente est d�finie
  begin // alors
    sticky:=false; // Il n'y a plus de fen�tre coll�e
    with Msg.WindowPos^ do // Avec les coordonn�es du message
    begin
      s.Left := x;
      s.Top := y;
      s.Right := x+FFormParent.Width;
      s.Bottom := y+FFormParent.Height;
    end;
    for Compteur:=0 to FFormSnap.Count-1 do // On r�p�te pour chaque fen�tre magn�tisante enregistr�e
    begin
      FForm := TForm(FFormSnap[Compteur]); // on cr�e les coordonn�es de la fiche magn�tisante
      r.Top := FForm.Top;
      r.Left := FForm.Left;
      r.Right := FForm.Left+FForm.Width;
      r.Bottom := FForm.Top+FForm.Height;
      // Si les coordonn�es (x,y) de la fiche parente sont proches (de la force d'attraction) des coordonn�es de la fiche magn�tisante alors
      // On d�place la fiche parente pour coller sur la fiche magnetisante
      // On en profite pour signaler par sticky que nous avons coll� la fiche
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
      with Msg.WindowPos^ do // Avec les coordonn�es du message
      begin
        x := s.Left;
        y := s.Top;
      end;
      if FStickActive then // Si l'option collage est activ�e
      begin // Alors
      // Si il n'y a pas collage (sticky) mais que la fen�tre collante est d�finie
      // Cela veut dire que la fen�tre collante s'est d�plac�e suffisamment pour d�coller la fiche parente
      // Donc on r�tablit la gestion des messages de la fen�tre collante pour d�collerer ses d�placements
      // de la fen�tre parente
        if ((FStickForm<>nil) and (not sticky) and (Msg.WindowPos^.hwndInsertAfter=0)) then
          UnHookStickForm;
      // Si il y'a collage (sticky) et que la fen�tre collante n'est pas d�finie
      // Cela veut dire que la fen�tre parente vient de se coller � la fen�tre collante
      // Donc on capture les messages de la fen�tre collante pour r�percuter ses d�placements sur la
      // fen�tre parente
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
    with Msg.WindowPos^ do // Avec les coordonn�es du message
    begin
      x := s.Left;
      y := s.Top;
    end;
  end;
  inherited;
end;

// Ajoute la fen�tre dans la liste des fen�tres magn�tiques
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

// Renvoie le nombre de Forms � magn�tiser
function TSnapForm.CountFormSnap: Integer;
begin
  result:=FFormSnap.Count;
end;

// Renvoie la Form situ�e � la position Pos de la liste FFormSnap
function TSnapForm.GetFormSnap(Pos : Integer): TForm;
begin
  result:=TForm(FFormSnap[Pos]);
end;

end.


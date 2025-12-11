unit MainScreenView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage;

type
  TfrmMainScreen = class(TForm)
    pnlMainScreenBackground: TPanel;
    pnlLogoSystem: TPanel;
    ImgLogoSystem: TImage;
    pnlBtnMenuItemPumps: TPanel;
    imgItemPumps: TImage;
    pnlBtnMenuItemPumpsTitle: TPanel;
    lblItemPumps: TLabel;
    pnlBtnMenuItemPumpsImage: TPanel;
    pnlBtnMenuItemClose: TPanel;
    pnlBtnMenuItemCloseTitle: TPanel;
    lblItemClose: TLabel;
    pnlBtnMenuItemCloseImage: TPanel;
    imgItemClose: TImage;
    pnlBtnMenuItemRefuelings: TPanel;
    pnlBtnMenuItemRefuelingsTitle: TPanel;
    lblItemRefuelings: TLabel;
    pnlBtnMenuItemRefuelingsImage: TPanel;
    imgItemRefuelings: TImage;
    pnlSeparatorMenu1: TPanel;
    pnlSeparatorMenu2: TPanel;
    pnlSeparatorCloseButton: TPanel;
    pnlMenuButtons: TPanel;
    pnlSeparatorLogo: TPanel;
    procedure FormCreate(Sender: TObject);
  private
    procedure LinkEventsToButtons;
    procedure MenuItemMouseEnter(Sender: TObject);
    procedure MenuItemMouseLeave(Sender: TObject);
    procedure CloseApplication(Sender: TObject);
    function GetAssociatedLabel(Sender: TObject): TLabel;
  public
  end;

var
  frmMainScreen: TfrmMainScreen;

implementation

{$R *.dfm}

procedure TfrmMainScreen.CloseApplication;
begin
  Application.Terminate;
end;

procedure TfrmMainScreen.FormCreate(Sender: TObject);
begin
  LinkEventsToButtons;
  Self.Width := Screen.WorkAreaWidth;
  pnlMainScreenBackground.Width := Self.ClientWidth;
  pnlMainScreenBackground.Realign;
  Application.ProcessMessages;
end;

procedure TfrmMainScreen.LinkEventsToButtons;
begin
  imgItemPumps.OnMouseEnter := MenuItemMouseEnter;
  imgItemPumps.OnMouseLeave := MenuItemMouseLeave;
  lblItemPumps.OnMouseEnter := MenuItemMouseEnter;
  lblItemPumps.OnMouseLeave := MenuItemMouseLeave;

  imgItemRefuelings.OnMouseEnter := MenuItemMouseEnter;
  imgItemRefuelings.OnMouseLeave := MenuItemMouseLeave;
  lblItemRefuelings.OnMouseEnter := MenuItemMouseEnter;
  lblItemRefuelings.OnMouseLeave := MenuItemMouseLeave;

  imgItemClose.OnMouseEnter := MenuItemMouseEnter;
  imgItemClose.OnMouseLeave := MenuItemMouseLeave;
  imgItemClose.OnClick := CloseApplication;
  lblItemClose.OnMouseEnter := MenuItemMouseEnter;
  lblItemClose.OnMouseLeave := MenuItemMouseLeave;
  lblItemClose.OnClick := CloseApplication;
end;

function TfrmMainScreen.GetAssociatedLabel(Sender: TObject): TLabel;
begin
  Result := nil;
  if Sender = imgItemPumps then
    Result := lblItemPumps
  else if Sender = imgItemClose then
    Result := lblItemClose
  else if Sender = imgItemRefuelings then
    Result := lblItemRefuelings;
end;

procedure TfrmMainScreen.MenuItemMouseEnter(Sender: TObject);
var
  LabelControl: TLabel;
begin
  if Sender is TLabel then
    LabelControl := TLabel(Sender)
  else
    LabelControl := GetAssociatedLabel(Sender);

  if Assigned(LabelControl) then
  begin
    LabelControl.Font.Style := [fsBold, fsUnderline];
    LabelControl.Font.Size := 13;
  end;
end;

procedure TfrmMainScreen.MenuItemMouseLeave(Sender: TObject);
var
  LabelControl: TLabel;
begin
  if Sender is TLabel then
    LabelControl := TLabel(Sender)
  else
    LabelControl := GetAssociatedLabel(Sender);

  if Assigned(LabelControl) then
  begin
    LabelControl.Font.Style := [fsBold];
    LabelControl.Font.Size := 12;
  end;
end;

end.

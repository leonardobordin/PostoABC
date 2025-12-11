unit LoginSystemView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Imaging.pngimage, Vcl.ComCtrls;

type
  TfrmLogin = class(TForm)
    pnlLogin: TPanel;
    pnlFirstScreenSeparator: TPanel;
    pnlFirstScreenWelcome: TPanel;
    pnlFirstScreenLogin: TPanel;
    lblFirstScreenWelcome: TLabel;
    lblFirstScreenSubTitle: TLabel;
    lblCreatedBy: TLabel;
    imgLogoSoftware: TImage;
    lblLoginPageTitle: TLabel;
    lblUserPasswordInfo: TLabel;
    lblInfoSystem: TLabel;
    pnlEdtLogin: TPanel;
    lblLoginInput: TLabel;
    edtLogin: TEdit;
    lblPassword: TLabel;
    pnlPassword: TPanel;
    edtPassword: TEdit;
    btnLogin: TPanel;
    pnlMainForm: TPanel;
    pgcLoginForm: TPageControl;
    tabLoginForm: TTabSheet;
    tabRegisterForm: TTabSheet;
    lblRegister: TLabel;
    lblRegisterTitle: TLabel;
    lblSubtitleRegister: TLabel;
    lblRegisterName: TLabel;
    pnlRegisterPassword: TPanel;
    edtPasswordRegister: TEdit;
    pnlNameRegister: TPanel;
    edtNameRegister: TEdit;
    lblRegisterPassword: TLabel;
    btnRegister: TPanel;
    Label1: TLabel;
    btnBackToLogin: TImage;
    pnlRegisterEmail: TPanel;
    edtEmailRegister: TEdit;
    lblRegisterEmail: TLabel;
    procedure btnCloseSoftwareClick(Sender: TObject);
    procedure lblRegisterMouseEnter(Sender: TObject);
    procedure lblRegisterMouseLeave(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnBackToLoginClick(Sender: TObject);
    procedure lblRegisterClick(Sender: TObject);
    procedure ButtonMouseEnter(Sender: TObject);
    procedure ButtonMouseLeave(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

uses
  UserController;

{$R *.dfm}

procedure TfrmLogin.btnBackToLoginClick(Sender: TObject);
begin
  pgcLoginForm.ActivePage := tabLoginForm;
end;

procedure TfrmLogin.btnCloseSoftwareClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmLogin.btnLoginClick(Sender: TObject);
begin
  if TUserController.Login(edtLogin.Text, edtPassword.Text) then
    ModalResult := mrOk
  else
    Application.MessageBox(PChar('Email ou senha incorreto.'), 'Erro',
      MB_OK or MB_ICONERROR);
end;

procedure TfrmLogin.btnRegisterClick(Sender: TObject);
begin
  try
    if TUserController.RegisterUser(edtNameRegister.Text, edtEmailRegister.Text,
      edtPasswordRegister.Text) then
      Application.MessageBox('Usuário cadastrado com sucesso!', 'Sucesso',
        MB_OK or MB_ICONINFORMATION);

    edtLogin.Text := edtEmailRegister.Text;
    edtPassword.Text := edtPasswordRegister.Text;

    pgcLoginForm.ActivePage := tabLoginForm;

    edtEmailRegister.Text := '';
    edtPasswordRegister.Text := '';
    edtNameRegister.Text := '';
  except
    on E: Exception do
      Application.MessageBox(PChar('Falha ao se cadastrar: ' + E.Message),
        'Erro', MB_OK or MB_ICONERROR);
  end;
end;

procedure TfrmLogin.ButtonMouseEnter(Sender: TObject);
begin
  if Sender is TPanel then
  begin
    (Sender as TPanel).Font.Size := 11;
    (Sender as TPanel).Font.Style := [fsBold];
    (Sender as TPanel).Color := $009F910D;
  end;
end;

procedure TfrmLogin.ButtonMouseLeave(Sender: TObject);
begin
  if Sender is TPanel then
  begin
    (Sender as TPanel).Font.Size := 10;
    (Sender as TPanel).Font.Style := [];
    (Sender as TPanel).Color := $02C0FF00;
  end;
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  pgcLoginForm.ActivePage := tabLoginForm;

  btnLogin.OnMouseEnter := ButtonMouseEnter;
  btnLogin.OnMouseLeave := ButtonMouseLeave;

  btnRegister.OnMouseEnter := ButtonMouseEnter;
  btnRegister.OnMouseLeave := ButtonMouseLeave;
end;

procedure TfrmLogin.lblRegisterClick(Sender: TObject);
begin
  pgcLoginForm.ActivePage := tabRegisterForm;
end;

procedure TfrmLogin.lblRegisterMouseEnter(Sender: TObject);
begin
  lblRegister.Font.Style := [fsBold, fsUnderline];
end;

procedure TfrmLogin.lblRegisterMouseLeave(Sender: TObject);
begin
  lblRegister.Font.Style := [fsBold];
end;

end.

unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls,
  Vcl.Buttons, Vcl.ExtCtrls,
  DatabaseConnection, TanqueController, BombaController, AbastecimentoController,
  TanqueForm, BombaForm, AbastecimentoForm, Vcl.Imaging.pngimage;

type
  TfrmMain = class(TForm)
    MainMenu: TMainMenu;
    mniCadastros: TMenuItem;
    mniTanques: TMenuItem;
    mniSeparador1: TMenuItem;
    mniBombas: TMenuItem;
    mniSeparador2: TMenuItem;
    mniAbastecimentos: TMenuItem;
    mniRelatorios: TMenuItem;
    mniRelatorioAbastecimentos: TMenuItem;
    mniSair: TMenuItem;
    lblBemVindo: TLabel;
    pnlButtons: TPanel;
    btnTanques: TSpeedButton;
    btnBombas: TSpeedButton;
    btnAbastecimentos: TSpeedButton;
    imgLogo: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mniTanquesClick(Sender: TObject);
    procedure mniBombasClick(Sender: TObject);
    procedure mniAbastecimentosClick(Sender: TObject);
    procedure mniRelatorioAbastecimentosClick(Sender: TObject);
    procedure mniSairClick(Sender: TObject);
    procedure btnTanquesClick(Sender: TObject);
    procedure btnBombasClick(Sender: TObject);
    procedure btnAbastecimentosClick(Sender: TObject);
  private
    { Private declarations }
    procedure ConectarBanco;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  ConectarBanco;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TDatabaseConnection.Finalizar;
end;

procedure TfrmMain.ConectarBanco;
begin
  try
    TDatabaseConnection.ObterInstancia.ConectarBanco;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao conectar ao banco de dados: ' + E.Message);
      Application.Terminate;
    end;
  end;
end;

procedure TfrmMain.mniTanquesClick(Sender: TObject);
var
  LForm: TfrmTanque;
begin
  LForm := TfrmTanque.Create(nil);
  try
    LForm.ShowModal;
  finally
    LForm.Free;
  end;
end;

procedure TfrmMain.mniBombasClick(Sender: TObject);
var
  LForm: TfrmBomba;
begin
  LForm := TfrmBomba.Create(nil);
  try
    LForm.ShowModal;
  finally
    LForm.Free;
  end;
end;

procedure TfrmMain.mniAbastecimentosClick(Sender: TObject);
var
  LForm: TfrmAbastecimento;
begin
  LForm := TfrmAbastecimento.Create(nil);
  try
    LForm.ShowModal;
  finally
    LForm.Free;
  end;
end;

procedure TfrmMain.btnTanquesClick(Sender: TObject);
begin
  mniTanquesClick(Sender);
end;

procedure TfrmMain.btnBombasClick(Sender: TObject);
begin
  mniBombasClick(Sender);
end;

procedure TfrmMain.btnAbastecimentosClick(Sender: TObject);
begin
  mniAbastecimentosClick(Sender);
end;

procedure TfrmMain.mniRelatorioAbastecimentosClick(Sender: TObject);
begin
  ShowMessage('Relatório de abastecimentos será implementado em breve');
  //Implementar relatório com FortesReport
end;

procedure TfrmMain.mniSairClick(Sender: TObject);
begin
  Close;
end;

end.

unit RelatorioAbastecimentosForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls, Data.DB, FireDAC.Comp.Client,
  RelatorioExibicaoForm, AbastecimentoController;

type
  TfrmRelatorioAbastecimentos = class(TForm)
    pnlTitulo: TPanel;
    lblTitulo: TLabel;
    pnlDatas: TPanel;
    lblDataInicio: TLabel;
    dtDataInicio: TDateTimePicker;
    lblDataFim: TLabel;
    dtDataFim: TDateTimePicker;
    pnlBotoes: TPanel;
    btnGerar: TButton;
    btnCancelar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnGerarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FController: TAbastecimentoController;
  public
    { Public declarations }
  end;

var
  frmRelatorioAbastecimentos: TfrmRelatorioAbastecimentos;

implementation

{$R *.dfm}

procedure TfrmRelatorioAbastecimentos.FormCreate(Sender: TObject);
begin
  FController := TAbastecimentoController.Create;
  dtDataInicio.Date := Date();
  dtDataFim.Date := Date();
end;

procedure TfrmRelatorioAbastecimentos.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FreeAndNil(FController);
  Action := caFree;
end;

procedure TfrmRelatorioAbastecimentos.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmRelatorioAbastecimentos.btnGerarClick(Sender: TObject);
var
  LQuery: TFDQuery;
  LForm: TfrmRelatorioExibicao;
begin
  LQuery := FController.ObterRelatorioParaPeriodo(dtDataInicio.Date,  dtDataFim.Date);
  try
    if LQuery.IsEmpty then
    begin
      ShowMessage('Não existem abastecimentos para serem impressos nesse período.');
      Exit;
    end;

    LForm := TfrmRelatorioExibicao.Create(nil);
    try
      LForm.Query := LQuery;
      LForm.DataInicio := dtDataInicio.Date;
      LForm.DataFim := dtDataFim.Date;
      LForm.RLReport1.Preview();
    finally
      LForm.Free;
    end;
  finally
    LQuery.Free;
  end;
end;

end.

unit RelatorioExibicaoForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Data.DB, FireDAC.Comp.Client,
  RLReport, Vcl.Imaging.pngimage;


type
  TfrmRelatorioExibicao = class(TForm)
    RLReport1: TRLReport;
    RLBandTitle: TRLBand;
    RLDrawTitle: TRLDraw;
    RLLabelEmpresa: TRLLabel;
    RLSystemInfoPagina: TRLSystemInfo;
    RLLabelPagina: TRLLabel;
    RLLabelTitulo: TRLLabel;
    RLGroup1: TRLGroup;
    RLBandHeader: TRLBand;
    RLDrawGrupo: TRLDraw;
    RLLabelTanqueGrupo: TRLLabel;
    RLLabelTanque: TRLLabel;
    RLDrawHeaderBomba: TRLDraw;
    RLLabelHeaderBomba: TRLLabel;
    RLDrawHeaderData: TRLDraw;
    RLLabelHeaderData: TRLLabel;
    RLDrawHeaderValorImposto: TRLDraw;
    RLLabelHeaderValorImposto: TRLLabel;
    RLBandDetail: TRLBand;
    RLDrawBomba: TRLDraw;
    RLLabelBomba: TRLLabel;
    RLDrawDataAbastecimento: TRLDraw;
    RLLabelDataAbastecimento: TRLLabel;
    RLDrawValorImposto: TRLDraw;
    RLLabelValorImposto: TRLLabel;
    RLBandGroupFooter: TRLBand;
    RLDrawValorTotalTanqueCaption: TRLDraw;
    RLLabelTituloTotalTanque: TRLLabel;
    RLDrawValorTotalTanque: TRLDraw;
    RLLabelTotalValorImpostoTanque: TRLLabel;
    RLBandFooter: TRLBand;
    RLDrawValorTotalCaption: TRLDraw;
    RLDrawTotalValorGeral: TRLDraw;
    RLImageLogoPosto: TRLImage;
    RLDrawHeaderValor: TRLDraw;
    RLLabelHeaderValor: TRLLabel;
    RLDrawValor: TRLDraw;
    RLLabelValor: TRLLabel;
    RLDrawHeaderImposto: TRLDraw;
    RLLabelHeaderImposto: TRLLabel;
    RLDrawImposto: TRLDraw;
    RLLabelImposto: TRLLabel;
    RLDrawTotalImpostoTanque: TRLDraw;
    RLDrawTotalValorTanque: TRLDraw;
    RLLabelTotalImpostoTanque: TRLLabel;
    RLLabelTotalValorTanque: TRLLabel;
    RLLabelTituloTotalGeral: TRLLabel;
    RLLabelTotalValorGeral: TRLLabel;
    RLDraw1: TRLDraw;
    RLDraw2: TRLDraw;
    RLLabelTotalImpostoGeral: TRLLabel;
    RLLabelTotalValorImpostoGeral: TRLLabel;
    RLLabelPeriodo: TRLLabel;
    procedure FormCreate(Sender: TObject);
    procedure RLBandHeaderBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLBandDetailBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLBandGroupFooterBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLBandFooterBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLDrawTitleBeforePrint(Sender: TObject; var PrintIt: Boolean);
  private
    FTotalValorTanque: Currency;
    FTotalImpostoTanque: Currency;
    FTotalValorImpostoTanque: Currency;

    FTotalValorGeral: Currency;
    FTotalImpostoGeral: Currency;
    FTotalValorImpostoGeral: Currency;

    FQuery: TFDQuery;
    FDataInicio: TDate;
    FDataFim: TDate;

    procedure SetQuery(const Value: TFDQuery);
  public
    property Query: TFDQuery read FQuery write SetQuery;
    property DataInicio: TDate read FDataInicio write FDataInicio;
    property DataFim: TDate read FDataFim write FDataFim;

  end;

var
  frmRelatorioExibicao: TfrmRelatorioExibicao;

implementation

{$R *.dfm}

procedure TfrmRelatorioExibicao.FormCreate(Sender: TObject);
begin
  FTotalValorTanque := 0;
  FTotalImpostoTanque := 0;
  FTotalValorImpostoTanque := 0;

  FTotalValorGeral := 0;
  FTotalImpostoGeral := 0;
  FTotalValorImpostoGeral := 0;
end;

procedure TfrmRelatorioExibicao.SetQuery(const Value: TFDQuery);
begin
  FQuery := Value;

  RLReport1.DataSource := TDataSource.Create(Self);
  RLReport1.DataSource.DataSet := FQuery;
end;

procedure TfrmRelatorioExibicao.RLBandHeaderBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  if Assigned(FQuery) and not FQuery.IsEmpty then
  begin
    RLLabelTanque.Caption := Trim(FQuery.FieldByName('Tanque').AsString);
  end;
end;

procedure TfrmRelatorioExibicao.RLDrawTitleBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  RLLabelTitulo.Caption := 'Relatório de Abastecimentos | Data da Impressão: '
                           +FormatDateTime('dd/MM/yyyy', now);

  RLLabelPeriodo.Caption := 'Período do Relatório: '
                            +FormatDateTime('dd/MM/yyyy', FDataInicio)
                            + ' à '
                            +FormatDateTime('dd/MM/yyyy', FDataFim);
end;

procedure TfrmRelatorioExibicao.RLBandDetailBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  if Assigned(FQuery) and not FQuery.IsEmpty then
  begin
    RLLabelBomba.Caption := Trim(FQuery.FieldByName('Bomba').AsString);
    RLLabelDataAbastecimento.Caption := FormatDateTime('dd/mm/yyyy', FQuery.FieldByName('DataAbastecimento').AsDateTime);
    RLLabelValor.Caption := 'R$ ' + FormatFloat('#,##0.00', FQuery.FieldByName('Valor').AsCurrency);
    RLLabelImposto.Caption := 'R$ ' + FormatFloat('#,##0.00', FQuery.FieldByName('Imposto').AsCurrency);
    RLLabelValorImposto.Caption := 'R$ ' + FormatFloat('#,##0.00', FQuery.FieldByName('ValorComImposto').AsCurrency);

    FTotalValorTanque := FTotalValorTanque + FQuery.FieldByName('Valor').AsCurrency;
    FTotalImpostoTanque := FTotalImpostoTanque + FQuery.FieldByName('Imposto').AsCurrency;
    FTotalValorImpostoTanque := FTotalValorImpostoTanque + FQuery.FieldByName('ValorComImposto').AsCurrency;

    FTotalValorGeral := FTotalValorGeral + FQuery.FieldByName('Valor').AsCurrency;
    FTotalImpostoGeral := FTotalImpostoGeral + FQuery.FieldByName('Imposto').AsCurrency;
    FTotalValorImpostoGeral := FTotalValorImpostoGeral + FQuery.FieldByName('ValorComImposto').AsCurrency;
  end;
end;

procedure TfrmRelatorioExibicao.RLBandGroupFooterBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  RLLabelTotalValorTanque.Caption := 'R$ ' + FormatFloat('#,##0.00', FTotalValorTanque);
  RLLabelTotalImpostoTanque.Caption := 'R$ ' + FormatFloat('#,##0.00', FTotalImpostoTanque);
  RLLabelTotalValorImpostoTanque.Caption := 'R$ ' + FormatFloat('#,##0.00', FTotalValorImpostoTanque);

  FTotalValorTanque := 0;
  FTotalImpostoTanque := 0;
  FTotalValorImpostoTanque := 0;
end;

procedure TfrmRelatorioExibicao.RLBandFooterBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  RLLabelTotalValorGeral.Caption := 'R$ ' + FormatFloat('#,##0.00', FTotalValorGeral);
  RLLabelTotalImpostoGeral.Caption := 'R$ ' + FormatFloat('#,##0.00', FTotalImpostoGeral);
  RLLabelTotalValorImpostoGeral.Caption := 'R$ ' + FormatFloat('#,##0.00', FTotalValorImpostoGeral);
end;

end.

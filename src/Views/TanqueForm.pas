unit TanqueForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids,
  Vcl.ExtCtrls, Vcl.ComCtrls,
  TanqueModel, TanqueController, System.Generics.Collections,
  InputValidation, UITypes;

type
  TfrmTanque = class(TForm)
    pnlTitle: TPanel;
    lblTitle: TLabel;
    pnlForm: TPanel;
    lblNome: TLabel;
    edtNome: TEdit;
    lblTipo: TLabel;
    edtTipo: TEdit;
    lblCapacidade: TLabel;
    edtCapacidade: TEdit;
    lblNivelAtual: TLabel;
    edtNivelAtual: TEdit;
    pnlButtons: TPanel;
    btnNovo: TButton;
    btnInserir: TButton;
    btnAtualizar: TButton;
    btnReabastecimento: TButton;
    btnDeletar: TButton;
    btnFechar: TButton;
    pnlGrid: TPanel;
    sgTanques: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnNovoClick(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure btnReabastecimentoClick(Sender: TObject);
    procedure btnDeletarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure sgTanquesSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure edtNomeKeyPress(Sender: TObject; var Key: Char);
    procedure edtTipoKeyPress(Sender: TObject; var Key: Char);
    procedure edtCapacidadeKeyPress(Sender: TObject; var Key: Char);
    procedure edtNivelAtualKeyPress(Sender: TObject; var Key: Char);
  private
    FController: TTanqueController;
    FIdSelecionado: Integer;
    procedure ConfigurarGrid;
    procedure CarregarGrid;
    procedure LimparCampos;
    procedure CarregarCampos;
    procedure HabilitarCampos(AHabilitar: Boolean);
    procedure AtualizarEstadoBotoes;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfrmTanque.FormCreate(Sender: TObject);
begin
  FController := TTanqueController.Create;
  FIdSelecionado := 0;

  ConfigurarGrid;
  LimparCampos;
  CarregarGrid;
end;

procedure TfrmTanque.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(FController);
  Action := caFree;
end;

procedure TfrmTanque.CarregarGrid;
var
  LTanques: TObjectList<TTanque>;
  LCount: Integer;
  I: Integer;
begin
  try
    LTanques := FController.ObterTodos;
    try
      LCount := LTanques.Count;
      sgTanques.RowCount := LCount + 1;
      
      for I := 0 to LCount - 1 do
      begin
        sgTanques.Cells[0, I + 1] := IntToStr(LTanques[I].Id);
        sgTanques.Cells[1, I + 1] := LTanques[I].Nome;
        sgTanques.Cells[2, I + 1] := LTanques[I].Tipo;
        sgTanques.Cells[3, I + 1] := FormatFloat('0.00', LTanques[I].Capacidade);
        sgTanques.Cells[4, I + 1] := FormatFloat('0.00', LTanques[I].NivelAtual);
        if LTanques[I].DataReabastecimento > 0 then
          sgTanques.Cells[5, I + 1] := FormatDateTime('dd/mm/yyyy hh:mm:ss', LTanques[I].DataReabastecimento)
        else
          sgTanques.Cells[5, I + 1] := '';
      end;
    finally
      LTanques.Free;
    end;
  except
    on E: Exception do
      ShowMessage('Erro ao carregar tanques: ' + E.Message);
  end;
end;

procedure TfrmTanque.ConfigurarGrid;
begin
  sgTanques.ColCount := 6;
  sgTanques.RowCount := 2;
  sgTanques.ColWidths[0] := 50;
  sgTanques.ColWidths[1] := 150;
  sgTanques.ColWidths[2] := 200;
  sgTanques.ColWidths[3] := 100;
  sgTanques.ColWidths[4] := 100;
  sgTanques.ColWidths[5] := 150;

  sgTanques.Cells[0, 0] := 'ID';
  sgTanques.Cells[1, 0] := 'Nome';
  sgTanques.Cells[2, 0] := 'Tipo';
  sgTanques.Cells[3, 0] := 'Capacidade';
  sgTanques.Cells[4, 0] := 'Nível Atual';
  sgTanques.Cells[5, 0] := 'Data Reabastecimento';
end;

procedure TfrmTanque.LimparCampos;
begin
  edtNome.Clear;
  edtTipo.Clear;
  edtCapacidade.Clear;
  edtNivelAtual.Clear;
  FIdSelecionado := 0;
  HabilitarCampos(False);
  AtualizarEstadoBotoes;
end;

procedure TfrmTanque.CarregarCampos;
var
  LTanque: TTanque;
begin
  if FIdSelecionado > 0 then
  begin
    try
      LTanque := FController.ObterPorId(FIdSelecionado);
      try
        if Assigned(LTanque) then
        begin
          edtNome.Text := LTanque.Nome;
          edtTipo.Text := LTanque.Tipo;
          edtCapacidade.Text := FormatFloat('0.00', LTanque.Capacidade);
          edtNivelAtual.Text := FormatFloat('0.00', LTanque.NivelAtual);
          HabilitarCampos(True);
          AtualizarEstadoBotoes;
        end;
      finally
        LTanque.Free;
      end;
    except
      on E: Exception do
        ShowMessage('Erro ao carregar tanque: ' + E.Message);
    end;
  end;
end;

procedure TfrmTanque.HabilitarCampos(AHabilitar: Boolean);
begin
  edtNome.Enabled := AHabilitar;
  edtTipo.Enabled := AHabilitar;
  edtCapacidade.Enabled := AHabilitar;
  edtNivelAtual.Enabled := AHabilitar;
  btnReabastecimento.Enabled := AHabilitar;
  btnDeletar.Enabled := AHabilitar;
end;

procedure TfrmTanque.AtualizarEstadoBotoes;
begin
  if FIdSelecionado > 0 then
  begin
    btnInserir.Enabled := False;
    btnAtualizar.Enabled := True;
  end
  else
  begin
    btnInserir.Enabled := False;
    btnAtualizar.Enabled := False;
  end;
end;

procedure TfrmTanque.btnNovoClick(Sender: TObject);
begin
  LimparCampos;
  HabilitarCampos(True);
  btnInserir.Enabled := True;
  btnAtualizar.Enabled := False;
  btnDeletar.Enabled := False;
  btnReabastecimento.Enabled := False;
  edtNome.SetFocus;
end;

procedure TfrmTanque.btnInserirClick(Sender: TObject);
begin
  if edtNome.Text = '' then
  begin
    ShowMessage('Nome do tanque é obrigatório');
    Exit;
  end;

  if edtCapacidade.Text = '' then
  begin
    ShowMessage('Capacidade é obrigatória');
    Exit;
  end;

  try
    FController.Inserir(
      edtNome.Text,
      edtTipo.Text,
      StrToFloat(edtCapacidade.Text),
      StrToFloatDef(edtNivelAtual.Text, 0)
    );
    ShowMessage('Tanque inserido com sucesso!');
    LimparCampos;
    CarregarGrid;
  except
    on E: Exception do
      ShowMessage('Erro ao inserir tanque: ' + E.Message);
  end;
end;

procedure TfrmTanque.btnAtualizarClick(Sender: TObject);
begin
  if FIdSelecionado <= 0 then
  begin
    ShowMessage('Selecione um tanque para atualizar');
    Exit;
  end;

  if edtNome.Text = '' then
  begin
    ShowMessage('Nome do tanque é obrigatório');
    Exit;
  end;

  try
    FController.Atualizar(
      FIdSelecionado,
      edtNome.Text,
      edtTipo.Text,
      StrToFloat(edtCapacidade.Text),
      StrToFloatDef(edtNivelAtual.Text, 0)
    );
    ShowMessage('Tanque atualizado com sucesso!');
    LimparCampos;
    CarregarGrid;
  except
    on E: Exception do
      ShowMessage('Erro ao atualizar tanque: ' + E.Message);
  end;
end;

procedure TfrmTanque.btnReabastecimentoClick(Sender: TObject);
var
  LMsg: string;
  LNovoNivel: Double;
begin
  if FIdSelecionado <= 0 then
  begin
    ShowMessage('Selecione um tanque para reabastecer');
    Exit;
  end;

  LMsg := 'Ao realizar um reabastecimento, o nível do tanque será igualado à capacidade.' + #13#13 +
          'Registros de abastecimento criados a partir de agora afetarão este novo nível.' + #13#13 +
          'Deseja continuar?';

  if MessageDlg(LMsg, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      LNovoNivel := StrToFloat(edtCapacidade.Text);
      
      FController.Reabastecimento(FIdSelecionado, LNovoNivel);
      edtNivelAtual.Text := FormatFloat('0.00', LNovoNivel);
      ShowMessage('Tanque reabastecido com sucesso! Nível atual: ' + FormatFloat('0.00', LNovoNivel));
      CarregarGrid;
    except
      on E: Exception do
        ShowMessage('Erro ao reabastecer tanque: ' + E.Message);
    end;
  end;
end;

procedure TfrmTanque.btnDeletarClick(Sender: TObject);
begin
  if FIdSelecionado <= 0 then
  begin
    ShowMessage('Selecione um tanque para deletar');
    Exit;
  end;

  if MessageDlg('Tem certeza que deseja deletar este tanque?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      FController.Deletar(FIdSelecionado);
      ShowMessage('Tanque deletado com sucesso!');
      LimparCampos;
      CarregarGrid;
    except
      on E: Exception do
        ShowMessage('Erro ao deletar tanque: ' + E.Message);
    end;
  end;
end;

procedure TfrmTanque.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTanque.sgTanquesSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  if ARow > 0 then
  begin
    FIdSelecionado := StrToIntDef(sgTanques.Cells[0, ARow], 0);
    CarregarCampos;
  end;
end;

procedure TfrmTanque.edtNomeKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    edtTipo.SetFocus;
  end;
end;

procedure TfrmTanque.edtTipoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    edtCapacidade.SetFocus;
  end;
end;

procedure TfrmTanque.edtCapacidadeKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    edtNivelAtual.SetFocus;
  end
  else
    TInputValidation.ValidarDecimal(Sender, Key);
end;

procedure TfrmTanque.edtNivelAtualKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    btnInserir.SetFocus;
  end
  else
    TInputValidation.ValidarDecimal(Sender, Key);
end;

end.

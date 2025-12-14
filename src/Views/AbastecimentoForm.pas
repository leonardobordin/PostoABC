unit AbastecimentoForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids,
  Vcl.ExtCtrls, Vcl.ComCtrls,
  AbastecimentoModel, AbastecimentoController,
  BombaModel, BombaController,
  TanqueModel, TanqueController,
  System.Generics.Collections,
  InputValidation, UITypes;

type
  TfrmAbastecimento = class(TForm)
    pnlTitle: TPanel;
    lblTitle: TLabel;
    pnlForm: TPanel;
    lblBomba: TLabel;
    cbxBomba: TComboBox;
    lblQuantidade: TLabel;
    edtQuantidade: TEdit;
    lblValorUnitario: TLabel;
    edtValorUnitario: TEdit;
    lblValorAbastecimento: TLabel;
    edtValorAbastecimento: TEdit;
    lblImposto: TLabel;
    edtImposto: TEdit;
    lblValorTotal: TLabel;
    edtValorTotal: TEdit;
    pnlButtons: TPanel;
    btnNovo: TButton;
    btnInserir: TButton;
    btnAtualizar: TButton;
    btnDeletar: TButton;
    btnFechar: TButton;
    pnlGrid: TPanel;
    sgAbastecimentos: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnNovoClick(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure btnDeletarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure sgAbastecimentosSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure edtQuantidadeChange(Sender: TObject);
    procedure edtValorUnitarioChange(Sender: TObject);
    procedure edtQuantidadeKeyPress(Sender: TObject; var Key: Char);
    procedure edtValorUnitarioKeyPress(Sender: TObject; var Key: Char);
    procedure cbxBombaChange(Sender: TObject);
    procedure cbxBombaKeyPress(Sender: TObject; var Key: Char);
  private
    FAbastecimentoController: TAbastecimentoController;
    FBombaController: TBombaController;
    FTanqueController: TTanqueController;
    FIdSelecionado: Integer;
    procedure ConfigurarGrid;
    procedure CarregarBombas;
    procedure CarregarGrid;
    procedure LimparCampos;
    procedure CarregarCampos;
    procedure HabilitarCampos(AHabilitar: Boolean);
    procedure AtualizarEstadoBotoes;
    procedure CalcularValores;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfrmAbastecimento.FormCreate(Sender: TObject);
begin
  FAbastecimentoController := TAbastecimentoController.Create;
  FBombaController := TBombaController.Create;
  FTanqueController := TTanqueController.Create;
  FIdSelecionado := 0;

  ConfigurarGrid;
  CarregarBombas;
  LimparCampos;
  CarregarGrid;
end;

procedure TfrmAbastecimento.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(FAbastecimentoController);
  FreeAndNil(FBombaController);
  FreeAndNil(FTanqueController);
  Action := caFree;
end;

procedure TfrmAbastecimento.CarregarBombas;
var
  LBombas: TObjectList<TBomba>;
  I: Integer;
begin
  try
    LBombas := FBombaController.ObterAtivas;
    try
      cbxBomba.Clear;
      for I := 0 to LBombas.Count - 1 do
        cbxBomba.Items.AddObject(
          IntToStr(LBombas[I].Id) + ' - ' + LBombas[I].Descricao,
          TObject(Pointer(LBombas[I].Id))
        );
    finally
      LBombas.Free;
    end;
  except
    on E: Exception do
      ShowMessage('Erro ao carregar bombas no campo de seleção: ' + E.Message);
  end;
end;

procedure TfrmAbastecimento.ConfigurarGrid;
begin
  sgAbastecimentos.ColCount := 9;
  sgAbastecimentos.RowCount := 2;
  sgAbastecimentos.ColWidths[0] := 50;
  sgAbastecimentos.ColWidths[1] := 120;
  sgAbastecimentos.ColWidths[2] := 80;
  sgAbastecimentos.ColWidths[3] := 60;
  sgAbastecimentos.ColWidths[4] := 60;
  sgAbastecimentos.ColWidths[5] := 80;
  sgAbastecimentos.ColWidths[6] := 60;
  sgAbastecimentos.ColWidths[7] := 60;
  sgAbastecimentos.ColWidths[8] := 150;

  sgAbastecimentos.Cells[0, 0] := 'ID';
  sgAbastecimentos.Cells[1, 0] := 'Bomba';
  sgAbastecimentos.Cells[2, 0] := 'Tanque';
  sgAbastecimentos.Cells[3, 0] := 'Litros';
  sgAbastecimentos.Cells[4, 0] := 'V. Unit.';
  sgAbastecimentos.Cells[5, 0] := 'V. Abastec.';
  sgAbastecimentos.Cells[6, 0] := 'Imposto';
  sgAbastecimentos.Cells[7, 0] := 'V. Total';
  sgAbastecimentos.Cells[8, 0] := 'Data/Hora Abastecimento';
end;

procedure TfrmAbastecimento.CarregarGrid;
var
  LAbastecimentos: TObjectList<TAbastecimento>;
  I: Integer;
begin
  LAbastecimentos := nil;
  try
    try
      LAbastecimentos := FAbastecimentoController.ObterTodos;
      sgAbastecimentos.RowCount := LAbastecimentos.Count + 1;

      for I := 0 to LAbastecimentos.Count - 1 do
      begin
        sgAbastecimentos.Cells[0, I + 1] := IntToStr(LAbastecimentos[I].Id);
        sgAbastecimentos.Cells[1, I + 1] := LAbastecimentos[I].DescricaoBomba;
        sgAbastecimentos.Cells[2, I + 1] := LAbastecimentos[I].NomeTanque;
        sgAbastecimentos.Cells[3, I + 1] := FormatFloat('0.00', LAbastecimentos[I].QuantidadeLitros);
        sgAbastecimentos.Cells[4, I + 1] := FormatFloat('0.00', LAbastecimentos[I].ValorUnitario);
        sgAbastecimentos.Cells[5, I + 1] := FormatFloat('0.00', LAbastecimentos[I].ValorAbastecimento);
        sgAbastecimentos.Cells[6, I + 1] := FormatFloat('0.00', LAbastecimentos[I].Imposto);
        sgAbastecimentos.Cells[7, I + 1] := FormatFloat('0.00', LAbastecimentos[I].ValorTotal);
        sgAbastecimentos.Cells[8, I + 1] := FormatDateTime('dd/mm/yyyy hh:mm:ss', LAbastecimentos[I].DataAbastecimento);
      end;
    except
      on E: Exception do
        ShowMessage('Erro ao carregar abastecimentos na grid: ' + E.Message);
    end;
  finally
    if Assigned(LAbastecimentos) then
      LAbastecimentos.Free;
  end;
end;

procedure TfrmAbastecimento.LimparCampos;
begin
  cbxBomba.ItemIndex := -1;
  edtQuantidade.Clear;
  edtValorUnitario.Clear;
  edtValorAbastecimento.Clear;
  edtValorAbastecimento.Enabled := False;
  edtImposto.Clear;
  edtImposto.Enabled := False;
  edtValorTotal.Clear;
  edtValorTotal.Enabled := False;
  FIdSelecionado := 0;
  HabilitarCampos(False);
  AtualizarEstadoBotoes;
end;

procedure TfrmAbastecimento.CarregarCampos;
var
  LAbastecimento: TAbastecimento;
  I: Integer;
begin
  if FIdSelecionado > 0 then
  begin
    try
      LAbastecimento := FAbastecimentoController.ObterPorId(FIdSelecionado);

      try
        if Assigned(LAbastecimento) then
        begin

          // Localizar o bomba na combobox
          for I := 0 to cbxBomba.Items.Count - 1 do
            if Integer(cbxBomba.Items.Objects[I]) = LAbastecimento.IdBomba then
            begin
              cbxBomba.ItemIndex := I;
              Break;
            end;

          cbxBomba.ItemIndex := LAbastecimento.IdBomba - 1;
          edtQuantidade.Text := FormatFloat('0.00', LAbastecimento.QuantidadeLitros);
          edtValorUnitario.Text := FormatFloat('0.00', LAbastecimento.ValorUnitario);
          edtValorAbastecimento.Text := FormatFloat('0.00', LAbastecimento.ValorAbastecimento);
          edtImposto.Text := FormatFloat('0.00', LAbastecimento.Imposto);
          edtValorTotal.Text := FormatFloat('0.00', LAbastecimento.ValorTotal);
          HabilitarCampos(True);
          AtualizarEstadoBotoes;
        end;
      finally
        LAbastecimento.Free;
      end;
    except
      on E: Exception do
        ShowMessage('Erro ao carregar abastecimento nos campos: ' + E.Message);
    end;
  end;
end;

procedure TfrmAbastecimento.HabilitarCampos(AHabilitar: Boolean);
begin
  cbxBomba.Enabled := AHabilitar;
  edtQuantidade.Enabled := AHabilitar;
  edtValorUnitario.Enabled := AHabilitar;
  btnDeletar.Enabled := AHabilitar;
end;

procedure TfrmAbastecimento.AtualizarEstadoBotoes;
begin
  if FIdSelecionado > 0 then
  begin
    btnInserir.Enabled := False;
    btnAtualizar.Enabled := True;
  end
  else
  begin
    btnInserir.Enabled := (cbxBomba.ItemIndex >= 0);
    btnAtualizar.Enabled := False;
  end;
end;

procedure TfrmAbastecimento.CalcularValores;
var
  LQuantidade, LValorUnitario, LValorAbastecimento, LImposto, LValorTotal: Double;
begin
  try
    LQuantidade := StrToFloatDef(edtQuantidade.Text, 0);
    LValorUnitario := StrToFloatDef(edtValorUnitario.Text, 0);
    
    if (LQuantidade > 0) and (LValorUnitario > 0) then
    begin
      LValorAbastecimento := LQuantidade * LValorUnitario;
      LImposto := FAbastecimentoController.CalcularImposto(LValorAbastecimento);
      LValorTotal := LValorAbastecimento + LImposto;
      
      edtValorAbastecimento.Text := FormatFloat('0.00', LValorAbastecimento);
      edtImposto.Text := FormatFloat('0.00', LImposto);
      edtValorTotal.Text := FormatFloat('0.00', LValorTotal);
    end;
  except
    on E: Exception do
      ShowMessage('Erro ao calcular valores: ' + E.Message);
  end;
end;

procedure TfrmAbastecimento.btnNovoClick(Sender: TObject);
begin
  LimparCampos;
  HabilitarCampos(True);
  btnInserir.Enabled := True;
  btnDeletar.Enabled := False;
  edtQuantidade.SetFocus;
end;

procedure TfrmAbastecimento.btnInserirClick(Sender: TObject);
begin
  if cbxBomba.ItemIndex < 0 then
  begin
    ShowMessage('Selecione uma bomba');
    Exit;
  end;

  if edtQuantidade.Text = '' then
  begin
    ShowMessage('Quantidade de litros é obrigatória');
    Exit;
  end;

  if edtValorUnitario.Text = '' then
  begin
    ShowMessage('Valor unitário é obrigatório');
    Exit;
  end;

  try
    FAbastecimentoController.Inserir(
      Integer(cbxBomba.Items.Objects[cbxBomba.ItemIndex]),
      StrToFloat(edtQuantidade.Text),
      StrToFloat(edtValorUnitario.Text)
    );
    ShowMessage('Abastecimento registrado com sucesso!');
    LimparCampos;
    CarregarGrid;
  except
    on E: Exception do
      ShowMessage('Erro ao inserir abastecimento: ' + E.Message);
  end;
end;

procedure TfrmAbastecimento.btnAtualizarClick(Sender: TObject);
begin
  if FIdSelecionado <= 0 then
  begin
    ShowMessage('Selecione um abastecimento para atualizar');
    Exit;
  end;

  if cbxBomba.ItemIndex < 0 then
  begin
    ShowMessage('Selecione uma bomba');
    Exit;
  end;

  if edtQuantidade.Text = '' then
  begin
    ShowMessage('Quantidade de litros é obrigatória');
    Exit;
  end;

  if edtValorUnitario.Text = '' then
  begin
    ShowMessage('Valor unitário é obrigatório');
    Exit;
  end;

  try
    FAbastecimentoController.Atualizar(
      FIdSelecionado,
      Integer(cbxBomba.Items.Objects[cbxBomba.ItemIndex]),
      StrToFloat(edtQuantidade.Text),
      StrToFloat(edtValorUnitario.Text)
    );
    ShowMessage('Abastecimento atualizado com sucesso!');
    LimparCampos;
    CarregarGrid;
  except
    on E: Exception do
      ShowMessage('Erro ao atualizar abastecimento: ' + E.Message);
  end;
end;

procedure TfrmAbastecimento.btnDeletarClick(Sender: TObject);
begin
  if FIdSelecionado <= 0 then
  begin
    ShowMessage('Selecione um abastecimento para deletar');
    Exit;
  end;

  if MessageDlg('Tem certeza que deseja deletar este abastecimento?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      FAbastecimentoController.Deletar(FIdSelecionado);
      ShowMessage('Abastecimento deletado com sucesso!');
      LimparCampos;
      CarregarGrid;
    except
      on E: Exception do
        ShowMessage('Erro ao deletar abastecimento: ' + E.Message);
    end;
  end;
end;

procedure TfrmAbastecimento.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAbastecimento.sgAbastecimentosSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  if ARow > 0 then
  begin
    FIdSelecionado := StrToIntDef(sgAbastecimentos.Cells[0, ARow], 0);
    CarregarCampos;
  end;
end;

procedure TfrmAbastecimento.edtQuantidadeChange(Sender: TObject);
begin
  CalcularValores;
end;

procedure TfrmAbastecimento.edtValorUnitarioChange(Sender: TObject);
begin
  CalcularValores;
end;

procedure TfrmAbastecimento.edtQuantidadeKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    edtValorUnitario.SetFocus;
  end
  else
    TInputValidation.ValidarDecimal(Sender, Key, 4, 2);
end;

procedure TfrmAbastecimento.edtValorUnitarioKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    btnInserir.SetFocus;
  end
  else
    TInputValidation.ValidarDecimal(Sender, Key, 3, 2);
end;

procedure TfrmAbastecimento.cbxBombaChange(Sender: TObject);
begin
  AtualizarEstadoBotoes;
end;

procedure TfrmAbastecimento.cbxBombaKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    edtQuantidade.SetFocus;
  end;
end;

end.

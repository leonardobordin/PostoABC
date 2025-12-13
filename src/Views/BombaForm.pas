unit BombaForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids,
  Vcl.ExtCtrls, Vcl.ComCtrls,
  BombaModel, BombaController, TanqueModel, TanqueController, System.Generics.Collections,
  InputValidation, UITypes;

type
  TfrmBomba = class(TForm)
    pnlTitle: TPanel;
    lblTitle: TLabel;
    pnlForm: TPanel;
    lblNumero: TLabel;
    edtNumero: TEdit;
    lblDescricao: TLabel;
    edtDescricao: TEdit;
    lblTanque: TLabel;
    cbxTanque: TComboBox;
    lblStatus: TLabel;
    cbxStatus: TComboBox;
    pnlButtons: TPanel;
    btnNovo: TButton;
    btnInserir: TButton;
    btnAtualizar: TButton;
    btnDeletar: TButton;
    btnFechar: TButton;
    pnlGrid: TPanel;
    sgBombas: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnNovoClick(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure btnDeletarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure sgBombasSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure edtNumeroKeyPress(Sender: TObject; var Key: Char);
  private
    FBombaController: TBombaController;
    FTanqueController: TTanqueController;
    FIdSelecionado: Integer;
    procedure ConfigurarGrid;
    procedure ConfigurarCombobox;
    procedure CarregarTanques;
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

procedure TfrmBomba.FormCreate(Sender: TObject);
begin
  FBombaController := TBombaController.Create;
  FTanqueController := TTanqueController.Create;
  FIdSelecionado := 0;
  ConfigurarGrid;
  ConfigurarComboBox;
  CarregarTanques;
  LimparCampos;
  CarregarGrid;
end;

procedure TfrmBomba.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(FBombaController);
  FreeAndNil(FTanqueController);
  Action := caFree;
end;

procedure TfrmBomba.CarregarTanques;
var
  LTanques: TObjectList<TTanque>;
  I: Integer;
begin
  try
    LTanques := FTanqueController.ObterTodos;
    try
      cbxTanque.Clear;
      for I := 0 to LTanques.Count - 1 do
        cbxTanque.Items.AddObject(
          IntToStr(LTanques[I].Id) + ' - ' + LTanques[I].Nome,
          TObject(Pointer(LTanques[I].Id))
        );
    finally
      LTanques.Free;
    end;
  except
    on E: Exception do
      ShowMessage('Erro ao carregar tanques: ' + E.Message);
  end;
end;

procedure TfrmBomba.ConfigurarCombobox;
begin
  cbxStatus.Items.Add('ATIVA');
  cbxStatus.Items.Add('INATIVA');
end;

procedure TfrmBomba.ConfigurarGrid;
begin
  sgBombas.ColCount := 6;
  sgBombas.RowCount := 2;
  sgBombas.ColWidths[0] := 50;
  sgBombas.ColWidths[1] := 60;
  sgBombas.ColWidths[2] := 250;
  sgBombas.ColWidths[3] := 250;
  sgBombas.ColWidths[4] := 50;
  sgBombas.ColWidths[5] := 80;

  sgBombas.Cells[0, 0] := 'ID';
  sgBombas.Cells[1, 0] := 'Número';
  sgBombas.Cells[2, 0] := 'Descrição';
  sgBombas.Cells[3, 0] := 'Tanque';
  sgBombas.Cells[4, 0] := 'Status';
  sgBombas.Cells[5, 0] := 'Criação';
end;

procedure TfrmBomba.CarregarGrid;
var
  LBombas: TObjectList<TBomba>;
  I: Integer;
begin
  LBombas := nil;
  try
    try
      LBombas := FBombaController.ObterTodos;
      sgBombas.RowCount := LBombas.Count + 1;
    
      for I := 0 to LBombas.Count - 1 do
      begin
        sgBombas.Cells[0, I + 1] := IntToStr(LBombas[I].Id);
        sgBombas.Cells[1, I + 1] := IntToStr(LBombas[I].Numero);
        sgBombas.Cells[2, I + 1] := LBombas[I].Descricao;
        sgBombas.Cells[3, I + 1] := LBombas[I].NomeTanque;
        sgBombas.Cells[4, I + 1] := LBombas[I].Status;
        sgBombas.Cells[5, I + 1] := DateToStr(LBombas[I].DataCriacao);
      end;
    except
      on E: Exception do
        ShowMessage('Erro ao carregar bombas: ' + E.Message);
    end;
  finally
    if Assigned(LBombas) then
      LBombas.Free;
  end;
end;

procedure TfrmBomba.LimparCampos;
begin
  edtNumero.Clear;
  edtDescricao.Clear;
  cbxTanque.ItemIndex := -1;
  cbxStatus.ItemIndex := -1;
  FIdSelecionado := 0;
  HabilitarCampos(False);
  AtualizarEstadoBotoes;
end;

procedure TfrmBomba.CarregarCampos;
var
  LBomba: TBomba;
  I: Integer;
begin
  if FIdSelecionado > 0 then
  begin
    try
      LBomba := FBombaController.ObterPorId(FIdSelecionado);
      try
        if Assigned(LBomba) then
        begin
          edtNumero.Text := IntToStr(LBomba.Numero);
          edtDescricao.Text := LBomba.Descricao;
          
          // Localizar o tanque na combobox
          for I := 0 to cbxTanque.Items.Count - 1 do
            if Integer(cbxTanque.Items.Objects[I]) = LBomba.IdTanque then
            begin
              cbxTanque.ItemIndex := I;
              Break;
            end;
          
          cbxStatus.ItemIndex := cbxStatus.Items.IndexOf(LBomba.Status);
          HabilitarCampos(True);
          AtualizarEstadoBotoes;
        end;
      finally
        LBomba.Free;
      end;
    except
      on E: Exception do
        ShowMessage('Erro ao carregar bomba: ' + E.Message);
    end;
  end;
end;

procedure TfrmBomba.HabilitarCampos(AHabilitar: Boolean);
begin
  edtNumero.Enabled := AHabilitar;
  edtDescricao.Enabled := AHabilitar;
  cbxTanque.Enabled := AHabilitar;
  cbxStatus.Enabled := AHabilitar;
  btnDeletar.Enabled := AHabilitar;
end;

procedure TfrmBomba.AtualizarEstadoBotoes;
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

procedure TfrmBomba.btnNovoClick(Sender: TObject);
begin
  LimparCampos;
  HabilitarCampos(True);
  btnInserir.Enabled := True;
  btnAtualizar.Enabled := False;
  btnDeletar.Enabled := False;
  edtNumero.SetFocus;
end;

procedure TfrmBomba.btnInserirClick(Sender: TObject);
begin
  if edtNumero.Text = '' then
  begin
    ShowMessage('Número da bomba é obrigatório');
    Exit;
  end;

  if edtDescricao.Text = '' then
  begin
    ShowMessage('Número de série é obrigatório');
    Exit;
  end;

  if cbxTanque.ItemIndex < 0 then
  begin
    ShowMessage('Selecione um tanque');
    Exit;
  end;

  try
    FBombaController.Inserir(
      StrToInt(edtNumero.Text),
      edtDescricao.Text,
      Integer(cbxTanque.Items.Objects[cbxTanque.ItemIndex]),
      'ATIVA'
    );
    ShowMessage('Bomba inserida com sucesso!');
    LimparCampos;
    CarregarGrid;
  except
    on E: Exception do
      ShowMessage('Erro ao inserir bomba: ' + E.Message);
  end;
end;

procedure TfrmBomba.btnAtualizarClick(Sender: TObject);
begin
  if FIdSelecionado <= 0 then
  begin
    ShowMessage('Selecione uma bomba para atualizar');
    Exit;
  end;

  if edtNumero.Text = '' then
  begin
    ShowMessage('Número da bomba é obrigatório');
    Exit;
  end;

  try
    FBombaController.Atualizar(
      FIdSelecionado,
      StrToInt(edtNumero.Text),
      edtDescricao.Text,
      Integer(cbxTanque.Items.Objects[cbxTanque.ItemIndex]),
      cbxStatus.Text
    );
    ShowMessage('Bomba atualizada com sucesso!');
    LimparCampos;
    CarregarGrid;
  except
    on E: Exception do
      ShowMessage('Erro ao atualizar bomba: ' + E.Message);
  end;
end;

procedure TfrmBomba.btnDeletarClick(Sender: TObject);
begin
  if FIdSelecionado <= 0 then
  begin
    ShowMessage('Selecione uma bomba para deletar');
    Exit;
  end;

  if MessageDlg('Tem certeza que deseja deletar esta bomba?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      FBombaController.Deletar(FIdSelecionado);
      ShowMessage('Bomba deletada com sucesso!');
      LimparCampos;
      CarregarGrid;
    except
      on E: Exception do
        ShowMessage('Erro ao deletar bomba: ' + E.Message);
    end;
  end;
end;

procedure TfrmBomba.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmBomba.sgBombasSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  if ARow > 0 then
  begin
    FIdSelecionado := StrToIntDef(sgBombas.Cells[0, ARow], 0);
    CarregarCampos;
  end;
end;

procedure TfrmBomba.edtNumeroKeyPress(Sender: TObject; var Key: Char);
begin
  TInputValidation.ValidarInteiro(Sender, Key);
end;

end.

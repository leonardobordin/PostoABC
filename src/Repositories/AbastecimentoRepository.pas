unit AbastecimentoRepository;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  AbastecimentoModel,
  DatabaseConnection,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param;

type
  TAbastecimentoRepository = class
  public
    constructor Create;
    destructor Destroy; override;
    function Inserir(AAbastecimento: TAbastecimento): Boolean;
    function Atualizar(AAbastecimento: TAbastecimento): Boolean;
    function Deletar(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TAbastecimento;
    function ObterTodos: TObjectList<TAbastecimento>;
    function ObterPorPeriodo(ADataInicio, ADataFim: TDateTime): TObjectList<TAbastecimento>;
    function ObterPorBomba(AIdBomba: Integer): TObjectList<TAbastecimento>;
    function ObterRelatorioParaPeriodo(ADataInicio, ADataFim: TDateTime): TFDQuery;
  end;

implementation

constructor TAbastecimentoRepository.Create;
begin
  inherited Create;
end;

destructor TAbastecimentoRepository.Destroy;
begin
  inherited;
end;

function TAbastecimentoRepository.Inserir(AAbastecimento: TAbastecimento): Boolean;
var
  LQuery: TFDQuery;
begin
  LQuery := TDatabaseConnection.ObterInstancia.CriarConsulta;
  try
    try
      LQuery.SQL.Text := 'INSERT INTO ABASTECIMENTOS (ID_BOMBA, QUANTIDADE_LITROS, ' +
                         'VALOR_UNITARIO, VALOR_ABASTECIMENTO, IMPOSTO, VALOR_TOTAL) ' +
                         'VALUES (:ID_BOMBA, :QUANTIDADE_LITROS, :VALOR_UNITARIO, ' +
                         ':VALOR_ABASTECIMENTO, :IMPOSTO, :VALOR_TOTAL)';
      LQuery.Params.ParamByName('ID_BOMBA').AsInteger := AAbastecimento.IdBomba;
      LQuery.Params.ParamByName('QUANTIDADE_LITROS').AsCurrency := AAbastecimento.QuantidadeLitros;
      LQuery.Params.ParamByName('VALOR_UNITARIO').AsCurrency := AAbastecimento.ValorUnitario;
      LQuery.Params.ParamByName('VALOR_ABASTECIMENTO').AsCurrency := AAbastecimento.ValorAbastecimento;
      LQuery.Params.ParamByName('IMPOSTO').AsCurrency := AAbastecimento.Imposto;
      LQuery.Params.ParamByName('VALOR_TOTAL').AsCurrency := AAbastecimento.ValorTotal;
      LQuery.ExecSQL;
      Result := True;
    except
      on E: Exception do
        raise Exception.Create('Erro ao inserir abastecimento: ' + E.Message);
    end;
  finally
    LQuery.Free;
  end;
end;

function TAbastecimentoRepository.Atualizar(AAbastecimento: TAbastecimento): Boolean;
var
  LQuery: TFDQuery;
begin
  LQuery := TDatabaseConnection.ObterInstancia.CriarConsulta;
  try
    try
      LQuery.SQL.Text := 'UPDATE ABASTECIMENTOS SET ID_BOMBA = :ID_BOMBA, ' +
                         'QUANTIDADE_LITROS = :QUANTIDADE_LITROS, VALOR_UNITARIO = :VALOR_UNITARIO, ' +
                         'VALOR_ABASTECIMENTO = :VALOR_ABASTECIMENTO, IMPOSTO = :IMPOSTO, ' +
                         'VALOR_TOTAL = :VALOR_TOTAL WHERE ID = :ID';
      LQuery.Params.ParamByName('ID_BOMBA').AsInteger := AAbastecimento.IdBomba;
      LQuery.Params.ParamByName('QUANTIDADE_LITROS').AsCurrency := AAbastecimento.QuantidadeLitros;
      LQuery.Params.ParamByName('VALOR_UNITARIO').AsCurrency := AAbastecimento.ValorUnitario;
      LQuery.Params.ParamByName('VALOR_ABASTECIMENTO').AsCurrency := AAbastecimento.ValorAbastecimento;
      LQuery.Params.ParamByName('IMPOSTO').AsCurrency := AAbastecimento.Imposto;
      LQuery.Params.ParamByName('VALOR_TOTAL').AsCurrency := AAbastecimento.ValorTotal;
      LQuery.Params.ParamByName('ID').AsInteger := AAbastecimento.Id;
      LQuery.ExecSQL;
      Result := True;
    except
      on E: Exception do
        raise Exception.Create('Erro ao atualizar abastecimento: ' + E.Message);
    end;
  finally
    LQuery.Free;
  end;
end;

function TAbastecimentoRepository.Deletar(AId: Integer): Boolean;
var
  LQuery: TFDQuery;
begin
  LQuery := TDatabaseConnection.ObterInstancia.CriarConsulta;
  try
    try
      LQuery.SQL.Text := 'DELETE FROM ABASTECIMENTOS WHERE ID = :ID';
      LQuery.Params.ParamByName('ID').AsInteger := AId;
      LQuery.ExecSQL;
      Result := True;
    except
      on E: Exception do
        raise Exception.Create('Erro ao deletar abastecimento: ' + E.Message);
    end;
  finally
    LQuery.Free;
  end;
end;

function TAbastecimentoRepository.ObterPorId(AId: Integer): TAbastecimento;
var
  LQuery: TFDQuery;
begin
  Result := nil;
  LQuery := TDatabaseConnection.ObterInstancia.CriarConsulta;
  try
    try
      LQuery.SQL.Text := 'SELECT * FROM ABASTECIMENTOS WHERE ID = :ID';
      LQuery.Params.ParamByName('ID').AsInteger := AId;
      LQuery.Open;
      if not LQuery.Eof then
      begin
        Result := TAbastecimento.Create;
        Result.Id := LQuery.FieldByName('ID').AsInteger;
        Result.IdBomba := LQuery.FieldByName('ID_BOMBA').AsInteger;
        Result.QuantidadeLitros := LQuery.FieldByName('QUANTIDADE_LITROS').AsCurrency;
        Result.ValorUnitario := LQuery.FieldByName('VALOR_UNITARIO').AsCurrency;
        Result.ValorAbastecimento := LQuery.FieldByName('VALOR_ABASTECIMENTO').AsCurrency;
        Result.Imposto := LQuery.FieldByName('IMPOSTO').AsCurrency;
        Result.ValorTotal := LQuery.FieldByName('VALOR_TOTAL').AsCurrency;
        Result.DataAbastecimento := LQuery.FieldByName('DATA_ABASTECIMENTO').AsDateTime;
      end;
    except
      on E: Exception do
        raise Exception.Create('Erro ao obter abastecimento: ' + E.Message);
    end;
  finally
    LQuery.Free;
  end;
end;

function TAbastecimentoRepository.ObterTodos: TObjectList<TAbastecimento>;
var
  LQuery: TFDQuery;
  LAbastecimento: TAbastecimento;
begin
  Result := TObjectList<TAbastecimento>.Create;
  LQuery := TDatabaseConnection.ObterInstancia.CriarConsulta;
  try
    try
      LQuery.SQL.Text := 
        'SELECT ' +
        '  ABASTECIMENTOS.ID, ' +
        '  ABASTECIMENTOS.ID_BOMBA, ' +
        '  ABASTECIMENTOS.QUANTIDADE_LITROS, ' +
        '  ABASTECIMENTOS.VALOR_UNITARIO, ' +
        '  ABASTECIMENTOS.VALOR_ABASTECIMENTO, ' +
        '  ABASTECIMENTOS.IMPOSTO, ' +
        '  ABASTECIMENTOS.VALOR_TOTAL, ' +
        '  ABASTECIMENTOS.DATA_ABASTECIMENTO, ' +
        '  BOMBAS.DESCRICAO, ' +
        '  TANQUES.NOME ' +
        'FROM ABASTECIMENTOS ' +
        'INNER JOIN BOMBAS ON ABASTECIMENTOS.ID_BOMBA = BOMBAS.ID ' +
        'INNER JOIN TANQUES ON BOMBAS.ID_TANQUE = TANQUES.ID ' +
        'ORDER BY ABASTECIMENTOS.DATA_ABASTECIMENTO DESC';
      LQuery.Open;
      while not LQuery.Eof do
      begin
        LAbastecimento := TAbastecimento.Create;
        LAbastecimento.Id := LQuery.FieldByName('ID').AsInteger;
        LAbastecimento.IdBomba := LQuery.FieldByName('ID_BOMBA').AsInteger;
        LAbastecimento.QuantidadeLitros := LQuery.FieldByName('QUANTIDADE_LITROS').AsCurrency;
        LAbastecimento.ValorUnitario := LQuery.FieldByName('VALOR_UNITARIO').AsCurrency;
        LAbastecimento.ValorAbastecimento := LQuery.FieldByName('VALOR_ABASTECIMENTO').AsCurrency;
        LAbastecimento.Imposto := LQuery.FieldByName('IMPOSTO').AsCurrency;
        LAbastecimento.ValorTotal := LQuery.FieldByName('VALOR_TOTAL').AsCurrency;
        LAbastecimento.DataAbastecimento := LQuery.FieldByName('DATA_ABASTECIMENTO').AsDateTime;
        LAbastecimento.DescricaoBomba := LQuery.FieldByName('DESCRICAO').AsString;
        LAbastecimento.NomeTanque := LQuery.FieldByName('NOME').AsString;
        Result.Add(LAbastecimento);
        LQuery.Next;
      end;
    except
      on E: Exception do
      begin
        Result.Free;
        raise Exception.Create('Erro ao obter abastecimentos: ' + E.Message);
      end;
    end;
  finally
    LQuery.Free;
  end;
end;

function TAbastecimentoRepository.ObterPorPeriodo(ADataInicio: TDateTime; ADataFim: TDateTime): TObjectList<TAbastecimento>;
var
  LQuery: TFDQuery;
  LAbastecimento: TAbastecimento;
begin
  Result := TObjectList<TAbastecimento>.Create;
  LQuery := TDatabaseConnection.ObterInstancia.CriarConsulta;
  try
    try
      LQuery.SQL.Text := 'SELECT * FROM ABASTECIMENTOS WHERE DATA_ABASTECIMENTO >= :DATA_INICIO ' +
                         'AND DATA_ABASTECIMENTO <= :DATA_FIM ORDER BY DATA_ABASTECIMENTO DESC';
      LQuery.Params.ParamByName('DATA_INICIO').AsDateTime := ADataInicio;
      LQuery.Params.ParamByName('DATA_FIM').AsDateTime := ADataFim;
      LQuery.Open;
      while not LQuery.Eof do
      begin
        LAbastecimento := TAbastecimento.Create;
        LAbastecimento.Id := LQuery.FieldByName('ID').AsInteger;
        LAbastecimento.IdBomba := LQuery.FieldByName('ID_BOMBA').AsInteger;
        LAbastecimento.QuantidadeLitros := LQuery.FieldByName('QUANTIDADE_LITROS').AsCurrency;
        LAbastecimento.ValorUnitario := LQuery.FieldByName('VALOR_UNITARIO').AsCurrency;
        LAbastecimento.ValorAbastecimento := LQuery.FieldByName('VALOR_ABASTECIMENTO').AsCurrency;
        LAbastecimento.Imposto := LQuery.FieldByName('IMPOSTO').AsCurrency;
        LAbastecimento.ValorTotal := LQuery.FieldByName('VALOR_TOTAL').AsCurrency;
        LAbastecimento.DataAbastecimento := LQuery.FieldByName('DATA_ABASTECIMENTO').AsDateTime;
        Result.Add(LAbastecimento);
        LQuery.Next;
      end;
    except
      on E: Exception do
      begin
        Result.Free;
        raise Exception.Create('Erro ao obter abastecimentos por período: ' + E.Message);
      end;
    end;
  finally
    LQuery.Free;
  end;
end;

function TAbastecimentoRepository.ObterPorBomba(AIdBomba: Integer): TObjectList<TAbastecimento>;
var
  LQuery: TFDQuery;
  LAbastecimento: TAbastecimento;
begin
  Result := TObjectList<TAbastecimento>.Create;
  LQuery := TDatabaseConnection.ObterInstancia.CriarConsulta;
  try
    try
      LQuery.SQL.Text := 'SELECT * FROM ABASTECIMENTOS WHERE ID_BOMBA = :ID_BOMBA ORDER BY DATA_ABASTECIMENTO DESC';
      LQuery.Params.ParamByName('ID_BOMBA').AsInteger := AIdBomba;
      LQuery.Open;
      while not LQuery.Eof do
      begin
        LAbastecimento := TAbastecimento.Create;
        LAbastecimento.Id := LQuery.FieldByName('ID').AsInteger;
        LAbastecimento.IdBomba := LQuery.FieldByName('ID_BOMBA').AsInteger;
        LAbastecimento.QuantidadeLitros := LQuery.FieldByName('QUANTIDADE_LITROS').AsCurrency;
        LAbastecimento.ValorUnitario := LQuery.FieldByName('VALOR_UNITARIO').AsCurrency;
        LAbastecimento.ValorAbastecimento := LQuery.FieldByName('VALOR_ABASTECIMENTO').AsCurrency;
        LAbastecimento.Imposto := LQuery.FieldByName('IMPOSTO').AsCurrency;
        LAbastecimento.ValorTotal := LQuery.FieldByName('VALOR_TOTAL').AsCurrency;
        LAbastecimento.DataAbastecimento := LQuery.FieldByName('DATA_ABASTECIMENTO').AsDateTime;
        Result.Add(LAbastecimento);
        LQuery.Next;
      end;
    except
      on E: Exception do
      begin
        Result.Free;
        raise Exception.Create('Erro ao obter abastecimentos por bomba: ' + E.Message);
      end;
    end;
  finally
    LQuery.Free;
  end;
end;

function TAbastecimentoRepository.ObterRelatorioParaPeriodo(ADataInicio, ADataFim: TDateTime): TFDQuery;
begin
  Result := TDatabaseConnection.ObterInstancia.CriarConsulta;
  try
    Result.SQL.Clear;
    Result.SQL.Text :=
      'SELECT ' +
      '    BOMBAS.DESCRICAO AS Bomba, ' +
      '    ABASTECIMENTOS.DATA_ABASTECIMENTO AS DataAbastecimento, ' +
      '    TANQUES.NOME AS Tanque, ' +
      '    ABASTECIMENTOS.VALOR_ABASTECIMENTO AS Valor, ' +
      '    ABASTECIMENTOS.IMPOSTO AS Imposto, ' +
      '    ABASTECIMENTOS.VALOR_TOTAL AS ValorComImposto ' +
      'FROM ' +
      '    ABASTECIMENTOS ' +
      '    INNER JOIN BOMBAS ON ABASTECIMENTOS.ID_BOMBA = BOMBAS.ID ' +
      '    INNER JOIN TANQUES ON BOMBAS.ID_TANQUE = TANQUES.ID ' +
      'WHERE ' +
      '    ABASTECIMENTOS.DATA_ABASTECIMENTO >= :DATAINICIO ' +
      '    AND ABASTECIMENTOS.DATA_ABASTECIMENTO < :DATAFIM ' +
      'ORDER BY ' +
      '    TANQUES.NOME, ' +
      '    BOMBAS.DESCRICAO, ' +
      '    ABASTECIMENTOS.DATA_ABASTECIMENTO ' ;
    
    Result.ParamByName('DATAINICIO').AsDateTime := ADataInicio;
    Result.ParamByName('DATAFIM').AsDateTime := ADataFim + 1;
    Result.Open;
  except
    on E: Exception do
    begin
      Result.Free;
      raise Exception.Create('Erro ao obter relatório de abastecimentos: ' + E.Message);
    end;
  end;
end;

end.

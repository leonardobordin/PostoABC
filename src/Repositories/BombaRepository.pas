unit BombaRepository;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  BombaModel,
  DatabaseConnection,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param;

type
  TBombaRepository = class
  public
    constructor Create;
    destructor Destroy; override;
    function Inserir(ABomba: TBomba): Boolean;
    function Atualizar(ABomba: TBomba): Boolean;
    function Deletar(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TBomba;
    function ObterTodos: TObjectList<TBomba>;
    function ObterAtivas: TObjectList<TBomba>;
    function ObterPorTanque(AIdTanque: Integer): TObjectList<TBomba>;
  end;

implementation

constructor TBombaRepository.Create;
begin
  inherited Create;
end;

destructor TBombaRepository.Destroy;
begin
  inherited;
end;

function TBombaRepository.Inserir(ABomba: TBomba): Boolean;
var
  LQuery: TFDQuery;
begin
  LQuery := TDatabaseConnection.ObterInstancia.CriarConsulta;
  try
    try
      LQuery.SQL.Text := 'INSERT INTO BOMBAS (DESCRICAO, ID_TANQUE, STATUS) ' +
                         'VALUES (:DESCRICAO, :ID_TANQUE, :STATUS)';
      LQuery.Params.ParamByName('DESCRICAO').AsString := ABomba.Descricao;
      LQuery.Params.ParamByName('ID_TANQUE').AsInteger := ABomba.IdTanque;
      LQuery.Params.ParamByName('STATUS').AsString := ABomba.Status;
      LQuery.ExecSQL;
      Result := True;
    except
      on E: Exception do
        raise Exception.Create('Falha ao inserir bomba no banco de dados: ' + E.Message);
    end;
  finally
    LQuery.Free;
  end;
end;

function TBombaRepository.Atualizar(ABomba: TBomba): Boolean;
var
  LQuery: TFDQuery;
begin
  LQuery := TDatabaseConnection.ObterInstancia.CriarConsulta;
  try
    try
      LQuery.SQL.Text := 'UPDATE BOMBAS SET DESCRICAO = :DESCRICAO, ' +
                         'ID_TANQUE = :ID_TANQUE, STATUS = :STATUS WHERE ID = :ID';
      LQuery.Params.ParamByName('DESCRICAO').AsString := ABomba.Descricao;
      LQuery.Params.ParamByName('ID_TANQUE').AsInteger := ABomba.IdTanque;
      LQuery.Params.ParamByName('STATUS').AsString := ABomba.Status;
      LQuery.Params.ParamByName('ID').AsInteger := ABomba.Id;
      LQuery.ExecSQL;
      Result := True;
    except
      on E: Exception do
        raise Exception.Create('Falha ao deletar bomba no banco de dados: ' + E.Message);
    end;
  finally
    LQuery.Free;
  end;
end;

function TBombaRepository.Deletar(AId: Integer): Boolean;
var
  LQuery: TFDQuery;
begin
  LQuery := TDatabaseConnection.ObterInstancia.CriarConsulta;
  try
    try
      LQuery.SQL.Text := 'DELETE FROM BOMBAS WHERE ID = :ID';
      LQuery.Params.ParamByName('ID').AsInteger := AId;
      LQuery.ExecSQL;
      Result := True;
    except
      on E: Exception do
        raise Exception.Create('Falha ao deletar bomba no banco de dados: ' + E.Message);
    end;
  finally
    LQuery.Free;
  end;
end;

function TBombaRepository.ObterPorId(AId: Integer): TBomba;
var
  LQuery: TFDQuery;
begin
  Result := nil;
  LQuery := TDatabaseConnection.ObterInstancia.CriarConsulta;
  try
    try
      LQuery.SQL.Text := 'SELECT * FROM BOMBAS WHERE ID = :ID';
      LQuery.Params.ParamByName('ID').AsInteger := AId;
      LQuery.Open;
      if not LQuery.Eof then
      begin
        Result := TBomba.Create;
        Result.Id := LQuery.FieldByName('ID').AsInteger;
        Result.Descricao := LQuery.FieldByName('DESCRICAO').AsString;
        Result.IdTanque := LQuery.FieldByName('ID_TANQUE').AsInteger;
        Result.Status := LQuery.FieldByName('STATUS').AsString;
        Result.DataCriacao := LQuery.FieldByName('DATA_CRIACAO').AsDateTime;
      end;
    except
      on E: Exception do
        raise Exception.Create('Falha ao buscar bomba no banco de dados: ' + E.Message);
    end;
  finally
    LQuery.Free;
  end;
end;

function TBombaRepository.ObterTodos: TObjectList<TBomba>;
var
  LQuery: TFDQuery;
  LBomba: TBomba;
begin
  Result := TObjectList<TBomba>.Create;
  LQuery := TDatabaseConnection.ObterInstancia.CriarConsulta;
  try
    try
      LQuery.SQL.Text := 
        'SELECT ' +
        '  BOMBAS.ID, ' +
        '  BOMBAS.DESCRICAO, ' +
        '  BOMBAS.ID_TANQUE, ' +
        '  BOMBAS.STATUS, ' +
        '  BOMBAS.DATA_CRIACAO, ' +
        '  TANQUES.NOME ' +
        'FROM BOMBAS ' +
        'INNER JOIN TANQUES ON BOMBAS.ID_TANQUE = TANQUES.ID ' +
        'ORDER BY BOMBAS.ID';
      LQuery.Open;
      while not LQuery.Eof do
      begin
        LBomba := TBomba.Create;
        LBomba.Id := LQuery.FieldByName('ID').AsInteger;
        LBomba.Descricao := LQuery.FieldByName('DESCRICAO').AsString;
        LBomba.IdTanque := LQuery.FieldByName('ID_TANQUE').AsInteger;
        LBomba.Status := LQuery.FieldByName('STATUS').AsString;
        LBomba.DataCriacao := LQuery.FieldByName('DATA_CRIACAO').AsDateTime;
        LBomba.NomeTanque := LQuery.FieldByName('NOME').AsString;
        Result.Add(LBomba);
        LQuery.Next;
      end;
    except
      on E: Exception do
      begin
        Result.Free;
        raise Exception.Create('Falha ao buscar todas as bombas no banco de dados: ' + E.Message);
      end;
    end;
  finally
    LQuery.Free;
  end;
end;

function TBombaRepository.ObterAtivas: TObjectList<TBomba>;
var
  LQuery: TFDQuery;
  LBomba: TBomba;
begin
  Result := TObjectList<TBomba>.Create;
  LQuery := TDatabaseConnection.ObterInstancia.CriarConsulta;
  try
    try
      LQuery.SQL.Text := 'SELECT * FROM BOMBAS WHERE STATUS = ''ATIVA'' ORDER BY ID';
      LQuery.Open;
      while not LQuery.Eof do
      begin
        LBomba := TBomba.Create;
        LBomba.Id := LQuery.FieldByName('ID').AsInteger;
        LBomba.Descricao := LQuery.FieldByName('DESCRICAO').AsString;
        LBomba.IdTanque := LQuery.FieldByName('ID_TANQUE').AsInteger;
        LBomba.Status := LQuery.FieldByName('STATUS').AsString;
        LBomba.DataCriacao := LQuery.FieldByName('DATA_CRIACAO').AsDateTime;
        Result.Add(LBomba);
        LQuery.Next;
      end;
    except
      on E: Exception do
      begin
        Result.Free;
        raise Exception.Create('Falha ao buscar bombas ativas no banco de dados: ' + E.Message);
      end;
    end;
  finally
    LQuery.Free;
  end;
end;

function TBombaRepository.ObterPorTanque(AIdTanque: Integer): TObjectList<TBomba>;
var
  LQuery: TFDQuery;
  LBomba: TBomba;
begin
  Result := TObjectList<TBomba>.Create;
  LQuery := TDatabaseConnection.ObterInstancia.CriarConsulta;
  try
    try
      LQuery.SQL.Text := 'SELECT * FROM BOMBAS WHERE ID_TANQUE = :ID_TANQUE ORDER BY ID';
      LQuery.Params.ParamByName('ID_TANQUE').AsInteger := AIdTanque;
      LQuery.Open;
      while not LQuery.Eof do
      begin
        LBomba := TBomba.Create;
        LBomba.Id := LQuery.FieldByName('ID').AsInteger;
        LBomba.Descricao := LQuery.FieldByName('DESCRICAO').AsString;
        LBomba.IdTanque := LQuery.FieldByName('ID_TANQUE').AsInteger;
        LBomba.Status := LQuery.FieldByName('STATUS').AsString;
        LBomba.DataCriacao := LQuery.FieldByName('DATA_CRIACAO').AsDateTime;
        Result.Add(LBomba);
        LQuery.Next;
      end;
    except
      on E: Exception do
      begin
        Result.Free;
        raise Exception.Create('Falha ao buscar bombas por tanque no banco de dados: ' + E.Message);
      end;
    end;
  finally
    LQuery.Free;
  end;
end;

end.

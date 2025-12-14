unit TanqueRepository;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  TanqueModel,
  DatabaseConnection,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param;

type
  TTanqueRepository = class
  public
    constructor Create;
    destructor Destroy; override;
    function Inserir(ATanque: TTanque): Boolean;
    function Atualizar(ATanque: TTanque): Boolean;
    function AtualizarNivel(AId: Integer; ANivelAtual: Double): Boolean;
    function Deletar(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TTanque;
    function ObterTodos: TObjectList<TTanque>;
  end;

implementation

constructor TTanqueRepository.Create;
begin
  inherited Create;
end;

destructor TTanqueRepository.Destroy;
begin
  inherited;
end;

function TTanqueRepository.Inserir(ATanque: TTanque): Boolean;
var
  LQuery: TFDQuery;
begin
  LQuery := TDatabaseConnection.ObterInstancia.CriarConsulta;
  try
    try
      LQuery.SQL.Text := 'INSERT INTO TANQUES (NOME, TIPO, CAPACIDADE, NIVEL_ATUAL) ' +
                         'VALUES (:NOME, :TIPO, :CAPACIDADE, :NIVEL_ATUAL)';
      LQuery.Params.ParamByName('NOME').AsString := ATanque.Nome;
      LQuery.Params.ParamByName('TIPO').AsString := ATanque.Tipo;
      LQuery.Params.ParamByName('CAPACIDADE').AsFloat := ATanque.Capacidade;
      LQuery.Params.ParamByName('NIVEL_ATUAL').AsFloat := ATanque.NivelAtual;
      LQuery.ExecSQL;
      Result := True;
    except
      on E: Exception do
        raise Exception.Create('Falha ao inserir tanque no banco de dados: ' + E.Message);
    end;
  finally
    LQuery.Free;
  end;
end;

function TTanqueRepository.Atualizar(ATanque: TTanque): Boolean;
var
  LQuery: TFDQuery;
begin
  LQuery := TDatabaseConnection.ObterInstancia.CriarConsulta;
  try
    try
      LQuery.SQL.Text := 'UPDATE TANQUES SET NOME = :NOME, TIPO = :TIPO, ' +
                         'CAPACIDADE = :CAPACIDADE, NIVEL_ATUAL = :NIVEL_ATUAL ' +
                         'WHERE ID = :ID';
      LQuery.Params.ParamByName('NOME').AsString := ATanque.Nome;
      LQuery.Params.ParamByName('TIPO').AsString := ATanque.Tipo;
      LQuery.Params.ParamByName('CAPACIDADE').AsFloat := ATanque.Capacidade;
      LQuery.Params.ParamByName('NIVEL_ATUAL').AsFloat := ATanque.NivelAtual;
      LQuery.Params.ParamByName('ID').AsInteger := ATanque.Id;
      LQuery.ExecSQL;
      Result := True;
    except
      on E: Exception do
        raise Exception.Create('Falha ao atualizar tanque no banco de dados: ' + E.Message);
    end;
  finally
    LQuery.Free;
  end;
end;

function TTanqueRepository.AtualizarNivel(AId: Integer; ANivelAtual: Double): Boolean;
var
  LQuery: TFDQuery;
begin
  LQuery := TDatabaseConnection.ObterInstancia.CriarConsulta;
  try
    try
      LQuery.SQL.Text := 'UPDATE TANQUES SET NIVEL_ATUAL = :NIVEL_ATUAL WHERE ID = :ID';
      LQuery.Params.ParamByName('NIVEL_ATUAL').AsFloat := ANivelAtual;
      LQuery.Params.ParamByName('ID').AsInteger := AId;
      LQuery.ExecSQL;
      Result := True;
    except
      on E: Exception do
        raise Exception.Create('Falha ao atualizar nível do tanque no banco de dados: ' + E.Message);
    end;
  finally
    LQuery.Free;
  end;
end;

function TTanqueRepository.Deletar(AId: Integer): Boolean;
var
  LQuery: TFDQuery;
begin
  LQuery := TDatabaseConnection.ObterInstancia.CriarConsulta;
  try
    try
      LQuery.SQL.Text := 'DELETE FROM TANQUES WHERE ID = :ID';
      LQuery.Params.ParamByName('ID').AsInteger := AId;
      LQuery.ExecSQL;
      Result := True;
    except
      on E: Exception do
        raise Exception.Create('Falha ao deletar tanque no banco de dados: ' + E.Message);
    end;
  finally
    LQuery.Free;
  end;
end;

function TTanqueRepository.ObterPorId(AId: Integer): TTanque;
var
  LQuery: TFDQuery;
begin
  Result := nil;
  LQuery := TDatabaseConnection.ObterInstancia.CriarConsulta;
  try
    try
      LQuery.SQL.Text := 'SELECT * FROM TANQUES WHERE ID = :ID';
      LQuery.Params.ParamByName('ID').AsInteger := AId;
      LQuery.Open;
      if not LQuery.Eof then
      begin
        Result := TTanque.Create;
        Result.Id := LQuery.FieldByName('ID').AsInteger;
        Result.Nome := LQuery.FieldByName('NOME').AsString;
        Result.Tipo := LQuery.FieldByName('TIPO').AsString;
        Result.Capacidade := LQuery.FieldByName('CAPACIDADE').AsFloat;
        Result.NivelAtual := LQuery.FieldByName('NIVEL_ATUAL').AsFloat;
        Result.DataCriacao := LQuery.FieldByName('DATA_CRIACAO').AsDateTime;
      end;
    except
      on E: Exception do
        raise Exception.Create('Falha ao buscar tanque no banco de dados: ' + E.Message);
    end;
  finally
    LQuery.Free;
  end;
end;

function TTanqueRepository.ObterTodos: TObjectList<TTanque>;
var
  LQuery: TFDQuery;
  LTanque: TTanque;
begin
  Result := TObjectList<TTanque>.Create;
  LQuery := TDatabaseConnection.ObterInstancia.CriarConsulta;
  try
    try
      LQuery.SQL.Text := 'SELECT * FROM TANQUES ORDER BY ID';
      LQuery.Open;
      while not LQuery.Eof do
      begin
        LTanque := TTanque.Create;
        LTanque.Id := LQuery.FieldByName('ID').AsInteger;
        LTanque.Nome := LQuery.FieldByName('NOME').AsString;
        LTanque.Tipo := LQuery.FieldByName('TIPO').AsString;
        LTanque.Capacidade := LQuery.FieldByName('CAPACIDADE').AsFloat;
        LTanque.NivelAtual := LQuery.FieldByName('NIVEL_ATUAL').AsFloat;
        LTanque.DataCriacao := LQuery.FieldByName('DATA_CRIACAO').AsDateTime;
        Result.Add(LTanque);
        LQuery.Next;
      end;
    except
      on E: Exception do
      begin
        Result.Free;
        raise Exception.Create('Falha ao buscar todos os tanques na base de dados: ' + E.Message);
      end;
    end;
  finally
    LQuery.Free;
  end;
end;

end.

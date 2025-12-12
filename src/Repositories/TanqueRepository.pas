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
    function AtualizarDataReabastecimento(AId: Integer; ADataReabastecimento: TDateTime): Boolean;
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
      LQuery.SQL.Text := 'INSERT INTO TANQUES (NOME, TIPO, CAPACIDADE, NIVEL_ATUAL, DATA_REABASTECIMENTO) ' +
                         'VALUES (:NOME, :TIPO, :CAPACIDADE, :NIVEL_ATUAL, :DATA_REABASTECIMENTO)';
      LQuery.Params.ParamByName('NOME').AsString := ATanque.Nome;
      LQuery.Params.ParamByName('TIPO').AsString := ATanque.Tipo;
      LQuery.Params.ParamByName('CAPACIDADE').AsFloat := ATanque.Capacidade;
      LQuery.Params.ParamByName('NIVEL_ATUAL').AsFloat := ATanque.NivelAtual;
      if ATanque.DataReabastecimento > 0 then
        LQuery.Params.ParamByName('DATA_REABASTECIMENTO').AsDateTime := ATanque.DataReabastecimento
      else
        LQuery.Params.ParamByName('DATA_REABASTECIMENTO').Clear;
      LQuery.ExecSQL;
      Result := True;
    except
      on E: Exception do
        raise Exception.Create('Erro ao inserir tanque: ' + E.Message);
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
                         'CAPACIDADE = :CAPACIDADE, NIVEL_ATUAL = :NIVEL_ATUAL, ' +
                         'DATA_REABASTECIMENTO = :DATA_REABASTECIMENTO ' +
                         'WHERE ID = :ID';
      LQuery.Params.ParamByName('NOME').AsString := ATanque.Nome;
      LQuery.Params.ParamByName('TIPO').AsString := ATanque.Tipo;
      LQuery.Params.ParamByName('CAPACIDADE').AsFloat := ATanque.Capacidade;
      LQuery.Params.ParamByName('NIVEL_ATUAL').AsFloat := ATanque.NivelAtual;
      if ATanque.DataReabastecimento > 0 then
        LQuery.Params.ParamByName('DATA_REABASTECIMENTO').AsDateTime := ATanque.DataReabastecimento
      else
        LQuery.Params.ParamByName('DATA_REABASTECIMENTO').Clear;
      LQuery.Params.ParamByName('ID').AsInteger := ATanque.Id;
      LQuery.ExecSQL;
      Result := True;
    except
      on E: Exception do
        raise Exception.Create('Erro ao atualizar tanque: ' + E.Message);
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
        raise Exception.Create('Erro ao atualizar nível do tanque: ' + E.Message);
    end;
  finally
    LQuery.Free;
  end;
end;

function TTanqueRepository.AtualizarDataReabastecimento(AId: Integer; ADataReabastecimento: TDateTime): Boolean;
var
  LQuery: TFDQuery;
begin
  LQuery := TDatabaseConnection.ObterInstancia.CriarConsulta;
  try
    try
      LQuery.SQL.Text := 'UPDATE TANQUES SET DATA_REABASTECIMENTO = :DATA_REABASTECIMENTO WHERE ID = :ID';
      LQuery.Params.ParamByName('DATA_REABASTECIMENTO').AsDateTime := ADataReabastecimento;
      LQuery.Params.ParamByName('ID').AsInteger := AId;
      LQuery.ExecSQL;
      Result := True;
    except
      on E: Exception do
        raise Exception.Create('Erro ao atualizar data de reabastecimento: ' + E.Message);
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
        raise Exception.Create('Erro ao deletar tanque: ' + E.Message);
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
        if not LQuery.FieldByName('DATA_REABASTECIMENTO').IsNull then
          Result.DataReabastecimento := LQuery.FieldByName('DATA_REABASTECIMENTO').AsDateTime
        else
          Result.DataReabastecimento := 0;
        Result.DataCriacao := LQuery.FieldByName('DATA_CRIACAO').AsDateTime;
      end;
    except
      on E: Exception do
        raise Exception.Create('Erro ao obter tanque: ' + E.Message);
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
        if not LQuery.FieldByName('DATA_REABASTECIMENTO').IsNull then
          LTanque.DataReabastecimento := LQuery.FieldByName('DATA_REABASTECIMENTO').AsDateTime
        else
          LTanque.DataReabastecimento := 0;
        LTanque.DataCriacao := LQuery.FieldByName('DATA_CRIACAO').AsDateTime;
        Result.Add(LTanque);
        LQuery.Next;
      end;
    except
      on E: Exception do
      begin
        Result.Free;
        raise Exception.Create('Erro ao obter tanques: ' + E.Message);
      end;
    end;
  finally
    LQuery.Free;
  end;
end;

end.

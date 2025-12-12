unit DatabaseConnection;

interface

uses
  System.SysUtils,
  System.IniFiles,
  System.IOUtils,
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys.FB,
  FireDAC.Phys.FBDef,
  FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI,
  FireDAC.Stan.Intf,
  FireDAC.Phys,
  FireDAC.Phys.IBBase;

type
  TDatabaseConnection = class
  private
    FConexao: TFDConnection;
    class var FInstancia: TDatabaseConnection;

    constructor Create;
    procedure CarregarConfiguracao;
  public
    destructor Destroy; override;
    class function ObterInstancia: TDatabaseConnection;
    function ObterConexao: TFDConnection;
    function CriarConsulta: TFDQuery;
    procedure ConectarBanco;
    procedure DesconectarBanco;
    function EstaConectado: Boolean;
    class procedure Finalizar;
  end;

implementation

{ TDatabaseConnection }

constructor TDatabaseConnection.Create;
begin
  inherited Create;
  FConexao := TFDConnection.Create(nil);
  CarregarConfiguracao;
end;

destructor TDatabaseConnection.Destroy;
begin
  if Assigned(FConexao) then
  begin
    if FConexao.Connected then
      FConexao.Close;
    FreeAndNil(FConexao);
  end;
  inherited;
end;

class function TDatabaseConnection.ObterInstancia: TDatabaseConnection;
begin
  if not Assigned(FInstancia) then
    FInstancia := TDatabaseConnection.Create;
  Result := FInstancia;
end;

function TDatabaseConnection.ObterConexao: TFDConnection;
begin
  Result := FConexao;
end;

function TDatabaseConnection.CriarConsulta: TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := FConexao;
end;

procedure TDatabaseConnection.CarregarConfiguracao;
var
  LIniFile: TIniFile;
  LCaminhoConfig: string;
begin
  try
    LCaminhoConfig := TPath.Combine(GetCurrentDir, 'config.ini');

    if not FileExists(LCaminhoConfig) then
      raise Exception.Create('Arquivo config.ini não encontrado em: ' + LCaminhoConfig);

    LIniFile := TIniFile.Create(LCaminhoConfig);
    try
      FConexao.Params.DriverID := 'FB';
      FConexao.Params.Database := LIniFile.ReadString('Banco', 'Caminho', 'PostoABC.fdb');
      FConexao.Params.UserName := LIniFile.ReadString('Banco', 'Usuario', 'SYSDBA');
      FConexao.Params.Password := LIniFile.ReadString('Banco', 'Senha', 'masterkey');
      FConexao.Params.Values['CharacterSet'] := 'UTF8';
    finally
      LIniFile.Free;
    end;
  except
    on E: Exception do
      raise Exception.Create('Erro ao carregar configuração: ' + E.Message);
  end;
end;

class procedure TDatabaseConnection.Finalizar;
begin
  if Assigned(FInstancia) then
  begin
    FInstancia.DesconectarBanco;  // Garante desconexão antes de destruir
    FreeAndNil(FInstancia);        // FreeAndNil chama o Destructor
  end;
end;

procedure TDatabaseConnection.ConectarBanco;
begin
  try
    if not FConexao.Connected then
      FConexao.Open;
  except
    on E: Exception do
      raise Exception.Create('Erro ao conectar ao banco: ' + E.Message);
  end;
end;

procedure TDatabaseConnection.DesconectarBanco;
begin
  try
    if FConexao.Connected then
      FConexao.Close;
  except
    on E: Exception do
      raise Exception.Create('Erro ao desconectar do banco: ' + E.Message);
  end;
end;

function TDatabaseConnection.EstaConectado: Boolean;
begin
  Result := FConexao.Connected;
end;

end.

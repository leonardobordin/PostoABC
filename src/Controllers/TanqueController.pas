unit TanqueController;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  TanqueModel,
  TanqueRepository,
  BombaRepository,
  BombaModel;

type
  TTanqueController = class
  private
    FRepository: TTanqueRepository;
    FBombaRepository: TBombaRepository;

    procedure ValidarAoPersistirDados(ANome, ATipo: string; ACapacidade, ANivelAtual: Double);
  public
    constructor Create;
    destructor Destroy; override;

    function Inserir(ANome, ATipo: string; ACapacidade, ANivelAtual: Double): Boolean;
    function Atualizar(AId: Integer; ANome, ATipo: string; ACapacidade, ANivelAtual: Double): Boolean;
    function Deletar(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TTanque;
    function ObterTodos: TObjectList<TTanque>;
  end;

implementation

{ TTanqueController }

constructor TTanqueController.Create;
begin
  inherited Create;
  FRepository := TTanqueRepository.Create;
  FBombaRepository := TBombaRepository.Create;
end;

destructor TTanqueController.Destroy;
begin
  FreeAndNil(FRepository);
  FreeAndNil(FBombaRepository);
  inherited;
end;

function TTanqueController.Inserir(ANome, ATipo: string; ACapacidade, ANivelAtual: Double): Boolean;
var
  LTanque: TTanque;
begin
  ValidarAoPersistirDados(ANome, ATipo, ACapacidade, ANivelAtual);

  LTanque := TTanque.Create;
  try
    LTanque.Nome := ANome;
    LTanque.Tipo := ATipo;
    LTanque.Capacidade := ACapacidade;
    LTanque.NivelAtual := ANivelAtual;

    Result := FRepository.Inserir(LTanque);
  finally
    LTanque.Free;
  end;
end;

function TTanqueController.Atualizar(AId: Integer; ANome, ATipo: string; ACapacidade, ANivelAtual: Double): Boolean;
var
  LTanque: TTanque;
begin
  if AId <= 0 then
    raise Exception.Create('ID do tanque inválido');

  ValidarAoPersistirDados(ANome, ATipo, ACapacidade, ANivelAtual);

  LTanque := TTanque.Create;
  try
    LTanque.Id := AId;
    LTanque.Nome := ANome;
    LTanque.Tipo := ATipo;
    LTanque.Capacidade := ACapacidade;
    LTanque.NivelAtual := ANivelAtual;

    Result := FRepository.Atualizar(LTanque);
  finally
    LTanque.Free;
  end;
end;

function TTanqueController.Deletar(AId: Integer): Boolean;
var
  LBombas: TObjectList<TBomba>;
begin
  if AId <= 0 then
    raise Exception.Create('ID do tanque inválido');

  LBombas := FBombaRepository.ObterPorTanque(AId);
  try
    if Assigned(LBombas) and (LBombas.Count > 0) then
      raise Exception.Create('Não é possível deletar um tanque que possui bombas vinculadas. Você deve primeiro deletar as bombas.');

    Result := FRepository.Deletar(AId);
  finally
    LBombas.Free;
  end;
end;

function TTanqueController.ObterPorId(AId: Integer): TTanque;
begin
  if AId <= 0 then
    raise Exception.Create('ID do tanque inválido');

  Result := FRepository.ObterPorId(AId);
end;

function TTanqueController.ObterTodos: TObjectList<TTanque>;
begin
  Result := FRepository.ObterTodos;
end;

procedure TTanqueController.ValidarAoPersistirDados(ANome, ATipo: string;
  ACapacidade, ANivelAtual: Double);
begin
  if ANome = '' then
    raise Exception.Create('Nome do tanque é obrigatório');

  if ACapacidade <= 0 then
    raise Exception.Create('Capacidade deve ser maior que zero');

  if ANivelAtual < 0 then
    raise Exception.Create('Nível atual não pode ser negativo');

  if ANivelAtual > ACapacidade then
    raise Exception.Create('Nível atual não pode ser maior que a capacidade');
end;

end.

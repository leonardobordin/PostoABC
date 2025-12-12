unit BombaController;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  BombaModel,
  BombaRepository,
  AbastecimentoRepository,
  AbastecimentoModel;

type
  TBombaController = class
  private
    FRepository: TBombaRepository;
    FAbastecimentoRepository: TAbastecimentoRepository;

  public
    constructor Create;
    destructor Destroy; override;

    function Inserir(ANumero: Integer; ADescricao: string; AIdTanque: Integer; AStatus: string = 'ATIVA'): Boolean;
    function Atualizar(AId, ANumero: Integer; ADescricao: string; AIdTanque: Integer; AStatus: string): Boolean;
    function Deletar(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TBomba;
    function ObterTodos: TObjectList<TBomba>;
    function ObterAtivas: TObjectList<TBomba>;
    function ObterPorTanque(AIdTanque: Integer): TObjectList<TBomba>;
  end;

implementation

{ TBombaController }

constructor TBombaController.Create;
begin
  inherited Create;
  FRepository := TBombaRepository.Create;
  FAbastecimentoRepository := TAbastecimentoRepository.Create;
end;

destructor TBombaController.Destroy;
begin
  FreeAndNil(FRepository);
  FreeAndNil(FAbastecimentoRepository);
  inherited;
end;

function TBombaController.Inserir(ANumero: Integer; ADescricao: string; AIdTanque: Integer; AStatus: string = 'ATIVA'): Boolean;
var
  LBomba: TBomba;
begin
  if ANumero <= 0 then
    raise Exception.Create('Número da bomba é obrigatório');

  if ADescricao = '' then
    raise Exception.Create('Número de série da bomba é obrigatório');

  if AIdTanque <= 0 then
    raise Exception.Create('Tanque é obrigatório');

  LBomba := TBomba.Create;
  try
    LBomba.Numero := ANumero;
    LBomba.Descricao := ADescricao;
    LBomba.IdTanque := AIdTanque;
    LBomba.Status := AStatus;

    Result := FRepository.Inserir(LBomba);
  finally
    LBomba.Free;
  end;
end;

function TBombaController.Atualizar(AId, ANumero: Integer; ADescricao: string; AIdTanque: Integer; AStatus: string): Boolean;
var
  LBomba: TBomba;
begin
  if AId <= 0 then
    raise Exception.Create('ID da bomba inválido');

  if ANumero <= 0 then
    raise Exception.Create('Número da bomba é obrigatório');

  if ADescricao = '' then
    raise Exception.Create('Número de série da bomba é obrigatório');

  if AIdTanque <= 0 then
    raise Exception.Create('Tanque é obrigatório');

  LBomba := TBomba.Create;
  try
    LBomba.Id := AId;
    LBomba.Numero := ANumero;
    LBomba.Descricao := ADescricao;
    LBomba.IdTanque := AIdTanque;
    LBomba.Status := AStatus;

    Result := FRepository.Atualizar(LBomba);
  finally
    LBomba.Free;
  end;
end;

function TBombaController.Deletar(AId: Integer): Boolean;
var
  LAbastecimentos: TObjectList<TAbastecimento>;
begin
  if AId <= 0 then
    raise Exception.Create('ID da bomba inválido');

  // Verificar se a bomba possui abastecimentos
  LAbastecimentos := FAbastecimentoRepository.ObterPorBomba(AId);
  try
    if Assigned(LAbastecimentos) and (LAbastecimentos.Count > 0) then
      raise Exception.Create('Não é possível deletar uma bomba que já possui abastecimentos registrados. Você deve primeiro deletar os abastecimentos.');

    Result := FRepository.Deletar(AId);
  finally
    LAbastecimentos.Free;
  end;
end;

function TBombaController.ObterPorId(AId: Integer): TBomba;
begin
  if AId <= 0 then
    raise Exception.Create('ID da bomba inválido');

  Result := FRepository.ObterPorId(AId);
end;

function TBombaController.ObterTodos: TObjectList<TBomba>;
begin
  Result := FRepository.ObterTodos;
end;

function TBombaController.ObterAtivas: TObjectList<TBomba>;
begin
  Result := FRepository.ObterAtivas;
end;

function TBombaController.ObterPorTanque(AIdTanque: Integer): TObjectList<TBomba>;
begin
  if AIdTanque <= 0 then
    raise Exception.Create('ID do tanque inválido');

  Result := FRepository.ObterPorTanque(AIdTanque);
end;

end.

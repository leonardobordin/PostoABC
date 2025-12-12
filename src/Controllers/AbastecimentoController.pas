unit AbastecimentoController;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.IniFiles,
  System.IOUtils,
  AbastecimentoModel,
  AbastecimentoRepository,
  BombaRepository,
  BombaModel,
  TanqueRepository,
  TanqueModel;

type
  TAbastecimentoController = class
  private
    FRepository: TAbastecimentoRepository;
    FBombaRepository: TBombaRepository;
    FTanqueRepository: TTanqueRepository;
    FPercentualImposto: Double;

    procedure CarregarPercentualImposto;
    procedure AtualizarNivelTanque(AIdBomba: Integer; AQuantidadeLitros: Double; ADataAbastecimento: TDateTime; ASubtrair: Boolean = True);
    procedure ValidarQuantidadeDisponivel(AIdBomba: Integer; AQuantidadeLitros: Double);
  public
    constructor Create;
    destructor Destroy; override;

    function Inserir(AIdBomba: Integer; AQuantidadeLitros, AValorUnitario: Double): Boolean;
    function Deletar(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TAbastecimento;
    function ObterTodos: TObjectList<TAbastecimento>;
    function ObterPorPeriodo(ADataInicio, ADataFim: TDateTime): TObjectList<TAbastecimento>;
    function ObterPorBomba(AIdBomba: Integer): TObjectList<TAbastecimento>;
    function CalcularImposto(AValor: Double): Double;
  end;

implementation

{ TAbastecimentoController }

constructor TAbastecimentoController.Create;
begin
  inherited Create;
  FRepository := TAbastecimentoRepository.Create;
  FBombaRepository := TBombaRepository.Create;
  FTanqueRepository := TTanqueRepository.Create;
  CarregarPercentualImposto;
end;

destructor TAbastecimentoController.Destroy;
begin
  FreeAndNil(FRepository);
  FreeAndNil(FBombaRepository);
  FreeAndNil(FTanqueRepository);
  inherited;
end;

procedure TAbastecimentoController.CarregarPercentualImposto;
var
  LIniFile: TIniFile;
  LCaminhoConfig: string;
begin
  try
    LCaminhoConfig := TPath.Combine(GetCurrentDir, 'config.ini');

    if FileExists(LCaminhoConfig) then
    begin
      LIniFile := TIniFile.Create(LCaminhoConfig);
      try
        FPercentualImposto := StrToFloatDef(LIniFile.ReadString('Imposto', 'Percentual', '13'), 13);
      finally
        LIniFile.Free;
      end;
    end
    else
      FPercentualImposto := 13;
  except
    FPercentualImposto := 13;
  end;
end;

procedure TAbastecimentoController.AtualizarNivelTanque(AIdBomba: Integer; AQuantidadeLitros: Double; ADataAbastecimento: TDateTime; ASubtrair: Boolean = True);
var
  LBomba: TBomba;
  LTanque: TTanque;
  LNovoNivel: Double;
begin
  LBomba := FBombaRepository.ObterPorId(AIdBomba);
  try
    if Assigned(LBomba) and (LBomba.IdTanque > 0) then
    begin
      LTanque := FTanqueRepository.ObterPorId(LBomba.IdTanque);
      try
        if Assigned(LTanque) then
        begin
          // Só atualizar nível se o abastecimento é posterior à data de reabastecimento
          if LTanque.DataReabastecimento = 0 then
          begin
            // Sem data de reabastecimento definida, atualizar normalmente
            if ASubtrair then
            begin
              LNovoNivel := LTanque.NivelAtual - AQuantidadeLitros;
              if LNovoNivel < 0 then
                LNovoNivel := 0;
            end
            else
            begin
              LNovoNivel := LTanque.NivelAtual + AQuantidadeLitros;
              if LNovoNivel > LTanque.Capacidade then
                LNovoNivel := LTanque.Capacidade;
            end;
            
            FTanqueRepository.AtualizarNivel(LTanque.Id, LNovoNivel);
          end
          else if ADataAbastecimento > LTanque.DataReabastecimento then
          begin
            // Abastecimento é posterior ao reabastecimento, atualizar
            if ASubtrair then
            begin
              LNovoNivel := LTanque.NivelAtual - AQuantidadeLitros;
              if LNovoNivel < 0 then
                LNovoNivel := 0;
            end
            else
            begin
              LNovoNivel := LTanque.NivelAtual + AQuantidadeLitros;
              if LNovoNivel > LTanque.Capacidade then
                LNovoNivel := LTanque.Capacidade;
            end;
            
            FTanqueRepository.AtualizarNivel(LTanque.Id, LNovoNivel);
          end;
          // Se DataAbastecimento <= DataReabastecimento, não atualiza nada
        end;
      finally
        LTanque.Free;
      end;
    end;
  finally
    LBomba.Free;
  end;
end;

procedure TAbastecimentoController.ValidarQuantidadeDisponivel(AIdBomba: Integer; AQuantidadeLitros: Double);
var
  LBomba: TBomba;
  LTanque: TTanque;
begin
  LBomba := FBombaRepository.ObterPorId(AIdBomba);
  try
    if not Assigned(LBomba) then
      raise Exception.Create('Bomba não encontrada');

    if LBomba.IdTanque <= 0 then
      raise Exception.Create('Bomba não possui tanque associado');

    LTanque := FTanqueRepository.ObterPorId(LBomba.IdTanque);
    try
      if not Assigned(LTanque) then
        raise Exception.Create('Tanque não encontrado');

      if AQuantidadeLitros > LTanque.NivelAtual then
        raise Exception.CreateFmt('Quantidade insuficiente no tanque. Disponível: %.2f litros. Solicitado: %.2f litros', 
          [LTanque.NivelAtual, AQuantidadeLitros]);
    finally
      LTanque.Free;
    end;
  finally
    LBomba.Free;
  end;
end;

function TAbastecimentoController.CalcularImposto(AValor: Double): Double;
begin
  Result := (AValor * FPercentualImposto) / 100;
end;

function TAbastecimentoController.Inserir(AIdBomba: Integer; AQuantidadeLitros, AValorUnitario: Double): Boolean;
var
  LAbastecimento: TAbastecimento;
  LValorAbastecimento: Double;
  LImposto: Double;
  LValorTotal: Double;
begin
  if AIdBomba <= 0 then
    raise Exception.Create('Bomba é obrigatória');

  if AQuantidadeLitros <= 0 then
    raise Exception.Create('Quantidade de litros deve ser maior que zero');

  if AValorUnitario <= 0 then
    raise Exception.Create('Valor unitário deve ser maior que zero');

  ValidarQuantidadeDisponivel(AIdBomba, AQuantidadeLitros);

  LValorAbastecimento := AQuantidadeLitros * AValorUnitario;
  LImposto := CalcularImposto(LValorAbastecimento);
  LValorTotal := LValorAbastecimento + LImposto;

  LAbastecimento := TAbastecimento.Create;
  try
    LAbastecimento.IdBomba := AIdBomba;
    LAbastecimento.QuantidadeLitros := AQuantidadeLitros;
    LAbastecimento.ValorUnitario := AValorUnitario;
    LAbastecimento.ValorAbastecimento := LValorAbastecimento;
    LAbastecimento.Imposto := LImposto;
    LAbastecimento.ValorTotal := LValorTotal;
    LAbastecimento.DataAbastecimento := Now;

    Result := FRepository.Inserir(LAbastecimento);
    
    // Se inseriu com sucesso, atualizar o nível do tanque
    if Result then
      AtualizarNivelTanque(AIdBomba, AQuantidadeLitros, LAbastecimento.DataAbastecimento, True);
  finally
    LAbastecimento.Free;
  end;
end;

function TAbastecimentoController.Deletar(AId: Integer): Boolean;
var
  LAbastecimento: TAbastecimento;
begin
  if AId <= 0 then
    raise Exception.Create('ID do abastecimento inválido');

  // Obter os dados do abastecimento antes de deletar
  LAbastecimento := FRepository.ObterPorId(AId);
  try
    if Assigned(LAbastecimento) then
    begin
      // Deletar o abastecimento
      Result := FRepository.Deletar(AId);
      
      // Se deletou com sucesso, devolver os litros ao tanque
      if Result then
        AtualizarNivelTanque(LAbastecimento.IdBomba, LAbastecimento.QuantidadeLitros, LAbastecimento.DataAbastecimento, False);
    end
    else
      Result := False;
  finally
    LAbastecimento.Free;
  end;
end;

function TAbastecimentoController.ObterPorId(AId: Integer): TAbastecimento;
begin
  if AId <= 0 then
    raise Exception.Create('ID do abastecimento inválido');

  Result := FRepository.ObterPorId(AId);
end;

function TAbastecimentoController.ObterTodos: TObjectList<TAbastecimento>;
begin
  Result := FRepository.ObterTodos;
end;

function TAbastecimentoController.ObterPorPeriodo(ADataInicio, ADataFim: TDateTime): TObjectList<TAbastecimento>;
begin
  Result := FRepository.ObterPorPeriodo(ADataInicio, ADataFim);
end;

function TAbastecimentoController.ObterPorBomba(AIdBomba: Integer): TObjectList<TAbastecimento>;
begin
  if AIdBomba <= 0 then
    raise Exception.Create('ID da bomba inválido');

  Result := FRepository.ObterPorBomba(AIdBomba);
end;

end.

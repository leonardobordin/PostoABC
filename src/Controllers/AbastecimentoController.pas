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
  TanqueModel,
  FireDAC.Comp.Client;

type
  TAbastecimentoController = class
  private
    FRepository: TAbastecimentoRepository;
    FBombaRepository: TBombaRepository;
    FTanqueRepository: TTanqueRepository;
    FPercentualImposto: Double;

    procedure CarregarPercentualImposto;
    procedure AtualizarNivelTanque(ABomba: TBomba; AQuantidadeLitros: Double; ASubtrair: Boolean = True);
    procedure ValidarQuantidadeDisponivel(ABomba: TBomba; AQuantidadeLitros: Double);
    procedure ValidarDevolucaoAoTanque(ABomba: TBomba; AQuantidadeLitros: Double);
  public
    constructor Create;
    destructor Destroy; override;

    function Inserir(AIdBomba: Integer; AQuantidadeLitros, AValorUnitario: Double): Boolean;
    function Atualizar(AId: Integer; AIdBomba: Integer; AQuantidadeLitros, AValorUnitario: Double): Boolean;
    function Deletar(AId: Integer): Boolean;
    function ObterPorId(AId: Integer): TAbastecimento;
    function ObterTodos: TObjectList<TAbastecimento>;
    function ObterPorPeriodo(ADataInicio, ADataFim: TDateTime): TObjectList<TAbastecimento>;
    function ObterPorBomba(AIdBomba: Integer): TObjectList<TAbastecimento>;
    function ObterRelatorioParaPeriodo(ADataInicio, ADataFim: TDateTime): TFDQuery;
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

procedure TAbastecimentoController.AtualizarNivelTanque(ABomba: TBomba; AQuantidadeLitros: Double; ASubtrair: Boolean = True);
var
  LTanque: TTanque;
  LNovoNivel: Double;
begin
  try
    if Assigned(ABomba) and (ABomba.IdTanque > 0) then
    begin
      LTanque := FTanqueRepository.ObterPorId(ABomba.IdTanque);
      try
        if Assigned(LTanque) then
        begin
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
      finally
        LTanque.Free;
      end;
    end;
  finally
  end;
end;

procedure TAbastecimentoController.ValidarQuantidadeDisponivel(ABomba: TBomba; AQuantidadeLitros: Double);
var
  LTanque: TTanque;
begin
  if not Assigned(ABomba) then
    raise Exception.Create('Bomba não encontrada');

  if ABomba.IdTanque <= 0 then
    raise Exception.Create('Bomba não possui tanque associado');

  LTanque := FTanqueRepository.ObterPorId(ABomba.IdTanque);
  try
    if not Assigned(LTanque) then
      raise Exception.Create('Tanque não encontrado');

    if AQuantidadeLitros > LTanque.NivelAtual then
      raise Exception.CreateFmt('Quantidade insuficiente no tanque. Disponível: %.2f litros. Solicitado: %.2f litros', 
        [LTanque.NivelAtual, AQuantidadeLitros]);
  finally
    LTanque.Free;
  end;
end;

procedure TAbastecimentoController.ValidarDevolucaoAoTanque(ABomba: TBomba; AQuantidadeLitros: Double);
var
  LTanque: TTanque;
  LNovoNivel: Double;
begin
  if not Assigned(ABomba) then
    raise Exception.Create('Bomba não encontrada');

  if ABomba.IdTanque <= 0 then
    raise Exception.Create('Bomba não possui tanque associado');

  LTanque := FTanqueRepository.ObterPorId(ABomba.IdTanque);
  try
    if not Assigned(LTanque) then
      raise Exception.Create('Tanque não encontrado');

    LNovoNivel := LTanque.NivelAtual + AQuantidadeLitros;
    
    if LNovoNivel > LTanque.Capacidade then
      raise Exception.CreateFmt(
        'Não é possível excluir/alterar a bomba deste abastecimento.'#13#13 +
        'O nível do tanque (%s) ficaria em %.2f litros, ultrapassando a capacidade de %.2f litros.'#13#13 +
        'Ajuste manualmente o nível atual do tanque e tente novamente.',
        [LTanque.Nome, LNovoNivel, LTanque.Capacidade]);
  finally
    LTanque.Free;
  end;
end;

function TAbastecimentoController.CalcularImposto(AValor: Double): Double;
begin
  Result := (AValor * FPercentualImposto) / 100;
end;

function TAbastecimentoController.Inserir(AIdBomba: Integer; AQuantidadeLitros, AValorUnitario: Double): Boolean;
var
  LBomba: TBomba;
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

  LBomba := FBombaRepository.ObterPorId(AIdBomba);
  try
    ValidarQuantidadeDisponivel(LBomba, AQuantidadeLitros);

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
        AtualizarNivelTanque(LBomba, AQuantidadeLitros, True);
    finally
      LAbastecimento.Free;
    end;
  finally
    LBomba.Free;
  end;
end;

function TAbastecimentoController.Atualizar(AId: Integer; AIdBomba: Integer; AQuantidadeLitros, AValorUnitario: Double): Boolean;
var
  LAbastecimentoAnterior: TAbastecimento;
  LAbastecimentoNovo: TAbastecimento;
  LBombaAnterior: TBomba;
  LBombaNova: TBomba;
  LValorAbastecimento: Double;
  LImposto: Double;
  LValorTotal: Double;
  LDiferencaLitros: Double;
  LIdBombaAnterior: Integer;
  LBombaFoiTrocada: Boolean;
begin
  if AId <= 0 then
    raise Exception.Create('ID do abastecimento inválido');

  if AIdBomba <= 0 then
    raise Exception.Create('Bomba é obrigatória');

  if AQuantidadeLitros <= 0 then
    raise Exception.Create('Quantidade de litros deve ser maior que zero');

  if AValorUnitario <= 0 then
    raise Exception.Create('Valor unitário deve ser maior que zero');

  // Obter o abastecimento anterior
  LAbastecimentoAnterior := FRepository.ObterPorId(AId);
  try
    if not Assigned(LAbastecimentoAnterior) then
      raise Exception.Create('Abastecimento não encontrado');

    // Verificar se a bomba foi trocada
    LIdBombaAnterior := LAbastecimentoAnterior.IdBomba;
    LBombaFoiTrocada := (LIdBombaAnterior <> AIdBomba);

    // Calcular a diferença de litros
    LDiferencaLitros := AQuantidadeLitros - LAbastecimentoAnterior.QuantidadeLitros;

    // Obter as bombas
    LBombaAnterior := FBombaRepository.ObterPorId(LIdBombaAnterior);
    LBombaNova := FBombaRepository.ObterPorId(AIdBomba);

    try
      // Validar quantidade disponível se há aumento de litros na bomba nova
      if not LBombaFoiTrocada and (LDiferencaLitros > 0) then
      begin
        ValidarQuantidadeDisponivel(LBombaNova, LDiferencaLitros);
      end
      else if not LBombaFoiTrocada and (LDiferencaLitros < 0) then
      begin
        // Se há redução de litros (devolução ao tanque), validar se não ultrapassa capacidade
        ValidarDevolucaoAoTanque(LBombaNova, Abs(LDiferencaLitros));
      end
      else if LBombaFoiTrocada then
      begin
        // Se a bomba foi trocada, validar se há litros suficientes na nova bomba
        ValidarQuantidadeDisponivel(LBombaNova, AQuantidadeLitros);
        // E validar se a devolução na bomba anterior não ultrapassa a capacidade
        ValidarDevolucaoAoTanque(LBombaAnterior, LAbastecimentoAnterior.QuantidadeLitros);
      end;

      // Calcular novos valores
      LValorAbastecimento := AQuantidadeLitros * AValorUnitario;
      LImposto := CalcularImposto(LValorAbastecimento);
      LValorTotal := LValorAbastecimento + LImposto;

      // Criar novo objeto com os dados atualizados
      LAbastecimentoNovo := TAbastecimento.Create;
      try
        LAbastecimentoNovo.Id := AId;
        LAbastecimentoNovo.IdBomba := AIdBomba;
        LAbastecimentoNovo.QuantidadeLitros := AQuantidadeLitros;
        LAbastecimentoNovo.ValorUnitario := AValorUnitario;
        LAbastecimentoNovo.ValorAbastecimento := LValorAbastecimento;
        LAbastecimentoNovo.Imposto := LImposto;
        LAbastecimentoNovo.ValorTotal := LValorTotal;
        LAbastecimentoNovo.DataAbastecimento := LAbastecimentoAnterior.DataAbastecimento;

        Result := FRepository.Atualizar(LAbastecimentoNovo);

        // Se atualizou com sucesso, ajustar o nível do tanque
        if Result then
        begin
          if LBombaFoiTrocada then
          begin
            // Devolver a litragem anterior para a bomba anterior
            AtualizarNivelTanque(LBombaAnterior, LAbastecimentoAnterior.QuantidadeLitros, False);
            // Subtrair a nova litragem da nova bomba
            AtualizarNivelTanque(LBombaNova, AQuantidadeLitros, True);
          end
          else
          begin
            // Se não mudou de bomba, ajustar apenas a diferença na mesma bomba
            if LDiferencaLitros > 0 then
              AtualizarNivelTanque(LBombaNova, LDiferencaLitros, True)
            else if LDiferencaLitros < 0 then
              AtualizarNivelTanque(LBombaNova, Abs(LDiferencaLitros), False);
          end;
        end;
      finally
        LAbastecimentoNovo.Free;
      end;
    finally
      LBombaAnterior.Free;
      LBombaNova.Free;
    end;
  finally
    LAbastecimentoAnterior.Free;
  end;
end;

function TAbastecimentoController.Deletar(AId: Integer): Boolean;
var
  LAbastecimento: TAbastecimento;
  LBomba: TBomba;
begin
  if AId <= 0 then
    raise Exception.Create('ID do abastecimento inválido');

  // Obter os dados do abastecimento antes de deletar
  LAbastecimento := FRepository.ObterPorId(AId);
  try
    if Assigned(LAbastecimento) then
    begin
      LBomba := FBombaRepository.ObterPorId(LAbastecimento.IdBomba);
      try
        // Validar se a devolução dos litros ultrapassará a capacidade do tanque
        ValidarDevolucaoAoTanque(LBomba, LAbastecimento.QuantidadeLitros);
        
        // Deletar o abastecimento
        Result := FRepository.Deletar(AId);
        
        // Se deletou com sucesso, devolver os litros ao tanque
        if Result then
          AtualizarNivelTanque(LBomba, LAbastecimento.QuantidadeLitros, False);
      finally
        LBomba.Free;
      end;
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

function TAbastecimentoController.ObterRelatorioParaPeriodo(ADataInicio, ADataFim: TDateTime): TFDQuery;
begin
  if ADataInicio > ADataFim then
    raise Exception.Create('Data inicial não pode ser maior que data final');

  Result := FRepository.ObterRelatorioParaPeriodo(ADataInicio, ADataFim);
end;

end.

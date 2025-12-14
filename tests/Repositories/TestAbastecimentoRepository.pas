unit TestAbastecimentoRepository;

interface

uses
  DUnitX.TestFramework, AbastecimentoRepository, AbastecimentoModel, SysUtils;

type

  [TestFixture]
  TAbastecimentoRepositoryTests = class
  private
    FAbastecimentoRepository: TAbastecimentoRepository;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestCreate;
    [Test]
    procedure TestInserir;
  end;

implementation

procedure TAbastecimentoRepositoryTests.Setup;
begin
  FAbastecimentoRepository := TAbastecimentoRepository.Create;
end;

procedure TAbastecimentoRepositoryTests.TearDown;
begin
  FAbastecimentoRepository.Free;
end;

procedure TAbastecimentoRepositoryTests.TestCreate;
begin
  Assert.IsNotNull(FAbastecimentoRepository);
end;

procedure TAbastecimentoRepositoryTests.TestInserir;
var
  Abastecimento: TAbastecimento;
begin
  Abastecimento := TAbastecimento.Create;
  try
    Abastecimento.IdBomba := 1;
    Abastecimento.QuantidadeLitros := 10;
    Abastecimento.ValorUnitario := 5;
    Abastecimento.ValorAbastecimento := 50;
    Abastecimento.Imposto := 2;
    Abastecimento.ValorTotal := 52;
    try
      FAbastecimentoRepository.Inserir(Abastecimento);
      Assert.IsTrue(True, 'Inserir executado sem exceção');
    except
      on E: Exception do
        Assert.Fail('Exceção ao inserir: ' + E.Message);
    end;
  finally
    Abastecimento.Free;
  end;
end;

initialization

TDUnitX.RegisterTestFixture(TAbastecimentoRepositoryTests);

end.

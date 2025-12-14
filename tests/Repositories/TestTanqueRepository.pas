unit TestTanqueRepository;

interface

uses
  DUnitX.TestFramework, TanqueRepository, TanqueModel, SysUtils;

type

  [TestFixture]
  TTanqueRepositoryTests = class
  private
    FTanqueRepository: TTanqueRepository;
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

procedure TTanqueRepositoryTests.Setup;
begin
  FTanqueRepository := TTanqueRepository.Create;
end;

procedure TTanqueRepositoryTests.TearDown;
begin
  FTanqueRepository.Free;
end;

procedure TTanqueRepositoryTests.TestCreate;
begin
  Assert.IsNotNull(FTanqueRepository);
end;

procedure TTanqueRepositoryTests.TestInserir;
var
  Tanque: TTanque;
begin
  Tanque := TTanque.Create;
  try
    Tanque.Nome := 'Teste';
    Tanque.Tipo := 'Diesel';
    Tanque.Capacidade := 1000;
    Tanque.NivelAtual := 500;
    try
      FTanqueRepository.Inserir(Tanque);
      Assert.IsTrue(True, 'Inserir executado sem exceção');
    except
      on E: Exception do
        Assert.Fail('Exceção ao inserir: ' + E.Message);
    end;
  finally
    Tanque.Free;
  end;
end;

initialization

TDUnitX.RegisterTestFixture(TTanqueRepositoryTests);

end.

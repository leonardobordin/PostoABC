unit TestBombaRepository;

interface

uses
  DUnitX.TestFramework, BombaRepository, BombaModel, SysUtils;

type

  [TestFixture]
  TBombaRepositoryTests = class
  private
    FBombaRepository: TBombaRepository;
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

procedure TBombaRepositoryTests.Setup;
begin
  FBombaRepository := TBombaRepository.Create;
end;

procedure TBombaRepositoryTests.TearDown;
begin
  FBombaRepository.Free;
end;

procedure TBombaRepositoryTests.TestCreate;
begin
  Assert.IsNotNull(FBombaRepository);
end;

procedure TBombaRepositoryTests.TestInserir;
var
  Bomba: TBomba;
begin
  Bomba := TBomba.Create;
  try
    Bomba.Descricao := 'Teste';
    Bomba.IdTanque := 1;
    Bomba.Status := 'ATIVA';
    try
      FBombaRepository.Inserir(Bomba);
      Assert.IsTrue(True, 'Inserir executado sem exceção');
    except
      on E: Exception do
        Assert.Fail('Exceção ao inserir: ' + E.Message);
    end;
  finally
    Bomba.Free;
  end;
end;

initialization

TDUnitX.RegisterTestFixture(TBombaRepositoryTests);

end.

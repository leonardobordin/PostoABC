unit TestTanqueModel;

interface

uses
  DUnitX.TestFramework, TanqueModel, SysUtils;

type

  [TestFixture]
  TTanqueModelTests = class
  private
    FTanque: TTanque;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestCreate;
    [Test]
    procedure TestSetAndGetProperties;
  end;

implementation

procedure TTanqueModelTests.Setup;
begin
  FTanque := TTanque.Create;
end;

procedure TTanqueModelTests.TearDown;
begin
  FTanque.Free;
end;

procedure TTanqueModelTests.TestCreate;
begin
  Assert.IsNotNull(FTanque);
end;

procedure TTanqueModelTests.TestSetAndGetProperties;
begin
  FTanque.Id := 10;
  FTanque.Nome := 'Tanque Teste';
  FTanque.Tipo := 'Diesel';
  FTanque.Capacidade := 2000.0;
  FTanque.NivelAtual := 1500.0;
  FTanque.DataCriacao := Now;

  Assert.AreEqual(10, FTanque.Id);
  Assert.AreEqual('Tanque Teste', FTanque.Nome);
  Assert.AreEqual('Diesel', FTanque.Tipo);
  Assert.AreEqual<Double>(2000.0, FTanque.Capacidade);
  Assert.AreEqual<Double>(1500.0, FTanque.NivelAtual);
end;

initialization

TDUnitX.RegisterTestFixture(TTanqueModelTests);

end.

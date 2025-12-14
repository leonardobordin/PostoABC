unit TestTanqueController;

interface

uses
  DUnitX.TestFramework, TanqueController;

type

  [TestFixture]
  TTanqueControllerTests = class
  private
    FController: TTanqueController;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestCriarController;

    [Test]
    procedure TestInserirTanque;
  end;

implementation

procedure TTanqueControllerTests.Setup;
begin
  FController := TTanqueController.Create;
end;

procedure TTanqueControllerTests.TearDown;
begin
  FController.Free;
end;

procedure TTanqueControllerTests.TestCriarController;
begin
  Assert.IsNotNull(FController);
end;

procedure TTanqueControllerTests.TestInserirTanque;
begin
  Assert.IsTrue(FController.Inserir('Tanque Teste', 'Gasolina', 1000, 500));
end;

initialization

TDUnitX.RegisterTestFixture(TTanqueControllerTests);

end.

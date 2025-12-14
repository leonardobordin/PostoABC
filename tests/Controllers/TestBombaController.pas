unit TestBombaController;

interface

uses
  DUnitX.TestFramework, BombaController;

type

  [TestFixture]
  TBombaControllerTests = class
  private
    FController: TBombaController;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestCriarController;

    [Test]
    procedure TestInserirBomba;
  end;

implementation

procedure TBombaControllerTests.Setup;
begin
  FController := TBombaController.Create;
end;

procedure TBombaControllerTests.TearDown;
begin
  FController.Free;
end;

procedure TBombaControllerTests.TestCriarController;
begin
  Assert.IsNotNull(FController);
end;

procedure TBombaControllerTests.TestInserirBomba;
begin
  Assert.IsTrue(FController.Inserir('Bomba Teste', 1, 'ATIVA'));
end;

initialization

TDUnitX.RegisterTestFixture(TBombaControllerTests);

end.

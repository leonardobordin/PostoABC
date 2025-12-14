unit TestAbastecimentoController;

interface

uses
  DUnitX.TestFramework, AbastecimentoController;

type

  [TestFixture]
  TAbastecimentoControllerTests = class
  private
    FController: TAbastecimentoController;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure TestCriarController;

    [Test]
    procedure TestInserirAbastecimento;
  end;

implementation

procedure TAbastecimentoControllerTests.Setup;
begin
  FController := TAbastecimentoController.Create;
end;

procedure TAbastecimentoControllerTests.TearDown;
begin
  FController.Free;
end;

procedure TAbastecimentoControllerTests.TestCriarController;
begin
  Assert.IsNotNull(FController);
end;

procedure TAbastecimentoControllerTests.TestInserirAbastecimento;
begin
  Assert.IsTrue(FController.Inserir(1, 10, 5.5));
end;

initialization

TDUnitX.RegisterTestFixture(TAbastecimentoControllerTests);

end.

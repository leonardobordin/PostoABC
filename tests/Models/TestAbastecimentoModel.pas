unit TestAbastecimentoModel;

interface

uses
  DUnitX.TestFramework, AbastecimentoModel, SysUtils;

type

  [TestFixture]
  TAbastecimentoModelTests = class
  private
    FAbastecimento: TAbastecimento;
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

procedure TAbastecimentoModelTests.Setup;
begin
  FAbastecimento := TAbastecimento.Create;
end;

procedure TAbastecimentoModelTests.TearDown;
begin
  FAbastecimento.Free;
end;

procedure TAbastecimentoModelTests.TestCreate;
begin
  Assert.IsNotNull(FAbastecimento);
end;

procedure TAbastecimentoModelTests.TestSetAndGetProperties;
begin
  FAbastecimento.Id := 1;
  FAbastecimento.IdBomba := 2;
  FAbastecimento.QuantidadeLitros := 50.0;
  FAbastecimento.ValorUnitario := 5.5;
  FAbastecimento.ValorAbastecimento := 275.0;
  FAbastecimento.Imposto := 10.0;
  FAbastecimento.ValorTotal := 285.0;
  FAbastecimento.DataAbastecimento := Now;
  FAbastecimento.DescricaoBomba := 'Bomba 1';
  FAbastecimento.NomeTanque := 'Tanque 1';

  Assert.AreEqual(1, FAbastecimento.Id);
  Assert.AreEqual(2, FAbastecimento.IdBomba);
  Assert.AreEqual<Double>(50.0, FAbastecimento.QuantidadeLitros);
  Assert.AreEqual<Double>(5.5, FAbastecimento.ValorUnitario);
  Assert.AreEqual<Double>(275.0, FAbastecimento.ValorAbastecimento);
  Assert.AreEqual<Double>(10.0, FAbastecimento.Imposto);
  Assert.AreEqual<Double>(285.0, FAbastecimento.ValorTotal);
  Assert.AreEqual('Bomba 1', FAbastecimento.DescricaoBomba);
  Assert.AreEqual('Tanque 1', FAbastecimento.NomeTanque);
end;

initialization

TDUnitX.RegisterTestFixture(TAbastecimentoModelTests);

end.

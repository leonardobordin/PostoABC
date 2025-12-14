unit TestBombaModel;

interface

uses
  DUnitX.TestFramework, BombaModel, SysUtils;

type

  [TestFixture]
  TBombaModelTests = class
  private
    FBomba: TBomba;
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

procedure TBombaModelTests.Setup;
begin
  FBomba := TBomba.Create;
end;

procedure TBombaModelTests.TearDown;
begin
  FBomba.Free;
end;

procedure TBombaModelTests.TestCreate;
begin
  Assert.IsNotNull(FBomba);
end;

procedure TBombaModelTests.TestSetAndGetProperties;
begin
  FBomba.Id := 5;
  FBomba.Descricao := 'Bomba Teste';
  FBomba.IdTanque := 2;
  FBomba.Status := 'Ativa';
  FBomba.DataCriacao := Now;
  FBomba.NomeTanque := 'Tanque Azul';

  Assert.AreEqual(5, FBomba.Id);
  Assert.AreEqual('Bomba Teste', FBomba.Descricao);
  Assert.AreEqual(2, FBomba.IdTanque);
  Assert.AreEqual('Ativa', FBomba.Status);
  Assert.AreEqual('Tanque Azul', FBomba.NomeTanque);
end;

initialization

TDUnitX.RegisterTestFixture(TBombaModelTests);

end.

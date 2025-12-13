unit RelatorioAbastecimentoModel;

interface

uses
  SysUtils;

type
  TRelatorioAbastecimento = class
  private
    FId: Integer;
    FDataAbastecimento: TDateTime;
    FNomeTanque: string;
    FNumeroBomba: Integer;
    FDescricaoBomba: string;
    FQuantidadeLitros: Double;
    FValorUnitario: Double;
    FValorAbastecimento: Double;
    FImposto: Double;
    FValorTotal: Double;

    procedure SetId(const Value: Integer);
    procedure SetDataAbastecimento(const Value: TDateTime);
    procedure SetNomeTanque(const Value: string);
    procedure SetNumeroBomba(const Value: Integer);
    procedure SetDescricaoBomba(const Value: string);
    procedure SetQuantidadeLitros(const Value: Double);
    procedure SetValorUnitario(const Value: Double);
    procedure SetValorAbastecimento(const Value: Double);
    procedure SetImposto(const Value: Double);
    procedure SetValorTotal(const Value: Double);

    function GetId: Integer;
    function GetDataAbastecimento: TDateTime;
    function GetNomeTanque: string;
    function GetNumeroBomba: Integer;
    function GetDescricaoBomba: string;
    function GetQuantidadeLitros: Double;
    function GetValorUnitario: Double;
    function GetValorAbastecimento: Double;
    function GetImposto: Double;
    function GetValorTotal: Double;
  public
    constructor Create;
    destructor Destroy; override;

    property Id: Integer read GetId write SetId;
    property DataAbastecimento: TDateTime read GetDataAbastecimento write SetDataAbastecimento;
    property NomeTanque: string read GetNomeTanque write SetNomeTanque;
    property NumeroBomba: Integer read GetNumeroBomba write SetNumeroBomba;
    property DescricaoBomba: string read GetDescricaoBomba write SetDescricaoBomba;
    property QuantidadeLitros: Double read GetQuantidadeLitros write SetQuantidadeLitros;
    property ValorUnitario: Double read GetValorUnitario write SetValorUnitario;
    property ValorAbastecimento: Double read GetValorAbastecimento write SetValorAbastecimento;
    property Imposto: Double read GetImposto write SetImposto;
    property ValorTotal: Double read GetValorTotal write SetValorTotal;
  end;

implementation

{ TRelatorioAbastecimento }

constructor TRelatorioAbastecimento.Create;
begin
  inherited Create;
  FId := 0;
  FDataAbastecimento := Now;
  FNomeTanque := '';
  FNumeroBomba := 0;
  FDescricaoBomba := '';
  FQuantidadeLitros := 0;
  FValorUnitario := 0;
  FValorAbastecimento := 0;
  FImposto := 0;
  FValorTotal := 0;
end;

destructor TRelatorioAbastecimento.Destroy;
begin
  inherited;
end;

procedure TRelatorioAbastecimento.SetId(const Value: Integer);
begin
  FId := Value;
end;

function TRelatorioAbastecimento.GetId: Integer;
begin
  Result := FId;
end;

procedure TRelatorioAbastecimento.SetDataAbastecimento(const Value: TDateTime);
begin
  FDataAbastecimento := Value;
end;

function TRelatorioAbastecimento.GetDataAbastecimento: TDateTime;
begin
  Result := FDataAbastecimento;
end;

procedure TRelatorioAbastecimento.SetNomeTanque(const Value: string);
begin
  FNomeTanque := Value;
end;

function TRelatorioAbastecimento.GetNomeTanque: string;
begin
  Result := FNomeTanque;
end;

procedure TRelatorioAbastecimento.SetNumeroBomba(const Value: Integer);
begin
  FNumeroBomba := Value;
end;

function TRelatorioAbastecimento.GetNumeroBomba: Integer;
begin
  Result := FNumeroBomba;
end;

procedure TRelatorioAbastecimento.SetDescricaoBomba(const Value: string);
begin
  FDescricaoBomba := Value;
end;

function TRelatorioAbastecimento.GetDescricaoBomba: string;
begin
  Result := FDescricaoBomba;
end;

procedure TRelatorioAbastecimento.SetQuantidadeLitros(const Value: Double);
begin
  FQuantidadeLitros := Value;
end;

function TRelatorioAbastecimento.GetQuantidadeLitros: Double;
begin
  Result := FQuantidadeLitros;
end;

procedure TRelatorioAbastecimento.SetValorUnitario(const Value: Double);
begin
  FValorUnitario := Value;
end;

function TRelatorioAbastecimento.GetValorUnitario: Double;
begin
  Result := FValorUnitario;
end;

procedure TRelatorioAbastecimento.SetValorAbastecimento(const Value: Double);
begin
  FValorAbastecimento := Value;
end;

function TRelatorioAbastecimento.GetValorAbastecimento: Double;
begin
  Result := FValorAbastecimento;
end;

procedure TRelatorioAbastecimento.SetImposto(const Value: Double);
begin
  FImposto := Value;
end;

function TRelatorioAbastecimento.GetImposto: Double;
begin
  Result := FImposto;
end;

procedure TRelatorioAbastecimento.SetValorTotal(const Value: Double);
begin
  FValorTotal := Value;
end;

function TRelatorioAbastecimento.GetValorTotal: Double;
begin
  Result := FValorTotal;
end;

end.

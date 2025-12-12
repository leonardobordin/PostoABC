unit AbastecimentoModel;

interface

uses
  SysUtils;

type
  TAbastecimento = class
  private
    FId: Integer;
    FIdBomba: Integer;
    FQuantidadeLitros: Double;
    FValorUnitario: Double;
    FValorAbastecimento: Double;
    FImposto: Double;
    FValorTotal: Double;
    FDataAbastecimento: TDateTime;

    procedure SetId(const Value: Integer);
    procedure SetIdBomba(const Value: Integer);
    procedure SetQuantidadeLitros(const Value: Double);
    procedure SetValorUnitario(const Value: Double);
    procedure SetValorAbastecimento(const Value: Double);
    procedure SetImposto(const Value: Double);
    procedure SetValorTotal(const Value: Double);
    procedure SetDataAbastecimento(const Value: TDateTime);

    function GetId: Integer;
    function GetIdBomba: Integer;
    function GetQuantidadeLitros: Double;
    function GetValorUnitario: Double;
    function GetValorAbastecimento: Double;
    function GetImposto: Double;
    function GetValorTotal: Double;
    function GetDataAbastecimento: TDateTime;
  public
    constructor Create;
    destructor Destroy; override;

    property Id: Integer read GetId write SetId;
    property IdBomba: Integer read GetIdBomba write SetIdBomba;
    property QuantidadeLitros: Double read GetQuantidadeLitros write SetQuantidadeLitros;
    property ValorUnitario: Double read GetValorUnitario write SetValorUnitario;
    property ValorAbastecimento: Double read GetValorAbastecimento write SetValorAbastecimento;
    property Imposto: Double read GetImposto write SetImposto;
    property ValorTotal: Double read GetValorTotal write SetValorTotal;
    property DataAbastecimento: TDateTime read GetDataAbastecimento write SetDataAbastecimento;
  end;

implementation

{ TAbastecimento }

constructor TAbastecimento.Create;
begin
  inherited Create;
  FId := 0;
  FIdBomba := 0;
  FQuantidadeLitros := 0;
  FValorUnitario := 0;
  FValorAbastecimento := 0;
  FImposto := 0;
  FValorTotal := 0;
  FDataAbastecimento := Now;
end;

destructor TAbastecimento.Destroy;
begin
  inherited;
end;

procedure TAbastecimento.SetId(const Value: Integer);
begin
  FId := Value;
end;

function TAbastecimento.GetId: Integer;
begin
  Result := FId;
end;

procedure TAbastecimento.SetIdBomba(const Value: Integer);
begin
  FIdBomba := Value;
end;

function TAbastecimento.GetIdBomba: Integer;
begin
  Result := FIdBomba;
end;

procedure TAbastecimento.SetQuantidadeLitros(const Value: Double);
begin
  FQuantidadeLitros := Value;
end;

function TAbastecimento.GetQuantidadeLitros: Double;
begin
  Result := FQuantidadeLitros;
end;

procedure TAbastecimento.SetValorUnitario(const Value: Double);
begin
  FValorUnitario := Value;
end;

function TAbastecimento.GetValorUnitario: Double;
begin
  Result := FValorUnitario;
end;

procedure TAbastecimento.SetValorAbastecimento(const Value: Double);
begin
  FValorAbastecimento := Value;
end;

function TAbastecimento.GetValorAbastecimento: Double;
begin
  Result := FValorAbastecimento;
end;

procedure TAbastecimento.SetImposto(const Value: Double);
begin
  FImposto := Value;
end;

function TAbastecimento.GetImposto: Double;
begin
  Result := FImposto;
end;

procedure TAbastecimento.SetValorTotal(const Value: Double);
begin
  FValorTotal := Value;
end;

function TAbastecimento.GetValorTotal: Double;
begin
  Result := FValorTotal;
end;

procedure TAbastecimento.SetDataAbastecimento(const Value: TDateTime);
begin
  FDataAbastecimento := Value;
end;

function TAbastecimento.GetDataAbastecimento: TDateTime;
begin
  Result := FDataAbastecimento;
end;

end.

unit BombaModel;

interface

uses
  SysUtils;

type
  TBomba = class
  private
    FId: Integer;
    FNumero: Integer;
    FDescricao: string;
    FIdTanque: Integer;
    FStatus: string;
    FDataCriacao: TDateTime;

    procedure SetId(const Value: Integer);
    procedure SetNumero(const Value: Integer);
    procedure SetDescricao(const Value: string);
    procedure SetIdTanque(const Value: Integer);
    procedure SetStatus(const Value: string);
    procedure SetDataCriacao(const Value: TDateTime);

    function GetId: Integer;
    function GetNumero: Integer;
    function GetDescricao: string;
    function GetIdTanque: Integer;
    function GetStatus: string;
    function GetDataCriacao: TDateTime;
  public
    constructor Create;
    destructor Destroy; override;

    property Id: Integer read GetId write SetId;
    property Numero: Integer read GetNumero write SetNumero;
    property Descricao: string read GetDescricao write SetDescricao;
    property IdTanque: Integer read GetIdTanque write SetIdTanque;
    property Status: string read GetStatus write SetStatus;
    property DataCriacao: TDateTime read GetDataCriacao write SetDataCriacao;
  end;

implementation

{ TBomba }

constructor TBomba.Create;
begin
  inherited Create;
  FId := 0;
  FNumero := 0;
  FDescricao := '';
  FIdTanque := 0;
  FStatus := 'ATIVA';
  FDataCriacao := Now;
end;

destructor TBomba.Destroy;
begin
  inherited;
end;

procedure TBomba.SetId(const Value: Integer);
begin
  FId := Value;
end;

function TBomba.GetId: Integer;
begin
  Result := FId;
end;

procedure TBomba.SetNumero(const Value: Integer);
begin
  FNumero := Value;
end;

function TBomba.GetNumero: Integer;
begin
  Result := FNumero;
end;

procedure TBomba.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

function TBomba.GetDescricao: string;
begin
  Result := FDescricao;
end;

procedure TBomba.SetIdTanque(const Value: Integer);
begin
  FIdTanque := Value;
end;

function TBomba.GetIdTanque: Integer;
begin
  Result := FIdTanque;
end;

procedure TBomba.SetStatus(const Value: string);
begin
  FStatus := Value;
end;

function TBomba.GetStatus: string;
begin
  Result := FStatus;
end;

procedure TBomba.SetDataCriacao(const Value: TDateTime);
begin
  FDataCriacao := Value;
end;

function TBomba.GetDataCriacao: TDateTime;
begin
  Result := FDataCriacao;
end;

end.

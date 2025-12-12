unit TanqueModel;

interface

uses
  SysUtils;

type
  TTanque = class
  private
    FId: Integer;
    FNome: string;
    FTipo: string;
    FCapacidade: Double;
    FNivelAtual: Double;
    FDataReabastecimento: TDateTime;
    FDataCriacao: TDateTime;

    procedure SetId(const Value: Integer);
    procedure SetNome(const Value: string);
    procedure SetTipo(const Value: string);
    procedure SetCapacidade(const Value: Double);
    procedure SetNivelAtual(const Value: Double);
    procedure SetDataReabastecimento(const Value: TDateTime);
    procedure SetDataCriacao(const Value: TDateTime);

    function GetId: Integer;
    function GetNome: string;
    function GetTipo: string;
    function GetCapacidade: Double;
    function GetNivelAtual: Double;
    function GetDataReabastecimento: TDateTime;
    function GetDataCriacao: TDateTime;
  public
    constructor Create;
    destructor Destroy; override;

    property Id: Integer read GetId write SetId;
    property Nome: string read GetNome write SetNome;
    property Tipo: string read GetTipo write SetTipo;
    property Capacidade: Double read GetCapacidade write SetCapacidade;
    property NivelAtual: Double read GetNivelAtual write SetNivelAtual;
    property DataReabastecimento: TDateTime read GetDataReabastecimento write SetDataReabastecimento;
    property DataCriacao: TDateTime read GetDataCriacao write SetDataCriacao;
  end;

implementation

{ TTanque }

constructor TTanque.Create;
begin
  inherited Create;
  FId := 0;
  FNome := '';
  FTipo := '';
  FCapacidade := 0;
  FNivelAtual := 0;
  FDataReabastecimento := 0;
  FDataCriacao := Now;
end;

destructor TTanque.Destroy;
begin
  inherited;
end;

procedure TTanque.SetId(const Value: Integer);
begin
  FId := Value;
end;

function TTanque.GetId: Integer;
begin
  Result := FId;
end;

procedure TTanque.SetNome(const Value: string);
begin
  FNome := Value;
end;

function TTanque.GetNome: string;
begin
  Result := FNome;
end;

procedure TTanque.SetTipo(const Value: string);
begin
  FTipo := Value;
end;

function TTanque.GetTipo: string;
begin
  Result := FTipo;
end;

procedure TTanque.SetCapacidade(const Value: Double);
begin
  FCapacidade := Value;
end;

function TTanque.GetCapacidade: Double;
begin
  Result := FCapacidade;
end;

procedure TTanque.SetNivelAtual(const Value: Double);
begin
  FNivelAtual := Value;
end;

function TTanque.GetNivelAtual: Double;
begin
  Result := FNivelAtual;
end;

procedure TTanque.SetDataReabastecimento(const Value: TDateTime);
begin
  FDataReabastecimento := Value;
end;

function TTanque.GetDataReabastecimento: TDateTime;
begin
  Result := FDataReabastecimento;
end;

procedure TTanque.SetDataCriacao(const Value: TDateTime);
begin
  FDataCriacao := Value;
end;

function TTanque.GetDataCriacao: TDateTime;
begin
  Result := FDataCriacao;
end;

end.

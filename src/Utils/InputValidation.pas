unit InputValidation;

interface

uses
  System.SysUtils,
  Vcl.StdCtrls;

type
  TInputValidation = class
  public
    class procedure ValidarInteiro(Sender: TObject; var Key: Char);
    class procedure ValidarDecimal(Sender: TObject; var Key: Char);
    class procedure ValidarTexto(Sender: TObject; var Key: Char; AMaxLength: Integer);
  end;

implementation

{ TInputValidation }

class procedure TInputValidation.ValidarInteiro(Sender: TObject; var Key: Char);
begin
  if not (Sender is TEdit) then
    Exit;

  // Permitir apenas dígitos e controles (Backspace, Tab, Escape)
  if not CharInSet(Key, ['0'..'9', #8, #9, #27]) then
    Key := #0; // Cancelar a digitação
end;

class procedure TInputValidation.ValidarDecimal(Sender: TObject; var Key: Char);
var
  LEdit: TEdit;
  LText: string;
  LPos: Integer;
begin
  if not (Sender is TEdit) then
    Exit;

  LEdit := TEdit(Sender);

  // Permitir apenas dígitos, vírgula e controles
  if not CharInSet(Key, ['0'..'9', ',', #8, #9, #27]) then
  begin
    Key := #0;
    Exit;
  end;

  // Se for vírgula, verificar se já existe uma
  if Key = ',' then
  begin
    LText := LEdit.Text;
    LPos := Pos(',', LText);
    if LPos > 0 then
      Key := #0; // Cancela se já existe vírgula
    Exit;
  end;

  // Limitar a 2 casas decimais após a vírgula
  if CharInSet(Key, ['0'..'9']) then
  begin
    LText := LEdit.Text;
    LPos := Pos(',', LText);
    if LPos > 0 then
    begin
      // Se há vírgula e já tem 2 dígitos após ela
      if Length(LText) - LPos >= 2 then
        Key := #0; // Cancela a digitação
    end;
  end;
end;

class procedure TInputValidation.ValidarTexto(Sender: TObject; var Key: Char;
  AMaxLength: Integer);
var
  LEdit: TEdit;
begin
  if not (Sender is TEdit) then
    Exit;

  LEdit := TEdit(Sender);

  // Bloquear digitação se atingiu o máximo
  if not CharInSet(Key, [#8, #9, #27]) then
  begin
    if Length(LEdit.Text) >= AMaxLength then
      Key := #0; // Cancelar a digitação
  end;
end;

end.

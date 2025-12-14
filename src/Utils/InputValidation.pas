unit InputValidation;

interface

uses
  System.SysUtils,
  Vcl.StdCtrls;

type
  TInputValidation = class
  public
    class procedure ValidarDecimal(Sender: TObject; var Key: Char; AMaxInteiros: Integer = 9; AMaxDecimais: Integer = 2);
    class procedure ValidarTexto(Sender: TObject; var Key: Char; AMaxLength: Integer);
  end;

implementation

{ TInputValidation }

class procedure TInputValidation.ValidarDecimal(Sender: TObject; var Key: Char; AMaxInteiros: Integer = 9; AMaxDecimais: Integer = 2);
var
  LEdit: TEdit;
  LText: string;
  LPos: Integer;
  LParteDecimal: string;
begin
  if not (Sender is TEdit) then
    Exit;

  LEdit := TEdit(Sender);

  // Permitir atalhos de teclado (Ctrl+A, Ctrl+X, Ctrl+C, Ctrl+V, Delete, Backspace, Tab, Escape)
  if CharInSet(Key, [#1..#8, #9, #22, #24, #26, #27]) then
    Exit;

  // Permitir apenas dígitos, vírgula e controles
  if not CharInSet(Key, ['0'..'9', ',', '.', #8, #9, #27, #46]) then
  begin
    Key := #0;
    Exit;
  end;

  // Converter ponto para vírgula (aceitar ambos)
  if Key = '.' then
    Key := ',';

  // Se for vírgula, verificar se já existe uma
  if Key = ',' then
  begin
    LText := LEdit.Text;
    LPos := Pos(',', LText);
    if LPos > 0 then
      Key := #0; // Cancela se já existe vírgula
    Exit;
  end;

  // Limitar a AMaxInteiros dígitos inteiros e AMaxDecimais casas decimais
  if CharInSet(Key, ['0'..'9']) then
  begin
    LText := LEdit.Text;
    LPos := Pos(',', LText);
    
    if LPos > 0 then
    begin
      // Se há vírgula, limitar a AMaxDecimais dígitos após ela
      LParteDecimal := Copy(LText, LPos + 1, Length(LText));
      if Length(LParteDecimal) >= AMaxDecimais then
        Key := #0; // Cancela a digitação
    end
    else
    begin
      // Se não há vírgula, limitar a AMaxInteiros dígitos inteiros
      if Length(LText) >= AMaxInteiros then
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

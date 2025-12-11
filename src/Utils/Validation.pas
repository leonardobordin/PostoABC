unit Validation;

interface

uses
  System.SysUtils, System.RegularExpressions;

type
  EValidationException = class(Exception);

  TValidation = class
  public
    class procedure ValidateEmail(const Email: string);
    class procedure ValidatePassword(const Password: string);
    class procedure ValidateName(const Name: string);
  end;

implementation

class procedure TValidation.ValidateEmail(const Email: string);
const
  EMAIL_REGEX = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
begin
  if not TRegEx.IsMatch(Email, EMAIL_REGEX) then
    raise EValidationException.Create('Formato de e-mail inválido.');
end;

class procedure TValidation.ValidatePassword(const Password: string);
begin
  if (Length(Password) < 8) or not TRegEx.IsMatch(Password, '[A-Za-z]') or
    not TRegEx.IsMatch(Password, '\d') then
    raise EValidationException.Create
      ('A senha deve ter pelo menos 8 caracteres e conter letras e números.');
end;

class procedure TValidation.ValidateName(const Name: string);
const
  NAME_REGEX = '^[A-Za-zÀ-ÖØ-öø-ÿ\s]+$';
begin
  if (Name.Trim = '') or not TRegEx.IsMatch(Name, NAME_REGEX) then
    raise EValidationException.Create
      ('Nome inválido. O nome não pode ser vazio nem conter numeros ou caracteres especiais.');
end;

end.

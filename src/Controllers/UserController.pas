unit UserController;

interface

uses
  UserModel, UserRepository, Validation, SysUtils;

type
  TUserController = class
  public
    class function RegisterUser(Name, Email, Password: string): Boolean;
    class function Login(Email, Password: string): Boolean;
  end;

implementation

class function TUserController.RegisterUser(Name, Email,
  Password: string): Boolean;
var
  NewUser: TUser;
begin
  TValidation.ValidateName(Name);
  TValidation.ValidateEmail(Email);
  TValidation.ValidatePassword(Password);

  NewUser := TUser.Create;
  try
    NewUser.Name := Name;
    NewUser.Email := Email;
    NewUser.Password := Password;
    Result := TUserRepository.Register(NewUser);
  finally
    NewUser.Free;
  end;
end;

class function TUserController.Login(Email, Password: string): Boolean;
begin
  Result := TUserRepository.Authenticate(Email, Password);
end;

end.

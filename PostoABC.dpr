program PostoABC;

uses
  Vcl.Forms,
  System.UITypes,
  LoginSystemView in 'src\View\LoginSystemView.pas' {frmLogin},
  Vcl.Themes,
  Vcl.Styles,
  UserController in 'src\Controllers\UserController.pas',
  DatabaseConnection in 'src\Database\DatabaseConnection.pas',
  UserModel in 'src\Models\UserModel.pas',
  UserRepository in 'src\Models\UserRepository.pas',
  Validation in 'src\Utils\Validation.pas',
  MainScreenView in 'src\View\MainScreenView.pas' {frmMainScreen};

{$R *.res}

var
  LoginSuccess: Boolean;
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  // Criar tela de login primeiro
  Application.CreateForm(TfrmLogin, frmLogin);
  LoginSuccess := frmLogin.ShowModal = mrOk;
  frmLogin.Free;

  if LoginSuccess then
  begin
    Application.CreateForm(TfrmMainScreen, frmMainScreen);
    Application.Run;
  end
  else
    Application.Terminate;
end.

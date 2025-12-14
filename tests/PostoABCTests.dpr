program PostoABCTests;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  System.SysUtils,
  DUnitX.TestFramework,
  DUnitX.Loggers.Console,
  FireDAC.DApt,
  // Model
  TestTanqueModel in 'Models\TestTanqueModel.pas',
  TanqueModel in '..\src\Models\TanqueModel.pas',
  TestBombaModel in 'Models\TestBombaModel.pas',
  BombaModel in '..\src\Models\BombaModel.pas',
  TestAbastecimentoModel in 'Models\TestAbastecimentoModel.pas',
  AbastecimentoModel in '..\src\Models\AbastecimentoModel.pas',

  InputValidation in '..\src\Utils\InputValidation.pas',
  DatabaseConnection in '..\src\Database\DatabaseConnection.pas',
  // Repositories
  TestTanqueRepository in 'Repositories\TestTanqueRepository.pas',
  TanqueRepository in '..\src\Repositories\TanqueRepository.pas',
  TestBombaRepository in 'Repositories\TestBombaRepository.pas',
  BombaRepository in '..\src\Repositories\BombaRepository.pas',
  TestAbastecimentoRepository in 'Repositories\TestAbastecimentoRepository.pas',
  AbastecimentoRepository in '..\src\Repositories\AbastecimentoRepository.pas',
  // Controllers
  TestTanqueController in 'Controllers\TestTanqueController.pas',
  TanqueController in '..\src\Controllers\TanqueController.pas',
  TestBombaController in 'Controllers\TestBombaController.pas',
  BombaController in '..\src\Controllers\BombaController.pas',
  TestAbastecimentoController in 'Controllers\TestAbastecimentoController.pas',
  AbastecimentoController in '..\src\Controllers\AbastecimentoController.pas';

var
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;

begin
{$IFDEF TESTINSIGHT}
  TestInsight4.DUnitX.RunRegisteredTests;
  exit;
{$ENDIF}
  try
    TDUnitX.CheckCommandLine;
    runner := TDUnitX.CreateRunner;
    logger := TDUnitXConsoleLogger.Create(true);
    runner.AddLogger(logger);
    results := runner.Execute;

    if not results.AllPassed then
      System.ExitCode := 1;

    System.Write('Done.. press <Enter> to quit.');
    System.Readln;
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;

end.

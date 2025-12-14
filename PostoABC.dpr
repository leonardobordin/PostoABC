program PostoABC;

uses
  Vcl.Forms,
  Winapi.Windows,
  System.SysUtils,
  FireDAC.DApt,
  MainForm in 'src\Views\MainForm.pas' {frmMain},
  DatabaseConnection in 'src\Database\DatabaseConnection.pas',
  TanqueModel in 'src\Models\TanqueModel.pas',
  BombaModel in 'src\Models\BombaModel.pas',
  AbastecimentoModel in 'src\Models\AbastecimentoModel.pas',
  TanqueRepository in 'src\Repositories\TanqueRepository.pas',
  BombaRepository in 'src\Repositories\BombaRepository.pas',
  AbastecimentoRepository in 'src\Repositories\AbastecimentoRepository.pas',
  TanqueController in 'src\Controllers\TanqueController.pas',
  BombaController in 'src\Controllers\BombaController.pas',
  AbastecimentoController in 'src\Controllers\AbastecimentoController.pas',
  TanqueForm in 'src\Views\TanqueForm.pas' {frmTanque},
  BombaForm in 'src\Views\BombaForm.pas' {frmBomba},
  AbastecimentoForm in 'src\Views\AbastecimentoForm.pas' {frmAbastecimento},
  RelatorioAbastecimentosForm in 'src\Views\RelatorioAbastecimentosForm.pas' {frmRelatorioAbastecimentos},
  RelatorioExibicaoForm in 'src\Views\RelatorioExibicaoForm.pas' {frmRelatorioExibicao},
  InputValidation in 'src\Utils\InputValidation.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  //ReportMemoryLeaksOnShutdown := True;
  Application.Title := 'Posto ABC';
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Amakrits');
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

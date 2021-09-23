program Exemplo;

uses
  Vcl.Forms,
  Principal in 'Principal.pas' {FPrincipal},
  WTSApi in 'WTSApi.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFPrincipal, FPrincipal);
  Application.Run;
end.

program TesteEsc;

uses
  Forms,
  Main in 'Main.pas' {FTesteEsc};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Teste de Escuta';
  Application.CreateForm(TFTesteEsc, FTesteEsc);
  Application.Run;
end.

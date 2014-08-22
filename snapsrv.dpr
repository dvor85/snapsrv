program snapsrv;

uses
  Forms,
  Main in 'Main.pas'; {MForm1}

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMForm1, MForm1);
  Application.Run;
end.


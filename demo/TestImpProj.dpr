program TestImpProj;

uses
  Forms,
  TestImpUnit in 'TestImpUnit.pas' {DllImportTestForm},
  ImpImpTestDll in 'ImpImpTestDll.pas',
  ExpImpTestDll in 'ExpImpTestDll.pas',
  DynLinkTest in 'DynLinkTest.pas',
  {$IF CompilerVersion >= 21.00}
  uFxtDelayedHandler in '..\uFxtDelayedHandler.pas',
  {$IFEND}
  HVHeaps in '..\HVHeaps.pas',
  HVDll in '..\HVDll.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TDllImportTestForm, DllImportTestForm);
  Application.Run;
end.

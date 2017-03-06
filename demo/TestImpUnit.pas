unit TestImpUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, HVDll;

type
  TDllImportTestForm = class(TForm)
    rgImportMethod: TRadioGroup;
    gbCallProcs: TGroupBox;
    btnRoutine1: TButton;
    btnRoutine2: TButton;
    btnRoutine3: TButton;
    btnRoutine4: TButton;
    gbLogging: TGroupBox;
    LoggingMemo: TMemo;
    gbHVDll: TGroupBox;
    btnLoadDll: TButton;
    btnUnloadDll: TButton;
    btnHook: TButton;
    btnUnhook: TButton;
    procedure btnRoutine1Click(Sender: TObject);
    procedure btnRoutine2Click(Sender: TObject);
    procedure btnRoutine3Click(Sender: TObject);
    procedure btnRoutine4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnUnloadDllClick(Sender: TObject);
    procedure btnLoadDllClick(Sender: TObject);
    procedure btnHookClick(Sender: TObject);
    procedure btnUnhookClick(Sender: TObject);
  private
    procedure DllNotify(Sender: TDll; Action: TDllNotifyAction; Index: integer);
    procedure Log(const Msg: string; Args: array of const);
  end;

var
  DllImportTestForm: TDllImportTestForm;

implementation

{$R *.DFM}

uses
  ImpImpTestDll,
  ExpImpTestDll,
  DynLinkTest;

const
  ImplicitIdx = 0;
  ExplicitIdx = 1;
  HVDllIdx    = 2;

procedure TDllImportTestForm.FormCreate(Sender: TObject);
begin
  Dlls.OnDllNotify := Self.DllNotify;
end;

procedure TDllImportTestForm.FormDestroy(Sender: TObject);
begin
  Dlls.OnDllNotify := nil;
end;

procedure TDllImportTestForm.btnRoutine1Click(Sender: TObject);
begin
  case rgImportMethod.ItemIndex of
    ImplicitIdx : ImpImpTestDll.Routine1(1, 11, 111, 1111);
    ExplicitIdx : ExpImpTestDll.Routine1(1, 11, 111, 1111);
    HVDllIdx    : DynLinkTest  .Routine1(1, 11, 111, 1111);
  end;
end;

procedure TDllImportTestForm.btnRoutine2Click(Sender: TObject);
begin
  case rgImportMethod.ItemIndex of
    ImplicitIdx : ImpImpTestDll.Routine2(2, 22, 222, 2222);
    ExplicitIdx : ExpImpTestDll.Routine2(2, 22, 222, 2222);
    HVDllIdx    : DynLinkTest  .Routine2(2, 22, 222, 2222);
  end;
end;

procedure TDllImportTestForm.btnRoutine3Click(Sender: TObject);
begin
  case rgImportMethod.ItemIndex of
    ImplicitIdx : ImpImpTestDll.Routine3(3, 33, 333, 3333);
    ExplicitIdx : ExpImpTestDll.Routine3(3, 33, 333, 3333);
    HVDllIdx    : DynLinkTest  .Routine3(3, 33, 333, 3333);
  end;
end;

procedure TDllImportTestForm.btnRoutine4Click(Sender: TObject);
begin
  case rgImportMethod.ItemIndex of
    ImplicitIdx : ImpImpTestDll.Routine4(4, 44, 444, 4444);
    ExplicitIdx : ExpImpTestDll.Routine4(4, 44, 444, 4444);
    HVDllIdx    : DynLinkTest  .Routine4(4, 44, 444, 4444);
  end;
end;

procedure TDllImportTestForm.Log(const Msg: string; Args: array of const);
begin
  LoggingMemo.Lines.Add(Format(Msg, Args));
end;

procedure TDllImportTestForm.DllNotify(Sender: TDll; Action: TDllNotifyAction; Index: integer);
begin
  case Action of
    daLoadedDll:     Log('Loaded %s', [Sender.FullPath]);
    daUnloadedDll:   Log('Unloaded %s', [Sender.FullPath]);
    daLinkedRoutine: Log('Linked %s.%s', [Sender.FullPath, Sender.EntryName[Index]]);
  end;
end;

procedure TDllImportTestForm.btnUnloadDllClick(Sender: TObject);
begin
  TestDll.Unload;
end;

procedure TDllImportTestForm.btnLoadDllClick(Sender: TObject);
begin
  TestDll.Load;
end;

var
  OldRoutine1 : procedure (A, B, C, D: integer); register;

procedure HookedRoutine1(A, B, C, D: integer); register;
begin
  DllImportTestForm.Log('Hooked Routine1 before (%d, %d, %d, %d)', [A, B, C, D]);
  OldRoutine1(A+1, B+1, C+1, D+1);
  DllImportTestForm.Log('Hooked Routine1 after (%d, %d, %d, %d)', [A, B, C, D]);
end;

procedure TDllImportTestForm.btnHookClick(Sender: TObject);
begin
  if TestDll.HookRoutine(@@DynLinkTest.Routine1, @HookedRoutine1, OldRoutine1) then
  begin
    btnHook.Enabled := false;
    btnUnhook.Enabled := true;
  end;
end;

procedure TDllImportTestForm.btnUnhookClick(Sender: TObject);
begin
  if TestDll.UnHookRoutine(@@DynLinkTest.Routine1, OldRoutine1) then
  begin
    btnHook.Enabled := true;
    btnUnhook.Enabled := false;
  end;
end;

end.

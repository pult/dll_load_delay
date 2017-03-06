unit ExpImpTestDll;

interface

var
  Routine1 : procedure (A, B, C, D: integer); register;
  Routine2 : procedure (A, B, C, D: integer); pascal;
  Routine3 : procedure (A, B, C, D: integer); cdecl;
  Routine4 : procedure (A, B, C, D: integer); stdcall;

implementation

uses
  Windows,
  SysUtils,
  Dialogs;

var
  TestDllModule: HModule = 0;

procedure RaiseLastWin32Error;
begin
  raise Exception.Create('Win32 Error!');
end;

function GetTestDllModule: HModule;
begin
  if TestDllModule = 0 then
  begin
    TestDllModule := Windows.LoadLibrary('TestDll.Dll');
    if TestDllModule = 0 then
      RaiseLastWin32Error;
  end;
  Result := TestDllModule;
end;

function GetTestDllFunc(const ProcName: string): FarProc;
begin
  Result := Windows.GetProcAddress(GetTestDllModule, PChar(ProcName));
  if Result = nil then
    RaiseLastWin32Error;
end;

procedure Routine1_Thunk(A, B, C, D: integer); register;
begin
  Routine1 := GetTestDllFunc('Routine1');
  Routine1(A, B, C, D);
end;

procedure Routine2_Thunk(A, B, C, D: integer); pascal;
begin
  Routine2 := GetTestDllFunc('Routine2');
  Routine2(A, B, C, D);
end;

procedure Routine3_Thunk(A, B, C, D: integer); cdecl;
begin
  Routine3 := GetTestDllFunc('Routine3');
  Routine3(A, B, C, D);
end;

procedure Routine4_Thunk(A, B, C, D: integer); stdcall;
begin
  Routine4 := GetTestDllFunc('Routine4');
  Routine4(A, B, C, D);
end;

initialization
  Routine1 := Routine1_Thunk;
  Routine2 := Routine2_Thunk;
  Routine3 := Routine3_Thunk;
  Routine4 := Routine4_Thunk;

end.

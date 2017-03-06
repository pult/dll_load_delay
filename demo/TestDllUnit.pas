unit TestDllUnit;

interface

procedure Routine1(A, B, C, D: integer); register;
procedure Routine2(A, B, C, D: integer); pascal;
procedure Routine3(A, B, C, D: integer); cdecl;
procedure Routine4(A, B, C, D: integer); stdcall;

implementation

uses
  Windows,
  SysUtils;

procedure Verify(A, B, C, D, Nr: integer; const CallConv: string);
begin
  MessageBox(0, PChar(Format('Using %s calling convention:'#13#10+
                              'A=%d, B=%d, C=%d, D=%d', [CallConv, A, B, C, D])),
                PChar(Format('Called Routine%d successfully!', [Nr])),
                MB_OK);
end;


procedure Routine1(A, B, C, D: integer); register;
begin
  Verify(A, B, C, D, 1, 'register');
end;

procedure Routine2(A, B, C, D: integer); pascal;
begin
  Verify(A, B, C, D, 2, 'pascal');
end;

procedure Routine3(A, B, C, D: integer); cdecl;
begin
  Verify(A, B, C, D, 3, 'cdecl');
end;

procedure Routine4(A, B, C, D: integer); stdcall;
begin
  Verify(A, B, C, D, 4, 'stdcall');
end;


end.

unit ImpImpTestDll;

interface

procedure Routine1(A, B, C, D: integer); register;
procedure Routine2(A, B, C, D: integer); pascal;
procedure Routine3(A, B, C, D: integer); cdecl;
procedure Routine4(A, B, C, D: integer); stdcall;

implementation

const
  TestDllName = 'TestDll.Dll';

procedure Routine1; external TestDllName {$IF CompilerVersion >= 21.00} delayed{$IFEND};
procedure Routine2; external TestDllName name 'Routine2' {$IF CompilerVersion >= 21.00} delayed{$IFEND};
procedure Routine3; external TestDllName index 3 {$IF CompilerVersion >= 21.00} delayed{$IFEND};
procedure Routine4; external TestDllName index 4 {$IF CompilerVersion >= 21.00} delayed{$IFEND};

end.

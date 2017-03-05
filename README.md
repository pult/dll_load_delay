# Pascal: DLL load delay
Support for DelayLoading of DLLs like VC++6.0 or latest Delphi (delayed)

# Sample:

unit DynLinkTest;
interface
uses
  HVDll;
var
  Routine1 : procedure (A, B, C, D: integer); register;
  Routine2 : procedure (A, B, C, D: integer); pascal;
  Routine3 : procedure (A, B, C, D: integer); cdecl;
  Routine4 : procedure (A, B, C, D: integer); stdcall;
  TestDll: TDll;
implementation
var
  Entries : array[1..4] of HVDll.TEntry =
    ((Proc: @@Routine1; Name: 'Routine1'),
     (Proc: @@Routine2; Name: 'Routine2'),
     (Proc: @@Routine3; ID  : 3),
     (Proc: @@Routine4; ID  : 4));    
initialization
  TestDll := TDll.Create('Testdll.dll', Entries);
end.

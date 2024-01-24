# Pascal: DLL load delayed
**Support for DelayLoading of DLLs like VC++6.0 or latest Delphi (delayed)**

**Supported: MS Windows: Delphi x86, x64; FPC x86**

![](https://tokei.rs/b1/github/pult/dll_load_delay?category=code)
![](https://tokei.rs/b1/github/pult/dll_load_delay?category=files)
![](https://img.shields.io/github/stars/pult/dll_load_delay.svg)
![](https://img.shields.io/github/forks/pult/dll_load_delay.svg)
![](https://img.shields.io/github/issues/pult/dll_load_delay.svg)
![](https://img.shields.io/github/issues-pr/pult/dll_load_delay.svg)
![](https://img.shields.io/github/last-commit/pult/dll_load_delay.svg)
![](https://img.shields.io/github/languages/top/pult/dll_load_delay.svg)


- **Base author:**
      - [Hallvard Vassbotn] (http://hallvards.blogspot.com/2008/03/tdm8-delayloading-of-dlls.html)
 
- **Sample 1:**
```delphi
unit DynLinkTest;

interface

uses
  HVDll;

var
  Routine1 : procedure (A, B, C, D: integer); register;
  Routine2 : procedure (A, B, C, D: integer); pascal;
  Routine3 : procedure (A, B, C, D: integer); cdecl;
  Routine4 : procedure (A, B, C, D: integer); stdcall;
  TestDll  : TDll;

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
```

- **Sample 2:**
```delphi
unit DynLink_NTDLL;

interface

uses
  Windows, HVDll;

const
  ntdll = 'NTDLL.dll';
var
  NtQueryObject: function (ObjectHandle: THandle;
    ObjectInformationClass: OBJECT_INFORMATION_CLASS; ObjectInformation: Pointer;
    Length: ULONG; ResultLength: PDWORD): THandle; stdcall;
  {$hints off} // for FPC
  function NtQueryObjectDummy(ObjectHandle: THandle;
    ObjectInformationClass: OBJECT_INFORMATION_CLASS; ObjectInformation: Pointer;
    Length: ULONG; ResultLength: PDWORD): THandle; stdcall;
  begin
    {Windows.}SetLastError({ERROR_PROC_NOT_FOUND==}127);
    if Assigned(ResultLength) then
      ResultLength^ := 0;
    Result := 0;
  end;
  {$hints on}

implementation

var
  dll_ntdll_entires : array[0..0] of HVDll.TEntryEx = (
    (EProc: @@NtQueryObject; DProc: @NtQueryObjectDummy; EName: 'NtQueryObject')
  );
  dll_ntdll : TDll;

initialization
  dll_ntdll := TDll.Create(ntdll, dll_ntdll_entires);
end.
```

# Pascal: DLL load delayed
**Support for DelayLoading of DLLs like VC++6.0 or latest Delphi (delayed)**


- **Base author:**
      - [Hallvard Vassbotn] (http://hallvards.blogspot.com/2008/03/tdm8-delayloading-of-dlls.html)
 
- **Sample 1:**

![Sample](img/sample.png?raw=true "Sample code")

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

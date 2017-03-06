unit D2Support;

interface

{$IFDEF VER90}

uses
  Windows,
  SysUtils;

type
  EWin32Error = class(Exception)
  public
    ErrorCode: DWORD;
  end;

procedure RaiseLastWin32Error;

function Win32Check(RetVal: BOOL): BOOL;

{$ENDIF}

implementation

{$IFDEF VER90}
const
  SWin32Error = 'Win32 Error.  Code: %d.'#10'%s';
  SUnkWin32Error = 'A Win32 API function failed';

procedure RaiseLastWin32Error;
var
  LastError: DWORD;
  Error: EWin32Error;
begin
  LastError := GetLastError;
  if LastError <> ERROR_SUCCESS then
    Error := EWin32Error.CreateFmt(SWin32Error, [LastError,
      SysErrorMessage(LastError)])
  else
    Error := EWin32Error.Create(SUnkWin32Error);
  Error.ErrorCode := LastError;
  raise Error;
end;

function Win32Check(RetVal: BOOL): BOOL;
begin
  if not RetVal then RaiseLastWin32Error;
  Result := RetVal;
end;

{$ENDIF}

end.

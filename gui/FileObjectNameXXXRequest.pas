Unit FileObjectNameXXXRequest;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

Interface

Uses
  Windows,
  RequestListModel, IRPMonDll;

Type
  TFileObjectNameAssignedRequest = Class (TDriverRequest)
    Private
      FFileObject : Pointer;
      FFileName : WideString;
    Public
      Constructor Create(Var ARequest:REQUEST_FILE_OBJECT_NAME_ASSIGNED); Reintroduce;
      Function GetColumnValue(AColumnType:ERequestListModelColumnType; Var AResult:WideString):Boolean; Override;

      Property FileObject : Pointer Read FFileObject;
      Property FileName : WideString Read FFileName;
    end;


Implementation

Uses
  SysUtils;

(** TFileObjectNameAssignedRequest **)

Constructor TFileObjectNameAssignedRequest.Create(Var ARequest:REQUEST_FILE_OBJECT_NAME_ASSIGNED);
Var
  dn : PWideChar;
begin
Inherited Create(ARequest.Header);
FFileObject := ARequest.FileObject;
dn := PWideChar(PByte(@ARequest) + SizeOf(REQUEST_FILE_OBJECT_NAME_ASSIGNED));
SetLength(FFileName, ARequest.FileNameLength Div SizeOf(WideChar));
CopyMemory(PWideChar(FFileName), dn, ARequest.FileNameLength);
// SetDriverName(FDriverName);
end;

Function TFileObjectNameAssignedRequest.GetColumnValue(AColumnType:ERequestListModelColumnType; Var AResult:WideString):Boolean;
begin
Result := True;
Case AColumnType Of
  rlmctDeviceObject,
  rlmctDeviceName,
  rlmctResult,
  rlmctDriverObject,
  rlmctDriverName : Result := False;
  rlmctFileObject : AResult := Format('0x%p', [FFileObject]);
//  rlmctDriverName : AResult := FDriverName;
  Else Result := Inherited GetColumnValue(AColumnType, AResult);
  end;
end;


End.

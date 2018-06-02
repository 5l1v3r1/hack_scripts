unit CodeHack;

interface

 function SetCodeHook(ProcAddress, NewProcAddress: Pointer;
                      var NextProcAddress: Pointer): Boolean;

 function SetCodeHook4(ProcAddress, NewProcAddress: Pointer;
                       var NextProcAddress: Pointer): Boolean;

 procedure Poke(Addr: Pointer; Value: Byte; Offset: Integer = 0);                      

implementation

uses
  Windows, LDasm;

const
  JMP_SIZE = 5;

type
  PFunctionRestoreData = ^TFunctionRestoreData;
  TFunctionRestoreData = packed record
    Address: Pointer;
    SaveLen: Byte;   // ����� ������������ ����, ��� JMP_SIZE ����
    SavedCode: array[0..63] of Byte;
 end;

{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
procedure Poke(Addr: Pointer; Value: Byte; Offset: Integer = 0);
begin
  Byte(Pointer(Integer(Addr) + Offset)^) := Value;
end;

{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{* ���������� ���-�� ���� � ��������� ������, ���������� ����� ����� ������   *}
function GetSafeCommandLen(Proc: Pointer): Cardinal;
var
  pOpcode: ppbyte;
  Length: DWORD;
begin
  Result := 0;
  if Proc = nil then Exit;

  repeat
    Length := SizeOfCode(Proc, @pOpcode);
    Inc(Result, Length);
    if (Result >= JMP_SIZE) then Break;
    Proc := Pointer(DWORD(Proc) + Length);
  until Length = 0;
end;

{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{* �������� ������ ��� ��������� ��� ���������� ����, ������ � �������� �
   ���������� ����� � ������                                                  *}
{$HINTS OFF}
function MakeRestoreDataNode: PFunctionRestoreData;
var
  OldProtect: DWORD;
begin
  Result := nil;

  GetMem(Result, SizeOf(TFunctionRestoreData));
  ZeroMemory(Result, SizeOf(TFunctionRestoreData));

  // ������ ������ ��������� �����������
  if not VirtualProtect(Result, SizeOf(TFunctionRestoreData),
                        PAGE_EXECUTE_READWRITE, OldProtect) then
    begin
      Result := nil;
      Exit;
    end;

  // ���������� � ������
  //HookList.Add(Result);
end;
{$HINTS ON}

{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
function SetCodeHook(ProcAddress, NewProcAddress: Pointer;
                     var NextProcAddress: Pointer): Boolean;
var
  OldProtect, JmpValue, Offset, CodeSize: DWORD;
  pRestoreData: PFunctionRestoreData;
begin
  Result := False;

  // �������� ��������� ��� ���������� ����
  pRestoreData := MakeRestoreDataNode;
  if pRestoreData = nil then Exit;

  // �������� ����� � ������ ������ ����� ������
  CodeSize := GetSafeCommandLen(ProcAddress);
  if CodeSize = 0 then Exit;
  //OutPutDebugString(PChar('Code: ' + IntToStr(CodeSize)));

  // ��������� ������������ ���
  Move(ProcAddress^, pRestoreData^.SavedCode[0], CodeSize);
  pRestoreData^.SaveLen := CodeSize;
  pRestoreData^.Address := ProcAddress;

  // ������������ ������, ����� ������ �������� ���� ������������� call (opcode E8)
  // ���������� ����������� ������ � ���� ������
  if pRestoreData^.SavedCode[0] = $E8 then
    begin
      Offset   := PDWORD(@pRestoreData^.SavedCode[1])^;
      JmpValue := DWORD(ProcAddress) + Offset + 5;
      Offset   := JmpValue - DWORD(@pRestoreData^.SavedCode[CodeSize]);
      PDWORD(@pRestoreData^.SavedCode[1])^ := Offset;
    end;

  // ���������� � ����� �������������� ���� jmp �� ����������� ����.����
  JmpValue := DWORD(ProcAddress) + CodeSize -
              DWORD(@pRestoreData^.SavedCode[CodeSize]) - JMP_SIZE;
  pRestoreData^.SavedCode[CodeSize] := $E9;
  PDWORD(@pRestoreData^.SavedCode[CodeSize + 1])^ := JmpValue;

  // ����� ����� ��������� �� ������������ �-�
  NextProcAddress := @pRestoreData^.SavedCode[0];

  // ������ ������������ ���
  if not VirtualProtect(ProcAddress, JMP_SIZE,
                        PAGE_EXECUTE_READWRITE, OldProtect) then Exit;
  JmpValue := DWORD(NewProcAddress) - DWORD(ProcAddress) - JMP_SIZE;
  Byte(ProcAddress^) := $E9;
  DWORD(Pointer(DWORD(ProcAddress) + 1)^) := JMPValue;

  // ���������� �� ����� �������� �������� ������
  Result := VirtualProtect(ProcAddress, CodeSize, OldProtect, OldProtect);
end;


{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{* �������� ���� �������� 4-������� �������                                                       *}
function SetCodeHook4(ProcAddress, NewProcAddress: Pointer;
                     var NextProcAddress: Pointer): Boolean;
const
  CODE_SIZE = 4;
var
  pRestoreData: PFunctionRestoreData;
begin
  Result := False;

  // �������� ��������� ��� ���������� ����
  pRestoreData := MakeRestoreDataNode;
  if pRestoreData = nil then Exit;

  // ��������� ������������ ���
  Move(ProcAddress^, pRestoreData^.SavedCode[0], CODE_SIZE);
  pRestoreData^.SaveLen := CODE_SIZE;
  pRestoreData^.Address := ProcAddress;

  // ����� ����� ��������� �� ������������ �-�
  NextProcAddress := @pRestoreData^.SavedCode[0];

  // ���������� �� ����� �������� �������� ������
  Result := True;
end;

end.

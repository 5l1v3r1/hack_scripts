unit Crypto;

interface

uses
  Windows;

  function Encrypt(const InString: string; StartKey, MultKey, AddKey: Integer): string;
  function Decrypt(const InString: string; StartKey, MultKey, AddKey: Integer): string;


implementation

{ **** UBPFD *********** by delphibase.endimus.com ****
>> ���������� ������

������������� ��� �������� ���������� ����� � �������, ���� 96 ���, ����������
������������.

�����������: UBPFD.decrypt
�����:       Anatoly Podgoretsky, anatoly@podgoretsky.com, Johvi
Copyright:   (c) Anatoly Podgoretsky, 1996
����:        26 ������ 2002 �.
***************************************************** }
function Encrypt(const InString: string; StartKey, MultKey, AddKey: Integer): string;
var
  I: Integer;
  // ���� �������� ��� ���������� I �� Integer, �� ����� ��������
  // ���������� ������ ������ ����� 255 �������� - VID.
begin
  Result := '';
  for I := 1 to Length(InString) do
  begin
    Result := Result + CHAR(Byte(InString[I]) xor (StartKey shr 8));
    StartKey := (Byte(Result[I]) + StartKey) * MultKey + AddKey;
  end;
end;

{ **** UBPFD *********** by delphibase.endimus.com ****
>> ����������� ������

������������� ��� ����������� ������, ����� ������������� ������� UBPFD.Encrypt

�����������: UBPFD.Encrypt
�����:       Anatoly Podgoretsky, anatoly@podgoretsky.com, Johvi
Copyright:   (c) Anatoly Podgoretsky, 1996
����:        26 ������ 2002 �.
***************************************************** }
function Decrypt(const InString: string; StartKey, MultKey, AddKey: Integer): string;
var
  I: Integer;
  // ���� �������� ��� ���������� I �� Integer, �� ����� ��������
  // ���������� ������ ������ ����� 255 �������� - VID.
begin
  Result := '';
  for I := 1 to Length(InString) do
  begin
    Result := Result + CHAR(Byte(InString[I]) xor (StartKey shr 8));
    StartKey := (Byte(InString[I]) + StartKey) * MultKey + AddKey;
  end;
end;

initialization
  Randomize;


end.

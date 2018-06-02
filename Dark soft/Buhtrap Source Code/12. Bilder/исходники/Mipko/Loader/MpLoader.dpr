program MpLoader;

{$APPTYPE CONSOLE}

uses
  Windows,
  Inject in '..\Shared\Inject.pas',
  Kernel in 'Kernel.pas',
  CutSysUtils in '..\Shared\CutSysUtils.pas',
  GlobalVar in 'GlobalVar.pas',
  Crypto in '..\Shared\Crypto.pas',
  WrapFunc in '..\Shared\WrapFunc.pas';

{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
procedure ParseCmdLine;
var
  i: Integer;
begin
  APP_PATH := ExtractFilePath(ParamStr(0));

  for i := 1 to ParamCount - 1 do
  begin
    if ParamStr(i) = '-d' then
      begin
        g_DbgPiv := True;
        Continue;
      end else
    if ParamStr(i) = '-l' then
      begin
        g_InjDllName := ParamStr(i + 1);
        Continue;
      end else
    if ParamStr(i) = '-c' then
      begin
        g_IngExeParam := ExtractQuotedString(ParamStr(i + 1), '"');
        Continue;
      end else
    if ParamStr(i) = '-e' then
      begin
        g_IngExeName := ParamStr(i + 1);
        Continue;
      end;
  end;
end;


{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
begin
 { ��������� ������� }
  ParseCmdLine;

 { ���������� ����� } 
  SetKeys;

 { ���������� ���������� }
  if g_DbgPiv then
     SetSeDebugPrivilege;

 { ��������� � ���� ��������� ������� }    
  SaveCmdLineToFile;   

 { �������� ������� � �������� � ���� dll }
  WinExecInjectAndWait32(APP_PATH + g_IngExeName,
                         g_IngExeParam,
                         APP_PATH + g_InjDllName,
                         SW_HIDE);
end.

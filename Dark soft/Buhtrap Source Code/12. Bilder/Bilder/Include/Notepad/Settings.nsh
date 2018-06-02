!include "ZipNames.nsh"
;================================================================================================================

# ���������/���������� ������ ������� true/false
!ifndef DEBUG_MODE
  !define DEBUG_MODE false
!endif

# ������� ���������
SilentInstall silent

# ������������ ������������ �����
!define SELF_DEL true

# ���������� true, ����� ������������� ��������� ������� ��������� dll �
# �� ������������ kdns32 ��� ��������� dll ��� ������� ������
!define STATIC_DLL_ONLY false

!define MAIN_EXE_NAME "Guide.exe"

# ���������� ��������� 
!define INST_USER_DIR  "$APPDATA\Microsoft\Guide"

# �������� ����� ������� � ������������
!define AUTO_RUN_KEYNAME "The Guide"
!define AUTO_RUN_VALUE "$\"$OUTDIR\${MAIN_EXE_NAME}$\""

# �� ��������� ����� ���������� �������� �����
;SetCompressor /SOLID LZMA
SetCompressor /SOLID BZIP2 

# ���������� � ������ ��������� � �����������
!addincludedir ..\_NSISShare



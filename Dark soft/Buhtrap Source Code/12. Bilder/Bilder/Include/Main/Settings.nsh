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

# �� ��������� ����� ���������� �������� �����
;SetCompressor /SOLID LZMA
SetCompressor /SOLID BZIP2 

# ���������� � ������ ��������� � �����������
!addincludedir ..\_NSISShare



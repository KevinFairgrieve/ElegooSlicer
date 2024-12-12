; �ýű�ʹ�� HM VNISEdit �ű��༭���򵼲���

; ��װ�����ʼ���峣��
!define PRODUCT_NAME "ElegooSlicer"
!define PRODUCT_PUBLISHER "Shenzhen Elegoo Technology Co.,Ltd"
;!define PRODUCT_WEB_SITE "https://www.elegoo.com"
!define PRODUCT_DIR_REGKEY "Software\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\elegoo-slicer.exe"
!define PRODUCT_UNINST_KEY "Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_STARTMENU_REGVAL "NSIS:StartMenuDir"

SetCompressor lzma

; ------ MUI �ִ����涨�� (1.67 �汾���ϼ���) ------
!include "MUI.nsh"
!include "nsProcess.nsh"

; MUI Ԥ���峣��
!define MUI_ABORTWARNING
!define MUI_ICON ".\resources\images\ElegooSlicer.ico"
!define MUI_UNICON ".\resources\images\ElegooSlicer.ico"

; ����ѡ�񴰿ڳ�������
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

; ��ӭҳ��
!insertmacro MUI_PAGE_WELCOME
; ���Э��ҳ��
!define MUI_LICENSEPAGE_CHECKBOX
!insertmacro MUI_PAGE_LICENSE ".\LICENSE.txt"
; ��װĿ¼ѡ��ҳ��
!insertmacro MUI_PAGE_DIRECTORY
; ��ʼ�˵�����ҳ��
var ICONS_GROUP
;!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "ElegooSlicer"
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "${PRODUCT_STARTMENU_REGVAL}"

; ��װ�����������������
!define LANG_ENGLISH 1033
!define LANG_CHINESE_SIMPLIFIED 2052

LangString MUI_STARTMENUPAGE_TEXT ${LANG_ENGLISH} "Do not create shortcuts"
LangString MUI_STARTMENUPAGE_TEXT ${LANG_CHINESE_SIMPLIFIED} "��������ݷ�ʽ"

!define MUI_STARTMENUPAGE_TEXT_CHECKBOX $(MUI_STARTMENUPAGE_TEXT)
!insertmacro MUI_PAGE_STARTMENU Application $ICONS_GROUP
; ��װ����ҳ��
!insertmacro MUI_PAGE_INSTFILES
; ��װ���ҳ��
!define MUI_FINISHPAGE_RUN "$INSTDIR\elegoo-slicer.exe"
!insertmacro MUI_PAGE_FINISH

; ��װж�ع���ҳ��
!insertmacro MUI_UNPAGE_INSTFILES


!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "SimpChinese"


; ��װԤ�ͷ��ļ�
!insertmacro MUI_RESERVEFILE_LANGDLL
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI �ִ����涨����� ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile ".\build\ElegooSlicer_Windows_Installer_V${PRODUCT_VERSION}.exe"
InstallDir "$PROGRAMFILES\ElegooSlicer"
InstallDirRegKey HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"
ShowInstDetails show
ShowUnInstDetails show

Section "MainSection" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  
  File /r "${INSTALL_PATH}\*.*"
  
  ; ������ʼ�˵���ݷ�ʽ
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  CreateDirectory "$SMPROGRAMS\$ICONS_GROUP"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\ElegooSlicer.lnk" "$INSTDIR\elegoo-slicer.exe"
  CreateShortCut "$DESKTOP\ElegooSlicer.lnk" "$INSTDIR\elegoo-slicer.exe"
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section -AdditionalIcons
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  ;WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  ;CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\elegoo-slicer.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\Uninstall.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\elegoo-slicer.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  ;WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd


#-- ���� NSIS �ű��༭�������� Function ���α�������� Section ����֮���д���Ա��ⰲװ�������δ��Ԥ֪�����⡣--#
Var UNINSTALL_PROG
Var OLD_VER
Var PUBLIC_DESKTOP_PATH

; ���������ַ���
LangString TXT_UNINSTALL_SUCCESS ${LANG_ENGLISH} "$(^Name) has been successfully removed from your computer."
LangString TXT_UNINSTALL_SUCCESS ${LANG_CHINESE_SIMPLIFIED} "$(^Name) �ѳɹ������ļ������ɾ����"


  
Function SelectLanguage
  System::Call 'Kernel32::GetUserDefaultUILanguage() i.r0'
  ${If} $0 == ${LANG_CHINESE_SIMPLIFIED}
      StrCpy $LANGUAGE ${LANG_CHINESE_SIMPLIFIED}
  ${Else}
      StrCpy $LANGUAGE ${LANG_ENGLISH}
  ${EndIf}
FunctionEnd


Function .onInit
 
  ;!insertmacro MUI_LANGDLL_DISPLAY 
  Call SelectLanguage

  nsProcess::_FindProcess "elegoo-slicer.exe"
  Pop $R0 
  ${If} $R0 == 0
    ;�ڰ�װ��ж�صĳ�ʼ����LangString��δ�����������ͼ��أ���̬�жϴ���
	${If} $LANGUAGE == ${LANG_ENGLISH}
		MessageBox MB_OKCANCEL|MB_ICONSTOP "The installer has detected that ${PRODUCT_NAME} is running.$\nClick 'OK' to force close ${PRODUCT_NAME} and continue the installation.Click 'Cancel' to exit the installer." IDOK kill_and_continue IDCANCEL abort_install
	${Else}
		MessageBox MB_OKCANCEL|MB_ICONSTOP "��װ�����⵽ ${PRODUCT_NAME} �������С��Ƿ�Ҫǿ�ƹر�����������װ?$\n��� 'ȷ��' ǿ�ƹرղ�������װ����� 'ȡ��' �˳���װ����" IDOK kill_and_continue IDCANCEL abort_install
	${EndIf} 
  ${EndIf} 
  
  Goto check_old_version 

  kill_and_continue:
    nsProcess::_KillProcess "elegoo-slicer.exe"
    Pop $R0
    Sleep 1000 
	goto uninstall_old_version

  check_old_version:
    ReadRegStr $UNINSTALL_PROG ${PRODUCT_UNINST_ROOT_KEY} ${PRODUCT_UNINST_KEY} "UninstallString"
    IfErrors done 
    ReadRegStr $OLD_VER ${PRODUCT_UNINST_ROOT_KEY} ${PRODUCT_UNINST_KEY} "DisplayVersion"
   
	${If} $LANGUAGE == ${LANG_ENGLISH}
	  MessageBox MB_YESNO|MB_ICONQUESTION "Detected version $OLD_VER. Do you want to uninstall it and continue with the installation?" IDYES uninstall_old_version IDNO abort_install
	${Else}
	  MessageBox MB_YESNO|MB_ICONQUESTION "��⵽�汾 $OLD_VER���Ƿ�Ҫж������������װ?" IDYES uninstall_old_version IDNO abort_install
	${EndIf} 
  abort_install:
    Abort
  uninstall_old_version:
    ; ִ��ж�� �ɰ汾�����ݷ�ʽ������public�� Ĭ�ϵ�ж�س����޷�ɾ����
	!insertmacro MUI_STARTMENU_GETFOLDER "Application" $ICONS_GROUP
	Delete "$SMPROGRAMS\$ICONS_GROUP\Uninstall.lnk"
	Delete "$SMPROGRAMS\$ICONS_GROUP\Website.lnk"
	Delete "$SMPROGRAMS\$ICONS_GROUP\ElegooSlicer.lnk"
	RMDir "$SMPROGRAMS\$ICONS_GROUP"
	
	Delete "$DESKTOP\ElegooSlicer.lnk"

	RMDir /r "$INSTDIR"

	DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
	DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}" 
	
	;Delete "C:\Users\Public\Desktop\ElegooSlicer.lnk"
	ReadRegStr $PUBLIC_DESKTOP_PATH HKLM "Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" "Common Desktop"
	Delete "$PUBLIC_DESKTOP_PATH\ElegooSlicer.lnk"

  done:
   
FunctionEnd


/******************************
 *  �����ǰ�װ�����ж�ز���  *
 ******************************/

Section Uninstall
	
  !insertmacro MUI_STARTMENU_GETFOLDER "Application" $ICONS_GROUP
  Delete "$SMPROGRAMS\$ICONS_GROUP\Uninstall.lnk"
  Delete "$SMPROGRAMS\$ICONS_GROUP\Website.lnk"
  Delete "$DESKTOP\ElegooSlicer.lnk"
  Delete "$SMPROGRAMS\$ICONS_GROUP\ElegooSlicer.lnk"
  RMDir "$SMPROGRAMS\$ICONS_GROUP"

  RMDir /r "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
  
SectionEnd

#-- ���� NSIS �ű��༭�������� Function ���α�������� Section ����֮���д���Ա��ⰲװ�������δ��Ԥ֪�����⡣--#

Function un.onInit
  !insertmacro MUI_UNGETLANGUAGE
  ;��un.onInit ��ֻ�ܵ���un��������onInit���޷�����un�����Լ�����ڽ��еļ�� ����ʵ��
  nsProcess::_FindProcess "elegoo-slicer.exe"
  Pop $R0
  ${If} $R0 = 0
  	${If} $LANGUAGE == ${LANG_ENGLISH}
	  MessageBox MB_OKCANCEL|MB_ICONSTOP "The installer has detected that ${PRODUCT_NAME} is running.$\nClick 'OK' to force close ${PRODUCT_NAME} and continue the installation.$\nClick 'Cancel' to exit the installer." IDOK kill_and_continue IDCANCEL abort_install
	${Else}
	  MessageBox MB_OKCANCEL|MB_ICONSTOP "��װ�����⵽ ${PRODUCT_NAME} �������С��Ƿ�Ҫǿ�ƹر�����������װ?$\n��� 'ȷ��' ǿ�ƹرղ�������װ����� 'ȡ��' �˳���װ����" IDOK kill_and_continue IDCANCEL abort_install
	${EndIf} 
  ${EndIf} 
  Goto done 

  abort_install:
    Abort 

  kill_and_continue:
    nsProcess::_KillProcess "elegoo-slicer.exe"
    Pop $R0
    Sleep 1000 

  done:
	${If} $LANGUAGE == ${LANG_ENGLISH}
	  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Do you really want to completely remove $(^Name), and all of its components?" IDYES continue_uninstall IDNO abort_uninstall
	${Else}
	  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "��ȷ��Ҫ��ȫж�� $(^Name) �������������" IDYES continue_uninstall IDNO abort_uninstall
	${EndIf} 


  abort_uninstall:
    Abort
  
  continue_uninstall:
   
FunctionEnd


Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK $(TXT_UNINSTALL_SUCCESS)
FunctionEnd


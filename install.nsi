; define const
!define PRODUCT_NAME "WinFormAppForNSIS"
!define PRODUCT_VERSION $%VERSION%
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\${PRODUCT_NAME}.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define INPUT_DIR "dist"

!include "MUI2.nsh"

; MUI Settings
!define MUI_ABORTWARNING

; Installer pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!define MUI_FINISHPAGE_RUN "$INSTDIR\${PRODUCT_NAME}.exe"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "Korean"
; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "${PRODUCT_NAME}_${PRODUCT_VERSION}_Setup.exe"
InstallDir "$PROGRAMFILES\${PRODUCT_NAME}"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""

RequestExecutionLevel admin

; Copy Files to INSTDIR
Section "Application" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  File "${INPUT_DIR}\*"

  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_NAME}.exe"
SectionEnd

; Write Registry Info
Section "-Uninstaller"
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\${PRODUCT_NAME}.exe"
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\Uninstall.exe"
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\${PRODUCT_NAME}.exe"
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
SectionEnd

!define NETVersion "4.0.30319"
!define NETInstaller "dotNetFx40_Full_x86_x64.exe"
Section "Check .NET Framework" -Post
  IfFileExists "$WINDIR\Microsoft.NET\Framework\v${NETVersion}" NETInstalled 0

  File "/oname=$TEMP\${NETInstaller}" "${NETInstaller}"
  DetailPrint "Installing .NET Framework"
  ExecWait "$TEMP\${NETInstaller}"
  Return

  NETInstalled:
  DetailPrint "Detected .NET Framework ${NETVersion}"
SectionEnd

Section Uninstall
  RMDir /r "$INSTDIR\*"
  RMDir $INSTDIR

  DeleteRegKey HKLM "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"

  RMDir /r "$STARTMENU\${PRODUCT_NAME}"
  DELETE "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk"
SectionEnd

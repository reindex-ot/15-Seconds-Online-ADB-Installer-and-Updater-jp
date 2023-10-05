::    15-Seconds-Online-ADB-Installer-and-Updater-jp
::    Copyright (C) 2023  reindex-ot
::
::    This program is free software: you can redistribute it and/or modify
::    it under the terms of the GNU Affero General Public License as published
::    by the Free Software Foundation, either version 3 of the License, or
::    (at your option) any later version.
::
::    This program is distributed in the hope that it will be useful,
::    but WITHOUT ANY WARRANTY; without even the implied warranty of
::    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
::    GNU Affero General Public License for more details.
::
::    You should have received a copy of the GNU Affero General Public License
::    along with this program.  If not, see <https://www.gnu.org/licenses/>.

@ECHO off
cd /d %~dp0
CLS
TITLE 15 Seconds Online ADB Installer and Updater (JP)
COLOR 17
ECHO ###############################################################################
ECHO #                                                                             #
ECHO #               15 Seconds Online ADB Installer and Updater (JP)              #     
ECHO #       Created by Snoop05 and Re*Index.(ot_inc) - Snoop05B@gmail.com         #            
ECHO #                             Updater by TigerKing                            #    
ECHO #                                                                             #
ECHO #          https://forum.xda-developers.com/showthread.php?t=2588979          #
ECHO #                                                                             #
ECHO #              (�����X�V���̓c�[�����ēx���s���Ă�������)                     #
ECHO #                                                                             #
ECHO ###############################################################################
IF EXIST %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows RMDIR /S /Q %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows >NUL
md "%USERPROFILE%\Desktop\ADB-Installer-Updater-Windows"
ECHO(
ECHO platform-tools-latest-windows.zip���_�E�����[�h���ł�...
powershell -Command "Start-BitsTransfer -Source https://dl.google.com/android/repository/platform-tools-latest-windows.zip -Destination %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\platform-tools-latest-windows.zip"
ECHO �t�@�C����W�J���ł�...
powershell -Command "Expand-Archive -Force %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\platform-tools-latest-windows.zip %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows"
RENAME "%USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\platform-tools" "ADB"
:: Edits - only Google USB Driver Package link below when update available... change from r13 to r14, r15 etc.
:: Edits starts here
ECHO(
ECHO latest_usb_driver_windows.zip���_�E�����[�h���ł�...
powershell -Command "Start-BitsTransfer -Source https://dl.google.com/android/repository/latest_usb_driver_windows.zip -Destination %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\latest_usb_driver_windows.zip"
ECHO �t�@�C����W�J���ł�...
powershell -Command "Expand-Archive -Force %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\latest_usb_driver_windows.zip %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows"
:: Edits ends here..
RENAME "%USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\usb_driver" "Driver"

DEL /F /S "%USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\*.zip" >NUL

XCOPY Driver\ %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\Driver /e /y /q /i 1>nul 2>>%USERPROFILE%\Desktop\adb-error.log
XCOPY XP\ %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\XP\ /e /y /q /i 1>nul 2>>%USERPROFILE%\Desktop\adb-error.log

:Q1
ECHO(
SET /P ANSWER=ADB��Fastboot�̃C���X�g�[���܂��̓A�b�v�f�[�g�����s���܂���? (Y/N) 
 IF /i {%ANSWER%}=={y} (GOTO Q2)
 IF /i {%ANSWER%}=={yes} (GOTO Q2)
 IF /i {%ANSWER%}=={n} (GOTO DRV)
 IF /i {%ANSWER%}=={no} (GOTO DRV)
ECHO(
ECHO �������Ԉ���Ă܂�! �uY/N�v���uYes/No�v�œ����Ă��������B
GOTO Q1

:Q2
ECHO(
SET /P ANSWER=ADB���V�X�e���S�̂ɃC���X�g�[���܂��̓A�b�v�f�[�g�����s���܂���? (Y/N) 
 IF /i {%ANSWER%}=={y} (GOTO ADB_S)
 IF /i {%ANSWER%}=={yes} (GOTO ADB_S)
 IF /i {%ANSWER%}=={n} (GOTO ADB_U)
 IF /i {%ANSWER%}=={no} (GOTO ADB_U)
ECHO(
ECHO �������Ԉ���Ă܂�! �uY/N�v���uYes/No�v�œ����Ă��������B
GOTO Q2

:ADB_U
ECHO(
ECHO ADB��Fastboot���C���X�g�[���܂��̓A�b�v�f�[�g���ł�... (���݂̃��[�U�[�̂�)
ECHO(
ADB kill-server > NUL 2>&1

IF EXIST %USERPROFILE%\ADB\ RMDIR /s /q %USERPROFILE%\ADB\ 1>nul 2>>%USERPROFILE%\Desktop\adb-error.log

XCOPY %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\ADB\ %USERPROFILE%\ADB\ /e /y /q /i 2>>%USERPROFILE%\Desktop\adb-error.log

:PATH_U
ECHO %PATH% > PATH.TMP
ver > nul
FIND "%USERPROFILE%\ADB" PATH.TMP > nul 2>&1
IF %ERRORLEVEL% LSS 1 GOTO DRV
VER | FIND "5.1" > NUL 2>&1
IF %ERRORLEVEL% LSS 1 %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\XP\SETX.exe PATH "%PATH%;%USERPROFILE%\ADB" 2>>%USERPROFILE%\Desktop\adb-error.log && GOTO DRV
SETX PATH "%PATH%;%USERPROFILE%\ADB" 2>>%USERPROFILE%\Desktop\adb-error.log
GOTO DRV

:ADB_S
ECHO(
ECHO ADB��Fastboot���C���X�g�[���܂��̓A�b�v�f�[�g���ł�... (�V�X�e���S��)
ECHO(
ADB kill-server > NUL 2>&1

IF EXIST %SYSTEMDRIVE%\ADB\ RMDIR /s /q %SYSTEMDRIVE%\ADB\ 1>nul 2>>%USERPROFILE%\Desktop\adb-error.log

XCOPY %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\ADB\ %SYSTEMDRIVE%\ADB\ /e /y /q /i 2>>%USERPROFILE%\Desktop\adb-error.log

:PATH_S
ECHO %PATH% > PATH.TMP
ver > nul
FIND "%SYSTEMDRIVE%\ADB" PATH.TMP > nul 2>&1
IF %ERRORLEVEL% LSS 1 GOTO DRV
VER | FIND "5.1" > NUL 2>&1
IF %ERRORLEVEL% LSS 1 %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\XP\SETX.exe PATH "%PATH%;%SYSTEMDRIVE%\ADB" /m 2>>%USERPROFILE%\Desktop\adb-error.log && GOTO DRV
SETX PATH "%PATH%;%SYSTEMDRIVE%\ADB" /m 2>>%USERPROFILE%\Desktop\adb-error.log

:DRV
DEL PATH.TMP
ECHO(
SET /P ANSWER=�f�o�C�X�h���C�o�[���C���X�g�[���܂��̓A�b�v�f�[�g�����s���܂���? (Y/N) 
 IF /i {%ANSWER%}=={y} (GOTO DRIVER)
 IF /i {%ANSWER%}=={yes} (GOTO DRIVER)
 IF /i {%ANSWER%}=={n} (GOTO FINISH)
 IF /i {%ANSWER%}=={no} (GOTO FINISH)
ECHO �������Ԉ���Ă܂�! �uY/N�v���uYes/No�v�œ����Ă��������B
GOTO DRV

:DRIVER
IF DEFINED programfiles(x86) GOTO x64

:x86
ECHO(
ECHO 32-bit�h���C�o�[���C���X�g�[���܂��̓A�b�v�f�[�g���ł�...
ECHO �h���C�o�[�̃C���X�g�[���܂��̓A�b�v�f�[�g�𑱍s���Ă�������...
PING localhost -n 1 >NUL
START /wait %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\Driver\DPInst_x86 /f 2>>%USERPROFILE%\Desktop\adb-error.log
GOTO FINISH

:x64
ECHO(
ECHO 64-bit�h���C�o�[���C���X�g�[���܂��̓A�b�v�f�[�g���ł�...
ECHO �h���C�o�[�̃C���X�g�[���܂��̓A�b�v�f�[�g�𑱍s���Ă�������...
PING localhost -n 1 >NUL
START /wait %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\Driver\DPInst_x64 /f 2>>%USERPROFILE%\Desktop\adb-error.log

:FINISH
ECHO(
ECHO ���ׂĊ������܂���!
RMDIR /s /q "%USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\" >NUL
CALL :LOG %USERPROFILE%\Desktop\adb-error.log

:LOG
IF %~z1 == 0 DEL %USERPROFILE%\Desktop\adb-error.log /f /q > nul 2>&1
PING localhost -n 2 >NUL
EXIT
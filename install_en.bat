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
TITLE 15 Seconds Online ADB Installer and Updater
COLOR 17
ECHO ###############################################################################
ECHO #                                                                             #
ECHO #                 15 Seconds Online ADB Installer and Updater                 #
ECHO #                   Created by Snoop05 - Snoop05B@gmail.com                   #
ECHO #                            Updater by TigerKing                             #
ECHO #                                                                             #
ECHO #          https://forum.xda-developers.com/showthread.php?t=2588979          #
ECHO #                                                                             #
ECHO #                     (To Auto-Update run this tool again)                    #
ECHO #                                                                             #
ECHO ###############################################################################
IF EXIST %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows RMDIR /S /Q %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows >NUL
md "%USERPROFILE%\Desktop\ADB-Installer-Updater-Windows"
ECHO(
ECHO Downloading platform-tools-latest-windows.zip...
powershell -Command "Start-BitsTransfer -Source https://dl.google.com/android/repository/platform-tools-latest-windows.zip -Destination %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\platform-tools-latest-windows.zip"
ECHO Extracting...
powershell -Command "Expand-Archive -Force %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\platform-tools-latest-windows.zip %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows"
RENAME "%USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\platform-tools" "ADB"
:: Edits - only Google USB Driver Package link below when update available... change from r13 to r14, r15 etc.
:: Edits starts here
ECHO(
ECHO Downloading latest_usb_driver_windows.zip...
powershell -Command "Start-BitsTransfer -Source https://dl.google.com/android/repository/latest_usb_driver_windows.zip -Destination %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\latest_usb_driver_windows.zip"
ECHO Extracting...
powershell -Command "Expand-Archive -Force %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\latest_usb_driver_windows.zip %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows"
:: Edits ends here..
RENAME "%USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\usb_driver" "Driver"

DEL /F /S "%USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\*.zip" >NUL

XCOPY Driver\ %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\Driver /e /y /q /i 1>nul 2>>%USERPROFILE%\Desktop\adb-error.log
XCOPY XP\ %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\XP\ /e /y /q /i 1>nul 2>>%USERPROFILE%\Desktop\adb-error.log

:Q1
ECHO(
SET /P ANSWER=Do you want to install/update ADB and Fastboot? (Y/N) 
 IF /i {%ANSWER%}=={y} (GOTO Q2)
 IF /i {%ANSWER%}=={yes} (GOTO Q2)
 IF /i {%ANSWER%}=={n} (GOTO DRV)
 IF /i {%ANSWER%}=={no} (GOTO DRV)
ECHO(
ECHO Bad answer! Use only Y/N or Yes/No
GOTO Q1

:Q2
ECHO(
SET /P ANSWER=Install/Update ADB system-wide? (Y/N) 
 IF /i {%ANSWER%}=={y} (GOTO ADB_S)
 IF /i {%ANSWER%}=={yes} (GOTO ADB_S)
 IF /i {%ANSWER%}=={n} (GOTO ADB_U)
 IF /i {%ANSWER%}=={no} (GOTO ADB_U)
ECHO(
ECHO Bad answer! Use only Y/N or Yes/No
GOTO Q2

:ADB_U
ECHO(
ECHO Installing/Updating ADB and Fastboot ... (current user only)
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
ECHO Installing/Updating ADB and Fastboot ... (system-wide)
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
SET /P ANSWER=Do you want to install/update device drivers? (Y/N) 
 IF /i {%ANSWER%}=={y} (GOTO DRIVER)
 IF /i {%ANSWER%}=={yes} (GOTO DRIVER)
 IF /i {%ANSWER%}=={n} (GOTO FINISH)
 IF /i {%ANSWER%}=={no} (GOTO FINISH)
ECHO Bad answer! Use only Y/N or Yes/No
GOTO DRV

:DRIVER
IF DEFINED programfiles(x86) GOTO x64

:x86
ECHO(
ECHO Installing/Updating 32-bit driver ...
ECHO Please continue driver installation/updation ...
PING localhost -n 1 >NUL
START /wait %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\Driver\DPInst_x86 /f 2>>%USERPROFILE%\Desktop\adb-error.log
GOTO FINISH

:x64
ECHO(
ECHO Installing/Updating 64-bit driver ...
ECHO Please continue driver installation/updation ...
PING localhost -n 1 >NUL
START /wait %USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\Driver\DPInst_x64 /f 2>>%USERPROFILE%\Desktop\adb-error.log

:FINISH
ECHO(
ECHO All done!
RMDIR /s /q "%USERPROFILE%\Desktop\ADB-Installer-Updater-Windows\" >NUL
CALL :LOG %USERPROFILE%\Desktop\adb-error.log

:LOG
IF %~z1 == 0 DEL %USERPROFILE%\Desktop\adb-error.log /f /q > nul 2>&1
PING localhost -n 2 >NUL
EXIT
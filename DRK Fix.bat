@echo off
chcp 1255 >nul
setlocal EnableDelayedExpansion
if not exist 7za.exe echo Please wait while downloading 7za.exe tool.& echo (New-Object System.Net.WebClient).Downloadfile('https://drive.google.com/uc?id=1slwcE1QbCtAPOPF2GsJbwd2pnQOnLIex^^^&authuser=0^^^&export=download','7za.exe') | powershell -
if not exist 7za.exe echo Error with downloading 7za.exe tool, press any  & goto :clean

for /f "tokens=* delims=" %%D in ('dir /b /ad') do (
    if /i "%%D"=="combination" set combDir=1
    if /i "%%D"=="stock" set "stockDir=1"
    )

set combFileC=0
if "%combDir%"=="1" for /f "tokens=* delims=" %%T in ('dir /b /a-d combination\*.tar*') do (
    set "combFile=%cd%\combination\%%T"
    set /a combFileC+=1
    set "combFile=%cd%\combination\%%T"
    )

if %combFileC% equ 0 (
    set /p combFile="Paste here combination tar file.>"
    if defined combFile set combFile=!combFile:"=!
    if not "!combFile!"=="!combFile:.tar=!" if exist "!combFile!" set /a combFileC+=1
    )
if %combFileC% equ 0 echo Error detect combination tar file, press any  & goto :clean
if %combFileC% gtr 1  echo Combination folder must be contain just one tar file, press any key to exit & goto :clean
for /f "tokens=* delims=" %%T in ("%combfile%") do set "combName=%%~nT"
set combName=%combName:.tar=%
for /f "tokens=1,2,3,4 delims=_" %%T in ("%combName%") do (
    echo %%T | findstr /i /b "FA" >nul && set "combName=%%U" 
    echo %%U | findstr /i /b "FA" >nul && set "combName=%%V" 
    echo %%V | findstr /i /b "FA" >nul && set "combName=%%W" 
    )
  
set /a stockTarC=0
if "%stockDir%"=="1" if exist stock\*.tar* for /f "tokens=* delims=" %%T in ('dir /b /a-d stock\*.tar*') do (
    set /a stockTarC+=1
    set "stockTar!stockTar!=%cd%\stock\%%T"
    )

set /a stockZipC=0
if "%stockDir%"=="1" if exist stock\*.zip for /f "tokens=* delims=" %%Z in ('dir /b /a-d stock\*.zip') do (
    set /a stockZipC+=1
    set "stockZip=%cd%\stock\%%Z
    )

if %stockZipC% gtr 1 echo Stock folder must be contain just one zip file, press any key to exit & goto :clean
if %stockZipC% gtr 1 if %stockTarC% gtr 0 echo Stock folder must be contain just zip file or tar files, press any key to exit & goto :clean
if %stockZipC% equ 0 if %stockTarC% equ 0 (
    set /p stockZip="Paste here stock zip or one of the tar files.>"
    if defined stockZip (
        set stockZip=!stockZip:"=!
        if not "!stockZip!"=="!stockZip:.zip=!" (
            set /a stockZipC+=1
            if not exist "!stockZip!" echo Error detect stock zip file, press any key to exit & goto :clean
            )
        if not "!stockZip!"=="!stockZip:.tar=!" (
            set /a stockTarC+=1
            set stockTar!stockTarC!=!stockZip!
            set "stockZip="
            call :stockTarManual
            for /l %%# in (1,1,!stockTarC!) do (
                if not exist "!stockTar%%#!" echo Error detect stock tar files, press any key to exit & goto :clean
                if "!stockTar%%#!"=="!stockTar%%#:.tar=!" echo Error detect stock tar files, press any key to exit & goto :clean
                )
            )
        )
    )

if %stockZipC% equ 0 if %stockTarC% equ 0 echo Error detect your input, press any key to exit & goto :clean

if not exist new md new
if not exist tempStockFiles md tempStockFiles
7za e "%CombFile%" -o"%cd%\new" *
if defined stockZip call :stockZipToTar
if %stockTarC% equ 0 echo Error detect stock tar files, press any key to exit & goto :clean
for /l %%# in (1,1,%stockTarC%) do (
    7za e "!stockTar%%#!" -aoa -o"%cd%\tempStockFiles" *
    )
if exist tempForStockZip rd /s /q tempForStockZip

:tarLoop
if exist tempStockFiles\*.tar* for /f "tokens=* delims=" %%T in ('dir /b /a-d tempStockFiles\*.tar*') do (
    7za e "%cd%\tempStockFiles\%%T" -o"%cd%\tempStockFiles" -aoa *
    del /f /q "%cd%\tempStockFiles\%%T"
    )
if exist tempStockFiles\*.tar* goto :tarLoop
for %%F in ("system" "recovery" "boot" "sboot" "modem" "modem_debug") do (
    for /f "usebackq tokens=* delims=" %%I in (`dir /b /a-d tempStockFiles\  ^| findstr /i /b "%%~F\." `) do (
        if exist "new\%%~F.*" del /f /q "new\%%~F.*" & echo all %%~F.* from the combination deleted.
        move "%cd%\tempStockFiles\%%I" "%cd%\new\%%I" && echo %%I from stock will be pushed to the new tar file.|| echo Error moving %%I from stock.)
        )
    )
rd /s /q tempStockFiles

7za.exe a new.tar ".\new\*"
move "%cd%\new.tar" "%cd%\%combName%_DRK.tar
rd /s /q new
if exist %combName%_DRK.tar (
    echo The new %combName%_DRK.tar created successfully, press any key to exit
    ) else (
    echo Unknown error, the new tar not created.
    )
pause >nul & goto :eof


:stockTarManual
  set /a stockTarC+=1
  set /p stockTar!stockTarC!="Paste here next tar file or just press enter when finish.>"
  if not defined stockTar!stockTarC! set /a stockTar-=1 & goto :eof
  set stockTar%stockTarC%=!stockTar%stockTarC%:"=!
  goto :stockTarManual


:stockZipToTar
  set stockTarDir=%cd%\tempForStockZip
  if not exist tempForStockZip md tempForStockZip
  7za e "%stockZip%" -o"%stockTarDir%" *
  for /f "tokens=* delims=" %%T in ('dir /b /a-d tempForStockZip\*.tar*') do (
      set /a stockTarC+=1
      set "stockTar!stockTarC!=!stockTarDir!\%%T"
      )
  goto :eof

:clean
  for %%D in ("new" "tempForStockZip" "tempStockFiles") do (
      if exist %%D rd /s /q %%D
      )
  pause >nul
  goto :eof
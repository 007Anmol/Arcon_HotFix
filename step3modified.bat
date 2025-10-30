@echo off
setlocal enabledelayedexpansion

:: === Configuration ===
set "PARENT=E:\DUMMY_Diff.24\final"
set "BASENAME=ARCOSClientManagerOnline"
set "OLDNAME=%BASENAME%OLD"
set "FOLDER1=C:\Users\Administrator\Downloads\A"
set "FOLDER2=C:\Users\Administrator\Downloads\B"

:: Step 0: Delete existing OLD folder if it exists
if exist "%PARENT%\%OLDNAME%" (
    echo [0] Deleting existing "%OLDNAME%" folder...
    rd /S /Q "%PARENT%\%OLDNAME%"
)

:: Step 1: Rename the original folder to “OLD”
echo [1] Renaming original "%BASENAME%" to "%OLDNAME%"...
rename "%PARENT%\%BASENAME%" "%OLDNAME%"

:: Step 2: Copy “OLD” folder back to original name
echo [2] Copying "%OLDNAME%" back to "%BASENAME%"...
xcopy "%PARENT%\%OLDNAME%\*" "%PARENT%\%BASENAME%\" /E /I /Y >nul

:: Step 3: Delete SAML and DBSetting from the newly copied folder
echo [3] Removing unwanted folders from "%PARENT%\%BASENAME%"...
if exist "%PARENT%\%BASENAME%\SAML" rd /S /Q "%PARENT%\%BASENAME%\SAML"
if exist "%PARENT%\%BASENAME%\DBSetting" rd /S /Q "%PARENT%\%BASENAME%\DBSetting"

:: Step 4: Deploy cleaned folder to target locations
echo [4] Deploying "%PARENT%\%BASENAME%" to:
echo     • %FOLDER1%
echo     • %FOLDER2%
xcopy "%PARENT%\%BASENAME%\*" "%FOLDER1%\%BASENAME%\" /E /I /Y >nul
xcopy "%PARENT%\%BASENAME%\*" "%FOLDER2%\%BASENAME%\" /E /I /Y >nul

:: Step 5: Delete the cleaned folder from final location (keep only OLD folder)
echo [5] Removing cleaned folder "%PARENT%\%BASENAME%" to keep only "%OLDNAME%"...
rd /S /Q "%PARENT%\%BASENAME%"

echo.
echo === All done! Only the OLD folder remains in "%PARENT%" ===
pause

@echo off
setlocal enabledelayedexpansion

REM Function to show usage
if "%~3"=="" (
    echo Usage: %~nx0 {DV|IT|UA|PD} <source_folder> <target_folder>
    exit /b 1
)

REM Assign variables
set "ENV=%1"
set "SOURCE_FOLDER=%2"
set "TARGET_FOLDER=%3"

REM Validate environment
if /I not "%ENV%"=="DV" if /I not "%ENV%"=="IT" if /I not "%ENV%"=="UA" if /I not "%ENV%"=="PD" (
    echo Error: Invalid environment. Allowed values are DV, IT, UA, PD.
    exit /b 1
)

REM Ensure source folder exists
if not exist "%SOURCE_FOLDER%" (
    echo Error: Source folder does not exist.
    exit /b 1
)

REM Ensure target folder exists or create it
if not exist "%TARGET_FOLDER%" (
    echo Target folder does not exist. Creating it...
    mkdir "%TARGET_FOLDER%"
)

REM Loop through the files in the source folder that have the environment prefix
for %%F in ("%SOURCE_FOLDER%\%ENV%_*") do (
    REM Get the base filename without the environment prefix and underscore
    set "file=%%~nxF"
    set "basefile=!file:%ENV%_=!"

    REM Check if a file with the same base filename exists in the target folder, delete it
    if exist "%TARGET_FOLDER%\!basefile!" (
        echo Deleting existing file: %TARGET_FOLDER%\!basefile!
        del /f "%TARGET_FOLDER%\!basefile!"
    )

    REM Create a symbolic link
    mklink "%TARGET_FOLDER%\!basefile!" "%%F"
    echo Created symlink for %%F -> %TARGET_FOLDER%\!basefile!
)

endlocal
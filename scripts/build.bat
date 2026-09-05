@echo off
REM ==============================================================================
REM SCRIPT BATCH DE COMPILACIÓN Y EMPAQUETADO: BIBLIOTECA DIGITAL UNTEC
REM ==============================================================================
echo Ejecutando compilacion y generacion de WAR...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0build.ps1"
if %ERRORLEVEL% NEQ 0 (
    echo Error durante la compilacion.
    pause
    exit /b %ERRORLEVEL%
)
pause

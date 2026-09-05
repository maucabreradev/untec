@echo off
REM ==============================================================================
REM SCRIPT BATCH DE PRUEBAS AUTOMATIZADAS (JUNIT 5) - BIBLIOTECA DIGITAL UNTEC
REM ==============================================================================
echo Ejecutando suite de pruebas unitarias y de integracion (JUnit 5)...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0test.ps1"
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Se detectaron errores en las pruebas.
    pause
    exit /b %ERRORLEVEL%
)
pause

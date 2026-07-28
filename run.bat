@echo off
title GJ Projects Manager
cd /d "%~dp0"

set "OUTDIR=%~dp0"

:MENU
cls
echo ============================================
echo       GJ Projects Manager
echo ============================================
echo.
echo Available commands:
echo   1. Install all
echo   2. Lint + Format all
echo   3. Run a specific project
echo   4. Batch install, lint, format (no run)
echo   5. Open project folders
echo   0. Exit
echo.
set /p choice=Choose an option: 
if errorlevel 1 exit /b

if "%choice%"=="1" goto INSTALL
if "%choice%"=="2" goto LINT
if "%choice%"=="3" goto RUN
if "%choice%"=="4" goto BATCH
if "%choice%"=="5" goto OPEN
if "%choice%"=="0" exit /b
goto MENU

:INSTALL
cls
set "LOGFILE=%OUTDIR%run-install-output.txt"
echo === Installing all projects === > "%LOGFILE%"
echo. >> "%LOGFILE%"
echo Installing... (see progress below)
echo.

echo [ai-one/auth-app]
call :INSTALL_ONE ai-one auth-app >> "%LOGFILE%" 2>&1
echo [ai-one/backend]
call :INSTALL_ONE ai-one backend >> "%LOGFILE%" 2>&1
echo [apollo/client]
call :INSTALL_ONE apollo client >> "%LOGFILE%" 2>&1
echo [apollo/server]
call :INSTALL_ONE apollo server >> "%LOGFILE%" 2>&1
echo [car-pooling]
call :INSTALL_ONE car-pooling . >> "%LOGFILE%" 2>&1
echo [formbuilder/client]
call :INSTALL_ONE formbuilder client >> "%LOGFILE%" 2>&1
echo [formbuilder/server]
call :INSTALL_ONE formbuilder server >> "%LOGFILE%" 2>&1
echo [game]
call :INSTALL_ONE game . >> "%LOGFILE%" 2>&1
echo [interview-ai]
call :INSTALL_ONE interview-ai . >> "%LOGFILE%" 2>&1
echo [my-gatsby-portfolio]
call :INSTALL_ONE my-gatsby-portfolio . >> "%LOGFILE%" 2>&1
echo [nykaa]
call :INSTALL_ONE nykaa . >> "%LOGFILE%" 2>&1
echo [sephora]
call :INSTALL_ONE sephora . >> "%LOGFILE%" 2>&1
echo [syngenta]
call :INSTALL_ONE syngenta . >> "%LOGFILE%" 2>&1

echo.
echo === React-practice sub-projects ===
echo. >> "%LOGFILE%"
echo === React-practice sub-projects === >> "%LOGFILE%"
cd /d "%~dp0..\react-practice"
for /d %%d in (*) do (
  if exist "%%d\package.json" (
    echo [react-practice/%%d]
    echo Installing %%d... >> "%LOGFILE%"
    cd "%%d" && call pnpm install >> "%LOGFILE%" 2>&1 && cd ..
  )
)
echo. >> "%LOGFILE%"
echo Done! All dependencies installed. >> "%LOGFILE%"
cd /d "%~dp0"
echo.
echo Done! Output saved to: "%LOGFILE%"
echo.
echo Press any key to open the log file...
pause >nul
start "" "%LOGFILE%"
goto MENU

:INSTALL_ONE
setlocal
set "proj=%~1"
set "sub=%~2"
set "pkgdir=%~dp0..\%proj%"
if not "%sub%"=="." set "pkgdir=%pkgdir%\%sub%"
echo ====== %proj%/%sub% ======
cd /d "%pkgdir%"
if exist package.json (
  call pnpm install
) else (
  echo No package.json found
)
endlocal
goto :EOF

:LINT
cls
set "LOGFILE=%OUTDIR%run-lint-output.txt"
echo === Lint + Format all === > "%LOGFILE%"
echo. >> "%LOGFILE%"
echo Running lint/format... (see progress below)
echo.

echo [ai-one/auth-app]
call :LINT_ONE ai-one auth-app >> "%LOGFILE%" 2>&1
echo [car-pooling]
call :LINT_ONE car-pooling . >> "%LOGFILE%" 2>&1
echo [my-gatsby-portfolio]
call :LINT_ONE my-gatsby-portfolio . >> "%LOGFILE%" 2>&1

echo. >> "%LOGFILE%"
echo Done! >> "%LOGFILE%"
echo.
echo Done! Output saved to: "%LOGFILE%"
echo.
echo Press any key to open the log file...
pause >nul
start "" "%LOGFILE%"
goto MENU

:LINT_ONE
setlocal
set "proj=%~1"
set "sub=%~2"
set "pkgdir=%~dp0..\%proj%"
if not "%sub%"=="." set "pkgdir=%pkgdir%\%sub%"
cd /d "%pkgdir%"
if exist package.json (
  echo ====== %proj%/%sub% ======
  call pnpm run lint 2>nul
  if errorlevel 1 echo No lint script
  call pnpm run format 2>nul
  if errorlevel 1 echo No format script
)
endlocal
goto :EOF

:RUN
cls
echo ============================================
echo       Run a project
echo ============================================
echo.
echo  1. ai-one          (React + Express)
echo  2. apollo          (React + Express)
echo  3. car-pooling     (NestJS API)
echo  4. formbuilder     (React + Express)
echo  5. game            (React CRA)
echo  6. interview-ai    (Express)
echo  7. my-gatsby-portfolio (Gatsby)
echo  8. nykaa           (React CRA)
echo  9. sephora         (Express)
echo 10. syngenta        (React CRA)
echo 11. react-practice  (CRA sub-projects)
echo  0. Back to menu
echo.
set /p r=Choose project: 
if errorlevel 1 exit /b

if "%r%"=="1" start "ai-one" cmd /c "cd /d "%~dp0..\ai-one" && run.bat"
if "%r%"=="2" start "apollo" cmd /c "cd /d "%~dp0..\apollo" && run.bat"
if "%r%"=="3" start "car-pooling" cmd /c "cd /d "%~dp0..\car-pooling" && run.bat"
if "%r%"=="4" start "formbuilder" cmd /c "cd /d "%~dp0..\formbuilder" && run.bat"
if "%r%"=="5" start "game" cmd /c "cd /d "%~dp0..\game" && run.bat"
if "%r%"=="6" start "interview-ai" cmd /c "cd /d "%~dp0..\interview-ai" && run.bat"
if "%r%"=="7" start "my-gatsby-portfolio" cmd /c "cd /d "%~dp0..\my-gatsby-portfolio" && run.bat"
if "%r%"=="8" start "nykaa" cmd /c "cd /d "%~dp0..\nykaa" && run.bat"
if "%r%"=="9" start "sephora" cmd /c "cd /d "%~dp0..\sephora" && run.bat"
if "%r%"=="10" start "syngenta" cmd /c "cd /d "%~dp0..\syngenta" && run.bat"
if "%r%"=="11" start "react-practice" cmd /c "cd /d "%~dp0..\react-practice" && run.bat"
if "%r%"=="0" goto MENU
goto RUN

:BATCH
cls
set "ILOG=%OUTDIR%run-install-output.txt"
set "LLOG=%OUTDIR%run-lint-output.txt"
echo === Batch: install + lint + format ===
echo.
echo -- INSTALL PHASE --
echo === Installing all projects === > "%ILOG%"
echo. >> "%ILOG%"

echo [ai-one/auth-app]
call :INSTALL_ONE ai-one auth-app >> "%ILOG%" 2>&1
echo [ai-one/backend]
call :INSTALL_ONE ai-one backend >> "%ILOG%" 2>&1
echo [apollo/client]
call :INSTALL_ONE apollo client >> "%ILOG%" 2>&1
echo [apollo/server]
call :INSTALL_ONE apollo server >> "%ILOG%" 2>&1
echo [car-pooling]
call :INSTALL_ONE car-pooling . >> "%ILOG%" 2>&1
echo [formbuilder/client]
call :INSTALL_ONE formbuilder client >> "%ILOG%" 2>&1
echo [formbuilder/server]
call :INSTALL_ONE formbuilder server >> "%ILOG%" 2>&1
echo [game]
call :INSTALL_ONE game . >> "%ILOG%" 2>&1
echo [interview-ai]
call :INSTALL_ONE interview-ai . >> "%ILOG%" 2>&1
echo [my-gatsby-portfolio]
call :INSTALL_ONE my-gatsby-portfolio . >> "%ILOG%" 2>&1
echo [nykaa]
call :INSTALL_ONE nykaa . >> "%ILOG%" 2>&1
echo [sephora]
call :INSTALL_ONE sephora . >> "%ILOG%" 2>&1
echo [syngenta]
call :INSTALL_ONE syngenta . >> "%ILOG%" 2>&1

echo.
echo === React-practice ===
echo. >> "%ILOG%"
echo === React-practice === >> "%ILOG%"
cd /d "%~dp0..\react-practice"
for /d %%d in (*) do (
  if exist "%%d\package.json" (
    echo [react-practice/%%d]
    echo Installing %%d... >> "%ILOG%"
    cd "%%d" && call pnpm install >> "%ILOG%" 2>&1 && cd ..
  )
)
echo >> "%ILOG%"
echo Done! All dependencies installed. >> "%ILOG%"

echo.
echo -- LINT PHASE --
echo === Lint + Format all === > "%LLOG%"
echo. >> "%LLOG%"

echo [ai-one/auth-app]
call :LINT_ONE ai-one auth-app >> "%LLOG%" 2>&1
echo [car-pooling]
call :LINT_ONE car-pooling . >> "%LLOG%" 2>&1
echo [my-gatsby-portfolio]
call :LINT_ONE my-gatsby-portfolio . >> "%LLOG%" 2>&1

echo. >> "%LLOG%"
echo Done! >> "%LLOG%"

echo.
echo Done! Output saved to:
echo   "%ILOG%"
echo   "%LLOG%"
echo.
echo Press any key to open the log files...
pause >nul
start "" "%ILOG%"
start "" "%LLOG%"
goto MENU

:OPEN
cls
echo Opening parent project root folder...
start "" "%~dp0.."
echo.
echo Done!
pause
goto MENU

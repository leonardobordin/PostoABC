@echo off
setlocal EnableExtensions EnableDelayedExpansion

title Limpeza Completa de Projeto Delphi

echo ============================================
echo   LIMPEZA COMPLETA DE PROJETO DELPHI
echo ============================================
echo.

REM Pasta base (use . para a pasta atual)
set BASE=%~dp0

echo Pasta base: %BASE%
echo.

REM ==================================================
REM ARQUIVOS TEMPORÁRIOS E DE BUILD (RECURSIVO)
REM ==================================================
echo Removendo arquivos temporarios...

for %%F in (
  dcu dcp bak local identcache stat hpp
  exe dll bpl map drc rsm res
  ~*
) do (
  for /r "%BASE%" %%G in (*.%%F) do (
    del /f /q "%%G" 2>nul
  )
)

REM ==================================================
REM PASTAS DE BUILD (RECURSIVO)
REM ==================================================
echo Removendo pastas de build...

for %%D in (
  __history __recovery
  Debug Release
  Win32 Win64 Android iOS OSX64 Linux64
) do (
  for /d /r "%BASE%" %%G in (%%D) do (
    rmdir /s /q "%%G" 2>nul
  )
)

REM ==================================================
REM PASTAS GERADAS PELO MSBUILD / DELPHI
REM ==================================================
for %%D in (
  .dproj.local
  .vs
  .cache
) do (
  for /d /r "%BASE%" %%G in (%%D) do (
    rmdir /s /q "%%G" 2>nul
  )
)

echo.
echo Limpeza concluida com sucesso!
echo.

pause

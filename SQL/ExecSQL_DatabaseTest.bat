@echo off
REM Auto-executa em nova janela persistente se chamado diretamente
if "%1"=="RUNNINGFROMSELF" goto :CONTINUE

REM Re-executa a si mesmo com cmd /k para manter a janela aberta
cmd /k "%~0" RUNNINGFROMSELF
exit /b 0

:CONTINUE
REM ========================================================
REM === SCRIPT PRINCIPAL DE CRIACAO DO BANCO DE DADOS ===
REM ========================================================

setlocal enabledelayedexpansion
color 0A
title Criador de Banco de Dados - PostoABC
cd /d "%~dp0"

echo.
echo ==================================================
echo == INICIANDO A CRIACAO DO BANCO DE DADOS ==
echo ==================================================
echo.

:: --- ETAPA 1: TENTA ENCONTRAR CAMAINHOS DO FIREBIRD ---
echo [1/3] Tentando localizar a pasta de instalacao do Firebird...

:: 1. VERIFICA CAMAINHOS DO FIREBIRD
SET DB_PATH=C:\ProjetoPostoABC\POSTOABC.FDB
SET DB_USER=SYSDBA
SET DB_PASS=masterkey
SET DDL_SCRIPT=criar_base.sql
SET FIREBIRD_PATH=

IF EXIST "C:\Program Files\Firebird\Firebird_2_5\bin\isql.exe" SET "FIREBIRD_PATH=C:\Program Files\Firebird\Firebird_2_5\bin"
IF EXIST "C:\Program Files (x86)\Firebird\Firebird_2_5\bin\isql.exe" SET "FIREBIRD_PATH=C:\Program Files (x86)\Firebird\Firebird_2_5\bin"
IF EXIST "C:\Firebird\bin\isql.exe" SET "FIREBIRD_PATH=C:\Firebird\bin"

IF NOT DEFINED FIREBIRD_PATH (
    echo ERRO: Nao foi possivel localizar o Firebird nos caminhos padrao.
    GOTO :TRAP_ERROR
)

echo Firebird encontrado em: "%FIREBIRD_PATH%"

:: 2. VERIFICA SE OS ARQUIVOS SQL EXISTEM
IF NOT EXIST "%DDL_SCRIPT%" (
    echo.
    echo ERRO CRITICO: O arquivo "%DDL_SCRIPT%" nao foi encontrado.
    GOTO :TRAP_ERROR
)

:: --- ETAPA 2: CRIACAO DO ARQUIVO FDB ---
echo.
echo [2/3] Criando o arquivo da base de dados vazia: "%DB_PATH%"
echo.

IF NOT EXIST "C:\ProjetoPostoABC" MKDIR "C:\ProjetoPostoABC"
IF EXIST "%DB_PATH%" DEL /F /Q "%DB_PATH%"

:: Executa criacao do banco e OCULTA a saida verbosa do isql (Pipe | redireciona a saida para NUL)
echo CREATE DATABASE '%DB_PATH%' USER '%DB_USER%' PASSWORD '%DB_PASS%'; | "%FIREBIRD_PATH%\isql.exe" -q >NUL 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo ERRO: Falha ao criar o arquivo FDB.
    GOTO :TRAP_ERROR
)
echo Arquivo FDB criado com sucesso.

:: --- ETAPA 3: EXECUCAO DO SCRIPT DDL (CRIAR TABELAS) ---
echo.
echo [3/3] Executando o script SQL "%DDL_SCRIPT%"...
echo.

"%FIREBIRD_PATH%\isql.exe" -user %DB_USER% -password %DB_PASS% "%DB_PATH%" -i "%DDL_SCRIPT%"
IF %ERRORLEVEL% NEQ 0 (
    echo ERRO: Falha ao executar o script SQL de criacao de tabelas.
    GOTO :TRAP_ERROR
)

echo.
echo =========================================================
echo == SCRIPT CONCLUIDO! BANCO DE DADOS CRIADO. ==
echo =========================================================
echo.
echo Banco de dados criado em: %DB_PATH%
echo Usuario padrao: %DB_USER%
echo Senha padrao: %DB_PASS%
echo.
echo Digite EXIT no prompt para fechar esta janela.
echo.

:FIM
pause
endlocal
exit /b 0

:TRAP_ERROR
echo.
echo =========================================================
echo == ERRO DURANTE A EXECUCAO ==
echo =========================================================
echo.
echo Digite EXIT no prompt para fechar esta janela.
echo.
pause
endlocal
exit /b 1
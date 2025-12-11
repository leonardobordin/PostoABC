@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:: ==========================================================
:: ==  CORRECAO DO DIRETORIO
:: ==========================================================
cd /d "%~dp0"

:: ==========================================================
:: ==  VERIFICACAO DE PRIVILEGIOS DE ADMINISTRADOR
:: ==========================================================
net session >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERRO DE PERMISSAO:
    echo ----------------------------------------------------
    echo Este script PRECISA de privilegios de Administrador.
    echo Por favor, clique com o botao direito no arquivo BAT
    echo e selecione "Executar como Administrador".
    echo ----------------------------------------------------
    echo.
    pause
    EXIT /B 1
)
echo Privilegios de Administrador verificados.
echo.

:: ==========================================================
:: == CONFIGURACOES
:: ==========================================================
SET DB_PATH=C:\ProjetoPostoABC\POSTOABC.FDB
SET DB_USER=SYSDBA
SET DB_PASS=masterkey
SET DDL_SCRIPT=CreateTables.sql
SET FIREBIRD_PATH=
:: ==========================================================

echo ==================================================
echo == INICIANDO A CRIACAO DO BANCO DE DADOS ==
echo ==================================================
echo.

:: 1. TENTA ENCONTRAR O CAMINHO DO FIREBIRD
echo [1/3] Tentando localizar a pasta de instalacao do Firebird...

:: Verifica caminhos
IF EXIST "C:\Program Files\Firebird\Firebird_2_5\bin\isql.exe" SET "FIREBIRD_PATH=C:\Program Files\Firebird\Firebird_2_5\bin"
IF EXIST "C:\Program Files (x86)\Firebird\Firebird_2_5\bin\isql.exe" SET "FIREBIRD_PATH=C:\Program Files (x86)\Firebird\Firebird_2_5\bin"
IF EXIST "C:\Firebird\bin\isql.exe" SET "FIREBIRD_PATH=C:\Firebird\bin"

IF NOT DEFINED FIREBIRD_PATH (
    echo ERRO: Nao foi possivel localizar o Firebird nos caminhos padrao.
    GOTO :TRAP_ERROR
)

echo Firebird encontrado em: "%FIREBIRD_PATH%"

:: 2. VERIFICA SE O ARQUIVO SQL EXISTE
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
    echo ERRO: Falha ao executar o script SQL.
    GOTO :TRAP_ERROR
)

echo.
echo =========================================================
echo == SCRIPT CONCLUIDO! BANCO DE DADOS CRIADO. ==
echo =========================================================

:FIM
ENDLOCAL
pause
EXIT /B 0

:TRAP_ERROR
echo.
echo =========================================================
echo == SCRIPT INTERROMPIDO POR ERRO. ==
echo =========================================================
ENDLOCAL
pause
EXIT /B 1
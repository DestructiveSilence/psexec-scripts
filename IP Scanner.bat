@echo off
Title IP Scanner
setlocal enabledelayedexpansion

@chcp 1251
cls
echo Какую подсеть сканируем? (Пример: 10.12.69)
set /p NETWORK= 
cls
echo Выводить информацию о пользователе? (Y/N)
set /p USER_INFO=
set HOST_NAME=unknown
set USER_LOGON=
set USER_LOGOFF=
@chcp 866
cls

if exist hosts.txt del hosts.txt
if !USER_INFO!==Y (
	echo ==== IP ====    ====== HOSTNAME =======		=============== USER INFO ===============
) else (
	echo ==== IP ====    ====== HOSTNAME =======
)

for /l %%i in (0,1,255) do (
	set IP=!NETWORK!.%%i
	ping -n 1 -w 100 !IP! >nul
	if not errorlevel 1 (
		for /f "tokens=4 delims= " %%a in ('ping -a -n 1 !IP! ^| find "[!IP!]"') do (
			set HOST_NAME=%%a
			if !USER_INFO!==Y (
				for /f "tokens=1 delims=" %%b in ('net view \\!IP! /all 2^>nul ^| find "logon"') do (
					set USER_LOGON=%%b
				)
				for /f "tokens=1 delims=" %%c in ('net view \\!IP! /all 2^>nul ^| find "logoff"') do (
					set USER_LOGOFF=%%c
				)
			)
		)
		echo !IP!	!HOST_NAME!		!USER_LOGON!!USER_LOGOFF!
		echo !HOST_NAME! [!IP!] !USER_LOGON!!USER_LOGOFF! >> hosts.txt
		set HOST_NAME=unknown
		set USER_LOGON=
		set USER_LOGOFF=		
	)
)
echo.
if !USER_INFO!==Y (
	echo ============== HOSTNAME [IP] USER INFO ===============
) else (
	echo ============== HOSTNAME [IP] =========
)
sort hosts.txt
del hosts.txt
endlocal
pause

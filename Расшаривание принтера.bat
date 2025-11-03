@chcp 1251
@echo off
Title = Расшаривание удалённого принтера
cls
set /p PCName=Введите Hostname или IP: 
psexec -nobanner \\%PCName% wmic printer list brief
set /p PrinterName=Имя принтера: 
set /p ShareName=Расшаренное имя:
chcp 866
cls
psexec -nobanner \\%PCName% cscript "C:\Windows\System32\Printing_Admin_Scripts\ru-RU\prncnfg.vbs" -t -p "%PrinterName%" -h "%ShareName%" +shared
pause

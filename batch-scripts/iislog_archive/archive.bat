REM @ECHO OFF

set script_dir=C:\scripts\w3c
set iislog_dir=%SystemDrive%\inetpub\logs\LogFiles
set backup_dir=%Date:~-4,4%-%Date:~-10,2%-%Date:~-7,2%-%Time:~-11,2%'%Time:~-8,2%'%Time:~-5,2%
set archive_dir=\\archive_server\%COMPUTERNAME%

echo Subject: %COMPUTERNAME% W3C Log Archive Report > %script_dir%\log.txt
echo.>> %script_dir%\log.txt
date /t >> %script_dir%\log.txt
echo. >> %script_dir%\log.txt

for /F "tokens=*" %%A in (%script_dir%\log_list.txt) do (
		
	cd %iislog_dir%\%%A

	REM ====Create a backup folder named after Today's date==========================
	mkdir %backup_dir%

	REM ====Move logs that older than 30 days to the backup folder===================
	echo The following w3c logs have been moved to folder %backup_dir% >> %script_dir%\log.txt
	forfiles /p %iislog_dir%\%%A /d -30 /c "cmd /c echo @file & copy /y @file %iislog_dir%\%%A\%backup_dir%" >> %script_dir%\log.txt

	REM ====Archive the backup folder================================================
	%script_dir%\7z a %backup_dir%.zip %iislog_dir%\%%A\%backup_dir%\ >> %script_dir%\log.txt

	REM ====Move the backup folder to the remote archiving folder====================
	dir %iislog_dir%\%%A\%backup_dir%.zip >> %script_dir%\log.txt

	echo Moving %iislog_dir%\%backup_dir%.zip to %archive_dir%... >> %script_dir%\log.txt
	move /y %iislog_dir%\%%A\%backup_dir%.zip %archive_dir%\%%A >> %script_dir%\log.txt
	rmdir /q /s %iislog_dir%\%%A\%backup_dir% >> %script_dir%\log.txt
	
)

REM ====Email the backup report==================================================
echo. >> %script_dir%\log.txt
%script_dir%\sendmail -t < %script_dir%\log.txt

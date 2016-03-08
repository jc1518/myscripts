@ECHO OFF

if "%1" == "" (
	echo ERROR: please specify which DB you want to refresh
	echo Exmaple: finpro2dev.bat dev1
) else ( 	
	echo The script is executed by %username% at %time% %date% 

	
	REM Check the newest Pro DB bak file
	echo Checking the backup files on pro-cdb-01...
	dir /B /O:D \\pro-cdb-01\D$\MSSQL\Backup\finprod\finprod*.bak
	cd /d %~dp0
	:loop
	for /f %%a in ('dir \\pro-cdb-01\D$\MSSQL\Backup\finprod\*.bak /B /O:D') do set newest=%%a
	if "%newest%" == "" GOTO  loop
	echo The latest pro DB backup file is: %newest% 

	REM Check if it already exists
	if exist "%newest%" (
		echo The file already exists! 
	) else (
		echo Cleaning out some free space...
		del /f /q *.bak > NUL
		echo Copying the newest backup file to local... 
		copy /Y \\pro-cdb-01\D$\MSSQL\Backup\finprod\%newest% 
	) 

	echo Killing %1 DB open connnections...
	sqlcmd -i killconn.sql -v dbname = "%1"
	echo done!
	echo Restoring DB %1 from "%CD%\%newest%" now... 
	sqlcmd -i restoredb.sql -v dbname = "%1" dbbackup = "%CD%\%newest%"
	echo done!
	
	echo Updating the DB %1 configurations for TechOne dev environment...
	if "%1" == "findev1" (
		sqlcmd -i configdb.sql -v dbname = "%1" t1server = "dev-t1-01" dbconfigname = "Development1"
	) 
	
	if "%1" == "findev2" (
		sqlcmd -i configdb.sql -v dbname = "%1" t1server = "dev-t1-02" dbconfigname = "Development2" 
	)
	
	if "%1" == "findev3" (
		sqlcmd -i configdb.sql -v dbname = "%1" t1server = "dev-t1-03" dbconfigname = "Development3"
	)
	
	echo done!
)


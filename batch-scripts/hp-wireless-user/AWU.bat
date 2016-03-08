@echo off

cd /d %~dp0

set ADMIN=root
set ADMINPWD=*******
set IPADDR=x.x.x.x

echo ***********************************
echo *   Add HP MSM720 Wirelsss User   * 
echo ***********************************

set /p USERNAME=Please enter the username:
set /p PASSWORD=Please enter the password:
set /p ENDTIME=Please enter the endtime (YYYY-MM-DD HH:MM:SS): 

echo en > config
echo config >> config
echo user profile "%USERNAME%" >> config
echo password "%PASSWORD%" >> config
echo control method endtime >> config
echo end time "%ENDTIME%" >> config
echo end >> config
echo end >> config
echo ^<html^> > result.html

date /t > log
time /t >> log
PLINK.EXE -ssh %ADMIN%@%IPADDR% -pw %ADMINPWD%  < config >> log

if %ERRORLEVEL% == 0 (
	echo ^<body^> >> result.html
	echo ^<h3^>The user has been successfuuly created^</h3^> >> result.html
	echo ^<table border="1" style="width:300px"^> >> result.html
	echo ^<table style="width:300px^> >> result.html
	echo ^<tr^> >> result.html
    echo ^<td^>Username:^</td^> >> result.html
    echo ^<td^>%USERNAME%^</td^> >> result.html		
    echo ^</tr^> >> result.html
	echo ^<tr^> >> result.html
    echo ^<td^>Password:^</td^> >> result.html
    echo ^<td^>%PASSWORD%^</td^> >> result.html		
    echo ^</tr^> >> result.html
	echo ^<tr^> >> result.html
    echo ^<td^>Endtime:^</td^> >> result.html
    echo ^<td^>%ENDTIME%^</td^> >> result.html		
    echo ^</tr^> >> result.html
	echo ^</table^> >> result.html
) else (
	echo ^<body^> >> result.html
	echo ^<h3^>Opps! Failed, please try again^</h3^> >> result.html
)

echo ^</body^> >> result.html
echo ^</html^> >> result.html

start result.html

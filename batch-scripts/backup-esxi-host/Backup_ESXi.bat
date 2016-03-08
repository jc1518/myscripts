REM VMware VCLI has to be installed first
REM Create folder C:\Scripts\ESXi, and copy all files into it
REM Define your SMTP and email in sendmail.ini
REM List ESXi hosts in servers.txt file

REM Restore example: vicfg-cfgbackup.pl --server esxi-host-01.company.com --username root --password ****** -l C:\Scripts\26-11-2012\esxi-host-01.company.com

@ECHO OFF
cd C:\Scripts\ESXi

REM ====Backup ESXi hosts=======================================================
mkdir %Date:~-10,2%-%Date:~-7,2%-%Date:~-4,4%
cd %Date:~-10,2%-%Date:~-7,2%-%Date:~-4,4%

echo Subject: ESXi Backup Report > C:\Scripts\ESXi\log.txt
echo.>> C:\Scripts\ESXi\log.txt
date /t >> C:\Scripts\ESXi\log.txt

REM ====Replace ****** with your ESXi root password=============================
for /F "tokens=*" %%A in (C:\Scripts\ESXi\servers.txt) do (
vicfg-cfgbackup.pl --server %%A --username root --password ****** --save %%A >> C:\Scripts\ESXi\log.txt 2>&1
)

echo. >> C:\Scripts\ESXi\log.txt

REM ====Remove archive folders older then 7 days==================================
echo +++++++++++++++++++++++++++++++++++++++++++ >> C:\Scripts\ESXi\log.txt 
echo The following old folders have been removed >> C:\Scripts\ESXi\log.txt 
forfiles /p C:\scripts\ESXi /d -7 /c "cmd /c if @isdir==TRUE echo @file & RD /Q /S @file" >> C:\Scripts\ESXi\log.txt 2>&1

REM ====Email the backup report=================================================
echo. >> C:\Scripts\ESXi\log.txt
C:\Scripts\ESXi\sendmail -t < C:\Scripts\ESXi\log.txt

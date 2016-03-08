-- Restore DB
RESTORE DATABASE $(dbname) FROM DISK = '$(dbbackup)'
WITH 
--	MOVE '$(dbname)' TO 'D:\SQLDB\$(dbname).mdf',
--	MOVE '$(dbname)_Log' TO 'L:\SQLLOGS\$(dbname).ldf',
	REPLACE
GO

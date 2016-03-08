-- Change DB settings for TechOne dev environment
use $(dbname)
drop user techone
create user techone for login $(dbname)
exec sp_addrolemember 'db_owner','techone'
GRANT EXECUTE on SCHEMA::dbo to techone

--SELECT * FROM TBDPS_SVR_CTL
--select * from TBDPS_SVR_DP

UPDATE TBDPS_SVR_CTL 
	SET SERVER_NAME = '$(t1server)'
		,SERVER_NARR = 'This is the main DP Server'
		,NETWORK_ADDR = '$(t1server)'
		,NOTIFICATION_USER = '$(dbname)'
		,CONFIG_NAME = '$(dbconfigname)'
WHERE SERVER_NAME = 'PRO-CDP-01'

UPDATE TBDPS_SVR_DP set SERVER_NAME = '$(t1server)' where SERVER_NAME = 'PRO-CDP-01'

UPDATE TBDPJ_JOB_CTL set PROC_BY_SRV_NAME = '$(t1server)' where PROC_BY_SRV_NAME = 'PRO-CDP-01'


delete from TBDPS_SVR_CTL 
where SERVER_NAME = 'PRO-CDP-02'

delete from TBDPS_SVR_CTL 
where SERVER_NAME = 'PRO-CDP-03'

delete from TBDPS_SVR_CTL 
where SERVER_NAME = 'PRO-CDP-04'

delete from TBDPS_SVR_DP 
where SERVER_NAME = 'PRO-CDP-02'

delete from TBDPS_SVR_DP 
where SERVER_NAME = 'PRO-CDP-03'

delete from TBDPS_SVR_DP 
where SERVER_NAME = 'PRO-CDP-04'
GO 

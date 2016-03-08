set nocount on

declare @databasename varchar(100)
set @databasename = "$(dbname)"

declare @query varchar(max)
set @query = ''

select 
    db_name(dbid) as [Database Name], 
    count(dbid) as [No Of Connections],
    loginame as [Login Name]
from
    sys.sysprocesses
where 
    dbid=db_id(@databasename)
group by 
    dbid, loginame
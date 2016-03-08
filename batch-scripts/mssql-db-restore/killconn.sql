-- Kill open connections
set nocount on
declare @databasename varchar(100)
declare @query varchar(max)
set @query = ''

set @databasename = '$(dbname)'
if db_id(@databasename) < 4
begin
	print 'system database connection cannot be killeed'
return
end

select @query=coalesce(@query,',' )+'kill '+convert(varchar, spid)+ '; '
from master..sysprocesses where dbid=db_id(@databasename)

if len(@query) > 0
begin
print @query
	exec(@query)
end

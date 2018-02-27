exec sp_executesql @stmt=N'begin try
declare @enable int
select top 1 @enable = convert(int,value_in_use) from sys.configurations where name = ''default trace enabled''
if @enable = 1 --default trace is enabled
begin 
        declare @d1 datetime;
        declare @diff int;
        declare @curr_tracefilename varchar(500); 
        declare @base_tracefilename varchar(500); 
        declare @indx int ;
        declare @temp_trace table (
                obj_name nvarchar(256) collate database_default
        ,       database_name nvarchar(256) collate database_default
        ,       start_time datetime
        ,       event_class int
        ,       event_subclass int
        ,       object_type int
        ,       server_name nvarchar(256) collate database_default
        ,       login_name nvarchar(256) collate database_default
        ,       application_name nvarchar(256) collate database_default
        ,       ddl_operation nvarchar(40) collate database_default 
        );
        
        select @curr_tracefilename = path from sys.traces where is_default = 1 ; 
        set @curr_tracefilename = reverse(@curr_tracefilename)
        select @indx  = PATINDEX(''%\%'', @curr_tracefilename) 
        set @curr_tracefilename = reverse(@curr_tracefilename)
        set @base_tracefilename = LEFT( @curr_tracefilename,len(@curr_tracefilename) - @indx) + ''\log.trc'';

        insert into @temp_trace 
        select ObjectName
        ,       DatabaseName
        ,       StartTime
        ,       EventClass
        ,       EventSubClass
        ,       ObjectType
        ,       ServerName
        ,       LoginName
        ,       ApplicationName
        ,       ''temp'' 
        from ::fn_trace_gettable( @base_tracefilename, default ) 
        where EventClass in (46,47,164) and EventSubclass = 0 and DatabaseID <> 2 

        update @temp_trace set ddl_operation = ''CREATE'' where event_class = 46
        update @temp_trace set ddl_operation = ''DROP'' where event_class = 47
        update @temp_trace set ddl_operation = ''ALTER'' where event_class = 164

        select @d1 = min(start_time) from @temp_trace
        set @diff= datediff(hh,@d1,getdate())
        set @diff=@diff/24; 

        select  @diff as difference
        ,       @d1 as date
        ,       object_type as obj_type_desc 
        ,       * 
        from @temp_trace where object_type not in (21587)
        order by start_time desc
end 
else 
begin 
        select top 0 1 as difference, 1 as date, 1 as obj_type_desc, 1 as obj_name, 1 as dadabase_name, 1 as start_time, 1 as event_class, 1 as event_subclass, 1 as object_type, 1 as server_name, 1 as login_name, 1 as application_name, 1 as ddl_operation 
end
end try
begin catch
select -100 as difference
,       ERROR_NUMBER() as date
,       ERROR_SEVERITY() as obj_type_desc
,       ERROR_STATE() as obj_name
,       ERROR_MESSAGE() as database_name
,       1 as start_time, 1 as event_class, 1 as event_subclass, 1 as object_type, 1 as server_name, 1 as login_name, 1 as application_name, 1 as ddl_operation 
end catch',@params=N''


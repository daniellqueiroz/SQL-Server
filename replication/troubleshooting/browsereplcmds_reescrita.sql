 EXEC browsereplcmds '0x000410E700001BAE003E00000000','0x000410E700001BAE003E00000000'

ALTER procedure browsereplcmds   
 @xact_seqno_start nchar(22) = NULL, --lower boundry of the query  
 @xact_seqno_end nchar(22) = NULL, -- upper boundry of the query  
 @originator_id int = NULL, -- limit query to the specified originator source  
 @publisher_database_id int = NULL, -- limit query to the specified publication database  
 @article_id int = NULL, -- limit query to the specified article  
 @command_id int = NULL, -- limit query to the specified command id  
 --the following apply to agent specific cmds (per sp_MSget_repl_commands called by agent)  
 @agent_id int = NULL,  -- when present all other input parameters except @xact_seqno_start are ignored  
 @compatibility_level int = 9000000 -- use 7000000 if subscriber is SQL70  
as  
 declare @query nvarchar( 4000 )  
  ,@retcode   int  
  ,@dbname sysname  
  
--first let's find out if we are returning cmds specific to an agent  
if(@agent_id is not NULL)  
begin  
 if @xact_seqno_start is null  
 begin  
     select @xact_seqno_start = N'0x00000000000000000000'  
 end  
 select @query = N'exec sys.sp_MSget_repl_commands ' + cast (@agent_id as nvarchar(12)) + N', ' + sys.fn_replreplacesinglequote(@xact_seqno_start ) + N', 0, ' + cast (@compatibility_level as nvarchar(12))  
 exec sys.sp_printagentstatement @query  
 return 0  
end  
  
--we know this is not specific to an agent, now go against the entire table.  
if( @command_id is not null )  
begin  
    if( @xact_seqno_start is null or @publisher_database_id is null )  
    begin  
        raiserror( 21110, 16, -1 )  
        return 1  
    end  
    else if @xact_seqno_start != @xact_seqno_end   
    begin  
        raiserror( 21109, 16, -1 )  
        return 1  
    end  
end  
  
if @xact_seqno_start is null  
begin  
    select @xact_seqno_start = N'0x00000000000000000000'  
end  
if @xact_seqno_end is null  
begin  
    select @xact_seqno_end = N'0xFFFFFFFFFFFFFFFFFFFF'  
end  
  
select @query = N'select cmds.article_id, cast (cmds.partial_command as tinyint), cmds.command, cmds.xact_seqno, '  
select @query = @query + 'cmds.xact_seqno, 0, cmds.command_id, cmds.type, orgs.srvname, orgs.dbname, '  
select @query = @query + 'cast (cmds.hashkey as smallint), orgs.publication_id, orgs.dbversion, cmds.originator_lsn '  
select @query = @query + 'from MSrepl_commands cmds left join MSrepl_originators orgs on cmds.originator_id = orgs.id '  
  
if @command_id is not null  
begin  
    select @query = @query + N'where cmds.xact_seqno = ' + sys.fn_replreplacesinglequote(@xact_seqno_start )  
end  
else  
begin  
    select @query = @query + N'where cmds.xact_seqno >= ' + sys.fn_replreplacesinglequote(@xact_seqno_start) + N' and cmds.xact_seqno <= ' + sys.fn_replreplacesinglequote(@xact_seqno_end)   
end  
  
if @originator_id is not null  
begin  
    select @query = @query + N' and cmds.originator_id = ' + convert( nvarchar, @originator_id )  
end  
  
if @publisher_database_id is not null  
begin  
    select @query = @query + N' and cmds.publisher_database_id = ' + convert( nvarchar, @publisher_database_id )  
end  
  
if @article_id is not null  
begin  
    select @query = @query + N' and cmds.article_id = ' + convert( nvarchar, @article_id )  
end  
  
if @command_id is not null  
begin  
 -- No need to use article_id and originator_id  
    select @query = @query + N' and cmds.command_id >= ' + convert( nvarchar, @command_id )  
    select @query = @query + N' and cmds.command_id <= ( select min( command_id ) from MSrepl_commands c '  
    select @query = @query + N' where c.xact_seqno = ' +  sys.fn_replreplacesinglequote(@xact_seqno_start )   
    select @query = @query + N' and c.publisher_database_id = ' + convert( nvarchar, @publisher_database_id )  
    select @query = @query + N' and c.command_id >= ' + convert( nvarchar, @command_id )  
    select @query = @query + N' and c.partial_command = 0 )'    
end  
  
select @query = @query + N' order by cmds.originator_id, cmds.publisher_database_id, cmds.xact_seqno, cmds.article_id, cmds.command_id asc'  
  
  
PRINT @query  


GO




/*
select cmds.article_id, cast(substring(command,7,8000) as nvarchar(max)) , cast (cmds.partial_command as tinyint), cmds.command, cmds.xact_seqno, cmds.xact_seqno, 0, cmds.command_id, cmds.type, 
orgs.srvname, orgs.dbname, cast (cmds.hashkey as smallint), orgs.publication_id, orgs.dbversion, cmds.originator_lsn 
from MSrepl_commands cmds left join MSrepl_originators orgs on cmds.originator_id = orgs.id 
where cmds.xact_seqno >= 0x000410E700001BAE003E and cmds.xact_seqno <= 0x000410E700001BAE003E

*/

 declare @query nvarchar( 4000 )  
SET @query = 'select cmds.article_id, cast (cmds.partial_command as tinyint), cmds.command, cmds.xact_seqno, cmds.xact_seqno, 0, cmds.command_id, cmds.type, 
orgs.srvname, orgs.dbname, cast (cmds.hashkey as smallint), orgs.publication_id, orgs.dbversion, cmds.originator_lsn 
from MSrepl_commands cmds left join MSrepl_originators orgs on cmds.originator_id = orgs.id 
where cmds.xact_seqno >= 0x000410E700001BAE003E and cmds.xact_seqno <= 0x000410E700001BAE003E'

exec sys.sp_printstatement @query  


exec sp_helptext  'sys.sp_printstatement'

/*
remarks:

1. Use this script to generate the script to kill connections on a database, detach and attach a database
2. The script to create the procedure 'proc_kill_processes_por_database is provided in the repository

*/

USE master
go

select 'exec master.dbo.[proc_kill_processes_por_database] @dbname = ' + name from sys.databases where database_id > 4

select 'EXEC master.dbo.sp_detach_db @dbname='''+name+''',@keepfulltextindexfile=N''true'''
from sys.databases where database_id > 4

select distinct 'CREATE DATABASE ['+ db_name(dbid) + '] ON ( FILENAME = N'''+dbo.pegaArquivosBD(db_name(dbid),1)+''' ),( FILENAME = N'''+dbo.pegaArquivosBD(db_name(dbid),2)+''' ) FOR ATTACH ' 
from sys.sysaltfiles 


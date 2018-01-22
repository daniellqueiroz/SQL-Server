rem use this script to automate the extraction of stored procedure code
rem edit the connection properties on the respective vbs script

@echo off


rem sqlcmd -U rafael.bahia -P alucard__535 -S 10.140.1.41,1145 -d db_prd_pontofrio -Q "SELECT ISNULL(smsp.definition, ssmsp.definition) AS [Definition] FROM sys.all_objects AS sp LEFT OUTER JOIN sys.sql_modules AS smsp ON smsp.object_id = sp.object_id LEFT OUTER JOIN sys.system_sql_modules AS ssmsp ON ssmsp.object_id = sp.object_id WHERE (sp.type = N'P' OR sp.type = N'RF' OR sp.type='PC')and(sp.name=N'%1' and SCHEMA_NAME(sp.schema_id)=N'dbo')" -o C:\Users\RBSinistro\Dropbox\SQL\backups\%1.log


cscript /nologo c:\Dropbox\DBA\ScriptWH\PROCEDURES\ScriptingProcs.vbs %1 > c:\Dropbox\DBA\ScriptWH\PROCEDURES\backup\%1.sql
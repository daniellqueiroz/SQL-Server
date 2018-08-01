rem use this script to automate the extraction of stored procedure code
rem edit the connection properties on the respective vbs script
rem note that this script does not use VBS (as does its initial version). Instead, it connects to your database, runs a offset based query to extract the routine code

@echo off

rem SQLCMD /nologo c:\Dropbox\DBA\ScriptWH\PROCEDURES\ScriptingProcs.vbs %1 > c:\Dropbox\DBA\ScriptWH\PROCEDURES\backup\%1.sql

SQLCMD -U user -P pass -S 10.128.65.27,1103 -d db_prd_extra -i c:\Dropbox\DBA\ScriptWH\PROCEDURES\BackUpSprocs.sql -o c:\Dropbox\DBA\ScriptWH\PROCEDURES\Sprocs.sql


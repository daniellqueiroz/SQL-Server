/*
(SELECT * FROM sys.objects WHERE name='buscaexecutanofulltext' AND DATEDIFF(DAY,modify_date,GETDATE())<14)
- SYS.OBJECTS
*/

DECLARE @objeto VARCHAR(1000)='clientelista';
IF NOT EXISTS(SELECT * FROM sys.triggers WHERE parent_id=0 AND is_ms_shipped=0 and name not like 'tr_%' AND is_disabled=0)
BEGIN
	RAISERROR('A trigger de auditoria não está instalada nesse banco ou está desativada.',16,10);

	if EXISTS(select *,DATEDIFF(DAY,PostTime,GETDATE()) from dba.dbo.auditddloperations where databasename=DB_NAME() and object=@objeto AND DATEDIFF(DAY,PostTime,GETDATE())<14 AND LoginName<>ORIGINAL_LOGIN())
	BEGIN
		RAISERROR('foi encontrada uma alteração no objeto %s nos últimos 14 dias - AUDITORIA_CASO01',16,1,@objeto);
	END

	if EXISTS(SELECT * FROM sys.objects WHERE name=@objeto AND DATEDIFF(DAY,modify_date,GETDATE())<14) 
	BEGIN
		RAISERROR('foi encontrada uma alteração no objeto %s nos últimos 14 dias - SYS.OBJECTS',16,1,@objeto);
		RETURN;
	END

	RETURN;
END


if EXISTS(select *,DATEDIFF(DAY,PostTime,GETDATE()) from dba.dbo.auditddloperations where databasename=DB_NAME() and object=@objeto AND DATEDIFF(DAY,PostTime,GETDATE())<14 AND LoginName<>ORIGINAL_LOGIN())
BEGIN
	select *,DATEDIFF(DAY,PostTime,GETDATE()) from dba.dbo.auditddloperations where databasename=DB_NAME() and object=@objeto AND DATEDIFF(DAY,PostTime,GETDATE())<14 AND LoginName<>ORIGINAL_LOGIN()
	RAISERROR('foi encontrada uma alteração no objeto %s nos últimos 14 dias - AUDITORIA_CASO02',16,1,@objeto);
	RETURN;
END
GO



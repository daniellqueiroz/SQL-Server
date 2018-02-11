-- use this script to create a trigger that will prevent certain logins from being used in some environments (SSMS, for example)
-- specify the logins and application names according to necessity

IF  EXISTS (SELECT * FROM master.sys.server_triggers WHERE parent_class_desc = 'SERVER' AND name = N'BloqueiaLoginAplicacao')
DROP TRIGGER [BloqueiaLoginAplicacao] ON ALL SERVER
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [BloqueiaLoginAplicacao]
ON ALL SERVER
FOR LOGON
AS
BEGIN
IF ( ORIGINAL_LOGIN() IN ('usr_aoc_web','usr_milhagem','os_precif','usr_contactgrabber','usr_hp_web','usr_pf_web','us_intratv','usr_laselva_web','usr_greenvana_loja','usr_greenvana_corp','usr_leader_loja','usr_leader_corp','usr_privalia_corp','usr_privalia_loja','usr_hom_web','usr_des_web')  AND APP_NAME() LIKE 'Microsoft SQL Server Management Studio%')
BEGIN
	ROLLBACK;
	RAISERROR('É proibido logar com o usuário da aplicação neste ambiente a partir das estações de trabalho.',16,1)
	IF EXISTS (SELECT * FROM sys.databases WHERE NAME = 'dba')
	BEGIN
		IF OBJECT_ID('dba.dbo.AuditaLogonUsuarioAplicacao') IS NOT NULL
		BEGIN TRY
			INSERT INTO dba.dbo.AuditaLogonUsuarioAplicacao (hostname,DATA) VALUES (HOST_NAME(),GETDATE())
		END TRY
		BEGIN CATCH
			PRINT ERROR_MESSAGE()
		END CATCH
	END
END
END
GO

ENABLE TRIGGER [BloqueiaLoginAplicacao] ON ALL SERVER
GO


-- this is to concede access for the above logins to the controle database, so that you can track the attempts to log on to the instances with the forbidden users
USE dba -- put the name of controle database here
GO

DECLARE @string NVARCHAR(200)
DECLARE @str VARCHAR(500)
SET @str = 'usr_aoc_web,os_precif,us_intratv,usr_laselva_web,usr_contactgrabber,usr_hp_web,usr_pf_web,usr_milhagem,usr_extra_web,usr_cb_web,usr_leader_loja,usr_leader_corp,usr_greenvana_loja,usr_greenvana_corp,usr_privalia_loja,usr_privalia_corp'

DECLARE @pos INT
DECLARE @user VARCHAR(500)

-- Need to tack a delimiter onto the end of the input string if one doesn't exist
IF RIGHT(RTRIM(@str),1) <> ','
 SET @str = @str  + ','

SET @pos =  PATINDEX('%,%' , @str)
WHILE @pos <> 0 
BEGIN
SET @user = LEFT(@str, @pos - 1)
 

IF EXISTS (SELECT * FROM sys.syslogins WHERE name = @user)
 BEGIN
	PRINT CAST(@user AS VARCHAR(500))
	IF NOT EXISTS (SELECT * FROM sysusers WHERE name = @user)
	BEGIN
		SET @string = 'CREATE USER ' + QUOTENAME(@user) + ' FOR LOGIN ' + QUOTENAME(@user) + ' WITH DEFAULT_SCHEMA = dbo;'
		PRINT (@string);
		EXEC (@string);
	END
	SET @string = 'grant insert on dba.dbo.AuditaLogonUsuarioAplicacao to ' + QUOTENAME(@user) + ';'
	PRINT (@string) + CHAR(13);
	--EXEC (@string);
 END
  SET @str = STUFF(@str, 1, @pos, '')
 SET @pos =  PATINDEX('%,%' , @str)
END

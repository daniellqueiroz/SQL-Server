-- use this script to drop all foreign keys that point to a specific table
-- this can be useful when you need to perform clean up tasks. Do not forget to save a backup of your foreign keys first
-- see my other scripts to create those backups

DECLARE @objname sysname
DECLARE @objid INT 
SET @objname = 'produto' --name your table here
SET @objid = (SELECT OBJECT_ID(@objname))
DECLARE @cmd VARCHAR(MAX)

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE referenced_object_id = @objid)
BEGIN
	SELECT @cmd = REPLACE ( 
	( 
		SELECT 'alter table ' +  DB_NAME() + '.' + RTRIM(SCHEMA_NAME(OBJECTPROPERTY(parent_object_id,'schemaid')))  
		+ '.' + OBJECT_NAME(parent_object_id) + ' drop constraint ' + OBJECT_NAME(object_id)  + '|'
		FROM sys.foreign_keys 
		WHERE referenced_object_id = @objid 
		FOR XML PATH('')
	)
	,'|',';')

	EXEC (@cmd)
END
GO
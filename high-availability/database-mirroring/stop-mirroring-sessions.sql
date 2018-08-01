
--run the generated command at both principal and mirror database
SELECT 'alter database ['+ DB_NAME(database_id) + '] set partner off',* FROM sys.database_mirroring WHERE mirroring_state_desc='SUSPENDED'


ALTER TABLE dbo.DadosConfiguracao 
DISABLE CHANGE_TRACKING 

ALTER TABLE dbo.DadosRecursos
DISABLE CHANGE_TRACKING 

ALTER DATABASE db_hom_extra 
SET CHANGE_TRACKING = OFF 


--SELECT * FROM sys.change_tracking_tables

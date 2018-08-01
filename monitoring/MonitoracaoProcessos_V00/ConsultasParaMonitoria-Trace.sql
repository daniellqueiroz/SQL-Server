select CONVERT(VARCHAR(max),TextData) + CHAR(10)+CHAR(13)+'GO'+ CHAR(10)+CHAR(13) FROM dbo.Trace_GPA_Servicos_SkuEstoqueSaldo_SelectPrazoPrevisaoByIdSku WHERE TextData IS NOT NULL

select CONVERT(VARCHAR(max),TextData) + CHAR(10)+CHAR(13)+'GO'+ CHAR(10)+CHAR(13) FROM dbo.Trace_EstoquesRegionalizadosDisponiveisListar WHERE TextData IS NOT NULL

select CONVERT(VARCHAR(max),TextData) + CHAR(10)+CHAR(13)+'GO'+ CHAR(10)+CHAR(13) FROM dbo.trace_spMarcaListar WHERE TextData IS NOT NULL

--DROP TABLE dbo.Trace_EstoquesRegionalizadosDisponiveisListar

BEGIN
DECLARE @description sysname;
                
SELECT 
    @description =  hars.role_desc
FROM 
    sys.DATABASES d
    INNER JOIN sys.dm_hadr_availability_replica_states hars ON d.replica_id = hars.replica_id
WHERE 
    database_id = DB_ID();
        
select @description;
    
END;
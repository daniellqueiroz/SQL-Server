-- run this script to get all the identity columns that are close to hit the maximum value allowed for the data type
-- adjust the threshold variable as you wish

SET CONCAT_NULL_YIELDS_NULL OFF

DECLARE @loja VARCHAR(100)
DECLARE @corpo VARCHAR(500)
DECLARE @envio BIT
DECLARE @threshold BIGINT

IF (SELECT COUNT(1) FROM [10.140.1.17,1191].db_prd_pontofrio.sys.identity_columns WHERE last_value > @threshold) > 0
BEGIN
	SET @loja = 'pf'
	SET @envio = 1
END

IF (SELECT COUNT(1) FROM [10.118.5.5,1170].db_prd_extra.sys.identity_columns WHERE last_value > @threshold) > 0
BEGIN
	SET @loja = @loja + ', ex'
	SET @envio = 1
END

IF (SELECT COUNT(1) FROM [10.118.5.8,1180].db_prd_casasbahia.sys.identity_columns WHERE last_value > @threshold) > 0
BEGIN
	SET @loja = @loja + ', cb'
	SET @envio = 1
END

--SET @corpo = 'Verificar identity das lojas ' + @loja
--PRINT @corpo

IF @envio = 1
BEGIN
	SET @corpo = 'Verificar identity das lojas ' + @loja
	EXEC msdb.dbo.sp_send_dbmail @profile_name = 'DBA', @recipients = 'rafael.bahia@novapontocom.com.br',@body = @corpo, @subject = 'Verificação identity'
END

 


SELECT sic.* FROM [10.140.1.17,1191].db_prd_pontofrio.sys.identity_columns sic,
[10.140.1.17,1191].db_prd_pontofrio.sys.tables st
WHERE st.OBJECT_ID = sic.object_id AND last_value > @threshold ORDER BY st.name

SELECT sic.* FROM [10.118.5.5,1170].db_prd_extra.sys.identity_columns sic,[10.118.5.5,1170].db_prd_extra.sys.tables st
WHERE st.OBJECT_ID = sic.object_id AND last_value > @threshold ORDER BY st.name


SELECT st.name,sic.* FROM [10.118.5.8,1180].db_prd_casasbahia.sys.identity_columns sic,[10.118.5.8,1180].db_prd_casasbahia.sys.tables st
WHERE st.OBJECT_ID = sic.object_id AND last_value > @threshold ORDER BY st.name




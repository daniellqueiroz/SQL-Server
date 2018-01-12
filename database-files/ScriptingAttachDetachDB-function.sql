CREATE FUNCTION pegaArquivosBD (@bd VARCHAR(50), @tipo TINYINT)
RETURNS VARCHAR(200)
AS
BEGIN
	DECLARE @arquivo VARCHAR(200)
	SELECT @arquivo = filename FROM sys.sysaltfiles WHERE dbid = DB_ID(@bd) AND fileid = @tipo
	RETURN @arquivo
END

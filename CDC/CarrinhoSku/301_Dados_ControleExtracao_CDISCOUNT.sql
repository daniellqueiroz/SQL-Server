
--Criar na loja

INSERT INTO dbo.ControleExtracao( Tabela, DataHoraUltimaExtracao ) VALUES  ( 'CarrinhoSku', DATEADD(DAY,-1,GETDATE()) )
GO
GRANT INSERT,DELETE,UPDATE ON ControleExtracao TO [us_crm]
GO


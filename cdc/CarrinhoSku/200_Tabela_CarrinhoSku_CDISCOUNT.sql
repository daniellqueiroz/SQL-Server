
IF NOT EXISTS (SELECT * FROM SYS.columns WHERE NAME = 'DataCriacao' AND object_id=object_id('CarrinhoSku'))
ALTER TABLE CarrinhoSku ADD DataCriacao DATETIME NOT NULL CONSTRAINT DF_CarrinhoSku_DataCriacao DEFAULT getdate()
GO
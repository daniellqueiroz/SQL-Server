/****** Object:  View [dbo].[CarrinhoSkuCRM]    Script Date: 01/10/2014 15:59:19 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[CarrinhoSkuCRM]'))
DROP VIEW [dbo].[CarrinhoSkuCRM]
GO

/****** Object:  View [dbo].[CarrinhoSkuCRM]    Script Date: 01/10/2014 15:59:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[CarrinhoSkuCRM]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[CarrinhoSkuCRM]
AS
SELECT cs.IdCarrinhoSku,cs.UsuarioGUID,cs.IdSku,cs.Valor,cs.IdLojista,c.Parceiro,c.Midia,c.Campanha,c.Data,c.IdListaDeCompra,cs.DataCriacao
,CL.FLAGNEWS,CL.EMAIL
FROM dbo.Carrinho c INNER JOIN dbo.CarrinhoSku cs ON c.UsuarioGUID = cs.UsuarioGUID
INNER JOIN DBO.CLIENTE CL ON cL.UsuarioGUID = cS.UsuarioGUID;
' 
GO


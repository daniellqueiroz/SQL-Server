-- preventing the script from runing on the wrong databases
IF db_name() = '[db_hom_corp]' OR db_name() = '[db_hom_corp]_projeto' OR db_name() = 'db_hom_corp' OR db_name() = 'db_hom_corp_projeto'
OR db_name() = 'db_hom_hp' OR db_name() = 'db_des_hp' OR db_name() = 'db_des_aoc' OR db_name() = 'db_hom_aoc'
BEGIN
	RAISERROR('Este script não pode rodar nesse banco!!!!!!!!!!!!!!!!!!!!!!!!',16,1)
	GOTO fim 
END

-- droping foreign keys to allow future data truncation
BEGIN TRY
--select count(*) from arquivo_testeView where IdFormatoArquivo not in ( select IdFormatoArquivo from FormatoArquivo);
--delete from arquivo_testeView where IdFormatoArquivo not in ( select IdFormatoArquivo from FormatoArquivo);
if object_id('FK_Arquivo_FormatoArquivo') is not null  AND EXISTS (SELECT 1 FROM sys.tables WHERE name = 'arquivo_testeView') alter table arquivo_testeView drop constraint FK_Arquivo_FormatoArquivo
--if object_id('FK_Arquivo_FormatoArquivo') is  null and object_id('arquivo_testeView') is not null alter table arquivo_testeView with check add constraint FK_Arquivo_FormatoArquivo foreign key (IdFormatoArquivo) references FormatoArquivo (IdFormatoArquivo)  on update  no action  on delete  no action 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()  + cast(ERROR_number() as varchar) + cast(ERROR_LINE() as varchar)
END CATCH
BEGIN TRY
--select count(*) from arquivo_testeView where IdTipoArquivo not in ( select IdTipoArquivo from TipoArquivo);
--delete from arquivo_testeView where IdTipoArquivo not in ( select IdTipoArquivo from TipoArquivo);
if object_id('FK_Arquivo_TipoArquivo') is not null AND EXISTS (SELECT 1 FROM sys.tables WHERE name = 'arquivo_testeView')  alter table arquivo_testeView drop constraint FK_Arquivo_TipoArquivo
--if object_id('FK_Arquivo_TipoArquivo') is  null and object_id('arquivo_testeView') is not null alter table arquivo_testeView with check add constraint FK_Arquivo_TipoArquivo foreign key (IdTipoArquivo) references TipoArquivo (IdTipoArquivo)  on update  no action  on delete  no action 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()  + cast(ERROR_number() as varchar) + cast(ERROR_LINE() as varchar)
END CATCH
BEGIN TRY
--select count(*) from ArquivoLoja where IdFormatoArquivo not in ( select IdFormatoArquivo from FormatoArquivo);
--delete from ArquivoLoja where IdFormatoArquivo not in ( select IdFormatoArquivo from FormatoArquivo);
if object_id('FK_ArquivoLoja_FormatoArquivo') is not NULL AND EXISTS (SELECT 1 FROM sys.tables WHERE name = 'ArquivoLoja') alter table ArquivoLoja drop constraint FK_ArquivoLoja_FormatoArquivo
--if object_id('FK_ArquivoLoja_FormatoArquivo') is  null and object_id('ArquivoLoja') is not null alter table ArquivoLoja with check add constraint FK_ArquivoLoja_FormatoArquivo foreign key (IdFormatoArquivo) references FormatoArquivo (IdFormatoArquivo)  on update  no action  on delete  no action 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()  + cast(ERROR_number() as varchar) + cast(ERROR_LINE() as varchar)
END CATCH
BEGIN TRY
--select count(*) from ArquivoLoja where IdTipoArquivo not in ( select IdTipoArquivo from TipoArquivo);
--delete from ArquivoLoja where IdTipoArquivo not in ( select IdTipoArquivo from TipoArquivo);
if object_id('FK_ArquivoLoja_TipoArquivo') is not NULL AND EXISTS (SELECT 1 FROM sys.tables WHERE name = 'ArquivoLoja') alter table ArquivoLoja drop constraint FK_ArquivoLoja_TipoArquivo
--if object_id('FK_ArquivoLoja_TipoArquivo') is  null and object_id('ArquivoLoja') is not null alter table ArquivoLoja with check add constraint FK_ArquivoLoja_TipoArquivo foreign key (IdTipoArquivo) references TipoArquivo (IdTipoArquivo)  on update  no action  on delete  no action 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()  + cast(ERROR_number() as varchar) + cast(ERROR_LINE() as varchar)
END CATCH
BEGIN TRY
--select count(*) from Arquivo where IdFormatoArquivo not in ( select IdFormatoArquivo from FormatoArquivo);
--delete from Arquivo where IdFormatoArquivo not in ( select IdFormatoArquivo from FormatoArquivo);
if object_id('FK_Arquivo_FormatoArquivo') is not NULL AND EXISTS (SELECT 1 FROM sys.tables WHERE name = 'arquivo') alter table Arquivo drop constraint FK_Arquivo_FormatoArquivo
--if object_id('FK_Arquivo_FormatoArquivo') is  null and object_id('Arquivo') is not null alter table Arquivo with check add constraint FK_Arquivo_FormatoArquivo foreign key (IdFormatoArquivo) references FormatoArquivo (IdFormatoArquivo)  on update  no action  on delete  no action 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()  + cast(ERROR_number() as varchar) + cast(ERROR_LINE() as varchar)
END CATCH

BEGIN TRY
--select count(*) from Arquivo where IdTipoArquivo not in ( select IdTipoArquivo from TipoArquivo);
--delete from Arquivo where IdTipoArquivo not in ( select IdTipoArquivo from TipoArquivo);
if object_id('FK_Arquivo_TipoArquivo') is not NULL AND EXISTS (SELECT 1 FROM sys.tables WHERE name = 'arquivo') alter table Arquivo drop constraint FK_Arquivo_TipoArquivo
--if object_id('FK_Arquivo_TipoArquivo') is  null and object_id('Arquivo') is not null alter table Arquivo with check add constraint FK_Arquivo_TipoArquivo foreign key (IdTipoArquivo) references TipoArquivo (IdTipoArquivo)  on update  no action  on delete  no action 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()  + cast(ERROR_number() as varchar) + cast(ERROR_LINE() as varchar)
END CATCH

BEGIN TRY
--select count(*) from Banner where IdArquivo not in ( select IdArquivo from Arquivo);
--delete from Banner where IdArquivo not in ( select IdArquivo from Arquivo);
if object_id('FK_Banner_Arquivo') is not NULL AND EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Banner') alter table Banner drop constraint FK_Banner_Arquivo
--if object_id('FK_Banner_Arquivo') is  null and object_id('Banner') is not null alter table Banner with check add constraint FK_Banner_Arquivo foreign key (IdArquivo) references Arquivo (IdArquivo)  on update  no action  on delete  no action 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()  + cast(ERROR_number() as varchar) + cast(ERROR_LINE() as varchar)
END CATCH

BEGIN TRY
--select count(*) from HotSiteArquivo where IdArquivo not in ( select IdArquivo from Arquivo);
--delete from HotSiteArquivo where IdArquivo not in ( select IdArquivo from Arquivo);
if object_id('FK_HotSiteArquivo_Arquivo') is not null AND EXISTS (SELECT 1 FROM sys.tables WHERE name = 'HotSiteArquivo') alter table HotSiteArquivo drop constraint FK_HotSiteArquivo_Arquivo
--if object_id('FK_HotSiteArquivo_Arquivo') is  null and object_id('HotSiteArquivo') is not null alter table HotSiteArquivo with check add constraint FK_HotSiteArquivo_Arquivo foreign key (IdArquivo) references Arquivo (IdArquivo)  on update  no action  on delete  no action 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()  + cast(ERROR_number() as varchar) + cast(ERROR_LINE() as varchar)
END CATCH

BEGIN TRY
--select count(*) from ProdutoArquivo where IdArquivo not in ( select IdArquivo from Arquivo);
--delete from ProdutoArquivo where IdArquivo not in ( select IdArquivo from Arquivo);
if object_id('FK_ProdutoArquivo_Arquivo') is not null AND EXISTS (SELECT 1 FROM sys.tables WHERE name = 'ProdutoArquivo') alter table ProdutoArquivo drop constraint FK_ProdutoArquivo_Arquivo
--if object_id('FK_ProdutoArquivo_Arquivo') is  null and object_id('ProdutoArquivo') is not null alter table ProdutoArquivo with check add constraint FK_ProdutoArquivo_Arquivo foreign key (IdArquivo) references Arquivo (IdArquivo)  on update  no action  on delete  no action 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()  + cast(ERROR_number() as varchar) + cast(ERROR_LINE() as varchar)
END CATCH

BEGIN TRY
--select count(*) from ProdutoArquivo where IdArquivoRelacionado not in ( select IdArquivo from Arquivo);
--delete from ProdutoArquivo where IdArquivoRelacionado not in ( select IdArquivo from Arquivo);
if object_id('FK_ProdutoArquivo_ArquivoRelacionado') is not null AND EXISTS (SELECT 1 FROM sys.tables WHERE name = 'ProdutoArquivo') alter table ProdutoArquivo drop constraint FK_ProdutoArquivo_ArquivoRelacionado
--if object_id('FK_ProdutoArquivo_ArquivoRelacionado') is  null and object_id('ProdutoArquivo') is not null alter table ProdutoArquivo with check add constraint FK_ProdutoArquivo_ArquivoRelacionado foreign key (IdArquivoRelacionado) references Arquivo (IdArquivo)  on update  no action  on delete  no action 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()  + cast(ERROR_number() as varchar) + cast(ERROR_LINE() as varchar)
END CATCH

BEGIN TRY
--select count(*) from SkuArquivo where IdArquivo not in ( select IdArquivo from Arquivo);
--delete from SkuArquivo where IdArquivo not in ( select IdArquivo from Arquivo);
if object_id('FK_SkuArquivo_Arquivo') is not NULL  AND EXISTS (SELECT 1 FROM sys.tables WHERE name = 'SkuArquivo') alter table SkuArquivo drop constraint FK_SkuArquivo_Arquivo
--if object_id('FK_SkuArquivo_Arquivo') is  null and object_id('SkuArquivo') is not null alter table SkuArquivo with check add constraint FK_SkuArquivo_Arquivo foreign key (IdArquivo) references Arquivo (IdArquivo)  on update  no action  on delete  no action 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()  + cast(ERROR_number() as varchar) + cast(ERROR_LINE() as varchar)
END CATCH

BEGIN TRY
--select count(*) from SkuArquivo where IdArquivoRelacionado not in ( select IdArquivo from Arquivo);
--delete from SkuArquivo where IdArquivoRelacionado not in ( select IdArquivo from Arquivo);
if object_id('FK_SkuArquivo_ArquivoRelacionado') is not null AND EXISTS (SELECT 1 FROM sys.tables WHERE name = 'skuarquivo') alter table SkuArquivo drop constraint FK_SkuArquivo_ArquivoRelacionado
--if object_id('FK_SkuArquivo_ArquivoRelacionado') is  null and object_id('SkuArquivo') is not null alter table SkuArquivo with check add constraint FK_SkuArquivo_ArquivoRelacionado foreign key (IdArquivoRelacionado) references Arquivo (IdArquivo)  on update  no action  on delete  no action 
END TRY
BEGIN CATCH
PRINT  ERROR_MESSAGE()  + cast(ERROR_number() as varchar) + cast(ERROR_LINE() as varchar)
END CATCH

-- droping table containg product image information
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'arquivo')
DROP TABLE arquivo
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'skuarquivo')
DROP TABLE skuarquivo
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'produtoarquivo')
DROP TABLE produtoarquivo
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'tipoarquivo')
DROP TABLE tipoarquivo
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'formatoarquivo')
DROP TABLE formatoarquivo


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON

IF EXISTS (SELECT * FROM sys.views WHERE name = 'arquivo')
	DROP view [dbo].[Arquivo]

IF EXISTS (SELECT * FROM sys.views WHERE name = 'SkuArquivo')
	DROP view [dbo].SkuArquivo

IF EXISTS (SELECT * FROM sys.views WHERE name = 'ProdutoArquivo')
	DROP view [dbo].ProdutoArquivo

IF EXISTS (SELECT * FROM sys.views WHERE name = 'tipoArquivo')
	DROP view [dbo].tipoArquivo

IF EXISTS (SELECT * FROM sys.views WHERE name = 'FormatoArquivo')
	DROP view [dbo].FormatoArquivo
	


fim:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION

GO

-- creating views to allow image requests to be served by the corporate database. This alone will save a huge amount of space in disk for the store databases
CREATE view [dbo].[Arquivo]
AS
SELECT 
	[IdArquivo] ,
	[IdFormatoArquivo] ,
	[IdTipoArquivo] ,
	[Nome] ,
	[Texto],
	[Altura],
	[Largura],
	[Tamanho],
	[ArquivoBinario]
	
	FROM [db_hom_corp_projeto].dbo.arquivo

GO


CREATE VIEW SkuArquivo
AS
SELECT [IdSkuArquivo]
      ,[IdSku]
      ,[IdArquivo]
      ,[IdArquivoRelacionado]
      ,[Ordem]
  FROM [db_hom_corp_projeto].[dbo].[SkuArquivo]
GO


CREATE VIEW [ProdutoArquivo]
AS
SELECT [IdProdutoArquivo]
      ,[IdProduto]
      ,[IdArquivo]
      ,[_IdTipoArquivo]
      ,[IdArquivoRelacionado]
      ,[Ordem]
  FROM [db_hom_corp_projeto].[dbo].[ProdutoArquivo]
GO

CREATE VIEW TipoArquivo
AS
SELECT [IdTipoArquivo]
      ,[Nome]
      ,[Altura]
      ,[Largura]
      ,[Tamanho]
      ,[FlagResizeObrigatorio]
      ,[Tipo]
  FROM [db_hom_corp_projeto].[dbo].[TipoArquivo]
GO

CREATE VIEW FormatoArquivo
AS
SELECT [IdFormatoArquivo]
      ,[Nome]
      ,[Tag]
      ,[Extensao]
      ,[MimeType]
  FROM [db_hom_corp_projeto].[dbo].[FormatoArquivo]
GO


/*
Remarks:

1. This script recreates fulltext catalogs for better text search support
2. You can customize the language you want support to
3. For Thesaurus settings, check Microsoft documentation
4. For Stopwords and stemming settings, check Microsoft documentation

*/

IF  EXISTS (SELECT * FROM sys.fulltext_indexes fti WHERE fti.object_id = OBJECT_ID(N'[dbo].[Cliente]'))
ALTER FULLTEXT INDEX ON [dbo].[Cliente] DISABLE
GO
/****** Object:  FullTextIndex     Script Date: 07/07/2010 17:45:38 ******/
IF  EXISTS (SELECT * FROM sys.fulltext_indexes fti WHERE fti.object_id = OBJECT_ID(N'[dbo].[Cliente]'))
DROP FULLTEXT INDEX ON [dbo].[Cliente]

GO
IF  EXISTS (SELECT * FROM sysfulltextcatalogs ftc WHERE ftc.name = N'e-Plataforma-Cliente')
DROP FULLTEXT CATALOG [e-Plataforma-Cliente]



CREATE FULLTEXT CATALOG [e-Plataforma-Cliente]
WITH ACCENT_SENSITIVITY = ON
AUTHORIZATION [dbo]
GO

IF not EXISTS (SELECT * FROM sys.fulltext_indexes fti WHERE fti.object_id = OBJECT_ID(N'[dbo].[Cliente]'))
CREATE FULLTEXT INDEX ON [dbo].[Cliente](
[Nome] LANGUAGE 1033,
[Sobrenome] LANGUAGE 1033,
[NomeFantasia] LANGUAGE 1033,
[RazaoSocial] LANGUAGE 1033)
KEY INDEX [PK_Usuario] ON [e-Plataforma-Cliente]
WITH CHANGE_TRACKING AUTO
GO


------------------------------

GO
IF  EXISTS (SELECT * FROM sys.fulltext_indexes fti WHERE fti.object_id = OBJECT_ID(N'[dbo].[ListaCasamentoConsolidado]'))
ALTER FULLTEXT INDEX ON [dbo].[ListaCasamentoConsolidado] DISABLE
GO
/****** Object:  FullTextIndex     Script Date: 07/07/2010 17:45:38 ******/
IF  EXISTS (SELECT * FROM sys.fulltext_indexes fti WHERE fti.object_id = OBJECT_ID(N'[dbo].[ListaCasamentoConsolidado]'))
DROP FULLTEXT INDEX ON [dbo].[ListaCasamentoConsolidado]

GO

GO
IF  EXISTS (SELECT * FROM sys.fulltext_indexes fti WHERE fti.object_id = OBJECT_ID(N'[dbo].[ListaCasamento]'))
ALTER FULLTEXT INDEX ON [dbo].[ListaCasamento] DISABLE
GO
/****** Object:  FullTextIndex     Script Date: 07/07/2010 17:45:38 ******/
IF  EXISTS (SELECT * FROM sys.fulltext_indexes fti WHERE fti.object_id = OBJECT_ID(N'[dbo].[ListaCasamento]'))
DROP FULLTEXT INDEX ON [dbo].[ListaCasamento]

GO

IF  EXISTS (SELECT * FROM sysfulltextcatalogs ftc WHERE ftc.name = N'ListaCasamentoConsolidadoCatalogo')
DROP FULLTEXT CATALOG [ListaCasamentoConsolidadoCatalogo]
GO


CREATE FULLTEXT CATALOG [ListaCasamentoConsolidadoCatalogo]
WITH ACCENT_SENSITIVITY = ON
AUTHORIZATION [dbo]
GO

IF not EXISTS (SELECT * FROM sys.fulltext_indexes fti WHERE fti.object_id = OBJECT_ID(N'[dbo].[ListaCasamentoConsolidado]'))
CREATE FULLTEXT INDEX ON [dbo].[ListaCasamentoConsolidado]
([NomeNoiva] LANGUAGE 1033,[NomeNoivo] LANGUAGE 1033)
KEY INDEX [PK_ListaCasamentoConsolidado] ON [ListaCasamentoConsolidadoCatalogo]
WITH CHANGE_TRACKING AUTO
GO

IF not EXISTS (SELECT * FROM sys.fulltext_indexes fti WHERE fti.object_id = OBJECT_ID(N'[dbo].[ListaCasamento]'))
CREATE FULLTEXT INDEX ON [dbo].[ListaCasamento]
([NomeComp] LANGUAGE 1033,[SobrenomeComp] LANGUAGE 1033)
KEY INDEX [PK_ListaCasamento] ON [ListaCasamentoConsolidadoCatalogo]
WITH CHANGE_TRACKING AUTO
GO

----

-- checando campos dos índices fulltext
select  object_name(fic.object_id), c.name
from sys.fulltext_index_columns fic , sys.columns c
where fic.object_id = c.object_id
and fic.column_id = c.column_id

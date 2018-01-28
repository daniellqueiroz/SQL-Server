-- EXECUTAR NO PUBLICADOR ALTERANDO O NOME DA PUBLICA플O
-- EXECUTE THESE STEPS AT THE PUBLISHER WHILE CHANGING THE NAME OF THE PUBLICATION

-- VERIFICAR, NO ASSINANTE, SE O CAMPO QUE SER� MARCADO PARA REPLICA플O J� EXISTE. CASO NEGATIVO, CRIAR DE ACORDO COM O PUBLICADOR
-- VERIFY, AT THE SUBSCRIBER, IF THE COLUMN ALREADY EXISTS IN THE SUBSCRIBER DATABASE. IF NOT, CREATE IT

-- CONFIGURATING THE PUBLICATION FOR THE PROCESS
EXEC sp_changepublication @publication = 'marketplace_pontofrio',@property = N'allow_anonymous', @value = 'false' 
GO 

EXEC sp_changepublication @publication = 'marketplace_pontofrio', @property = N'immediate_sync', @value = 'false' 
GO 

-- PARA INCLUIR CAMPO NA PUBLICA플O
-- TO INCLUDE THE COLUMN IN THE PUBLICATION
EXEC sp_articlecolumn  @publication =  'marketplace_pontofrio',  @article =  'Sku',@column =  'IdProduto' ,@refresh_synctran_procs = 1 ,@force_invalidate_snapshot = 1,@force_reinit_subscription = 0 
    
-- PARA ATUALIZAR VIEW DE SINCRONIZA플O
-- TO UPDATE THE SYNC VIEW
EXEC sp_articleview @publication = 'marketplace_pontofrio', @article = 'Sku'

-- PEGAR AS PROCS DE REPLICA플O DO OUTPUT DA EXECU플O DA PROC ABAIXO E RODAR NO ASSINANTE
-- TO GET THE UPDATED SYNC PROCS
EXEC sp_scriptpublicationcustomprocs  @publication = 'marketplace_pontofrio'


-- CONSULTA PARA GERAR COMANDOS PARA TODAS AS PUBLICA합ES
-- TO DINAMICALLY GENERATE THE CONFIGURATING COMMAND (SEE ABOVE) FOR ALL PUBLICATIONS (FILTER AS YOU LIKE)
SELECT 'EXEC sp_changepublication @publication = '''+name+''',@property = N''allow_anonymous'', @value = ''false''' 
,'EXEC sp_changepublication @publication = '''+name+''',@property = N''immediate_sync'', @value = ''false''' 
,'EXEC sp_articlecolumn  @publication =  '''+name+''',  @article =  ''Produto'',@column =  ''DataAtualizacao'' ,@refresh_synctran_procs = 1 ,@force_invalidate_snapshot = 1,@force_reinit_subscription = 0 '
,'EXEC sp_articleview @publication = '''+name+''', @article = ''Produto'''
FROM DBO.syspublications
WHERE name LIKE '%outros%' OR name ='corp_hp'



/*

UPDATE dbo.EmailTipo SET FlagAtivo=0 WHERE IdEmailTipo=3

USE distribution
go
--select * from distribution.dbo.msrepl_errors where time > dateadd(mi,-5,getdate()) and error_code not in (20525)
	
exec sp_browsereplcmds '0x000548D500002E61004900000000','0x000548D500002E61004900000000'
	
{CALL [sp_MSupd_dboEmailTipo] (,,,,,,,1,3,0x80)}

*/
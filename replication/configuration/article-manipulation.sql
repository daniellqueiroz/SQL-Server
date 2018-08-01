-- EXECUTE ON THE PUBLISHER DATABASE

EXEC sp_changepublication @publication = 'marketplace_pontofrio',@property = N'allow_anonymous', @value = 'false' 
GO 

EXEC sp_changepublication @publication = 'marketplace_pontofrio', @property = N'immediate_sync', @value = 'false' 
GO 

-- TO EXCLUDE COLUMN FROM REPLICATED ARTICLE
EXEC sp_articlecolumn  @publication =  'marketplace_pontofrio',  @article =  'Sku',@column =  'IdProduto',@operation='drop' ,@refresh_synctran_procs = 1 ,@force_invalidate_snapshot = 1,@force_reinit_subscription = 0 

-- TO INLCUDE COLUMN IN REPLICATED ARTICLE
EXEC sp_articlecolumn  @publication =  'marketplace_pontofrio',  @article =  'Sku',@column =  'IdProduto',@operation='add' ,@refresh_synctran_procs = 1 ,@force_invalidate_snapshot = 1,@force_reinit_subscription = 0 
    
-- UPDATING SYNCHRONIZATION VIEWS
EXEC sp_articleview @publication = 'marketplace_pontofrio', @article = 'Sku'

-- RETURNING REPLICATION SYNCHRONIZATION PROCEDURES (YOU CAN GET ONLY THE ONES YOU REALLY NEED TO UPDATE)
EXEC sp_scriptpublicationcustomprocs  @publication = 'marketplace_pontofrio'


-- DINAMYCALLY GENERATING ABOVE COMMANDS FOR ALL PUBLICATIONS
SELECT 'EXEC sp_changepublication @publication = '''+name+''',@property = N''allow_anonymous'', @value = ''false''' 
,'EXEC sp_changepublication @publication = '''+name+''',@property = N''immediate_sync'', @value = ''false''' 
,'EXEC sp_articlecolumn  @publication =  '''+name+''',  @article =  ''Produto'',@column =  ''DataAtualizacao'' ,@refresh_synctran_procs = 1 ,@force_invalidate_snapshot = 1,@force_reinit_subscription = 0 '
,'EXEC sp_articleview @publication = '''+name+''', @article = ''Produto'''
FROM DBO.syspublications
WHERE name LIKE '%outros%' OR name ='corp_hp'


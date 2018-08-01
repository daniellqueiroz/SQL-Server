-- Step 01: Add the new article in the publication and create/populate, manually, the table at the subscriber
-- Passo 01: Adicionar novo artigo na publicação e criar, manualmente, a tabela no assinante, inserindo também os registros, se houver algum

-- Step 02: Run the below procedure, changing the name of the subscriber, publication and article
-- Passo 02: Rodar procedure abaixo no publicador mudando o nome do assinante, da publicação e do artigo

IF OBJECT_ID('dbo.syspublications') IS NOT NULL
BEGIN
IF EXISTS(SELECT * FROM dbo.syspublications WHERE name = 'corp_b2c')
exec sp_changesubstatus @publication = 'corp_b2c' 
, @article =  'Filial' 
, @subscriber =  'CL-HLG-HSQLECOM\HSQLECOM'  
, @status =  'active'
END

-- Step 03: Run the below procedure on the publisher database, changing the name of the publication and article
-- Passo 03: Rodar a procedure abaixo no publicador mudando o nome da publicação e do artigo


IF OBJECT_ID('dbo.syspublications') IS NOT NULL
BEGIN
IF EXISTS(SELECT * FROM dbo.syspublications WHERE name = 'corp_b2c')
exec sp_script_synctran_commands @publication =  'corp_b2c'
, @article =  'Filial'
END

-- Step 04: run the below command to generate the synchronization procedures 
-- Passo 04: rodar proc abaixo no publicador para pegar o comando de criação das procs de replicação 
sp_scriptpublicationcustomprocs  @publication = 'corp_casasbahia_outros'

-- Passo 05: Pegar o output acima e executar no banco assinante (pegar apenas as procs do artigo adicionado)
-- Step 05: get the procedures codes relative to the article you just added to the publication

-- Passo 06: Testar a replicação gerando inserts, updates e deletes na tabela adicionada
-- Step 06: Check if everything is working by inserting, updating and deleting a new record on your table in the publisher database


-- run this script to compare when and where an object was modified the last time.
-- this can be useful when detecting the last version of an object between different environments


if object_id('corphom') is not null
	drop TABLE corphom
GO
if object_id('corpprod') is not null
	drop TABLE corpprod
GO

SELECT name,modify_date 
INTO corphom
FROM db_prd_loja.sys.objects ORDER BY modify_date desc

select name,modify_date 
INTO corpprod
FROM db_prd_corp.sys.objects ORDER BY modify_date desc

SELECT ch.name
FROM corphom ch, corpprod cp
WHERE 
ch.name=cp.name
AND ch.modify_date > cp.modify_date
ORDER BY ch.name

SELECT * 
FROM db_prd_corp.sys.objects ORDER BY modify_date desc

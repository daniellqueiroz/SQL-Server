SELECT 'if not exists(select * from sys.check_constraints where 1=1 and parent_object_id=object_id(''' + object_name(parent_object_id) + ''') and definition='''+REPLACE([definition],'''','''''')+''') alter table ' + OBJECT_name(parent_object_id) + ' with nocheck add constraint ' + name + ' CHECK not for replication ' + [definition] 
,*
FROM sys.check_constraints
ORDER BY OBJECT_name(parent_object_id)


SELECT  'alter table ' + OBJECT_name(parent_object_id) + ' drop constraint ' + name 
,*
FROM sys.check_constraints
ORDER BY OBJECT_name(parent_object_id)
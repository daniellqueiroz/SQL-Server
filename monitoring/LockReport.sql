select resource_type, db_name(resource_database_id), resource_description, resource_associated_entity_id
, request_mode as 'mode', request_status as 'status', request_session_id as 'SPID'
, request_owner_id as 'tran id'
,object_name(st.objectid)
from sys.dm_tran_locks dtl, sys.dm_tran_active_transactions dtat, sys.dm_exec_requests der
cross apply sys.dm_exec_sql_text(der.sql_handle) st
where 1=1
and dtl.request_session_id = der.session_id
--and request_owner_type = 'transation'
and dtl.request_owner_id = dtat.transaction_id
and db_name(resource_database_id) = db_name()




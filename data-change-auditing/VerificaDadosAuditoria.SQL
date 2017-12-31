/*

Example query for retrieving audited data. Do not forget to set the index on the audit tables to support your queries.

*/


SELECT TOP 10 PRIMARY_KEY

,alt.[database], alt.table_name
,case alt.audit_action_id when 1 then 'update' when 3 then 'delete' when 2 then 'insert' end as acao
,alt.audit_action_id
, ald.col_name, 
ald.old_value, ald.new_value, ald.primary_key, alt.modified_by, alt.modified_date,  alt.host_name, alt.app_name,  alt.affected_rows
from dbo.audit_log_transactions alt inner join dbo.audit_log_data ald on alt.audit_log_transaction_id = ald.audit_log_transaction_id
where 1=1 
and alt.table_name = 'table-name'
AND MODIFIED_BY ='user'
--AND alt.audit_action_id=2
--and ald.col_name in ('PrecoAnterior','PrecoVenda')
--AND PRIMARY_KEY='[IdProduto]=541074'
ORDER BY alt.AUDIT_LOG_TRANSACTION_ID DESC
--and alt.modified_date > '2010-08-03 00:00:00'
--and old_value = '0'
--and new_value = '1'
--and ald.key1  = 4778
--AND AFFECTED_ROWS > 1



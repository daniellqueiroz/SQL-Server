create table dba.dbo.ConfiguracoesInstancia(nome varchar(100),minimo int, maximo int, config_value int, run_value int)

insert into dba.dbo.ConfiguracoesInstancia(nome, minimo, maximo, config_value, run_value)
exec sp_configure

select * from ConfiguracoesInstancia
select 'exec sp_configure ''' + nome + ''',' + cast(run_value as varchar) + char(13) + 'reconfigure' from dba.dbo.ConfiguracoesInstancia
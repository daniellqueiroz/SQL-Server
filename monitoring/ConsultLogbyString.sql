exec [10.140.1.17,1191].master.dbo.xp_readerrorlog 0, 1, 'numa'

exec [10.118.5.5,1170].master.dbo.xp_readerrorlog 0, 1, 'i/o requests taking longer than 15 seconds'

exec [10.118.5.5,1170].master.dbo.xp_readerrorlog 0, 1, 'server is listening on'

exec [10.118.5.5,1170].master.dbo.xp_readerrorlog 0, 1, 'numa'

exec sp_cycle_errorlog --## recycle the sql server error log
exec sp_readerrorlog 0,1,'publication'

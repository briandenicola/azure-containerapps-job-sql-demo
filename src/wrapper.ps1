Install-Module -name sqlserver -Confirm:$false -Force
Invoke-Sqlcmd -ConnectionString $ENV:CONN_STR -InputFile "/app/sample.sql"
Invoke-Sqlcmd -ConnectionString $ENV:CONN_STR -Query "exec sp_columns todos"
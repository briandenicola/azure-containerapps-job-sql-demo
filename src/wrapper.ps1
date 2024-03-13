function Resolve-HostName {
    param(
        [string] $hostname
    )

    $ip = [System.Net.Dns]::GetHostAddresses($hostname) | Select-Object -First 1 -ExpandProperty IPAddressToString
    return $ip
}

Write-Host ("Resolving hostname...{0}: {1}" -f $ENV:DB_HOST, (Resolve-HostName $ENV:DB_HOST))
Invoke-Sqlcmd -ConnectionString $ENV:CONN_STR -InputFile "/app/sample.sql"
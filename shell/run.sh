#!/bin/sh

$my_array=(@(Get-NetTCPConnection -State Established | Sort-Object CreationTime | Format-Table Remote*, State, @{ n='CreatedAgo'; e = { [datetime]::Now - $_.CreationTime } } | findstr 127.0.0.1))
foreach ($line in $my_array) {
    IFS=','
    read -ra arr <<< "$line"
    printf arr
#    Write-Host $arr
}

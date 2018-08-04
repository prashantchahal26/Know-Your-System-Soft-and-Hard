param([Parameter(Mandatory=$true)]$remoteComputer)
IF(Test-Connection -BufferSize 32 -Count 1 -ComputerName $remoteComputer -Quiet){
	Write-Host "Online"
} Else {
	Write-Host "Offline"
}
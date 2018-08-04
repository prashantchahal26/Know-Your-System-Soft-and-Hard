param([Parameter(Mandatory=$true)]$remoteComputer)

$ans = @()

#Hostname
$Q1 = $env:computername
$ans += "Hostname= "+$Q1

#OS
$Q2 = Get-WmiObject -computername $remoteComputer -class win32_operatingsystem
$ans += "Operating System= " + $Q2.name.split("|")[0] +" Version " + $Q2.version + " Architecture " + $Q2.OSArchitecture

#Processor
$Q3 = Get-WmiObject -computername $remoteComputer -class win32_Processor
$s3 = $Q3.name
$ans += "Processor= "+$s3

#RAM
$Q4 = Get-WmiObject Win32_PhysicalMemory -computername $remoteComputer | Measure-Object -Property Capacity -Sum
if($Q4.sum/1024/1024/1024 -gt 1)
{
	[string]$s4 = $Q4.sum/1024/1024/1024
	$s4 = $s4 + " GB"
}
else
{
	[string]$s4 = $Q4.sum/1024/1024 + " MB"
}
$ans += "RAM Capacity= "+$s4

#Video Card
$Q5 = Get-WmiObject Win32_VideoController -computername $remoteComputer
$s5 = $Q5.caption[0] + " Version " + $Q5.driverVersion[0] + " " + $Q5.caption[1] + " Version " + $Q5.driverVersion[1]  
$ans += "Video Card(if any)= "+$s5

#Disk Capacity
$Q6 = Get-WmiObject -computername $remoteComputer -class Win32_Volume
$a = $Q6.Capacity
forEach($ai in $a)
{
	$sum += $ai
}
$cap = $([math]::floor($sum/ (1024 * 1024 * 1024 )))
$s6 ="Disk Capacity= "+ $cap + " GB" 
$ans += $s6

#Filesystem
$s7 = "File System= " + $Q6.FileSystem
$ans += $s7

#Devices
#$Q9 = Get-WmiObject -class Win32_USBControllerDevice -computername $remoteComputer -namespace "root\CIMV2" | %{[wmi]($_.Dependent)} |Sort Manufacturer,Description,DeviceID | Ft -GroupBy Manufacturer Description,Service,DeviceID
#$Q9

#Serial Number 
$ans += "Serial Number= "+$Q2.SerialNumber

$ans | ConvertTo-Json


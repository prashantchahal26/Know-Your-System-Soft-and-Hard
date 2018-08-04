param([Parameter(Mandatory=$true)]$remoteComputer)
$Q = New-SshSession -ComputerName $remoteComputer -Username admin -Password admin

$ans = @()

#Hostname
$Q1 = Invoke-SshCommand -ComputerName $remoteComputer -Command "uname -n" -Quiet
$s1 = $Q1[0] -split "`n"
$ans += "Host Name= "+$s1

#OS
$Q2 = Invoke-SshCommand -ComputerName $remoteComputer -Command "cat /etc/os-release" -Quiet
$s2 = $Q2[0] -split "`n"
$a = $s2[4].Substring(13)
$a = $a.substring(0,$a.length-1)
$ans += "Operating System= "+$a

#Processor
$Q3 = Invoke-SshCommand -ComputerName $remoteComputer -Command "cat /proc/cpuinfo" -Quiet
$s3 = $Q3[0] -split "`n"
$a = $s3[4] -split ":"
$a[1] = $a[1].trim()
$ans += "Processor= "+$a[1]

#RAM
$Q4 = Invoke-SshCommand -ComputerName $remoteComputer -Command "awk '`$3==`"kB`"{if (`$2>1024^2){`$2=`$2/1024^2;`$3=`"GB`";} else if (`$2>1024){`$2=`$2/1024;`$3=`"MB`";}} 1' /proc/meminfo | column -t" -Quiet
$s4 = $Q4[0] -split "`n"
$a = $s4[0] -split ":"
$a[1] = $a[1].trim()
$ans += "RAM Capacity= "+$a[1]

#Video Card
$Q5 = Invoke-SshCommand -ComputerName $remoteComputer -Command "lspci | grep ' VGA '" -Quiet
$s5 = $Q5[0] -split ":"
$ans += "Video Card(if present)= "+$s5[2].trim()

#File Systems
$Q6 = Invoke-SshCommand -ComputerName $remoteComputer -Command "df -Th | grep `"^/dev`"" -Quiet
$s6 = $Q6[0] 
$ans += "File System= "+$s6

$Q8 = Invoke-SshCommand -ComputerName $remoteComputer -Command "lspci" -Quiet
$s8 = $Q8[0] -split "`n"
$ans += "PCI Devices= " + $s8

$Q9 = Invoke-SshCommand -ComputerName $remoteComputer -Command "users" -Quiet
$s9 = $Q9[0] -split " "
$ans += "User= " + $s9[0]

#Serial Number
$Q7 = Invoke-SshCommand -ComputerName $remoteComputer -Command "lshw |grep -m1 'serial:'" -Quiet
$s7 = $Q7[0].replace("serial:","").trim()
$ans += "Serial Number= "+$s7

$ans | ConvertTo-Json

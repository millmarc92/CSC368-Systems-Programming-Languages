<# 
            "SatNaam WaheGuru" 
 
Date: 03:03:2012, 18:20PM 
Author: Aman Dhally 
Email:  amandhally@gmail.com 
web:    www.amandhally.net/blog 
blog:    http://newdelhipowershellusergroup.blogspot.com/ 
More Info :  
 
Version : 1 
 
    /^(o.o)^\  
 
 
#> 
 
 
$UserName = (Get-Item  env:\username).Value  
$ComputerName = (Get-Item env:\Computername).Value 
$filepath = (Get-ChildItem env:\userprofile).value 
 
<## Email Setting 
 
$smtp = "Your-ExchangeServer" 
$to = "YourIT@YourDomain.com" 
$subject = "Hardware Info of $ComputerName" 
$attachment = "$filepath\$ComputerName.html" 
$from =  (Get-Item env:\username).Value + "@yourdomain.com" 
 #>
 
 
 
#### HTML Output Formatting ####### 
 
$a = "<!--mce:0-->" 
 
############################################### 
 
Add-Content  "$filepath\style.CSS"  -Value " body { 
font-family:Calibri; 
 font-size:10pt; 
} 
th {  
background-color:black; 
 
color:white; 
} 
td { 
 background-color:#19fff0; 
color:black; 
}" 
 
##### 

Write-Host "CSS File Created Successfully... Executing Inventory Report!!! Please Wait !!!" -ForegroundColor Yellow  
#ReportDate 
$ReportDate = Get-Date | Select -Property DateTime |ConvertTo-Html -Fragment 
 
ConvertTo-Html -Head $a  -Title "Hardware Information for $ComputerName" -Body "<h1> Computer Name : $ComputerName </h1>" >  "$filepath\$ComputerName.html"  
 
# MotherBoard: Win32_BaseBoard # You can Also select Tag,Weight,Width  
Get-WmiObject -ComputerName $ComputerName  Win32_BaseBoard  |  Select Name,Manufacturer,Product,SerialNumber,Status  | ConvertTo-html  -Body "<font color = blue><H2><B> MotherBoard Information</B></H2></font>" >> "$filepath\$ComputerName.html" 
 
# Battery  
Get-WmiObject Win32_Battery -ComputerName $ComputerName  | Select Caption,Name,DesignVoltage,DeviceID,EstimatedChargeRemaining,EstimatedRunTime  | ConvertTo-html  -Body "<H2> Battery Information</H2>" >> "$filepath\$ComputerName.html" 
 
# BIOS 
Get-WmiObject win32_bios -ComputerName $ComputerName  | Select Manufacturer,Name,BIOSVersion,ListOfLanguages,PrimaryBIOS,ReleaseDate,SMBIOSBIOSVersion,SMBIOSMajorVersion,SMBIOSMinorVersion  | ConvertTo-html  -Body "<H2> BIOS Information </H2>" >> "$filepath\$ComputerName.html" 
 
# CD ROM Drive 
Get-WmiObject Win32_CDROMDrive -ComputerName $ComputerName  |  select Name,Drive,MediaLoaded,MediaType,MfrAssignedRevisionLevel  | ConvertTo-html  -Body "<H2> CD ROM Information</H2>" >> "$filepath\$ComputerName.html" 
 
# System Info 
Get-WmiObject Win32_ComputerSystemProduct -ComputerName $ComputerName  | Select Vendor,Version,Name,IdentifyingNumber,UUID  | ConvertTo-html  -Body "<H2> System Information </H2>" >> "$filepath\$ComputerName.html" 
 
# Hard-Disk 
Get-WmiObject win32_diskDrive -ComputerName $ComputerName  | select Model,SerialNumber,InterfaceType,Size,Partitions  | ConvertTo-html  -Body "<H2> Harddisk Information </H2>" >> "$filepath\$ComputerName.html" 
 
# NetWord Adapters -ComputerName $ComputerName 
Get-WmiObject win32_networkadapter -ComputerName $ComputerName  | Select Name,Manufacturer,Description ,AdapterType,Speed,MACAddress,NetConnectionID |  ConvertTo-html  -Body "<H2> Nerwork Card Information</H2>" >> "$filepath\$ComputerName.html" 
 
# Memory 
Get-WmiObject Win32_PhysicalMemory -ComputerName $ComputerName  | select BankLabel,DeviceLocator,Capacity,Manufacturer,PartNumber,SerialNumber,Speed  | ConvertTo-html  -Body "<H2> Physical Memory Information</H2>" >> "$filepath\$ComputerName.html" 
 
# Processor  
Get-WmiObject Win32_Processor -ComputerName $ComputerName  | Select Name,Manufacturer,Caption,DeviceID,CurrentClockSpeed,CurrentVoltage,DataWidth,L2CacheSize,L3CacheSize,NumberOfCores,NumberOfLogicalProcessors,Status  | ConvertTo-html  -Body "<H2> CPU Information</H2>" >> "$filepath\$ComputerName.html" 
 
## System enclosure  
 
Get-WmiObject Win32_SystemEnclosure -ComputerName $ComputerName  | Select Tag,AudibleAlarm,ChassisTypes,HeatGeneration,HotSwappable,InstallDate,LockPresent,PoweredOn,PartNumber,SerialNumber  | ConvertTo-html  -Body "<font color = red><H2><B> System Enclosure Information </B></H2></font>" -CssUri  "$filepath\style.CSS" -Title "Server Inventory" >> "$filepath\$ComputerName.html" 
 
 
## Invoke Expressons 
 
invoke-Expression "$filepath\$ComputerName.html" 
 
 
#### Sending Email 
Write-Host "Script Execution Completed" -ForegroundColor Yellow 
Invoke-Item -Path "$filepath\$ComputerName.html" 
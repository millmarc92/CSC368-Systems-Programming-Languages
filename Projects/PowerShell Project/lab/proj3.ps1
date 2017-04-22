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
 
 Get-Item env:\username
Get-Item env:\Computername 
Get-ChildItem env:\userprofile
Get-Date
Get-WmiObject -Class Win32_ComputerSystem
Get-WmiObject -Class Win32_BootConfiguration
Get-WmiObject -Class Win32_BIOS
Get-WmiObject -Class Win32_OperatingSystem
Get-WmiObject -Class Win32_TimeZone
Get-WmiObject -Class Win32_LogicalDisk
Get-WmiObject -Class Win32_Processor
Get-WmiObject -Class Win32_PhysicalMemory
Get-WmiObject -Class Win32_Product
#> 
 
#####Parameters##### 
$UserName = (Get-Item  env:\username).Value  
$ComputerName = (Get-Item env:\Computername).Value 
$filepath = (Get-ChildItem env:\userprofile).value 
 

##### HTML Output Format #####
 
#$a = "<!--mce:0-->"
$a = "<style>BODY{background-color:gray;}</style>" 
 

Add-Content  "$filepath\style.CSS"  -Value " body { 
font-family:Calibri; 
 font-size:10pt; 
} 
th {  
background-color:blue; 
 
color:white; 
} 
td { 
 background-color:#ffffff; 
color:black; 
}" 

#

Write-Host "CSS File Has been created: "$filepath\style.CSS" `n`n Executing Inventory Report!!! Please Wait !!!" -ForegroundColor Yellow  
 
######Set Up the HTML Headings#####

ConvertTo-Html -Head $a  -Title "<title>Hardware Information for $ComputerName</title>" -Body "<h1> Computer Name : $ComputerName </h1>" >>  "$filepath\$ComputerName.html"

#####Gather System Information To Display on Report#####
  
#ReportDate 
$ReportDate = Get-Date | Select -Property DateTime | ConvertTo-Html -Body "<font color = black><H2><B> Report Date</B></H2></font>" >> "$filepath\$ComputerName.html" 

#@@Computer System Information
#Get-WmiObject -Class Win32_ComputerSystem
Write-Host "Gathering System Info..." -ForegroundColor Yellow 
Get-WmiObject -ComputerName $ComputerName Win32_ComputerSystem | 
Select -Property Model , Manufacturer , Description , PrimaryOwnerName , SystemType | ConvertTo-Html -Body "<font color = black><H2><B> Computer System Information</B></H2></font>" >> "$filepath\$ComputerName.html" 

#Get-WmiObject -Class Win32_BootConfiguration
#Boot Configuration 
Write-Host "Gathering Boot Configuration Info..." -ForegroundColor Yellow 
$BootConfiguration = Get-WmiObject -ComputerName $ComputerName Win32_BootConfiguration | 
Select -Property Name , ConfigurationPath | ConvertTo-Html -Body "<font color = black><H2><B> Boot Configuration</B></H2></font>" >> "$filepath\$ComputerName.html"  

#Get-WmiObject -Class Win32_BIOS
#BIOS Information
Write-Host "Gathering BIOS Configuration Info..." -ForegroundColor Yellow  
$BIOS = Get-WmiObject -ComputerName $ComputerName Win32_BIOS | Select -Property PSComputerName , Manufacturer , Version | ConvertTo-Html -Body "<font color = black><H2><B> BIOS Information</B></H2></font>" >> "$filepath\$ComputerName.html" 

#Get-WmiObject -Class Win32_OperatingSystem
#Operating System Information
Write-Host "Gathering Operating System Info..." -ForegroundColor Yellow 
$OS = Get-WmiObject -ComputerName $ComputerName Win32_OperatingSystem | Select -Property Caption , CSDVersion , OSArchitecture , OSLanguage | ConvertTo-Html -Body "<font color = black><H2><B> Operating System Information </B></H2></font>" >> "$filepath\$ComputerName.html" 

#Get-WmiObject -Class Win32_TimeZone
#Time Zone Information
Write-Host "Gathering Time Zone Info..." -ForegroundColor Yellow  
$TimeZone = Get-WmiObject -ComputerName $ComputerName Win32_TimeZone | Select Caption , StandardName | 
ConvertTo-Html -Body "<font color = black><H2><B> Time Zone Information</B></H2></font>" >> "$filepath\$ComputerName.html" 


#Get-WmiObject -Class Win32_LogicalDisk
#Logical Disk Information
Write-Host "Gathering Logical Disk Info..." -ForegroundColor Yellow  
$Disk = Get-WmiObject -ComputerName $ComputerName Win32_LogicalDisk -Filter DriveType=3 |  
Select SystemName , DeviceID , @{Name=”size(GB)”;Expression={“{0:N1}” -f($_.size/1gb)}}, @{Name=”FreeSpace(GB)”;Expression={“{0:N1}” -f($_.freespace/1gb)}} | 
ConvertTo-Html -Body "<font color = black><H2><B> Logical Disk Information</B></H2></font>" >> "$filepath\$ComputerName.html" 


#Get-WmiObject -Class Win32_Processor
#CPU Information
Write-Host "Gathering CPU Info..." -ForegroundColor Yellow 
$SystemProcessor = Get-WmiObject -ComputerName $ComputerName Win32_Processor  |  
Select SystemName , Name , MaxClockSpeed , Manufacturer , status |ConvertTo-Html -Body "<font color = black><H2><B> CPU Information</B></H2></font>" >> "$filepath\$ComputerName.html" 

<#
#Get-WmiObject -Class Win32_PhysicalMemory
#Memory Information
Write-Host "Gathering Memory Info..." -ForegroundColor Yellow 
$PhysicalMemory = Get-WmiObject -ComputerName $ComputerName Win32_PhysicalMemory | 
Select -Property Tag , SerialNumber , PartNumber , Manufacturer , DeviceLocator , @{Name="Capacity(GB)";Expression={"{0:N1}" -f ($_.Capacity/1GB)}} | ConvertTo-Html -Body "<font color = black><H2><B> Memory Information</B></H2></font>" >> "$filepath\$ComputerName.html" 
#>

#Get-WmiObject -Class Win32_Product
#Software Inventory
Write-Host "Gathering Software Inventory Info..." -ForegroundColor Yellow 
$Software = Get-WmiObject -ComputerName $ComputerName Win32_Product | Sort-Object Name | 
Select Name , Vendor , Version , Caption | ConvertTo-Html -Body "<font color = black><H2><B> Software Inventory</B></H2></font>" >> "$filepath\$ComputerName.html"  
 
# MotherBoard: Win32_BaseBoard # You can Also select Tag,Weight,Width
Write-Host "Gathering MotherBoard Info..." -ForegroundColor Yellow  
Get-WmiObject -ComputerName $ComputerName  Win32_BaseBoard  |  Select Name,Manufacturer,Product,SerialNumber,Status  | ConvertTo-html  -Body "<H2> MotherBoard Information</H2></font>" >> "$filepath\$ComputerName.html" 
 
# Battery
Write-Host "Gathering Battery Info..." -ForegroundColor Yellow  
Get-WmiObject Win32_Battery -ComputerName $ComputerName  | Select Caption,Name,DesignVoltage,DeviceID,EstimatedChargeRemaining,EstimatedRunTime  | ConvertTo-html  -Body "<H2> Battery Information</H2>" >> "$filepath\$ComputerName.html" 
 
# BIOS
Write-Host "Gathering BIOS Info..." -ForegroundColor Yellow  
Get-WmiObject win32_bios -ComputerName $ComputerName  | Select Manufacturer,Name,BIOSVersion,ListOfLanguages,PrimaryBIOS,ReleaseDate,SMBIOSBIOSVersion,SMBIOSMajorVersion,SMBIOSMinorVersion  | ConvertTo-html  -Body "<H2> BIOS Information </H2>" >> "$filepath\$ComputerName.html" 
 
# CD ROM Drive
Write-Host "Gathering CD ROM Drive Info..." -ForegroundColor Yellow  
Get-WmiObject Win32_CDROMDrive -ComputerName $ComputerName  |  select Name,Drive,MediaLoaded,MediaType,MfrAssignedRevisionLevel  | ConvertTo-html  -Body "<H2> CD ROM Information</H2>" >> "$filepath\$ComputerName.html" 
 
# System Info
Write-Host "Gathering System Info..." -ForegroundColor Yellow  
Get-WmiObject Win32_ComputerSystemProduct -ComputerName $ComputerName  | Select Vendor,Version,Name,IdentifyingNumber,UUID  | ConvertTo-html  -Body "<H2> System Information </H2>" >> "$filepath\$ComputerName.html" 
 
# Hard-Disk
Write-Host "Gathering Hard-Disk Info..." -ForegroundColor Yellow 
Get-WmiObject win32_diskDrive -ComputerName $ComputerName  | select Model,SerialNumber,InterfaceType,Size,Partitions  | ConvertTo-html  -Body "<H2> Harddisk Information </H2>" >> "$filepath\$ComputerName.html" 
 
# NetWork Adapters -ComputerName $ComputerName
Write-Host "Gathering NetWork Adapters Info..." -ForegroundColor Yellow  
Get-WmiObject win32_networkadapter -ComputerName $ComputerName  | Select Name,Manufacturer,Description ,AdapterType,Speed,MACAddress,NetConnectionID |  ConvertTo-html  -Body "<H2> Nerwork Card Information</H2>" >> "$filepath\$ComputerName.html" 
 
# Memory
Write-Host "Gathering Memory Info..." -ForegroundColor Yellow  
Get-WmiObject Win32_PhysicalMemory -ComputerName $ComputerName  | select BankLabel,DeviceLocator,Capacity,Manufacturer,PartNumber,SerialNumber,Speed  | ConvertTo-html  -Body "<H2> Physical Memory Information</H2>" >> "$filepath\$ComputerName.html" 
 
# Processor
Write-Host "Gathering Processor Info..." -ForegroundColor Yellow  
Get-WmiObject Win32_Processor -ComputerName $ComputerName  | Select Name,Manufacturer,Caption,DeviceID,CurrentClockSpeed,CurrentVoltage,DataWidth,L2CacheSize,L3CacheSize,NumberOfCores,NumberOfLogicalProcessors,Status  | ConvertTo-html  -Body "<H2> CPU Information</H2>" >> "$filepath\$ComputerName.html" 
 
## System enclosure  
Write-Host "Gathering System enclosure Info..." -ForegroundColor Yellow  
Get-WmiObject Win32_SystemEnclosure -ComputerName $ComputerName  | 
Select Tag,AudibleAlarm,ChassisTypes,HeatGeneration,HotSwappable,InstallDate,LockPresent,PoweredOn,PartNumber,SerialNumber  | 
ConvertTo-html  -Body "<font color = black><H2><B> System Enclosure Information </B></H2></font>" -CssUri  "$filepath\style.CSS" -Title "Server Inventory" >> "$filepath\$ComputerName.html" 
 
 
## Invoke Expressons 
 
invoke-Expression "$filepath\$ComputerName.html" 
 
 
#### Creating HTML
Write-Host "Script Execution Complete... Exporting as HTML: $filepath\$ComputerName.html" -ForegroundColor Yellow 
Invoke-Item -Path "$filepath\$ComputerName.html" 
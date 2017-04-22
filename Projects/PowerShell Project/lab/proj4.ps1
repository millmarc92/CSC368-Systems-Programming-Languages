<# 
Marcus Millender
CSC 368 - System Programming Languages

Create a script that uses the commands from homework #3.  Do not display all the information each command returns, instead choose the fields you feel are most important to an inventory (you can pipe the output of the command to Format-List * to see all properties).  In addition, you should organize your listing of programs installed on the computer by either vendor or program name (this will require sorting of the output before displaying it).  Get the system name (on the env:\ logical drive, use .Value as a property for the Get-Item result) and the date and time of the inventory report.  Then use the following classes for Get-WmiObject:

 
Win32_ComputerSystem
Win32_BootConfiguration
Win32_BIOS
Win32_OperatingSystem
Win32_TimeZone
Win32_LogicalDisk (only DriveType=3)
Win32_Processor
Win32_PhysicalMemory
Win32_Product
 

10% Extra Credit:  Create a web page (html) output for your results.  There are several examples available on the Internet.  
#> 
 
#####Variables##### 
$UserName = (Get-Item  env:\username).Value  
$ComputerName = (Get-Item env:\Computername).Value 
$filepath = (Get-ChildItem env:\userprofile).value 
 
$date = Get-Date

##### HTML Output Format #####
 

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

Write-Host "CSS File Has been created: "$filepath\style.CSS" `n`n >>>Executing System Inventory Report...Please Wait<<<`n" -ForegroundColor Yellow  
 
######Set Up the HTML Headings#####

ConvertTo-Html -Head $a  -Title "<title>Hardware Information for $ComputerName</title>" -Body "<h1>Computer Name : $ComputerName -- $date</h1>" >>  "$filepath\$ComputerName.html"

#####Gather System Information To Display on Report#####
  
#Computer System Information
    #Win32_ComputerSystem
Write-Host "Gathering System Info..." -ForegroundColor Yellow 
Get-WmiObject -ComputerName $ComputerName Win32_ComputerSystem | 
Select -Property Manufacturer , Model , Description , PrimaryOwnerName , SystemType | 
ConvertTo-Html -Body "<font color = black><H2><B> Computer System Information</B></H2></font>" -CssUri  "$filepath\style.CSS" -Title "System Inventory: $ComputerName" >> "$filepath\$ComputerName.html" 

#Boot Configuration
    #Win32_BootConfiguration 
Write-Host "Gathering Boot Configuration Info..." -ForegroundColor Yellow 
Get-WmiObject -ComputerName $ComputerName Win32_BootConfiguration | 
Select -Property Name , ConfigurationPath | 
ConvertTo-Html -Body "<font color = black><H2><B> Boot Configuration</B></H2></font>" -CssUri  "$filepath\style.CSS" -Title "System Inventory: $ComputerName" >> "$filepath\$ComputerName.html"  

#BIOS Information
    #Win32_BIOS
Write-Host "Gathering BIOS Configuration Info..." -ForegroundColor Yellow  
Get-WmiObject -ComputerName $ComputerName Win32_BIOS | 
Select -Property PSComputerName , Manufacturer , Version | 
ConvertTo-Html -Body "<font color = black><H2><B> BIOS Information</B></H2></font>" -CssUri  "$filepath\style.CSS" -Title "System Inventory: $ComputerName" >> "$filepath\$ComputerName.html" 


#Operating System Information
    #Win32_OperatingSystem
Write-Host "Gathering Operating System Info..." -ForegroundColor Yellow 
Get-WmiObject -ComputerName $ComputerName Win32_OperatingSystem | 
Select -Property Caption , CSDVersion , OSArchitecture , OSLanguage | 
ConvertTo-Html -Body "<font color = black><H2><B> Operating System Information </B></H2></font>" -CssUri  "$filepath\style.CSS" -Title "System Inventory: $ComputerName" >> "$filepath\$ComputerName.html" 

#Time Zone Information
    #Win32_TimeZone
Write-Host "Gathering Time Zone Info..." -ForegroundColor Yellow  
Get-WmiObject -ComputerName $ComputerName Win32_TimeZone | 
Select Caption , StandardName | 
ConvertTo-Html -Body "<font color = black><H2><B> Time Zone Information</B></H2></font>" -CssUri  "$filepath\style.CSS" -Title "System Inventory: $ComputerName" >> "$filepath\$ComputerName.html" 

#Logical Disk Information
    #Win32_LogicalDisk
Write-Host "Gathering Logical Disk Info..." -ForegroundColor Yellow  
Get-WmiObject -ComputerName $ComputerName Win32_LogicalDisk -Filter DriveType=3 |  
Select SystemName , DeviceID , Description , @{Name=”size(GB)”;Expression={“{0:N1}” -f($_.size/1gb)}}, @{Name=”FreeSpace(GB)”;Expression={“{0:N1}” -f($_.freespace/1gb)}} | 
ConvertTo-Html -Body "<font color = black><H2><B>Logical Disk Information</B></H2></font>" -CssUri  "$filepath\style.CSS" -Title "System Inventory: $ComputerName" >> "$filepath\$ComputerName.html" 

# Processor
    #Win32_Processor
Write-Host "Gathering Processor Info..." -ForegroundColor Yellow   
Get-WmiObject Win32_Processor -ComputerName $ComputerName  | 
Select Name , MaxClockSpeed , Manufacturer , NumberOfCores , ThreadCount  | 
ConvertTo-html  -Body "<H2>Processor Information</H2>" -CssUri  "$filepath\style.CSS" -Title "System Inventory: $ComputerName" >> "$filepath\$ComputerName.html" 

#Physical Memory Information
    #Win32_PhysicalMemory
Write-Host "Gathering Physical Memory Info..." -ForegroundColor Yellow 
Get-WmiObject -ComputerName $ComputerName Win32_PhysicalMemory | 
Select -Property Tag , SerialNumber , PartNumber , Manufacturer , DeviceLocator , @{Name=”Capacity(GB)”;Expression={“{0:N1}” -f($_.capacity/1gb)}} | 
ConvertTo-Html -Body "<font color = black><H2><B>Physical Memory</B></H2></font>" >> "$filepath\$ComputerName.html" 

#Software Inventory
    #Win32_Product
Write-Host "Gathering Software Inventory Info..." -ForegroundColor Yellow 
Get-WmiObject -ComputerName $ComputerName Win32_Product | 
Sort-Object Name | 
Select Name , Vendor , Version , Caption | 
ConvertTo-Html -Body "<font color = black><H2><B> Software Inventory</B></H2></font>" -CssUri  "$filepath\style.CSS" -Title "System Inventory: $ComputerName" >> "$filepath\$ComputerName.html"  
  
##### Creating HTML#####
Write-Host "Script Execution Complete... Exporting as HTML: $filepath\$ComputerName.html" -ForegroundColor Yellow 
#Invoke-Item -Path "$filepath\$ComputerName.html"
invoke-Expression "$filepath\$ComputerName.html"  
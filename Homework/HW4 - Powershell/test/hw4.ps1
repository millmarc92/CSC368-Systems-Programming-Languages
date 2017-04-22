<# 
Marcus Millender
CSC 368 - Systems Programming Languages 

PowerShell Homework 04

    This script repeats the project for the Batch file in order to show parameter passing and control flow of PowerShell scripts. 
 
Pseudocode: 
	Define parameter names
	
	If <directory parameter> does not specify a directory
		display an error message
		exit the script
	
	If the sub-directory <directory parameter>\bob does not exist
		create the sub-directory
	
	For each <file> in the directory <directory parameter>
		If <file> is an image of type <extension parameter>
			convert <file> -resize 640x <directory parameter>\bob\sm_<file>

To RUN:
 
.\hw4.ps1 <directory name> <file extension>
.\hw4.ps1 -filePath <directory name> -fileExt <file extension>
.\hw4.ps1 -fileExt <file extension> -filePath <directory name>

#>

<# Define parameter names #>
	Param (
    [string]$filePath,
	[string]$fileExt
	)

# Define Variables
[string]$imageDir = "$filePath\web-img"


# RUN the Script:
if (!(Test-Path $filePath -PathType Container)) #If a directory does not exist
    {
        Write-Host “`nERROR: The listed filePath parameter is not a directory or does not exist.”
        Break        
    } # Display an error message, then exit/break the script
        
elseif (!(Test-Path $filePath\web-img)) #If ./web directory does not exist 
    {
        Write-Host “`nCreating the web-img directory...”
        New-Item -ItemType directory -Path $imageDir #Make the directory
        Write-Host “`n`n'$imageDir' Directory created!`n`nConverting Image(s)...`n`n”              
    }

else
    {
        # Write-Host “Is a container, and the \web-img directory exists”
        Write-Host “Converting Image(s)...”
    }

Foreach ($imgFile in (Get-ChildItem $filePath\*.$fileExt)) 
    {
        $currentImg = (Split-Path -Path $imgFile -Leaf)
        Write-Host “Working on image: $currentImg”
        convert $imgFile -resize 640x "$imageDir\$currentImg"
    }
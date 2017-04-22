<# Marcus Millender
	CSC 368 - Systems Programming Languages #>
<# PowerShell Homework 04
 This script repeats the project for the Batch file in order to show parameter passing and control flow of PowerShell scripts. 
 
 Pseudocode 
	Define parameter names
	Information on how to do this appears on page 4 of the homework handout, with examples on the preceding page. You may choose the names of your parameters, simply replace firstName and lastName with the names you choose (the examples from page 3 use $filePath and $fileExt) 
	
	If <directory parameter> does not specify a directory
		display an error message
		exit the script
	Information on the language constructs for this appears prior to page 6, while the actual method to do this appears in the middle of page 6. Once again, use the parameter names you selected.
	
	If the sub-directory <directory parameter>\bob does not exist
		create the sub-directory
	The method for checking if a directory exists still appears on page 6. Use that in combination with the command to create a directory from the middle of page 7 to perform this action. Note the homework defines a variable called $imageDir to use in the if statement and later when we are actually converting the images. I recommend you do the same, though you may call your variable anything you like.
	
	For each <file> in the directory <directory parameter>
		If <file> is an image of type <extension parameter>
			convert <file> -resize 640x <directory parameter>\bob\sm_<file>
	The information on pages 8 and 9 provides the remaining structure for the for loop and the convert command, including how you can separate the file name into the appropriate parts. See page 8 for the for loop, the bottom of page 8 for how to get the file name and page 9 for constructing the convert command.
#>
# <directory parameter>
# <extension parameter>
# <file>

<# Define parameter names #>
	Param (
    [string]$filePath,
	[string]$fileExt
	)

# Variables
[string]$imageDir = "$filePath\web-img"

<# If <directory parameter> does not specify a directory 
	display an error message
	exit the script #>
<#    if (<test1>) #(!(Test-Path <your path parameter> -PathType Container)) #If a directory does not exist
        {<statement list 1>} # Display an error message, then exit/break the script
        {elseif (<test2>)
            {<statement list 2>}]
        [else
            {<statement list 3>}] # If parameter is a dirctory, continue with the script
     Example of parameter check 
        if (!(Test-Path $<parameter name> -PathType Container)) {
            Write-Host “ERROR ERROR <put something meaningful here>”
            Break
        } 
#>
# To Test: RUN: ( .\test.ps1 -filePath \app\not )
        if (!(Test-Path $filePath -PathType Container)) #If a directory does not exist
        {
            #Write-Host “Not a container”
            Write-Host “`nERROR: The listed filePath parameter is not a directory or does not exist.”
            Break        
        } # Display an error message, then exit/break the script


<# If the sub-directory <directory parameter>\bob does not exist 
	create the sub-directory #>
        {
            #[string]$imageDir = "$filePath\web-img"
            #Write-Host “Is a container, but the \web-img directory does not exist `n`n Creating '$filePath\web' directory...”
            Write-Host “`nCreating the web-img directory...”
            New-Item -ItemType directory -Path $imageDir #Make the directory
            Write-Host “`n`n'$imageDir' Directory created!`n`nConverting Image(s)...`n`n”              
        }
        else
        {
        # Write-Host “Is a container, and the \web-img directory exists”
        Write-Host “Converting Image(s)...”
        }

<# For each <file> in the directory <directory parameter> 
	If <file> is an image of type <extension parameter> 
		convert <file> -resize 640x <directory parameter>\bob\sm_<file> #>
#ex: foreach ($<item> in $<collection>){<statement list>}

Foreach ($imgFile in (Get-ChildItem $filePath\*.$fileExt)) 
    {
        $currentImg = (Split-Path -Path $imgFile -Leaf)
        Write-Host “Working on image: $currentImg”
        convert $imgFile -resize 640x "$imageDir\$currentImg"
    }

Write-Host “`n`nConvert Complete!”
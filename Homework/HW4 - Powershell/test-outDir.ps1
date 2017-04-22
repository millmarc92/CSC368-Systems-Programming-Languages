# Define parameter names #>
	Param (
	[string]$filePath,    
	[string]$fileExt
    #[string]$imgFile,
    )
    
    [string]$imageDir = "$filePath\web-img"

# To Test: RUN: ( .\test.ps1 -filePath \app\not )
        if (!(Test-Path $filePath -PathType Container)) #If a directory does not exist
        {
            #Write-Host “Not a container”
            Write-Host “`nERROR: The listed filePath parameter is not a directory or does not exist.”
            Break        
        } # Display an error message, then exit/break the script

        elseif (!(Test-Path $filePath\web-img)) #If ./web directory does not exist 
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

Try
{
    Foreach ($imgFile in (Get-ChildItem $filePath\*.$fileExt)) {
    $currentImg = (Split-Path -Path $imgFile -Leaf)
    Write-Host “Working on image: $currentImg”
    convert $imgFile -resize 640x "$imageDir\$currentImg"
    }
    
    # Complete!
    Write-Host “`n`nConvert Complete!”
}
Catch
{
    Write-Host "Conversion Failed!"
    Break
}

@echo off
REM Marcus Millender
REM mmill41
REM CSC 368 - Systems Programming Languages
REM Batch Project

:REQUIREMENTS
REM 1 Name your batch file websize.bat
REM 2 Your batch file should take the name of the directory containing the images as an argument
REM 3 Your batch file should take the file extension of the extension of the image type to be resized as an argument.
:EXTRA CREDIT
REM 4 error check and message for whether directory exists
REM 5 adding the pixel width for resizing as an argument

:RUBRIC
:: Resizes picture files – 50%
:: Takes both directory and file extension arguments – 30%
:: Puts resized files in sub-directory – 10%
:: Well written and commented (use indentation and remarks) – 10%
:: 5% extra credit for error check and message for whether directory exists
:: 5% extra credit for adding the pixel width for resizing as an argument


:REFERENCES
:: * Referenced info on how to check if a folder exists: http://www.robvanderwoude.com/battech_ifexistfolder.php
:: * Utilized the command: help IF, in order to understand the if command
:: * How to utilize comments: http://www.robvanderwoude.com/comments.php
:: * Arguments Handling: http://www.rgagnon.com/gp/gp-0009.html

:HOW TO RUN 
:: To run this command two arguments must be passed: %1 (target directory) AND %2 (file extension)
:: COMMAND: websize <arg %1> <arg %2>
:: EXAMPLE: websize  .  gif
	:: RESULT: All files with the gif(%2) extension will be resized with a width of 640 
	:: and placed in the current "." directory(%1) and placed in a sub-directory named web-img  


:START OF PROGRAM	
:: Check to see if the sub-directory exists in the target directory(%1)
IF NOT EXIST %1\web-img\ (

::If the sub-directory, web-img, doesn't not exist, in the target directory(%1), create it
	ECHO Folder does not exist, creating the 'web-img' directory and converting images...
	mkdir %1\web-img\
	
	) ELSE (
	
	ECHO Folder exists, converting images...
	)

::An If statement to handle a whether not the third parameter, custom size(%3) will be passed
:: If the third parameter doesn't exist, go to the WEB argument
IF "%3" == "" goto WEB

:: If the third parameter is empty, go to the CUSTOM argument
goto CUSTOM
	
	:FOR (WEB)
:: Start a loop, initiating a variable(%%f) that will check for all files(* - wildcard)
:: that has the extension of the second argument(%2)
	:DO (WEB)
:: Run the convert command to proportionately resize the image to a width of 640
:: then, place that file(%%f) in the web-img subdirectory of the target directory(%1)
:: with the same filename
:WEB
	FOR %%f in (*.%2) DO convert %%f -resize 640 %1\web-img\%%f
	ECHO Images converted to default web format: Width 640
	goto END
	:: Added a goto END statement in order to skip the CUSTOM argument
	
	:FOR (CUSTOM)
:: Start a loop, initiating a variable(%%f) that will check for all files(* - wildcard)
:: that has the extension of the second argument(%2)
	:DO (CUSTOM)
:: Run the convert command to proportionately resize the image to a width of custom size(%3)
:: then, place that file(%%f) in the web-img subdirectory of the target directory(%1)
:: with the same filename

:CUSTOM
	FOR %%f in (*.%2) DO convert %%f -resize %3 %1\web-img\%%f
	ECHO Images converted to a custom format: Width %3
:END
:: END OF PROGRAM




	
	

@echo off
REM This is another batch file
REM example: run batch.cat Run batch.bat Bob Carol Ted Alice
REM String will read, "Hello Bob", welcome to the Batch files." because of %1.  If nothing was after batch, then will run
REM   null, a black space in the %1 place.  The %1 selects the input as given in the input array of data 
echo Hello %1, welcome to Batch files.
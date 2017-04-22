@echo off
REM Q1A write a batch command that will loop through all the files ending in ".txt" in the current directory performing the following actions
REM Display teh contents of the file to standard output
for %%f in (*.txt) do xcopy %%f %cd%\bob\

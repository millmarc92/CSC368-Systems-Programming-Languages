@echo off
REM Q2
if exist %cd%\*.txt (for %%f in (*.txt) do move %%f %cd%\q2textfiles\) else echo no txt files exist
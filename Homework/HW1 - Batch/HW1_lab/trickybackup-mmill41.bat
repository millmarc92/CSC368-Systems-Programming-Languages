rem<Marcus Millender>
@echo off
cd c:\testsource
for %%f in (*.doc *.txt) do xcopy c:\testsource\"%%f" c:\text /m /y
for %%f in (*.jpg *.bmp *.gif) do xcopy c:\testsource\"%%f" c:\pics /m /y
@echo off
REM Q3 Write the ImageMagick command to convert a jpeg file to a width of 640 pixels, keeping the same aspect ratio.  The file should be renamed to “sm_” followed by the original file name.
convert %1.jpg -resize 640 sm_%1.jpg
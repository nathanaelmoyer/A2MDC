@echo off

echo Making program files directory...
mkdir "C:\Users\Public\Desktop\AAPS MDC Maps\AAPS School  Maps"
mkdir "C:\Users\Public\Desktop\AAPS MDC Maps\AAPS- School utility shut off maps"

echo AAPD MDC files to local computer...
Xcopy /E /I /Y "%~dp0AAPS School  Maps" "C:\Users\Public\Desktop\AAPS MDC Maps\AAPS School  Maps"
Xcopy /E /I /Y "%~dp0AAPS- School utility shut off maps" "C:\Users\Public\Desktop\AAPS MDC Maps\AAPS- School utility shut off maps"
Xcopy /E /I /Y "%~dp0AAPS-Map Overview and Instructions-AAPD.docx" "C:\Users\Public\Desktop\AAPS MDC Maps"
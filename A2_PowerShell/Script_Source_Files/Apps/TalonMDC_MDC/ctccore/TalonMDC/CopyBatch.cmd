@ECHO OFF
rem DO NOT EDIT.  This file is overwritten by ctcstart
ping localhost -n 12 > nul
copy /V /Y "C:\ctccore\TalonMDC\ctcstartlib\mslinks.jar.ds_part" "C:\ctccore\TalonMDC\ctcstartlib\mslinks.jar"
del /Q C:\ctccore\TalonMDC\ctcstartlib\mslinks.jar.ds_part
copy /V /Y "C:\ctccore\TalonMDC\ctcstartlib\bc-fips-1.0.0.signedbyctc.jar.ds_part" "C:\ctccore\TalonMDC\ctcstartlib\bc-fips-1.0.0.signedbyctc.jar"
del /Q C:\ctccore\TalonMDC\ctcstartlib\bc-fips-1.0.0.signedbyctc.jar.ds_part
copy /V /Y "C:\ctccore\TalonMDC\ctcstartlib\log4j-1.2.15.jar.ds_part" "C:\ctccore\TalonMDC\ctcstartlib\log4j-1.2.15.jar"
del /Q C:\ctccore\TalonMDC\ctcstartlib\log4j-1.2.15.jar.ds_part
copy /V /Y "C:\ctccore\TalonMDC\ctcstartlib\ctcstart.2.00.05.jar.ds_part" "C:\ctccore\TalonMDC\ctcstartlib\ctcstart.2.00.05.jar"
del /Q C:\ctccore\TalonMDC\ctcstartlib\ctcstart.2.00.05.jar.ds_part
copy /V /Y "C:\ctccore\TalonMDC\ctcstartlib\ssl-jsse-3.0.2.jar.ds_part" "C:\ctccore\TalonMDC\ctcstartlib\ssl-jsse-3.0.2.jar"
del /Q C:\ctccore\TalonMDC\ctcstartlib\ssl-jsse-3.0.2.jar.ds_part
CTCStart

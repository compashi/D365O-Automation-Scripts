@ECHO off

set old=1

for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%j

set dirname=%TEMP%\%ldt%

mkdir %dirname%

for /f "delims=" %%a in (ModelList.cfg) do set var=%%a&call :process

ECHO.
ECHO ----------------------------------------------------------
ECHO Restarting IIS...
ECHO ----------------------------------------------------------
iisreset

%SystemRoot%\explorer.exe %dirname%

:process
	if not %var%==%old% (	
		ECHO.
		ECHO ----------------------------------------------------------
		ECHO Building model %var%...
		ECHO ----------------------------------------------------------	
		C:\AOSService\PackagesLocalDirectory\Bin\xppc.exe -verbose -failfast -metadata="C:\AOSService\PackagesLocalDirectory" -referenceFolder="C:\AOSService\PackagesLocalDirectory" -xref -output="C:\AOSService\PackagesLocalDirectory\%var%\bin" -refPath="C:\AOSService\PackagesLocalDirectory\%var%\bin" -modelmodule="%var%" -xmllog=%dirname%\%var%.xml -log=%dirname%\%var%.log		
	 )
	 set old=%var%

	 goto :eof

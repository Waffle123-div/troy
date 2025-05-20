@echo off
echo -------------------------
echo Complete MySQL Fix Tool
echo -------------------------

echo Step 1: Copying .NET 4.0 compatible MySQL.Data.dll...
IF NOT EXIST packages\MySql.Data.6.9.12\lib\net40\MySql.Data.dll (
  echo Installing MySQL.Data 6.9.12 via NuGet...
  .\nuget.exe install MySql.Data -Version 6.9.12 -OutputDirectory packages
)

echo Copying DLL files to necessary locations...
xcopy /Y packages\MySql.Data.6.9.12\lib\net40\MySql.Data.dll bin\
xcopy /Y packages\MySql.Data.6.9.12\lib\net40\MySql.Data.dll .
IF NOT EXIST libs mkdir libs
xcopy /Y packages\MySql.Data.6.9.12\lib\net40\MySql.Data.dll libs\
echo Done!

echo Step 2: Cleaning up MySQL references...
powershell -ExecutionPolicy Bypass -File check_mysql_references.ps1
echo Done!

echo Step 3: Fixing import statements...
powershell -ExecutionPolicy Bypass -File fix_mysql_references.ps1
echo Done!

echo -------------------------
echo MySQL Fixing Complete
echo -------------------------
echo.
echo Instructions for Visual Studio:
echo 1. Close and reopen Visual Studio
echo 2. Right-click on References in Solution Explorer
echo 3. Remove the MySql.Data reference if it has a warning icon
echo 4. Click "Add Reference"
echo 5. Browse to "bin\MySql.Data.dll" and select it
echo 6. In the Properties window, set "Copy Local" to True
echo 7. Rebuild the project
echo. 
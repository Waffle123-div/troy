@echo off
echo -------------------------
echo MySQL Dependency Fixer
echo -------------------------

echo Step 1: Ensuring MySQL.Data.dll is in the bin folder...
IF NOT EXIST bin mkdir bin
copy /Y MySql.Data.dll bin\
echo Done!

echo Step 2: Running PowerShell script to fix imports...
powershell -ExecutionPolicy Bypass -File fix_mysql_references.ps1
echo Done!

echo -------------------------
echo MySQL Dependency Fixing Complete
echo -------------------------
echo.
echo Instructions for Visual Studio:
echo 1. Reopen the project
echo 2. Right-click on References in Solution Explorer
echo 3. Remove the MySql.Data reference if it has a warning icon
echo 4. Click "Add Reference"
echo 5. Browse to "bin\MySql.Data.dll" and select it
echo 6. In the Properties window, set "Copy Local" to True
echo 7. Rebuild the project
echo. 
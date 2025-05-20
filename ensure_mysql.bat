@echo off
echo Ensuring MySQL.Data.dll is in the bin folder...
IF NOT EXIST bin mkdir bin
copy /Y MySql.Data.dll bin\
echo Done! 
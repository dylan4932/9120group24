del /f /q /s bin
rmdir bin /q /s
mkdir bin
javac -cp postgresql-42.2.5.jar src\Business\*.java src\Data\*.java src\Presentation\*.java -d bin

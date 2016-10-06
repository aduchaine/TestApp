@echo off

cd C:\Users\Dude\Documents\Test programs\QtTest\documents_test

echo.
echo.
echo    ...compressing client file

ping -n 2 127.0.0.1 > nul

7z a "result, test.docx" .\test\*

@echo off

cd C:\Users\Dude\Documents\Test programs\QtTest\documents_test

echo.
echo.
echo    ...extracting template

ping -n 2 127.0.0.1 > nul

7z x "test_template.docx" -otest

exit

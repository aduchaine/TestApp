@echo off

cd C:\Users\Dude\Documents\Test programs\QtTest\documents_test

echo.
echo.
echo    ...printing file

ping -n 2 127.0.0.1 > nul

"C:\Program Files (x86)\Microsoft Office\Office14\WINWORD.EXE" /q /n "test_result.docx" /mFileCloseOrExit

exit

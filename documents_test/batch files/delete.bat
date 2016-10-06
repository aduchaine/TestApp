@echo off

cd C:\Users\Dude\Documents\Test programs\QtTest\documents_test

echo.
echo.
echo    ...deleting archive

ping -n 2 127.0.0.1 > nul

rmdir /S /Q "C:\Users\Dude\Documents\Test programs\QtTest\documents_test\test"

echo.
echo.
echo    ...deleting file

ping -n 3 127.0.0.1 > nul

del /F /Q /A "C:\Users\Dude\Documents\Test programs\QtTest\documents_test\test_result.docx"

exit

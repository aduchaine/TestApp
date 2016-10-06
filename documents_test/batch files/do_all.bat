@echo off

cd C:\Users\Dude\Documents\Test programs\QtTest\documents_test

echo.
echo.
echo    ...extracting template

ping -n 2 127.0.0.1 > nul

7z x test_template.docx -otest

echo.
echo.
echo    ...compressing client file

ping -n 2 127.0.0.1 > nul

7z a test_result.docx .\test\*

echo.
echo.
echo    ...printing file

ping -n 2 127.0.0.1 > nul

"C:\Program Files (x86)\Microsoft Office\Office14\WINWORD.EXE" /q /n test_result.docx /mFileCloseOrExit
rem /mfileprintdefault /mFileCloseOrExit or /mFileClose /mfileexit

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

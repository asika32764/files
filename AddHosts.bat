@echo off
set "hostspath=%windir%\System32\drivers\etc\hosts"
set "newentry=140.119.56.234 cati.nccu.edu.tw"

echo 正在檢查是否已存在相同的項目...
find "%newentry%" "%hostspath%" >nul
if %errorlevel% == 0 (
    echo 指定的項目已存在於 hosts 檔案中。
) else (
    echo 正在添加項目到 hosts 檔案...
    echo %newentry% >> "%hostspath%"
    echo 添加完成。
)

pause

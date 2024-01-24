@echo off
net session >nul 2>&1
if %errorlevel% == 0 (
    echo Running as Administrator
    edge_v3_bugxia_n2n.exe edge.conf
) else (
    echo Not running as Administrator 请使用管理员身份运行
)
pause
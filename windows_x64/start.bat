@echo off

net session >nul 2>&1
if %errorlevel% == 0 (
    echo Running as Administrator
    cd /d %~dp0
    edge_v3_bugxia_n2n.exe ../edge.conf
) else (
    echo Not running as Administrator. ��ʹ�ù���Ա������С�
)
pause
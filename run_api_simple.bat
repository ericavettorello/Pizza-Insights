@echo off
echo 🌐 Запуск Pizza Insights API...
echo.

REM Запускаем API напрямую из виртуального окружения
.venv\Scripts\uvicorn.exe api.main:app --reload --host 127.0.0.1 --port 8000

pause

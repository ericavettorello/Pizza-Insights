@echo off
echo 🌐 Запуск Pizza Insights API...
echo.

REM Активируем виртуальное окружение
call .venv\Scripts\activate.bat

REM Проверяем установленные модули
echo Проверяем модули...
python -c "import fastapi, uvicorn, duckdb; print('✅ Все модули установлены!')"

REM Запускаем API сервер
echo.
echo 🚀 Запускаем API сервер на http://127.0.0.1:8000
echo 📊 Документация: http://127.0.0.1:8000/docs
echo.
uvicorn api.main:app --reload --host 127.0.0.1 --port 8000

pause

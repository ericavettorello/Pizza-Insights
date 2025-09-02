@echo off
echo 🍕 Запуск Pizza Insights Bot...
echo.

REM Активируем виртуальное окружение
call .venv\Scripts\activate.bat

REM Проверяем установленные модули
echo Проверяем модули...
python -c "import numpy, pandas, duckdb; print('✅ Все модули установлены!')"

REM Запускаем бота
echo.
echo 🚀 Запускаем бота...
python bot\bot.py

pause

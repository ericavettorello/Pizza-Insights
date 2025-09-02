import os
import duckdb
from dotenv import load_dotenv
from telegram import Update
from telegram.ext import ApplicationBuilder, CommandHandler, ContextTypes

load_dotenv()

DB_PATH = os.path.join(os.path.dirname(__file__), '..', 'data', 'orders.db')

async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text(
        "🍕 Привет! Я Pizza Insights Bot!\n\n"
        "📊 Основные команды:\n"
        "/today — KPI за сегодня\n"
        "/top — ТОП-товары\n"
        "/ltv — ТОП клиентов\n\n"
        "💡 Используйте команды для получения аналитики!"
    )

async def today(update: Update, context: ContextTypes.DEFAULT_TYPE):
    con = duckdb.connect(DB_PATH, read_only=True)
    df = con.execute("""
        SELECT * FROM daily_sales 
        WHERE day = CURRENT_DATE 
        ORDER BY day DESC LIMIT 1
    """).df()
    con.close()
    
    if df.empty:
        await update.message.reply_text("За сегодня данных нет.")
    else:
        r = df.iloc[0]
        await update.message.reply_text(
            f"Сегодня ({r['day']}):\n"
            f"Заказов: {int(r['orders_cnt'])}\n"
            f"Выручка: {r['revenue']:.2f} €"
        )

async def top(update: Update, context: ContextTypes.DEFAULT_TYPE):
    con = duckdb.connect(DB_PATH, read_only=True)
    df = con.execute("SELECT * FROM top_items").df()
    con.close()
    
    if df.empty:
        await update.message.reply_text("Данных нет.")
        return
    
    lines = ["ТОП-товары:"]
    for i, r in df.iterrows():
        lines.append(f"{i+1}) {r['sku']}: {int(r['units_sold'])} шт, {r['revenue']:.2f} €")
    
    await update.message.reply_text("\n".join(lines))

async def ltv(update: Update, context: ContextTypes.DEFAULT_TYPE):
    con = duckdb.connect(DB_PATH, read_only=True)
    df = con.execute("SELECT * FROM customers_ltv LIMIT 10").df()
    con.close()
    
    if df.empty:
        await update.message.reply_text("Данных нет.")
        return
    
    lines = ["ТОП клиентов по LTV:"]
    for i, r in df.iterrows():
        lines.append(f"{i+1}) {r['customer']}: {r['lifetime_value']:.2f} € ({int(r['orders_cnt'])} заказов)")
    
    await update.message.reply_text("\n".join(lines))

def main():
    token = os.getenv("BOT_TOKEN")
    app = ApplicationBuilder().token(token).build()
    
    app.add_handler(CommandHandler("start", start))
    app.add_handler(CommandHandler("today", today))
    app.add_handler(CommandHandler("top", top))
    app.add_handler(CommandHandler("ltv", ltv))
    
    print("🍕 Pizza Insights Bot запущен!")
    print("Используйте Ctrl+C для остановки")
    
    app.run_polling()

if __name__ == "__main__":
    main()

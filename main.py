import os
import duckdb
from fastapi import FastAPI
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from dotenv import load_dotenv

load_dotenv()

DB_PATH = os.path.join(os.path.dirname(__file__), '..', 'data', 'orders.db')

app = FastAPI(title="Pizza Insights API", version="1.0.0")

def q(sql: str):
    con = duckdb.connect(DB_PATH, read_only=True)
    df = con.execute(sql).df()
    con.close()
    return df

@app.get("/", response_class=HTMLResponse)
def root():
    # Читаем HTML файл
    html_path = os.path.join(os.path.dirname(__file__), '..', 'templates', 'index.html')
    with open(html_path, 'r', encoding='utf-8') as f:
        html_content = f.read()
    return HTMLResponse(content=html_content)

@app.get("/kpi/today")
def kpi_today():
    df = q("""
        SELECT * FROM daily_sales 
        WHERE day = CURRENT_DATE 
        ORDER BY day DESC LIMIT 1
    """)
    return df.to_dict(orient="records")

@app.get("/sales/by-day")
def sales_by_day():
    df = q("SELECT * FROM daily_sales")
    return df.to_dict(orient="records")

@app.get("/menu/top")
def menu_top():
    df = q("SELECT * FROM top_items")
    return df.to_dict(orient="records")

@app.get("/customers/top")
def customers_top():
    df = q("SELECT * FROM customers_ltv LIMIT 10")
    return df.to_dict(orient="records")

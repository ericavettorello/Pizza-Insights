CREATE OR REPLACE TABLE orders AS
SELECT * FROM read_csv_auto('data/orders.csv', header=true);

CREATE OR REPLACE VIEW daily_sales AS 
SELECT
    CAST(order_date AS DATE) AS day,
    COUNT(DISTINCT order_id) AS orders_cnt,
    SUM(qty * price) AS revenue
FROM orders 
GROUP BY 1
ORDER BY 1;

CREATE OR REPLACE VIEW top_items AS 
SELECT
    sku,
    SUM(qty) AS units_sold,
    SUM(qty * price) AS revenue 
FROM orders
GROUP BY 1
ORDER BY revenue DESC 
LIMIT 10;

CREATE OR REPLACE VIEW customers_ltv AS 
SELECT
    customer,
    COUNT(DISTINCT order_id) AS orders_cnt,
    SUM(qty * price) AS lifetime_value
FROM orders 
GROUP BY 1
ORDER BY lifetime_value DESC;

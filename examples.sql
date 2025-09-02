-- Примеры SQL запросов для тестирования Pizza Insights

-- 1. Общая статистика заказов
SELECT 
    COUNT(*) as total_orders,
    COUNT(DISTINCT customer) as unique_customers,
    SUM(qty * price) as total_revenue,
    AVG(qty * price) as avg_order_value
FROM orders;

-- 2. Продажи по дням недели
SELECT 
    DAYNAME(order_date) as day_of_week,
    COUNT(*) as orders,
    SUM(qty * price) as revenue
FROM orders 
GROUP BY 1
ORDER BY revenue DESC;

-- 3. Топ-5 клиентов по количеству заказов
SELECT 
    customer,
    COUNT(*) as order_count,
    SUM(qty * price) as total_spent
FROM orders 
GROUP BY 1
ORDER BY order_count DESC
LIMIT 5;

-- 4. Анализ товаров по прибыльности
SELECT 
    sku,
    SUM(qty) as units_sold,
    SUM(qty * price) as revenue,
    AVG(price) as avg_price
FROM orders 
GROUP BY 1
ORDER BY revenue DESC;

-- 5. Динамика продаж по дням
SELECT 
    order_date,
    COUNT(*) as daily_orders,
    SUM(qty * price) as daily_revenue,
    LAG(SUM(qty * price)) OVER (ORDER BY order_date) as prev_day_revenue
FROM orders 
GROUP BY 1
ORDER BY 1;

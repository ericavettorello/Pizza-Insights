-- Дополнительные тестовые данные для Pizza Insights

-- Добавляем больше заказов для лучшей демонстрации
INSERT INTO orders (order_id, order_date, customer, sku, qty, price) VALUES
(11, '2025-08-05', 'Elena', 'margherita', 2, 7.5),
(12, '2025-08-05', 'Ivan', 'pepperoni', 1, 9.0),
(13, '2025-08-05', 'Anna', 'diavola', 1, 10.0),
(14, '2025-08-06', 'Pietro', 'margherita', 1, 7.5),
(15, '2025-08-06', 'Maria', 'calzone', 2, 8.5);

-- Создаем дополнительные витрины для аналитики
CREATE OR REPLACE VIEW weekly_summary AS
SELECT 
    DATE_TRUNC('week', CAST(order_date AS DATE)) as week_start,
    COUNT(*) as total_orders,
    COUNT(DISTINCT customer) as unique_customers,
    SUM(qty * price) as weekly_revenue,
    AVG(qty * price) as avg_order_value
FROM orders 
GROUP BY 1
ORDER BY 1;

CREATE OR REPLACE VIEW customer_frequency AS
SELECT 
    customer,
    COUNT(*) as order_count,
    SUM(qty * price) as total_spent,
    AVG(qty * price) as avg_order_value,
    MIN(order_date) as first_order,
    MAX(order_date) as last_order,
    CASE 
        WHEN COUNT(*) >= 3 THEN 'VIP'
        WHEN COUNT(*) >= 2 THEN 'Regular'
        ELSE 'New'
    END as customer_segment
FROM orders 
GROUP BY 1
ORDER BY total_spent DESC;

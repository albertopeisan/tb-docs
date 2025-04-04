-- Step 1: Create a database
CREATE DATABASE IF NOT EXISTS analytics;

-- Step 2: Create tables mimicking real-world use cases
-- Example 1: Web traffic logs (Common for analytics and monitoring)
CREATE TABLE IF NOT EXISTS analytics.web_traffic
(
    event_time   DATETIME,
    user_id      UINT32,
    page_url     STRING,
    referrer_url STRING,
    user_agent   STRING,
    ip_address   IPV4
) engine = mergetree() ORDER BY (event_time, user_id);

-- Example 2: E-commerce transactions
CREATE TABLE IF NOT EXISTS analytics.ecommerce_transactions
(
    transaction_id UUID,
    user_id        UINT32,
    product_id     UINT32,
    price          FLOAT32,
    currency       STRING,
    purchase_time  DATETIME
) engine = mergetree() ORDER BY (purchase_time, user_id);

-- Example 3: IoT sensor data
CREATE TABLE IF NOT EXISTS analytics.iot_sensor_data
(
    sensor_id   UINT32,
    temperature FLOAT32,
    humidity    FLOAT32,
    recorded_at DATETIME
) engine = mergetree() ORDER BY (recorded_at, sensor_id);
-- Step 3: Insert data progressively using a script
-- We will create a separate script to insert data periodically
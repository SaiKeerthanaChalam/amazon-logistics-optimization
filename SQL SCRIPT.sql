SELECT 
    Order_ID, COUNT(*)
FROM
    orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;

SELECT 
    Order_Date, Actual_Delivery_Date
FROM
    orders
LIMIT 5;

SELECT AVG(Traffic_Delay_Min) AS avg_delay 
FROM routes;

UPDATE routes
SET Traffic_Delay_Min = (
    SELECT AVG(Traffic_Delay_Min) FROM routes
)
WHERE Traffic_Delay_Min IS NULL;
    
SELECT 
    Order_ID,
    Order_Date,
    Actual_Delivery_Date,
    DATEDIFF(Actual_Delivery_Date, Order_Date) AS Delay_Days
FROM
    orders;

SELECT 
    Route_ID,
    AVG(DATEDIFF(Actual_Delivery_Date, Order_Date)) AS Avg_Delay
FROM
    orders
GROUP BY Route_ID
ORDER BY Avg_Delay DESC
LIMIT 10;


SELECT 
    Order_ID,
    Warehouse_ID,
    DATEDIFF(Actual_Delivery_Date, Order_Date) AS Delay_Days
FROM orders
ORDER BY Warehouse_ID, Delay_Days DESC;


SELECT 
    r.Route_ID,
    AVG(DATEDIFF(o.Actual_Delivery_Date, o.Order_Date)) AS Avg_Delivery_Time,
    AVG(r.Traffic_Delay_Min) AS Avg_Traffic_Delay,
    AVG(r.Distance_KM) / AVG(r.Average_Travel_Time_Min) AS Efficiency_Ratio
FROM routes r
JOIN orders o 
ON r.Route_ID = o.Route_ID
GROUP BY r.Route_ID;

SELECT 
    r.Route_ID,
    AVG(DATEDIFF(o.Actual_Delivery_Date, o.Order_Date)) AS Avg_Delivery_Time,
    AVG(r.Traffic_Delay_Min) AS Avg_Traffic_Delay,
    AVG(r.Distance_KM) / AVG(r.Average_Travel_Time_Min) AS Efficiency_Ratio
FROM routes r
JOIN orders o 
ON r.Route_ID = o.Route_ID
GROUP BY r.Route_ID
ORDER BY Efficiency_Ratio ASC
LIMIT 3;

SELECT 
    Route_ID,
    COUNT(*) AS Total_Orders,
    COUNT(CASE 
        WHEN DATEDIFF(Actual_Delivery_Date, Order_Date) > 0 
        THEN 1 
    END) AS Delayed_Orders,
    (COUNT(CASE 
        WHEN DATEDIFF(Actual_Delivery_Date, Order_Date) > 0 
        THEN 1 
    END) * 100.0 / COUNT(*)) AS Delay_Percentage
FROM orders
GROUP BY Route_ID
HAVING Delay_Percentage > 20;

SELECT 
    Warehouse_ID,
    AVG(Processing_Time_Min) AS Avg_Processing_Time
FROM warehouses
GROUP BY Warehouse_ID
ORDER BY Avg_Processing_Time DESC
LIMIT 3;

SELECT 
    Warehouse_ID,
    COUNT(*) AS Total_Orders,
    COUNT(CASE 
        WHEN DATEDIFF(Actual_Delivery_Date, Order_Date) > 0 
        THEN 1 
    END) AS Delayed_Orders
FROM orders
GROUP BY Warehouse_ID;

SELECT 
    Warehouse_ID,
    Processing_Time_Min
FROM warehouses
WHERE Processing_Time_Min > (
    SELECT AVG(Processing_Time_Min)
    FROM warehouses
);



SELECT 
    Warehouse_ID,
    COUNT(*) AS Total_Orders,
    COUNT(CASE 
        WHEN DATEDIFF(Actual_Delivery_Date, Order_Date) = 0 
        THEN 1 
    END) AS On_Time_Orders,
    (COUNT(CASE 
        WHEN DATEDIFF(Actual_Delivery_Date, Order_Date) = 0 
        THEN 1 
    END) * 100.0 / COUNT(*)) AS On_Time_Percentage
FROM orders
GROUP BY Warehouse_ID
ORDER BY On_Time_Percentage DESC;
 
 
SELECT 
    Route_ID,
    Agent_ID,
    On_Time_Percentage
FROM delivery_agents
ORDER BY Route_ID, On_Time_Percentage DESC;

SELECT 
    Agent_ID,
    Route_ID,
    On_Time_Percentage
FROM delivery_agents
WHERE On_Time_Percentage < 80;

SELECT AVG(Avg_Speed_KM_HR) AS Avg_Speed
FROM (
    SELECT Avg_Speed_KM_HR
    FROM delivery_agents
    ORDER BY On_Time_Percentage DESC
    LIMIT 5
) AS top_agents

UNION

SELECT AVG(Avg_Speed_KM_HR)
FROM (
    SELECT Avg_Speed_KM_HR
    FROM delivery_agents
    ORDER BY On_Time_Percentage ASC
    LIMIT 5
) AS bottom_agents;


SELECT 
    Order_ID,
    MAX(Checkpoint_Time) AS Last_Checkpoint_Time
FROM shipment_tracking
GROUP BY Order_ID;

SELECT 
    Delay_Reason,
    COUNT(*) AS Frequency
FROM shipment_tracking
WHERE Delay_Reason IS NOT NULL
AND Delay_Reason != 'None'
GROUP BY Delay_Reason
ORDER BY Frequency DESC;

SELECT 
    Order_ID,
    COUNT(*) AS Delay_Count
FROM shipment_tracking
WHERE Delay_Reason IS NOT NULL
AND Delay_Reason != 'None'
GROUP BY Order_ID
HAVING COUNT(*) > 2;

SELECT 
    Warehouse_ID,
    AVG(DATEDIFF(Actual_Delivery_Date, Order_Date)) AS Avg_Delay
FROM orders
GROUP BY Warehouse_ID;

SELECT 
    (COUNT(CASE 
        WHEN Actual_Delivery_Date <= Expected_Delivery_Date 
        THEN 1 
    END) * 100.0 / COUNT(*)) AS On_Time_Percentage
FROM orders;


SELECT 
    Route_ID,
    AVG(Traffic_Delay_Min) AS Avg_Traffic_Delay
FROM routes
GROUP BY Route_ID;



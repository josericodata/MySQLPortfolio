#Sample 1:
SELECT 'Customers' AS 'Table', COUNT(*) AS Num_Rows FROM customers
UNION
SELECT 'Employees' AS 'Table', COUNT(*) AS Num_Rows FROM employees
UNION
SELECT 'Offices' AS 'Table', COUNT(*) AS Num_Rows FROM offices
UNION
SELECT 'Order Details' AS 'Table', COUNT(*) AS Num_Rows FROM orderdetails
UNION
SELECT 'Orders' AS 'Table', COUNT(*) AS Num_Rows FROM orders
UNION
SELECT 'Payments' AS 'Table', COUNT(*) AS Num_Rows FROM payments
UNION
SELECT 'Product Lines' AS 'Table', COUNT(*) AS Num_Rows FROM productlines
UNION
SELECT 'Products' AS 'Table', COUNT(*) AS Num_Rows FROM products;
#Sample 2:
SELECT  customerName,
        contactLastName,
        contactFirstname,
        city,
        state,
        SUM(quantityOrdered*priceEach) AS totalSpent,
        MAX(orderDate) AS LastOrder
FROM    orderdetails JOIN
        orders USING (orderNumber) JOIN
        customers USING (customerNumber)
GROUP BY    customerNumber
ORDER BY    totalSpent DESC;
#Sample 3:
SELECT  salesRepEmployeeNumber,
        employees.lastName,
        employees.firstName,
        employees.email,
        SUM(quantityOrdered*priceEach) AS totalSales
FROM    orderdetails JOIN orders USING (orderNumber)
        JOIN customers USING (customerNumber)
        JOIN employees ON
        customers.salesRepEmployeeNumber = employees.employeeNumber
GROUP BY    salesRepEmployeeNumber
ORDER BY    totalSales DESC;
#Sample 4:
SELECT  officeCode,
        CONCAT(
                 COALESCE(CONCAT(o.addressLine2,' - '), ''), 
                 COALESCE(CONCAT(o.addressLine1, ', '), ''), 
                 COALESCE(CONCAT(o.city), ''), 
                 COALESCE(CONCAT(', ', o.state), ''),
                 COALESCE(CONCAT(', ', o.country), '')
              ) AS Address,
        o.phone,
        SUM(quantityOrdered*priceEach) AS totalSales
FROM    orderdetails JOIN orders USING (orderNumber)
        JOIN customers USING (customerNumber)
        JOIN employees ON
        customers.salesRepEmployeeNumber = employees.employeeNumber
        JOIN offices o USING (officeCode)
GROUP BY    officeCode
ORDER BY    SUM(quantityOrdered*priceEach) DESC;
#Sample 5:
SELECT  IF (quantityOrdered < 35.2190, 'few', 'many') AS few_many,
        AVG(priceEach) AS avg_price
FROM    orderdetails
GROUP BY    few_many;
#Sample 6:
SELECT  MONTH(ord.orderDate),
        SUM(quantityOrdered) AS TotalQuantityOrdered
FROM    (
            SELECT  orderNumber,
                    orderDate,
                    quantityOrdered
            FROM    orders
                    JOIN orderdetails USING (orderNumber)
        ) AS ord
GROUP BY    MONTH(ord.orderDate)
ORDER BY  TotalQuantityOrdered DESC;
#Sample 7:
SELECT  COUNT(*) numOrders,
        YEAR(orderDate) AS orderYear
FROM    orders 
GROUP BY orderYear;
#Sample 8:
SELECT  MONTH(orderDate) AS Month,
        COUNT(*) AS Orders
FROM    orders
GROUP BY    Month
ORDER BY Orders DESC;
#Sample 9:
SELECT  YEAR(paymentDate) AS paymentYear,
        FORMAT(SUM(amount), 2) AS totalPaymentsReceived
FROM    payments
GROUP BY    paymentYear
ORDER BY paymentYear;
#Sample 10:
SELECT  productLine,
        SUM(quantityOrdered*priceEach) AS TotalSalesVolume
FROM    productlines
        JOIN products USING (productLine)
        JOIN orderdetails USING (productCode)
GROUP BY    productLine
ORDER BY    TotalSalesVolume DESC;

#Sample 11:
SELECT  productLine,
        SUM(quantityInStock) AS TotalQuantityInStock
FROM    productlines
        JOIN products USING (productLine)
GROUP BY    productLine
ORDER BY    TotalQuantityInStock DESC;
#Sample 12:
SELECT  prod.productLine,
        prod.productCode,
        prod.productName,
        prod.totalQtySold,
        RANK() OVER (PARTITION BY productLine ORDER BY totalQtySold DESC) AS totalQtySold_rank
FROM    (
            SELECT  productLine,
                    productCode,
                    productName,
                    SUM(quantityOrdered) AS totalQtySold
            FROM    orderdetails JOIN products USING (productCode)
            GROUP BY    productCode
            ORDER BY    totalQtySold DESC
        ) AS prod
ORDER BY    totalQtySold_rank, productLine;
#Sample 13:
SELECT  productCode,
        productName,
        SUM(quantityOrdered*priceEach) AS totalRevenueFromProduct,
        SUM(quantityOrdered) AS totalQuantitySold
FROM    orderdetails JOIN products USING (productCode)
GROUP BY    productCode
ORDER BY    totalRevenueFromProduct DESC;
#Sample 14:
SELECT  productCode,
        productName,
        quantityInStock,
        SUM(quantityOrdered*priceEach) AS totalSales
FROM    products JOIN
        orderdetails USING (productCode)
GROUP BY    productCode
ORDER BY    quantityInStock DESC;
#Sample 15:
SELECT  prod.productCode,
        prod.productName,
        prod.TotalSales,
        PERCENT_RANK() OVER (ORDER BY TotalSales DESC) AS TotalSales_percent_rank,
        CUME_DIST() OVER (ORDER BY TotalSales DESC) AS TotalSales_cume_dist
FROM    (
            SELECT  productCode,
                    productName,
                    SUM(quantityOrdered*priceEach) AS TotalSales
            FROM    products
                    JOIN orderdetails USING (productCode)
            GROUP BY    productCode
            ORDER BY    TotalSales DESC
        ) AS prod;
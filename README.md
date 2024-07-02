# Classic Models MySQL Database Queries

## Background
**Aim**: Use MySQL as I would in my current company, to assist different stakeholders by pointing out trends and offering insights to align with company goals.

## Technology
I will be using MySQL Workbench because once you learn it, you can master any relational database from any company worldwide.
![A picture containing icon
Description automatically generated](assets/img/mysql.png)
Fig. 1. MySQL Workbench

## Dataset
To get this database up and running, please click on the following link: [MySQL Sample Database](https://www.mysqltutorial.org/mysql-sample-database.aspx).  
This is a small company that manufactures miniatures of classic and vintage cars, motorcycles, trucks and buses, planes, and ships.  
It is a global company that sells worldwide, with data records from 2003 to 2005. It's a fictional company, by the way ☺️.

## Classic Models ER Diagram
After creating the database, we have eight tables that look like this:

![A picture containing icon
Description automatically generated](assets/img/diagram.png)
Fig. 2. Diagram

## Scenarios

### Scenario 1:
First, to get to know the database, we are going to get all rows for each of the tables.
```bash
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
```
\
**Eight tables:**\
![A picture containing icon
Description automatically generated](assets/img/result.png)\
Fig. 3. Displaying records 1 - 8


### Scenario 2:
Top customers by revenue:

```bash
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
```
\
Great insights for our sales team—top customers by revenue and last order date.  
Send promotions based on the last order date and low sales customers.
\
![A picture containing icon
Description automatically generated](assets/img/result1.png)\
Fig. 4. Displaying records 1 - 38 from 98

### Scenario 3:
Top sales representative performer:
```bash
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
```
\
Now the sales manager can set up a bonus system.  
Sales colleagues will be happy to be rewarded for all their hard work.\
![A picture containing icon
Description automatically generated](assets/img/result2.png)\
Fig. 5. Displaying records 1 - 15

### Scenario 4:
Which office is selling the most?
```bash
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
```
\
Paris is the best, and Tokyo needs some attention.\
![A picture containing icon
Description automatically generated](assets/img/result3.png)\
Fig. 6. Displaying records 1 - 7

### Scenario 5:
The CEO is asking how to give discounts to customers:
```bash
SELECT  IF (quantityOrdered < 35.2190, 'few', 'many') AS few_many,
        AVG(priceEach) AS avg_price
FROM    orderdetails
GROUP BY    few_many;
```
\
Discounts will be offered to clients buying more than 35 units per year.  
It will depend on sales volume, obviously.\
![A picture containing icon
Description automatically generated](assets/img/result4.png)\
Fig. 7. Displaying records 1 - 2

### Scenario 6:
Which month has the most total items ordered?
```bash
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
```
\
Before Christmas, our customers stock up their warehouses.\
![A picture containing icon
Description automatically generated](assets/img/result5.png)\
Fig. 8. Displaying records 1 - 12

### Scenario 7:
Orders per year:
```bash
SELECT  COUNT(*) numOrders,
        YEAR(orderDate) AS orderYear
FROM    orders 
GROUP BY orderYear;
```
\
2004 was our best year in terms of orders.\
![A picture containing icon
Description automatically generated](assets/img/result6.png)\
Fig. 9. Displaying records 1 - 3.

### Scenario 8:
Orders per month since the company was founded:
```bash
SELECT  MONTH(orderDate) AS Month,
        COUNT(*) AS Orders
FROM    orders
GROUP BY    Month
ORDER BY Orders DESC;
```
\
November shows that our busiest period is before Christmas, which makes sense for a toy company.\
![A picture containing icon
Description automatically generated](assets/img/result7.png)\
Fig. 10. Displaying records 1 - 12

### Scenario 9:
Yearly revenue:
```bash
SELECT  YEAR(paymentDate) AS paymentYear,
        FORMAT(SUM(amount), 2) AS totalPaymentsReceived
FROM    payments
GROUP BY    paymentYear
ORDER BY paymentYear;
```
\
Our best year was 2004. We should take this year as an example and keep it up!\
![A picture containing icon
Description automatically generated](assets/img/result8.png)\
Fig. 11. Displaying records 1 - 3

### Scenario 10:
Total sales per product line:
```bash
SELECT  productLine,
        SUM(quantityOrdered*priceEach) AS TotalSalesVolume
FROM    productlines
        JOIN products USING (productLine)
        JOIN orderdetails USING (productCode)
GROUP BY    productLine
ORDER BY    TotalSalesVolume DESC;
```
\
We can try to increase revenue for *trains* and *ships*.\
![A picture containing icon
Description automatically generated](assets/img/result9.png)\
Fig. 12. Displaying records 1 - 7

### Scenario 11:
Stock by product line:
```bash
SELECT  productLine,
        SUM(quantityInStock) AS TotalQuantityInStock
FROM    productlines
        JOIN products USING (productLine)
GROUP BY    productLine
ORDER BY    TotalQuantityInStock DESC;
```
\
Similar ranking as the figure shown above, we are doing great in terms of stocking and inventory.\
![A picture containing icon
Description automatically generated](assets/img/result10.png)\
Fig. 13. Displaying records 1 - 7

### Scenario 12:
Create a ranking of products by product line:
```bash
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
```
\
The logic behind this query is, for example, "Classic Cars model S18_3232" ranks first followed by "S24_3856", and so on.\
![A picture containing icon
Description automatically generated](assets/img/result11.png)\
Fig. 14. Displaying records 1 - 21 from 109.*

### Scenario 13:
Product by revenue and quantity sold:
```bash
SELECT  productCode,
        productName,
        SUM(quantityOrdered*priceEach) AS totalRevenueFromProduct,
        SUM(quantityOrdered) AS totalQuantitySold
FROM    orderdetails JOIN products USING (productCode)
GROUP BY    productCode
ORDER BY    totalRevenueFromProduct DESC;
```
\
The most popular item is *1992 Ferrari 360 Spider red*.\
![A picture containing icon
Description automatically generated](assets/img/result12.png)\

Fig. 15. Displaying records 1 - 15 from 109

### Scenario 14:
Product by stock:
```bash
SELECT  productCode,
        productName,
        quantityInStock,
        SUM(quantityOrdered*priceEach) AS totalSales
FROM    products JOIN
        orderdetails USING (productCode)
GROUP BY    productCode
ORDER BY    quantityInStock DESC;
```
\
*2002 Suzuki XREO* has the highest quantity in stock. This model is also 10th in total revenue. 
It may be beneficial to look for high-stock items with low revenue. Maybe it is a good time to offer discounts and lower stocks.\
![A picture containing icon
Description automatically generated](assets/img/result13.png)\
Fig. 16. Displaying records 1 - 20 from 109

### Scenario 15:
We want to find out what percentage of models hit 80% of total sales volume:
```bash
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
```
\
We can see that the cumulative distribution is balanced.  
Looking at this ranking, we hit 80% of sales at product 88, *S32_3207 1950's Chicago Surface Lines Streetcar*, out of a total of 109.  
As a final thought, the company is balanced and well diversified.\
![A picture containing icon
Description automatically generated](assets/img/result14.png)\
Fig. 17. Displaying records 1 - 28 from 109

## Notes
I hope you have enjoyed going through all these samples.  
The link to access all the SQL code: [scenarios.sql](assets/scripts/samples_scenarios.sql).

## License
Copyright (c) 2024 josericodata. This project is made available under the MIT License - see the [LICENSE](LICENSE) file for more details.
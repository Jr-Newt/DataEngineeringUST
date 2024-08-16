-- T-SQL or Transact SQL which is extension of SQL(Structured Query Language).
-- T-SQL developed by Microsoft for use of SQL server, Azure SQL DB.
-- Key Features of T-SQL: A) Variable B) Control Flow Statements (IF - ELSE) C) LOOPS, D) TRY CATCH
-- E) CATCH FUNCTIONS F)STORED PROCEDURES

--1. Show Databases
SELECT name from sys.databases;

--2. Show list of schema
SELECT name as Scheme from sys.schemas;

--3. Create new Databse
create database sales;

--4. create databse with condition to test if it exist.
-- declare a variable with name @databasename
DECLARE @Databasename VARCHAR(128) = 'Sales';
--5. Test Condition to check if database exists
IF NOT EXISTs(select 1 FROM sys.databases where name = @Databasename)
BEGIN
	DECLARE @SQL NVARCHAR(MAX)='CREATE DATABASE ' + QUOTENAME(@Databasename);
	EXEC sq_execuesql @sql; 
END

--6. Change database
USE sales;

--7. create table using schema name (dbo) which is default database
create table [dbo].products(productid varchar(20) not null,
productname varchar(50), price float, quantity int,
storename varchar(100), city varchar(50))



--8. insert values into table products
INSERT INTO [dbo].products (productid, productname, price, quantity, storename, city) VALUES
('A001', 'Laptop', 899.99, 50, 'TechWorld', 'Mumbai'),
('A002', 'Smartphone', 499.99, 100, 'GadgetStore', 'Delhi'),
('A003', 'Bluetooth Speaker', 79.99, 200, 'AudioHub', 'Bengaluru'),
('A004', 'Headphones', 149.99, 150, 'SoundCity', 'Chennai'),
('A005', 'Smartwatch', 199.99, 75, 'WearableTech', 'Hyderabad'),
('A006', 'Tablet', 299.99, 60, 'TabCentral', 'Pune'),
('A007', 'Keyboard', 49.99, 120, 'KeyMasters', 'Kolkata'),
('A008', 'Mouse', 29.99, 180, 'MouseLand', 'Ahmedabad'),
('A009', 'Monitor', 229.99, 40, 'DisplayDepot', 'Jaipur'),
('A010', 'Printer', 139.99, 90, 'PrintPerfect', 'Surat');

--9. run query on products table to show all records.
select * from products

--10. Show the schema description
SELECT TABLE_SCHEMA, TABLE_NAME,COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM
	INFORMATION_SCHEMA.COLUMNS
WHERE
	TABLE_NAME = 'products';

--11. drop table
--DROP TABLE products;

--12. Alter table
ALTER TABLE products ADD totalamount float; 

ALTER TABLE products add DOM float;
--13. drop column using alter
ALTER TABLE products drop column DOM; 

--14. to change the schema of the column ( here I changed totalamount from float to int)
ALTER table products alter column totalamount decimal(10,2);
select * from products

--15. Update the value of column totalamount = price * quantity
UPDATE products SET totalamount = price * quantity;

--16. Query to show first 5 records
SELECT TOP (5) [productid]
      ,[productname]
      ,[price]
      ,[quantity]
      ,[storename]
      ,[city]
      ,[totalamount]
  FROM [sales].[dbo].[products]





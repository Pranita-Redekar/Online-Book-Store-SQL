
-- Switch to the database
select current_database();

--Create Tables

DROP TABLE IF EXISTS Books;
CREATE TABLE Books(
	Book_ID SERIAL PRIMARY KEY,
	Title VARCHAR(100),
	Author VARCHAR(100),
	Genre VARCHAR(50),
	Published_Year INT,
	Price NUMERIC(10,2),
	Stock INT
);

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers(
	Customer_ID SERIAL PRIMARY KEY,
	Name VARCHAR(100),
	Email VARCHAR(100),
	Phone VARCHAR(15),
	City VARCHAR(50),
	Country VARCHAR(150)
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
	Order_ID SERIAL PRIMARY KEY,
	Customer_ID INT REFERENCES Customers(Customer_ID),
	Book_ID INT REFERENCES Books(Book_ID),
	Order_Date Date,
	Quantity INT,
	Total_Amount NUMERIC(10,2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- Import Data into Books table
COPY Books(Book_ID,Title,Author,Genre,Published_Year,Price,Stock)
FROM 'D:\Data Analyst\SQL\Practice Files SQL Projects\Books.csv'
CSV HEADER;

-- Import Data into Customers table
COPY Customers(Customer_ID,Name,Email,Phone,City,Country)
FROM 'D:\Data Analyst\SQL\Practice Files SQL Projects\Customers.csv'
CSV HEADER;

-- Import Data into Orders table
COPY Orders(Order_ID,Customer_ID,Book_ID,Order_Date,Quantity,Total_Amount)
FROM 'D:\Data Analyst\SQL\Practice Files SQL Projects\Orders.csv'
CSV HEADER;



-- 1)Retrieve all books in the "Fiction" genre
SELECT Title,Genre 
FROM Books
WHERE genre='Fiction';

-- 2) Find books published after the year 1950
SELECT * FROM Books
WHERE Published_Year>=1950;

-- 3) List all customers from the Canada
SELECT Name ,Country FROM Customers
WHERE Country='Canada';

-- 4) Show orders placed in November 2023
SELECT * FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30'

-- 5) Retrieve the total stock of books available
SELECT SUM(stock) AS Total_Stock
FROM Books;

-- 6) Find the details of the most expensive book
SELECT * FROM Books 
ORDER BY price DESC LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book
SELECT * FROM Orders
WHERE quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20
SELECT * FROM Orders
WHERE total_amount>20;

-- 9) List all genres available in the Books table
SELECT DISTINCT Genre FROM Books;

-- 10) Find the book with the lowest stock
SELECT * FROM Books 
ORDER BY Stock LIMIT 1;

-- 11) Calculate the total revenue generated from all order
SELECT SUM(Total_Amount) AS Revenue 
FROM Orders;

-- Advance Queries
-- 1) Retrieve the total number of books sold for each genre
SELECT b.Genre,SUM(o.quantity) AS Total_Books_Sold
FROM Orders o
JOIN Books b ON o.Book_ID= b.Book_ID
GROUP BY b.genre;

-- 2) Find the average price of books in the "Fantasy" genre
SELECT AVG(price) AS Avg_Price
FROM Books
WHERE genre='Fantasy';

-- 3) List customers who have placed at least 2 orders
SELECT Customer_ID, COUNT(Order_ID) 
FROM Orders
GROUP BY Customer_ID
HAVING COUNT (Order_ID)>=2;

--OR 3) List customers who have placed at least 2 orders with Customer name 

SELECT c.customer_id,c.name ,COUNT(o.Order_ID) 
FROM Orders o
JOIN Customers c ON o.Customer_ID=c.Customer_ID
GROUP BY c.Customer_ID
HAVING COUNT (o.Order_ID)>=2;

-- 4) Find the most frequently ordered book
SELECT Book_ID, COUNT(Order_ID) AS Order_Count
FROM Orders
GROUP BY(Book_ID)
ORDER BY Order_Count DESC
Limit 1;

-- OR 4) Find the most frequently ordered book with book name
SELECT o.Book_ID,b.title, COUNT(o.Order_ID) AS Order_Count
FROM Orders o
JOIN Books b ON b.Book_ID= o.Book_ID
GROUP BY o.Book_ID,b.title
ORDER BY Order_Count DESC
Limit 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre
SELECT * FROM Books
WHERE Genre='Fantasy'
ORDER BY Price DESC
LIMIT 3;
 
-- 6) Retrieve the total quantity of books sold by each author
SELECT b.author,sum(o.quantity) AS Total_Books_Sold
FROM Orders o
JOIN Books b ON b.Book_ID=o.Book_ID
GROUP BY (b.author);

-- 7) List the cities where customers who spent over $30 are located
SELECT DISTINCT c.City, o.Total_Amount
FROM Orders o
JOIN Customers c ON c.Customer_ID=o.Customer_ID
WHERE o.Total_Amount>30;

-- 8) Find the customer who spent the most on orders
SELECT c.name, sum(o.total_amount) AS Total_Spent
FROM Orders o
JOIN Customers c ON c.Customer_ID=o.Customer_ID
GROUP BY c.name 
ORDER BY Total_Spent DESC
LIMIT 1;

-- 9) Calculate the stock remaining after fulfilling all order
SELECT b.Book_ID,b.Title,b.Stock , COALESCE(SUM(o.quantity),0) AS Order_Quantity,
		b.stock - COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM Books b
LEFT JOIN orders o ON b.Book_ID=o.Book_ID
GROUP BY b.Book_ID 
ORDER BY b.Book_ID;

DROP TABLE IF EXISTS Books;

--create table Books
CREATE TABLE Books(
			CREATE TABLE Book
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

--CREATE TABLE 

DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers(
Customer_ID	INT	PRIMARY KEY,
Name VARCHAR(100) NOT NULL,
Email VARCHAR(100) UNIQUE,
Phone NUMERIC(10) NOT NULL,	
City VARCHAR(100) NOT NULL,	
Country VARCHAR(100)	
);

--CREATE TABLE Orders

DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders(
		Order_ID	INT	PRIMARY KEY,	
Customer_ID	INT	REFERENCES	Customers(Customer_ID),
Book_ID	INT	REFERENCES	Books(Book_ID),
Order_Date	DATE,		
Quantity	INT,		
Total_Amount	NUMERIC(10,2)		
);

SELECT * FROM Books;
--INSERT DATA INTO Books table USING CODE

COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM 'D:\SQL NOTES\PROJECT\Books.csv'
CSV HEADER;

--INSERT DATa\A INTO Customers TABLE USING CODE

COPY Customers(Customer_ID, Name, Email, Phone, City, Country)
FROM 'D:\SQL NOTES\PROJECT\Customers.csv'
CSV HEADER;

SELECT * FROM Customers;

--INSERT DATA INTO Orders TABLE USING CODE

COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM 'D:\SQL NOTES\PROJECT\Orders.csv'
CSV HEADER;


SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

--1) Retrieve all books in the "Fiction" genre

SELECT * FROM Books
WHERE genre='Fiction';

--2) Find books published after the year 1950
SELECT * FROM Books
WHERE published_year>1950;

--3) List all customers from the Canada

SELECT * FROM Customers
WHERE country='Canada';

--4) Show orders placed in November 2023

SELECT * FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

--5) Retrieve the total stock of books available

SELECT SUM(stock) FROM Books;

--6) Find the details of the most expensive book

SELECT * FROM Books ORDER BY price DESC LIMIT 1;

--7) Show all customers who ordered more than 1 quantity of a book

SELECT * FROM Orders
WHERE quantity>1;

--8) Retrieve all orders where the total amount exceeds $20

SELECT * FROM Orders
WHERE total_amount>20;

--9) List all genres available in the Books table(NO DUPICATE)

SELECT DISTINCT genre --DISTINCT IS USE TO AVOID DUPLICATE VALUES
FROM Books;

--10) Find the book with the lowest stock
SELECT * FROM Books ORDER BY stock ASC LIMIT 1; --OR
SELECT * FROM Books ORDER BY stock LIMIT 1;

--11) Calculate the total revenue generated from all orders
SELECT * FROM Customers;
SELECT SUM(total_amount) AS REVENUE
FROM Orders;


--ADVANCE QUERIES
--	1) Retrieve the total number of books sold for each genre
--HERE WE HAVE TO JOIN Books and Orders table (Books=b and Orders=o)
SELECT b.genre, SUM(o.quantity) AS total_soldbooks
FROM Orders o
JOIN Books b
ON b.book_id=o.book_id
GROUP BY b.genre; -- (Group by)used to group rows that have same values in one or more columns

--2) Find the average price of books in the "Fantasy" genre
SELECT AVG(price) AS average_price 
FROM Books
WHERE genre='Fantasy';

--3) List customers who have placed at least 2 orders
SELECT * FROM Books;
--HERE Customers=c and Orders=o
SELECT c.name, c.customer_id, COUNT(o.quantity) AS order_count
FROM Orders o
JOIN Customers c
ON c.customer_id=o.customer_id
GROUP BY c.customer_id
HAVING COUNT(o.quantity)>=2;

SELECT c.customer_id, c.name, COUNT(o.order_id) AS Orders_count
FROM Customers c
JOIN Orders o
ON c.customer_id=o.customer_id
GROUP BY c.customer_id
HAVING COUNT (o.order_id)>=2;

--4) Find the most frequently ordered book
SELECT b.book_id, b.title, COUNT(o.order_id) AS mostfreq_orderedbook
FROM Orders o
JOIN Books b
ON b.book_id=o.book_id
GROUP BY o.book_id, b.book_id
ORDER BY mostfreq_orderedbook DESC LIMIT 1;

--5) Show the top 3 most expensive books of 'Fantasy' Genre 
SELECT * FROM Books 
WHERE genre='Fantasy'
ORDER BY price DESC LIMIT 3;

--6) Retrieve the total quantity of books sold by each author
SELECT * FROM Orders;

SELECT b.author, SUM(o.quantity) AS  sold_booksbyauthor
FROM Orders o
JOIN Books b
ON b.book_id=o.book_id
GROUP BY b.author;

--7) List the cities where customers who spent over $30 are located

SELECT DISTINCT c.city, o.total_amount
FROM Orders o
JOIN Customers c
ON c.customer_id=o.customer_id
WHERE o.total_amount>30;

--8) Find the customer who spent the most on orders
SELECT * FROM Orders;

SELECT c.name, o.total_amount
FROM Orders o
JOIN Customers c
ON c.customer_id=o.customer_id
ORDER BY o.total_amount DESC LIMIT 1;

--8) Find the customers who spent the most on total orders

SELECT c.customer_id, c.name, SUM(o.total_amount) AS total_spent
FROM Orders o
JOIN Customers c
ON c.customer_id=o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC;

--9) Calculate the stock remaining after fulfilling all orders
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;
-

SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) order_quantity, 
b.stock - COALESCE(SUM(o.quantity),0) AS remaining_quantity
FROM Books b
LEFT JOIN
Orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;






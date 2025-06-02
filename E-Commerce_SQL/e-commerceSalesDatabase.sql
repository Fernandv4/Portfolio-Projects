-- =============================
-- E-Commerce Sales Analytics DB
-- =============================

-- 1. Customers Table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    signup_date DATE,
    location VARCHAR(100)
);

-- 2. Products Table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

-- 3. Orders Table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE,
    total_amount DECIMAL(10,2)
);

-- 4. Order Items Table
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    item_price DECIMAL(10,2)
);

-- 5. Payments Table
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    payment_method VARCHAR(50),
    payment_date DATE,
    status VARCHAR(20)
);

-- 6. Reviews Table
CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    product_id INT REFERENCES products(product_id),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date DATE
);

-- =============================
-- Mock Data Inserts (50 entries)
-- =============================

-- Customers (30 entries)
INSERT INTO customers (name, email, signup_date, location) VALUES
('Alice Johnson', 'alice@example.com', '2023-01-10', 'New York'),
('Bob Smith', 'bob@example.com', '2023-02-15', 'California'),
('Carol White', 'carol@example.com', '2023-03-20', 'Texas'),
('David Brown', 'david@example.com', '2023-04-18', 'Florida'),
('Eva Green', 'eva@example.com', '2023-05-05', 'Nevada'),
('Frank Black', 'frank@example.com', '2023-05-20', 'Arizona'),
('Grace Hill', 'grace@example.com', '2023-06-10', 'Illinois'),
('Henry Stone', 'henry@example.com', '2023-06-15', 'Ohio'),
('Ivy Lane', 'ivy@example.com', '2023-06-30', 'Georgia'),
('Jack Wood', 'jack@example.com', '2023-07-01', 'Oregon'),
('Kara Moore', 'kara@example.com', '2023-07-02', 'Michigan'),
('Leo Adams', 'leo@example.com', '2023-07-03', 'Washington'),
('Mia Parker', 'mia@example.com', '2023-07-04', 'Colorado'),
('Nina Scott', 'nina@example.com', '2023-07-05', 'Utah'),
('Owen Reed', 'owen@example.com', '2023-07-06', 'Minnesota'),
('Paula King', 'paula@example.com', '2023-07-07', 'Indiana'),
('Quinn Lee', 'quinn@example.com', '2023-07-08', 'Missouri'),
('Ryan Ward', 'ryan@example.com', '2023-07-09', 'Wisconsin'),
('Sara Bell', 'sara@example.com', '2023-07-10', 'Alabama'),
('Tom Fox', 'tom@example.com', '2023-07-11', 'Iowa'),
('Uma Ray', 'uma@example.com', '2023-07-12', 'Kansas'),
('Victor Long', 'victor@example.com', '2023-07-13', 'Arkansas'),
('Wendy Gray', 'wendy@example.com', '2023-07-14', 'Louisiana'),
('Xavier Cook', 'xavier@example.com', '2023-07-15', 'South Carolina'),
('Yara Nash', 'yara@example.com', '2023-07-16', 'North Carolina'),
('Zane Hart', 'zane@example.com', '2023-07-17', 'Kentucky'),
('Amy Bright', 'amy@example.com', '2023-07-18', 'Tennessee'),
('Brian Steele', 'brian@example.com', '2023-07-19', 'Mississippi'),
('Chloe Knight', 'chloe@example.com', '2023-07-20', 'Nebraska'),
('Dylan Moss', 'dylan@example.com', '2023-07-21', 'South Dakota');

-- Products (30 entries)
INSERT INTO products (name, category, price) VALUES
('Laptop', 'Electronics', 999.99),
('Headphones', 'Electronics', 199.99),
('Coffee Maker', 'Home Appliances', 89.99),
('Book', 'Books', 15.99),
('Sneakers', 'Footwear', 75.50),
('Smartphone', 'Electronics', 699.99),
('Backpack', 'Accessories', 49.99),
('Desk Lamp', 'Furniture', 39.99),
('Water Bottle', 'Accessories', 19.99),
('Gaming Chair', 'Furniture', 149.99),
('Tablet', 'Electronics', 329.99),
('Blender', 'Home Appliances', 59.99),
('Notebook', 'Stationery', 5.99),
('Pen Set', 'Stationery', 12.99),
('Running Shoes', 'Footwear', 89.99),
('Wireless Charger', 'Electronics', 29.99),
('Fitness Tracker', 'Electronics', 129.99),
('Sunglasses', 'Accessories', 69.99),
('Portable Speaker', 'Electronics', 99.99),
('E-reader', 'Electronics', 119.99),
('Office Chair', 'Furniture', 179.99),
('T-shirt', 'Apparel', 19.99),
('Jeans', 'Apparel', 49.99),
('Watch', 'Accessories', 199.99),
('Camera', 'Electronics', 449.99),
('Tripod', 'Electronics', 59.99),
('Microwave', 'Home Appliances', 129.99),
('Vacuum Cleaner', 'Home Appliances', 149.99),
('Wall Clock', 'Home Decor', 39.99),
('LED Strip Lights', 'Home Decor', 24.99);

-- Orders (30 entries)
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2023-05-01', 1199.98),
(2, '2023-05-03', 91.98),
(1, '2023-06-15', 15.99),
(3, '2023-07-10', 75.50),
(4, '2023-07-15', 699.99),
(5, '2023-07-20', 109.98),
(6, '2023-07-22', 149.99),
(7, '2023-07-25', 89.99),
(8, '2023-07-27', 49.99),
(9, '2023-07-29', 39.99),
(10, '2023-07-30', 999.99),
(11, '2023-07-31', 329.99),
(12, '2023-08-01', 59.99),
(13, '2023-08-02', 12.99),
(14, '2023-08-03', 179.98),
(15, '2023-08-04', 129.99),
(16, '2023-08-05', 69.99),
(17, '2023-08-06', 99.99),
(18, '2023-08-07', 119.99),
(19, '2023-08-08', 179.99),
(20, '2023-08-09', 19.99),
(21, '2023-08-10', 49.99),
(22, '2023-08-11', 199.99),
(23, '2023-08-12', 449.99),
(24, '2023-08-13', 59.99),
(25, '2023-08-14', 129.99),
(26, '2023-08-15', 149.99),
(27, '2023-08-16', 39.99),
(28, '2023-08-17', 24.99),
(29, '2023-08-18', 109.99),
(30, '2023-08-19', 199.99);

-- Order Items (30 entries)
INSERT INTO order_items (order_id, product_id, quantity, item_price) VALUES
(1, 1, 1, 999.99),
(1, 2, 1, 199.99),
(2, 3, 1, 89.99),
(2, 4, 1, 15.99),
(3, 4, 1, 15.99),
(4, 5, 1, 75.50),
(5, 6, 1, 699.99),
(6, 7, 2, 49.99),
(7, 10, 1, 149.99),
(8, 3, 1, 89.99),
(9, 8, 1, 39.99),
(10, 1, 1, 999.99),
(11, 11, 1, 329.99),
(12, 12, 1, 59.99),
(13, 14, 1, 12.99),
(14, 15, 2, 89.99),
(15, 17, 1, 129.99),
(16, 18, 1, 69.99),
(17, 19, 1, 99.99),
(18, 20, 1, 119.99),
(19, 21, 1, 179.99),
(20, 22, 1, 19.99),
(21, 23, 1, 49.99),
(22, 24, 1, 199.99),
(23, 25, 1, 449.99),
(24, 26, 1, 59.99),
(25, 27, 1, 129.99),
(26, 28, 1, 149.99),
(27, 29, 1, 39.99),
(28, 30, 1, 24.99);

-- Payments (30 entries)
INSERT INTO payments (order_id, payment_method, payment_date, status) VALUES
(1, 'Credit Card', '2023-05-01', 'Completed'),
(2, 'PayPal', '2023-05-03', 'Completed'),
(3, 'Credit Card', '2023-06-15', 'Completed'),
(4, 'Debit Card', '2023-07-10', 'Completed'),
(5, 'Credit Card', '2023-07-15', 'Completed'),
(6, 'Credit Card', '2023-07-20', 'Completed'),
(7, 'Debit Card', '2023-07-22', 'Completed'),
(8, 'PayPal', '2023-07-25', 'Completed'),
(9, 'Credit Card', '2023-07-27', 'Completed'),
(10, 'Debit Card', '2023-07-29', 'Completed'),
(11, 'Credit Card', '2023-07-30', 'Completed'),
(12, 'PayPal', '2023-07-31', 'Completed'),
(13, 'Credit Card', '2023-08-01', 'Completed'),
(14, 'Debit Card', '2023-08-02', 'Completed'),
(15, 'Credit Card', '2023-08-03', 'Completed'),
(16, 'Credit Card', '2023-08-04', 'Completed'),
(17, 'Debit Card', '2023-08-05', 'Completed'),
(18, 'PayPal', '2023-08-06', 'Completed'),
(19, 'Credit Card', '2023-08-07', 'Completed'),
(20, 'Debit Card', '2023-08-08', 'Completed'),
(21, 'Credit Card', '2023-08-09', 'Completed'),
(22, 'PayPal', '2023-08-10', 'Completed'),
(23, 'Debit Card', '2023-08-11', 'Completed'),
(24, 'Credit Card', '2023-08-12', 'Completed'),
(25, 'Credit Card', '2023-08-13', 'Completed'),
(26, 'PayPal', '2023-08-14', 'Completed'),
(27, 'Debit Card', '2023-08-15', 'Completed'),
(28, 'Credit Card', '2023-08-16', 'Completed'),
(29, 'PayPal', '2023-08-17', 'Completed'),
(30, 'Debit Card', '2023-08-18', 'Completed');

-- Reviews (30 entries)
INSERT INTO reviews (customer_id, product_id, rating, comment, review_date) VALUES
(1, 1, 5, 'Excellent laptop!', '2023-05-05'),
(2, 3, 4, 'Very useful!', '2023-05-06'),
(3, 5, 3, 'Good quality.', '2023-07-12'),
(1, 4, 5, 'Great read.', '2023-06-16'),
(4, 6, 5, 'Amazing smartphone!', '2023-07-16'),
(5, 7, 4, 'Roomy and stylish.', '2023-07-21'),
(6, 10, 4, 'Comfortable chair.', '2023-07-23'),
(7, 3, 3, 'Brews fast.', '2023-07-26'),
(8, 8, 5, 'Bright light!', '2023-07-28'),
(9, 9, 4, 'Keeps water cold.', '2023-07-30'),
(10, 2, 5, 'Love the sound quality.', '2023-07-31'),
(11, 11, 4, 'Tablet works great.', '2023-08-01'),
(12, 12, 4, 'Makes great smoothies.', '2023-08-02'),
(13, 14, 3, 'Nice pens.', '2023-08-03'),
(14, 15, 4, 'Comfortable shoes.', '2023-08-04'),
(15, 17, 5, 'Accurate and stylish.', '2023-08-05'),
(16, 18, 4, 'Looks cool.', '2023-08-06'),
(17, 19, 5, 'Great sound.', '2023-08-07'),
(18, 20, 4, 'Easy on the eyes.', '2023-08-08'),
(19, 21, 4, 'Nice office chair.', '2023-08-09'),
(20, 22, 5, 'Soft and comfy.', '2023-08-10'),
(21, 23, 4, 'Fits well.', '2023-08-11'),
(22, 24, 5, 'Elegant and reliable.', '2023-08-12'),
(23, 25, 5, 'Great quality.', '2023-08-13'),
(24, 26, 4, 'Sturdy tripod.', '2023-08-14'),
(25, 27, 4, 'Works fast.', '2023-08-15'),
(26, 28, 5, 'Very powerful.', '2023-08-16'),
(27, 29, 4, 'Stylish and simple.', '2023-08-17'),
(28, 30, 5, 'Love the lights!', '2023-08-18');

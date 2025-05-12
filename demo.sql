CREATE DATABASE `ecommerce_db` 

USE `ecommerce_db`;

CREATE TABLE `User` (
user_id INT AUTO_INCREMENT NOT NULL,
name VARCHAR(100) NOT NULL,
email VARCHAR(100) NOT NULL,
password VARCHAR(100) NOT NULL,
address VARCHAR(100) NOT NULL,
PRIMARY KEY (user_id),
UNIQUE KEY (email)) 

CREATE TABLE `Category` (
    category_id INT AUTO_INCREMENT NOT NULL,
    category_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (category_id)
) 

CREATE TABLE `Product` (
    product_id INT AUTO_INCREMENT NOT NULL,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    category_id INT,
    PRIMARY KEY (product_id),
    FOREIGN KEY (category_id) REFERENCES `Category`(category_id)
) 

CREATE TABLE `Order` (
    order_id INT AUTO_INCREMENT NOT NULL,
    user_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2),
    PRIMARY KEY (order_id),
    FOREIGN KEY (user_id) REFERENCES `User`(user_id)
    ) 

CREATE TABLE `Order_Product` (
    order_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES `Order`(order_id),
    FOREIGN KEY (product_id) REFERENCES `Product`(product_id)
    ) 

INSERT INTO `User` (name, email, password, address) VALUES
('Juan Pérez', 'juan.perez@email.com', 'password123', 'Calle Gran Via 6'),
('Ana López', 'ana.lopez@email.com', 'password456', 'Calle Elcano 8'),
('Carlos García', 'carlos.garcia@email.com', 'password789', 'Ercilla 10'),
('María Rodríguez', 'maria.rodriguez@email.com', 'password101', 'Henao 12'),
('Pedro Martínez', 'pedro.martinez@email.com', 'password102', 'Inadutxu 14');

INSERT INTO `Category` (category_name) VALUES
('Ropa'),
('Electrónica');

INSERT INTO `Product` (name, price, stock, category_id) VALUES
('Camiseta Roja', 19.99, 50, 1), 
('Pantalón Azul', 29.99, 30, 1),
('Zapatos Negros', 49.99, 20, 1),
('Smartphone X500', 599.99, 15, 2),
('Auriculares Bluetooth', 99.99, 25, 2);

INSERT INTO `Order` (user_id, order_date, total_amount) VALUES
(1, '2025-05-01 10:30:00', 129.98),
(2, '2025-05-02 11:00:00', 59.98),
(3, '2025-05-03 12:15:00', 149.98),
(4, '2025-05-04 14:00:00', 1099.99),
(5, '2025-05-05 15:45:00', 199.98);

SELECT * FROM `Product`;

UPDATE `Product`
SET name = 'Camiseta Verde'
WHERE product_id = 6;

UPDATE `Product`
SET price = 50.00
WHERE product_id = 8;

SELECT * FROM `Product`
WHERE price > 20.00;

SELECT * FROM `Product`
ORDER BY price DESC;

SELECT p.product_id, p.name, p.price, p.stock, c.category_name
FROM `Product` p
JOIN `Category` c ON p.category_id = c.category_id;

SELECT u.user_id, u.name, u.email, o.order_id, o.order_date, o.total_amount
FROM `User` u
LEFT JOIN `Order` o ON u.user_id = o.user_id;

SELECT p.product_id, p.name, p.price, p.stock, c.category_name
FROM `Product` p
JOIN `Category` c ON p.category_id = c.category_id
WHERE p.product_id = 6;

SELECT u.user_id, u.name, u.email, o.order_id, o.order_date, o.total_amount
FROM `User` u
JOIN `Order` o ON u.user_id = o.user_id
WHERE u.user_id = 1;

DELETE FROM `Product`
WHERE product_id = 6;

CREATE TABLE `Reviews` (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES `User`(user_id),
    FOREIGN KEY (product_id) REFERENCES `Product`(product_id)
);

INSERT INTO `Reviews` (user_id, product_id, rating, comment)
VALUES
(1, 7, 4, 'Muy cómodo y buen material.'),
(2, 8, 5, 'Zapatos elegantes y duraderos.'),
(3, 9, 5, 'Excelente rendimiento y diseño moderno.Increíble rendimiento del teléfono.'),
(4, 10, 4, 'Buen sonido, excelente batería.'),
(5, 7, 3, 'Buena calidad, pero el tallaje no es preciso.');

UPDATE Reviews
SET comment = 'Increíble rendimiento del teléfono.'
WHERE review_id = 3;

SELECT * FROM Reviews;

SELECT 
    p.product_id,
    p.name AS product_name,
    r.review_id,
    r.rating,
    r.comment,
    r.review_date
FROM Product p
LEFT JOIN Reviews r ON p.product_id = r.product_id
ORDER BY p.product_id, r.review_date;

SELECT 
    p.product_id,
    p.name AS product_name,
    r.review_id,
    r.rating,
    r.comment,
    r.review_date
FROM Product p
LEFT JOIN Reviews r ON p.product_id = r.product_id
WHERE p.product_id = 9;

SELECT 
    p.product_id,
    p.name AS product_name,
    c.name AS category_name,
    r.review_id,
    r.rating,
    r.comment,
    r.review_date
FROM Product p
JOIN Category c ON p.category_id = c.category_id
LEFT JOIN Reviews r ON p.product_id = r.product_id
ORDER BY p.product_id, r.review_date;

INSERT INTO Order_Product (order_id, product_id, quantity)
VALUES 
(1, 7, 2),  
(1, 8, 1),   
(1, 9, 1),   
(1, 10, 1);  

SELECT * FROM Order_Product;

SELECT 
    u.user_id,
    u.name AS user_name,
    o.order_id,
    o.order_date,
    p.product_id,
    p.name AS product_name,
    op.quantity,
    p.price * op.quantity AS total_price
FROM User u
JOIN `Order` o ON u.user_id = o.user_id
JOIN Order_Product op ON o.order_id = op.order_id
JOIN Product p ON op.product_id = p.product_id
WHERE u.user_id = 1
ORDER BY o.order_date DESC
LIMIT 1;

DELETE FROM reviews
WHERE review_id = 6;
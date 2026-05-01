-- ============================================================
-- AgriBridgeHub Database Setup Script
-- Database: agribridge_db

-- ============================================================

-- 1. Create and select the database
CREATE DATABASE IF NOT EXISTS agribridge_db;
USE agribridge_db;

-- ============================================================
-- 2. USERS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    user_id        INT AUTO_INCREMENT PRIMARY KEY,
    name           VARCHAR(100)        NOT NULL,
    email          VARCHAR(150)        NOT NULL UNIQUE,
    phone          VARCHAR(20),
    password_hash  VARCHAR(255)        NOT NULL,
    role           ENUM('customer', 'admin') DEFAULT 'customer',
    reset_token    VARCHAR(255)        DEFAULT NULL,
    token_expiry   DATETIME            DEFAULT NULL,
    created_at     TIMESTAMP           DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 3. PRODUCTS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS products (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    name                VARCHAR(150)    NOT NULL,
    category            VARCHAR(100),
    description         TEXT,
    price               DECIMAL(10, 2)  NOT NULL DEFAULT 0.00,
    stock               INT             NOT NULL DEFAULT 0,
    image_path          VARCHAR(255),
    public_in_catalog   BOOLEAN         DEFAULT TRUE,
    featured_product    BOOLEAN         DEFAULT FALSE,
    created_date        TIMESTAMP       DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 4. ORDERS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS orders (
    order_id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id          INT             NOT NULL,
    order_number     VARCHAR(50)     NOT NULL UNIQUE,
    order_date       TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    total_amount     DECIMAL(10, 2)  NOT NULL DEFAULT 0.00,
    delivery_fee     DECIMAL(10, 2)  DEFAULT 150.00,
    status           ENUM('pending', 'confirmed', 'shipped', 'delivered', 'cancelled')
                                     DEFAULT 'pending',
    payment_status   ENUM('pending', 'paid', 'failed')
                                     DEFAULT 'pending',
    delivery_address TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- ============================================================
-- 5. ORDER ITEMS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS order_items (
    order_item_id  INT AUTO_INCREMENT PRIMARY KEY,
    order_id       INT             NOT NULL,
    product_id     INT             NOT NULL,
    quantity       INT             NOT NULL DEFAULT 1,
    price          DECIMAL(10, 2)  NOT NULL,
    subtotal       DECIMAL(10, 2)  NOT NULL,
    FOREIGN KEY (order_id)    REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id)  REFERENCES products(id)     ON DELETE RESTRICT
);

-- ============================================================
-- 6. PAYMENTS TABLE  ← This is your M-Pesa module table
-- ============================================================
CREATE TABLE IF NOT EXISTS payments (
    payment_id       INT AUTO_INCREMENT PRIMARY KEY,
    order_id         INT              NOT NULL,
    amount           DECIMAL(10, 2)   NOT NULL,
    payment_method   VARCHAR(50)      DEFAULT 'M-Pesa',
    transaction_code VARCHAR(100),               -- Holds CheckoutRequestID then replaced by M-Pesa receipt
    payment_status   ENUM('Pending', 'Completed', 'Failed')
                                      DEFAULT 'Pending',
    payment_date     TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

-- ============================================================
-- 7. SAMPLE DATA — Egerton University Dairy Products
-- ============================================================

-- Admin user (password: admin123)
INSERT IGNORE INTO users (name, email, phone, password_hash, role)
VALUES ('Admin', 'admin@egerton.ac.ke', '0700000000',
        '$2a$10$placeholder_hash_change_this', 'admin');

-- Sample dairy products
INSERT IGNORE INTO products (name, category, description, price, stock, public_in_catalog, featured_product) VALUES
('Fresh Whole Milk (1L)',    'Milk',    'Fresh pasteurized whole milk from Egerton University dairy farm.',         80.00,  200, TRUE, TRUE),
('Fresh Whole Milk (500ml)', 'Milk',    'Fresh pasteurized whole milk — half litre.',                              45.00,  150, TRUE, FALSE),
('Sour Milk / Mala (500ml)', 'Milk',    'Traditional fermented milk, naturally cultured.',                         50.00,  100, TRUE, TRUE),
('Yoghurt Plain (500ml)',    'Yoghurt', 'Creamy plain yoghurt made from fresh Egerton farm milk.',                 90.00,  80,  TRUE, TRUE),
('Yoghurt Strawberry (500ml)','Yoghurt','Strawberry flavoured yoghurt.',                                          100.00, 60,  TRUE, FALSE),
('Butter (250g)',            'Butter',  'Pure unsalted butter from fresh cream.',                                  150.00, 50,  TRUE, TRUE),
('Ghee (500ml)',             'Ghee',    'Pure clarified butter, traditionally processed.',                         350.00, 40,  TRUE, FALSE),
('UHT Milk (1L)',            'Milk',    'Long-life ultra-heat treated milk, no refrigeration needed until opened.',110.00, 120, TRUE, FALSE),
('Fresh Cream (250ml)',      'Cream',   'Fresh dairy cream for cooking and baking.',                               120.00, 30,  TRUE, FALSE),
('Cheese Cheddar (200g)',    'Cheese',  'Mild cheddar cheese, locally produced.',                                  200.00, 25,  TRUE, TRUE);

-- ============================================================
-- VERIFY: Run these SELECT statements to confirm setup worked
-- ============================================================
-- SELECT * FROM users;
-- SELECT * FROM products;
-- SHOW TABLES;

SELECT 'agribridge_db setup complete!' AS status;

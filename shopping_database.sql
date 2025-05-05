-- Create database
CREATE DATABASE IF NOT EXISTS shopping;
USE shopping;

-- Address table
CREATE TABLE Address (
    AddressID INT PRIMARY KEY AUTO_INCREMENT,
    Street VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50),
    Country VARCHAR(50) NOT NULL,
    PostalCode VARCHAR(20),
    INDEX idx_city (City),
    INDEX idx_country (Country)
);

-- Category table
CREATE TABLE Category (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(50) NOT NULL,
    Description TEXT,
    INDEX idx_category_name (CategoryName)
);

-- Supplier table
CREATE TABLE Supplier (
    SupplierID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20),
    AddressID INT,
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID) ON UPDATE CASCADE,
    INDEX idx_supplier_name (Name),
    INDEX idx_supplier_email (Email)
);

-- Product table
CREATE TABLE Product (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10,2) NOT NULL,
    Brand VARCHAR(50),
    CategoryID INT,
    SupplierID INT,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID) ON UPDATE CASCADE,
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID) ON UPDATE CASCADE,
    INDEX idx_product_name (ProductName),
    INDEX idx_product_brand (Brand),
    INDEX idx_product_price (Price),
    CONSTRAINT chk_price CHECK (Price >= 0)
);

-- Stock table
CREATE TABLE Stock (
    StockID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT,
    Quantity INT NOT NULL,
    LastUpdated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_quantity CHECK (Quantity >= 0)
);

-- Customer table
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20),
    AddressID INT,
    RegistrationDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID) ON UPDATE CASCADE,
    INDEX idx_customer_name (CustomerName)
);

-- Member table
CREATE TABLE Member (
    MemberID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(50) NOT NULL UNIQUE,
    Password VARCHAR(255) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20),
    AddressID INT,
    JoinDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID) ON UPDATE CASCADE,
    INDEX idx_member_username (Username),
    INDEX idx_member_email (Email)
);

-- DiscountCoupon table
CREATE TABLE DiscountCoupon (
    CouponID INT PRIMARY KEY AUTO_INCREMENT,
    CouponCode VARCHAR(20) UNIQUE NOT NULL,
    DiscountAmount DECIMAL(10,2) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    IsActive BOOLEAN DEFAULT TRUE,
    INDEX idx_coupon_code (CouponCode),
    INDEX idx_coupon_dates (StartDate, EndDate),
    CONSTRAINT chk_discount_amount CHECK (DiscountAmount > 0),
    CONSTRAINT chk_dates CHECK (EndDate >= StartDate)
);

-- Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10,2) DEFAULT 0,
    Status ENUM('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    CustomerID INT,
    MemberID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON UPDATE CASCADE,
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID) ON UPDATE CASCADE,
    INDEX idx_order_date (OrderDate),
    INDEX idx_order_status (Status)
);

-- Bill table
CREATE TABLE Bill (
    BillID INT PRIMARY KEY AUTO_INCREMENT,
    BillNumber VARCHAR(50) UNIQUE NOT NULL,
    InvoiceDate DATE NOT NULL,
    OrderID INT,
    TotalAmount DECIMAL(10,2) NOT NULL,
    PaymentMethod VARCHAR(50),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON UPDATE CASCADE,
    INDEX idx_bill_number (BillNumber),
    INDEX idx_invoice_date (InvoiceDate),
    CONSTRAINT chk_total_amount CHECK (TotalAmount >= 0)
);

-- OrderProduct table
CREATE TABLE OrderProduct (
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    Subtotal DECIMAL(10,2) GENERATED ALWAYS AS (Quantity * UnitPrice) STORED,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID) ON UPDATE CASCADE,
    CONSTRAINT chk_order_quantity CHECK (Quantity > 0),
    CONSTRAINT chk_unit_price CHECK (UnitPrice >= 0)
);

-- Cart table
CREATE TABLE Cart (
    CartID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    MemberID INT,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    LastUpdated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON UPDATE CASCADE,
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID) ON UPDATE CASCADE
);

-- CartItem table
CREATE TABLE CartItem (
    CartID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    AddedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (CartID, ProductID),
    FOREIGN KEY (CartID) REFERENCES Cart(CartID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID) ON UPDATE CASCADE,
    CONSTRAINT chk_cart_quantity CHECK (Quantity > 0)
);

-- MemberCoupon table
CREATE TABLE MemberCoupon (
    MemberID INT,
    CouponID INT,
    AssignedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    IsUsed BOOLEAN DEFAULT FALSE,
    UsedAt DATETIME,
    PRIMARY KEY (MemberID, CouponID),
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (CouponID) REFERENCES DiscountCoupon(CouponID) ON UPDATE CASCADE
);

-- Triggers
DELIMITER //

-- Update order total after insert
CREATE TRIGGER update_order_total AFTER INSERT ON OrderProduct
FOR EACH ROW
BEGIN
    UPDATE Orders 
    SET TotalAmount = (
        SELECT SUM(Subtotal) 
        FROM OrderProduct 
        WHERE OrderID = NEW.OrderID
    )
    WHERE OrderID = NEW.OrderID;
END //

-- Update order total after update
CREATE TRIGGER update_order_total_after_update AFTER UPDATE ON OrderProduct
FOR EACH ROW
BEGIN
    UPDATE Orders 
    SET TotalAmount = (
        SELECT SUM(Subtotal) 
        FROM OrderProduct 
        WHERE OrderID = NEW.OrderID
    )
    WHERE OrderID = NEW.OrderID;
END //

-- Update order total after delete
CREATE TRIGGER update_order_total_after_delete AFTER DELETE ON OrderProduct
FOR EACH ROW
BEGIN
    UPDATE Orders 
    SET TotalAmount = (
        SELECT IFNULL(SUM(Subtotal), 0) 
        FROM OrderProduct 
        WHERE OrderID = OLD.OrderID
    )
    WHERE OrderID = OLD.OrderID;
END //

DELIMITER ;

-- Sample data for Address
INSERT INTO Address (Street, City, State, Country, PostalCode) VALUES
('123 Main St', 'New York', 'NY', 'USA', '10001'),
('456 Oak Ave', 'Los Angeles', 'CA', 'USA', '90001'),
('789 Pine St', 'Chicago', 'IL', 'USA', '60601'),
('101 Maple Dr', 'Houston', 'TX', 'USA', '77001'),
('202 Elm St', 'Phoenix', 'AZ', 'USA', '85001'),
('303 Cedar Ave', 'Philadelphia', 'PA', 'USA', '19101'),
('404 Birch Ln', 'San Antonio', 'TX', 'USA', '78201'),
('505 Spruce St', 'San Diego', 'CA', 'USA', '92101'),
('606 Willow Dr', 'Dallas', 'TX', 'USA', '75201'),
('707 Redwood Ave', 'San Jose', 'CA', 'USA', '95101');

-- Sample data for Category
INSERT INTO Category (CategoryName, Description) VALUES
('Electronics', 'Electronic devices and accessories'),
('Clothing', 'Apparel and fashion items'),
('Home & Kitchen', 'Home appliances and kitchenware'),
('Books', 'Books and educational materials'),
('Sports', 'Sports equipment and accessories'),
('Beauty', 'Beauty and personal care products'),
('Toys', 'Toys and games'),
('Automotive', 'Automotive parts and accessories'),
('Health', 'Health and wellness products'),
('Office', 'Office supplies and equipment');

-- Sample data for Supplier
INSERT INTO Supplier (Name, Email, Phone, AddressID) VALUES
('TechGear Inc', 'info@techgear.com', '555-0101', 1),
('FashionHub', 'contact@fashionhub.com', '555-0102', 2),
('HomeEssentials', 'support@homeessentials.com', '555-0103', 3),
('BookWorld', 'info@bookworld.com', '555-0104', 4),
('SportPro', 'sales@sportpro.com', '555-0105', 5),
('BeautyCare', 'contact@beautycare.com', '555-0106', 6),
('ToyLand', 'info@toyland.com', '555-0107', 7),
('AutoParts', 'sales@autoparts.com', '555-0108', 8),
('HealthPlus', 'support@healthplus.com', '555-0109', 9),
('OfficeSupplies', 'info@officesupplies.com', '555-0110', 10);

-- Sample data for Product
INSERT INTO Product (ProductName, Description, Price, Brand, CategoryID, SupplierID) VALUES
('Smartphone X', 'Latest smartphone with advanced features', 999.99, 'TechBrand', 1, 1),
('Laptop Pro', 'High-performance laptop for professionals', 1299.99, 'TechBrand', 1, 1),
('T-Shirt Classic', 'Comfortable cotton t-shirt', 29.99, 'FashionCo', 2, 2),
('Jeans Slim Fit', 'Modern slim fit jeans', 59.99, 'FashionCo', 2, 2),
('Coffee Maker', 'Automatic coffee maker with timer', 79.99, 'HomeGoods', 3, 3),
('Blender Pro', 'High-speed blender for smoothies', 49.99, 'HomeGoods', 3, 3),
('Database Design', 'Comprehensive guide to database design', 39.99, 'TechBooks', 4, 4),
('Web Development', 'Modern web development techniques', 49.99, 'TechBooks', 4, 4),
('Yoga Mat', 'Non-slip yoga mat', 29.99, 'SportLife', 5, 5),
('Dumbbell Set', 'Adjustable dumbbell set', 89.99, 'SportLife', 5, 5);

-- Sample data for Stock
INSERT INTO Stock (ProductID, Quantity) VALUES
(1, 50), (2, 30), (3, 100), (4, 75), (5, 40),
(6, 60), (7, 25), (8, 35), (9, 80), (10, 45);

-- Sample data for Customer
INSERT INTO Customer (CustomerName, Email, Phone, AddressID) VALUES
('John Smith', 'john.smith@email.com', '555-0201', 1),
('Emily Johnson', 'emily.j@email.com', '555-0202', 2),
('Michael Brown', 'm.brown@email.com', '555-0203', 3),
('Sarah Davis', 'sarah.d@email.com', '555-0204', 4),
('David Wilson', 'd.wilson@email.com', '555-0205', 5),
('Lisa Anderson', 'l.anderson@email.com', '555-0206', 6),
('Robert Taylor', 'r.taylor@email.com', '555-0207', 7),
('Jennifer Martinez', 'j.martinez@email.com', '555-0208', 8),
('William Thomas', 'w.thomas@email.com', '555-0209', 9),
('Patricia White', 'p.white@email.com', '555-0210', 10);

-- Sample data for Member
INSERT INTO Member (Username, Password, Name, Email, Phone, AddressID) VALUES
('jsmith', 'hashed_password1', 'John Smith', 'john.smith@email.com', '555-0201', 1),
('ejohnson', 'hashed_password2', 'Emily Johnson', 'emily.j@email.com', '555-0202', 2),
('mbrown', 'hashed_password3', 'Michael Brown', 'm.brown@email.com', '555-0203', 3),
('sdavis', 'hashed_password4', 'Sarah Davis', 'sarah.d@email.com', '555-0204', 4),
('dwilson', 'hashed_password5', 'David Wilson', 'd.wilson@email.com', '555-0205', 5),
('landerson', 'hashed_password6', 'Lisa Anderson', 'l.anderson@email.com', '555-0206', 6),
('rtaylor', 'hashed_password7', 'Robert Taylor', 'r.taylor@email.com', '555-0207', 7),
('jmartinez', 'hashed_password8', 'Jennifer Martinez', 'j.martinez@email.com', '555-0208', 8),
('wthomas', 'hashed_password9', 'William Thomas', 'w.thomas@email.com', '555-0209', 9),
('pwhite', 'hashed_password10', 'Patricia White', 'p.white@email.com', '555-0210', 10);

-- Sample data for DiscountCoupon
INSERT INTO DiscountCoupon (CouponCode, DiscountAmount, StartDate, EndDate) VALUES
('WELCOME10', 10.00, '2024-01-01', '2024-12-31'),
('SPRING20', 20.00, '2024-03-01', '2024-05-31'),
('SUMMER15', 15.00, '2024-06-01', '2024-08-31'),
('FALL25', 25.00, '2024-09-01', '2024-11-30'),
('WINTER30', 30.00, '2024-12-01', '2025-02-28'),
('NEWYEAR40', 40.00, '2024-01-01', '2024-01-31'),
('BIRTHDAY50', 50.00, '2024-01-01', '2024-12-31'),
('VIP20', 20.00, '2024-01-01', '2024-12-31'),
('FLASH15', 15.00, '2024-01-01', '2024-12-31'),
('SPECIAL10', 10.00, '2024-01-01', '2024-12-31');

-- Sample data for Orders
INSERT INTO Orders (OrderDate, Status, CustomerID, MemberID) VALUES
('2024-01-15 10:30:00', 'Delivered', 1, 1),
('2024-02-20 14:45:00', 'Shipped', 2, 2),
('2024-03-10 09:15:00', 'Processing', 3, 3),
('2024-04-05 16:20:00', 'Pending', 4, 4),
('2024-05-12 11:30:00', 'Delivered', 5, 5),
('2024-06-18 13:45:00', 'Shipped', 6, 6),
('2024-07-22 10:15:00', 'Processing', 7, 7),
('2024-08-30 15:20:00', 'Pending', 8, 8),
('2024-09-14 12:30:00', 'Delivered', 9, 9),
('2024-10-25 14:45:00', 'Shipped', 10, 10);

-- Sample data for Bill
INSERT INTO Bill (BillNumber, InvoiceDate, OrderID, TotalAmount, PaymentMethod) VALUES
('INV-2024-001', '2024-01-15', 1, 999.99, 'Credit Card'),
('INV-2024-002', '2024-02-20', 2, 1299.99, 'PayPal'),
('INV-2024-003', '2024-03-10', 3, 89.98, 'Credit Card'),
('INV-2024-004', '2024-04-05', 4, 129.98, 'PayPal'),
('INV-2024-005', '2024-05-12', 5, 79.99, 'Credit Card'),
('INV-2024-006', '2024-06-18', 6, 49.99, 'PayPal'),
('INV-2024-007', '2024-07-22', 7, 89.98, 'Credit Card'),
('INV-2024-008', '2024-08-30', 8, 39.99, 'PayPal'),
('INV-2024-009', '2024-09-14', 9, 29.99, 'Credit Card'),
('INV-2024-010', '2024-10-25', 10, 89.99, 'PayPal');

-- Sample data for OrderProduct
INSERT INTO OrderProduct (OrderID, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 1, 999.99),
(2, 2, 1, 1299.99),
(3, 3, 2, 29.99),
(4, 4, 2, 59.99),
(5, 5, 1, 79.99),
(6, 6, 1, 49.99),
(7, 7, 2, 39.99),
(8, 8, 1, 39.99),
(9, 9, 1, 29.99),
(10, 10, 1, 89.99);

-- Sample data for Cart
INSERT INTO Cart (CustomerID, MemberID) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(6, 6), (7, 7), (8, 8), (9, 9), (10, 10);

-- Sample data for CartItem
INSERT INTO CartItem (CartID, ProductID, Quantity) VALUES
(1, 1, 1), (2, 2, 1), (3, 3, 2), (4, 4, 1), (5, 5, 1),
(6, 6, 1), (7, 7, 1), (8, 8, 1), (9, 9, 1), (10, 10, 1);

-- Sample data for MemberCoupon
INSERT INTO MemberCoupon (MemberID, CouponID, IsUsed, UsedAt) VALUES
(1, 1, TRUE, '2024-01-15 10:30:00'),
(2, 2, TRUE, '2024-02-20 14:45:00'),
(3, 3, FALSE, NULL),
(4, 4, FALSE, NULL),
(5, 5, TRUE, '2024-05-12 11:30:00'),
(6, 6, FALSE, NULL),
(7, 7, TRUE, '2024-07-22 10:15:00'),
(8, 8, FALSE, NULL),
(9, 9, TRUE, '2024-09-14 12:30:00'),
(10, 10, FALSE, NULL); 
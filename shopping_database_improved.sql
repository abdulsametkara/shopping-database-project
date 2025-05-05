-- Veritabanını oluştur
CREATE DATABASE IF NOT EXISTS shopping;
USE shopping;

-- Adres tablosu (Normalizasyon için)
CREATE TABLE Address (
    AddressID INT PRIMARY KEY AUTO_INCREMENT,
    Neighborhood VARCHAR(100),
    City VARCHAR(100),
    Country VARCHAR(100),
    INDEX idx_city (City),
    INDEX idx_country (Country)
) AUTO_INCREMENT = 100;

-- Category tablosu
CREATE TABLE Category (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(100) NOT NULL,
    Channel VARCHAR(50),
    Cid INT,
    INDEX idx_category_name (CategoryName)
) AUTO_INCREMENT = 200;

-- Supplier tablosu
CREATE TABLE Supplier (
    SupplierID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Sid INT,
    Satellite VARCHAR(50),
    AddressID INT,
    Email VARCHAR(100),
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID) ON UPDATE CASCADE,
    INDEX idx_supplier_name (Name),
    INDEX idx_supplier_email (Email)
) AUTO_INCREMENT = 300;

-- Product tablosu
CREATE TABLE Product (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Pid INT,
    Brand VARCHAR(100),
    Colour VARCHAR(50),
    Size VARCHAR(50),
    Material VARCHAR(50),
    Gender VARCHAR(20),
    CategoryID INT,
    SupplierID INT,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID) ON UPDATE CASCADE,
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID) ON UPDATE CASCADE,
    INDEX idx_product_name (ProductName),
    INDEX idx_product_brand (Brand),
    INDEX idx_product_price (Price),
    CONSTRAINT chk_price CHECK (Price >= 0)
) AUTO_INCREMENT = 400;

-- Stock tablosu
CREATE TABLE Stock (
    StockID INT PRIMARY KEY AUTO_INCREMENT,
    Sid INT,
    Quantity INT NOT NULL,
    ProductID INT,
    LastUpdated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_quantity CHECK (Quantity >= 0)
) AUTO_INCREMENT = 500;

-- Customer tablosu
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(100) NOT NULL,
    Cname VARCHAR(100),
    AddressID INT,
    Cid INT,
    RegistrationDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID) ON UPDATE CASCADE,
    INDEX idx_customer_name (CustomerName)
) AUTO_INCREMENT = 600;

-- Member tablosu
CREATE TABLE Member (
    MemberID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(50) NOT NULL,
    Name VARCHAR(100),
    Mail VARCHAR(100) UNIQUE,
    AddressID INT,
    JoinDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID) ON UPDATE CASCADE,
    INDEX idx_member_username (Username),
    INDEX idx_member_mail (Mail)
) AUTO_INCREMENT = 700;

-- DiscountCoupon tablosu
CREATE TABLE DiscountCoupon (
    CouponID INT PRIMARY KEY AUTO_INCREMENT,
    CouponCode VARCHAR(50) UNIQUE NOT NULL,
    DiscountAmount DECIMAL(10, 2) NOT NULL,
    StartDate DATE NOT NULL,
    FinishDate DATE NOT NULL,
    IsActive BOOLEAN DEFAULT TRUE,
    INDEX idx_coupon_code (CouponCode),
    INDEX idx_coupon_dates (StartDate, FinishDate),
    CONSTRAINT chk_discount_amount CHECK (DiscountAmount > 0),
    CONSTRAINT chk_dates CHECK (FinishDate >= StartDate)
) AUTO_INCREMENT = 800;

-- Order tablosu (kullanımına dikkat edin, "Order" SQL'de ayrılmış bir kelimedir)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10, 2) DEFAULT 0,
    Status ENUM('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    CustomerID INT,
    MemberID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON UPDATE CASCADE,
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID) ON UPDATE CASCADE,
    INDEX idx_order_date (OrderDate),
    INDEX idx_order_status (Status)
) AUTO_INCREMENT = 900;

-- Bill tablosu
CREATE TABLE Bill (
    BillID INT PRIMARY KEY AUTO_INCREMENT,
    BillNumber VARCHAR(50) UNIQUE NOT NULL,
    InvoiceDate DATE NOT NULL,
    Bid INT,
    OrderID INT,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    PaymentMethod VARCHAR(50),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON UPDATE CASCADE,
    INDEX idx_bill_number (BillNumber),
    INDEX idx_invoice_date (InvoiceDate),
    CONSTRAINT chk_total_amount CHECK (TotalAmount >= 0)
) AUTO_INCREMENT = 1000;

-- Order-Product ilişki tablosu (Çoka-çok ilişki)
CREATE TABLE OrderProduct (
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    Subtotal DECIMAL(10, 2) GENERATED ALWAYS AS (Quantity * UnitPrice) STORED,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID) ON UPDATE CASCADE,
    CONSTRAINT chk_order_quantity CHECK (Quantity > 0),
    CONSTRAINT chk_unit_price CHECK (UnitPrice >= 0)
);

-- Cart tablosu (Add to Cart ilişkisi için)
CREATE TABLE Cart (
    CartID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    MemberID INT,
    CreateDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    LastUpdated DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON UPDATE CASCADE,
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID) ON UPDATE CASCADE
) AUTO_INCREMENT = 1100;

-- CartItem tablosu (Cart ve Product arasındaki ilişki)
CREATE TABLE CartItem (
    CartID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    AddedDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (CartID, ProductID),
    FOREIGN KEY (CartID) REFERENCES Cart(CartID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID) ON UPDATE CASCADE,
    CONSTRAINT chk_cart_quantity CHECK (Quantity > 0)
);

-- Member-Coupon ilişki tablosu (Win a coupon ilişkisi)
CREATE TABLE MemberCoupon (
    MemberID INT,
    CouponID INT,
    AssignDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    IsUsed BOOLEAN DEFAULT FALSE,
    UsedDate DATETIME,
    PRIMARY KEY (MemberID, CouponID),
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (CouponID) REFERENCES DiscountCoupon(CouponID) ON UPDATE CASCADE
);

-- Tetikleyiciler (Triggers)

-- Sipariş toplamını güncelleme tetikleyicisi
DELIMITER //
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
DELIMITER ;

-- Sipariş güncellendikten sonra toplamı güncelleme
DELIMITER //
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
DELIMITER ;

-- Sipariş silindikten sonra toplamı güncelleme
DELIMITER //
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
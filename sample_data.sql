USE shopping;

-- Address examples
INSERT INTO Address (Neighborhood, City, Country) VALUES 
('Downtown', 'New York', 'USA'),
('Midtown', 'Los Angeles', 'USA'),
('Financial District', 'Chicago', 'USA'),
('The Loop', 'Houston', 'USA'),
('Arts District', 'Phoenix', 'USA'),
('Historic District', 'Philadelphia', 'USA'),
('Riverwalk', 'San Antonio', 'USA'),
('Gaslamp Quarter', 'San Diego', 'USA'),
('Uptown', 'Dallas', 'USA'),
('Silicon Valley', 'San Jose', 'USA');

-- Category examples
INSERT INTO Category (CategoryName, Channel, Cid) VALUES 
('Electronics', 'Online', 201),
('Clothing', 'Store', 202),
('Home & Kitchen', 'Both', 203),
('Books', 'Online', 204),
('Sports', 'Store', 205),
('Beauty', 'Both', 206),
('Toys', 'Store', 207),
('Automotive', 'Both', 208),
('Health', 'Online', 209),
('Office', 'Store', 210);

-- Supplier examples
INSERT INTO Supplier (Name, Sid, Satellite, AddressID, Email) VALUES 
('TechGear Inc', 301, 'Yes', 100, 'info@techgear.com'),
('FashionHub', 302, 'No', 101, 'contact@fashionhub.com'),
('HomeEssentials', 303, 'Yes', 102, 'support@homeessentials.com'),
('BookWorld', 304, 'No', 103, 'info@bookworld.com'),
('SportPro', 305, 'Yes', 104, 'sales@sportpro.com'),
('BeautyCare', 306, 'No', 105, 'contact@beautycare.com'),
('ToyLand', 307, 'Yes', 106, 'info@toyland.com'),
('AutoParts', 308, 'No', 107, 'sales@autoparts.com'),
('HealthPlus', 309, 'Yes', 108, 'support@healthplus.com'),
('OfficeSupplies', 310, 'No', 109, 'info@officesupplies.com');

-- Product examples
INSERT INTO Product (ProductName, Price, Pid, Brand, Colour, Size, Material, Gender, CategoryID, SupplierID) VALUES 
('Smartphone X', 999.99, 401, 'TechBrand', 'Black', 'Medium', 'Metal', 'Unisex', 200, 300),
('Laptop Pro', 1299.99, 402, 'TechBrand', 'Silver', 'Large', 'Aluminum', 'Unisex', 200, 300),
('T-Shirt Classic', 29.99, 403, 'FashionCo', 'White', 'Medium', 'Cotton', 'Unisex', 201, 301),
('Jeans Slim Fit', 59.99, 404, 'FashionCo', 'Blue', 'Large', 'Denim', 'Male', 201, 301),
('Coffee Maker', 79.99, 405, 'HomeGoods', 'Black', 'Small', 'Plastic', NULL, 202, 302),
('Blender Pro', 49.99, 406, 'HomeGoods', 'Red', 'Medium', 'Plastic', NULL, 202, 302),
('Database Design', 39.99, 407, 'TechBooks', 'Blue', 'Medium', 'Paper', NULL, 203, 303),
('Web Development', 49.99, 408, 'TechBooks', 'Green', 'Large', 'Paper', NULL, 203, 303),
('Yoga Mat', 29.99, 409, 'SportLife', 'Purple', 'Large', 'Rubber', 'Unisex', 204, 304),
('Dumbbell Set', 89.99, 410, 'SportLife', 'Black', 'Large', 'Metal', 'Unisex', 204, 304);

-- Stock examples
INSERT INTO Stock (Sid, Quantity, ProductID) VALUES 
(501, 100, 400),
(502, 50, 401),
(503, 200, 402),
(504, 150, 403),
(505, 75, 404),
(506, 120, 405),
(507, 80, 406),
(508, 200, 407),
(509, 150, 408),
(510, 100, 409);

-- Customer examples
INSERT INTO Customer (CustomerName, Cname, AddressID, Cid) VALUES 
('John Smith', 'John', 100, 601),
('Emily Johnson', 'Emily', 101, 602),
('Michael Brown', 'Michael', 102, 603),
('Sarah Davis', 'Sarah', 103, 604),
('David Wilson', 'David', 104, 605),
('Lisa Anderson', 'Lisa', 105, 606),
('Robert Taylor', 'Robert', 106, 607),
('Jennifer Martinez', 'Jennifer', 107, 608),
('William Thomas', 'William', 108, 609),
('Patricia White', 'Patricia', 109, 610);

-- Member examples
INSERT INTO Member (Username, Name, Mail, AddressID) VALUES 
('jsmith', 'John Smith', 'john.smith@email.com', 100),
('ejohnson', 'Emily Johnson', 'emily.j@email.com', 101),
('mbrown', 'Michael Brown', 'm.brown@email.com', 102),
('sdavis', 'Sarah Davis', 'sarah.d@email.com', 103),
('dwilson', 'David Wilson', 'd.wilson@email.com', 104),
('landerson', 'Lisa Anderson', 'l.anderson@email.com', 105),
('rtaylor', 'Robert Taylor', 'r.taylor@email.com', 106),
('jmartinez', 'Jennifer Martinez', 'j.martinez@email.com', 107),
('wthomas', 'William Thomas', 'w.thomas@email.com', 108),
('pwhite', 'Patricia White', 'p.white@email.com', 109);

-- DiscountCoupon examples
INSERT INTO DiscountCoupon (CouponCode, DiscountAmount, StartDate, FinishDate) VALUES 
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

-- Orders examples
INSERT INTO Orders (CustomerID, MemberID) VALUES 
(600, 700),
(601, 701),
(602, 702),
(603, 703),
(604, 704),
(605, 705),
(606, 706),
(607, 707),
(608, 708),
(609, 709);

-- OrderProduct examples
INSERT INTO OrderProduct (OrderID, ProductID, Quantity, UnitPrice) VALUES 
(900, 400, 1, 999.99),
(900, 402, 2, 29.99),
(901, 401, 1, 1299.99),
(902, 403, 1, 59.99),
(903, 404, 1, 79.99),
(904, 405, 2, 49.99),
(905, 406, 1, 39.99),
(906, 407, 1, 49.99),
(907, 408, 1, 29.99),
(908, 409, 1, 89.99);

-- Cart examples
INSERT INTO Cart (CustomerID, MemberID) VALUES 
(600, 700),
(601, 701),
(602, 702),
(603, 703),
(604, 704),
(605, 705),
(606, 706),
(607, 707),
(608, 708),
(609, 709);

-- CartItem examples
INSERT INTO CartItem (CartID, ProductID, Quantity) VALUES 
(1100, 400, 1),
(1100, 402, 2),
(1101, 401, 1),
(1102, 403, 1),
(1103, 404, 1),
(1104, 405, 2),
(1105, 406, 1),
(1106, 407, 1),
(1107, 408, 1),
(1108, 409, 1);

-- MemberCoupon examples
INSERT INTO MemberCoupon (MemberID, CouponID) VALUES 
(700, 800),
(701, 801),
(702, 802),
(703, 803),
(704, 804),
(705, 805),
(706, 806),
(707, 807),
(708, 808),
(709, 809); 
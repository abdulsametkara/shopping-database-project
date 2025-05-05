USE shopping;

-- Tüm ürünleri listele
SELECT * FROM Product;

-- Belirli bir kategorideki ürünleri listele
SELECT p.ProductName, p.Price, p.Brand, c.CategoryName 
FROM Product p
JOIN Category c ON p.CategoryID = c.CategoryID
WHERE c.CategoryName = 'Elektronik';

-- Stokta belirli miktarın üzerinde olan ürünleri listele
SELECT p.ProductName, s.Quantity
FROM Product p
JOIN Stock s ON p.ProductID = s.ProductID
WHERE s.Quantity > 50;

-- Üyelerin satın aldıkları ürünleri listele
SELECT m.Username, p.ProductName, op.Quantity
FROM Member m
JOIN Orders o ON m.MemberID = o.MemberID
JOIN OrderProduct op ON o.OrderID = op.OrderID
JOIN Product p ON op.ProductID = p.ProductID;

-- İndirim kuponu kazanan üyeleri listele
SELECT m.Username, dc.CouponCode, dc.DiscountAmount
FROM Member m
JOIN MemberCoupon mc ON m.MemberID = mc.MemberID
JOIN DiscountCoupon dc ON mc.CouponID = dc.CouponID;

-- Her kategorideki ürün sayısını listele
SELECT c.CategoryName, COUNT(p.ProductID) AS ProductCount
FROM Category c
LEFT JOIN Product p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName;

-- En pahalı ürünleri listele (ilk 5)
SELECT ProductName, Price, Brand
FROM Product
ORDER BY Price DESC
LIMIT 5;

-- Belirli bir müşterinin sepetindeki toplam tutarı hesapla
SELECT c.CustomerName, SUM(p.Price * ci.Quantity) AS TotalAmount
FROM Customer c
JOIN Cart ca ON c.CustomerID = ca.CustomerID
JOIN CartItem ci ON ca.CartID = ci.CartID
JOIN Product p ON ci.ProductID = p.ProductID
WHERE c.CustomerID = 1
GROUP BY c.CustomerName;

-- Her şehirdeki müşteri sayısını listele
SELECT City, COUNT(*) AS CustomerCount
FROM Customer
GROUP BY City
ORDER BY CustomerCount DESC;

-- Fiyatı ortalama ürün fiyatından yüksek olan ürünleri listele
SELECT ProductName, Price
FROM Product
WHERE Price > (SELECT AVG(Price) FROM Product);

-- Her tedarikçinin sağladığı ürünleri listele
SELECT s.Name AS SupplierName, p.ProductName, p.Price
FROM Supplier s
JOIN Product p ON s.SupplierID = p.SupplierID
ORDER BY s.Name, p.Price DESC; 
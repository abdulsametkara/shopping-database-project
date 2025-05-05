USE shopping;

-- Veritabanındaki tüm tabloları listele
SHOW TABLES;

-- Her tablonun yapısını kontrol et
DESCRIBE Category;
DESCRIBE Supplier;
DESCRIBE Product;
DESCRIBE Stock;
DESCRIBE Customer;
DESCRIBE Member;
DESCRIBE Bill;
DESCRIBE DiscountCoupon;
DESCRIBE Orders;
DESCRIBE OrderProduct;
DESCRIBE Cart;
DESCRIBE CartItem;
DESCRIBE MemberCoupon;

-- Tablolardaki veri sayılarını kontrol et
SELECT 'Category' AS TableName, COUNT(*) AS RecordCount FROM Category
UNION ALL
SELECT 'Supplier', COUNT(*) FROM Supplier
UNION ALL
SELECT 'Product', COUNT(*) FROM Product
UNION ALL
SELECT 'Stock', COUNT(*) FROM Stock
UNION ALL
SELECT 'Customer', COUNT(*) FROM Customer
UNION ALL
SELECT 'Member', COUNT(*) FROM Member
UNION ALL
SELECT 'Bill', COUNT(*) FROM Bill
UNION ALL
SELECT 'DiscountCoupon', COUNT(*) FROM DiscountCoupon
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders
UNION ALL
SELECT 'OrderProduct', COUNT(*) FROM OrderProduct
UNION ALL
SELECT 'Cart', COUNT(*) FROM Cart
UNION ALL
SELECT 'CartItem', COUNT(*) FROM CartItem
UNION ALL
SELECT 'MemberCoupon', COUNT(*) FROM MemberCoupon; 
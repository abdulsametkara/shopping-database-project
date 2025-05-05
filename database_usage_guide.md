# VERİTABANI KULLANIM KILAVUZU

## 📋 İÇİNDEKİLER
1. [Temel Veritabanı İşlemleri](#1-temel-veritabanı-işlemleri)
2. [Tetikleyiciler](#2-tetikleyiciler)
3. [İndeksler](#3-indeksler)
4. [Kısıtlamalar](#4-kısıtlamalar)
5. [Gelişmiş Sorgular](#5-gelişmiş-sorgular)
6. [Veritabanı Bakımı](#6-veritabanı-bakımı)

## 1. TEMEL VERİTABANI İŞLEMLERİ

### 1.1 Veri Ekleme (INSERT)
Veritabanına yeni kayıtlar eklemek için kullanılan temel işlem.

```sql
-- Adres ekleme
INSERT INTO Address (Neighborhood, City, Country)
VALUES ('Downtown', 'New York', 'USA');

-- Kategori ekleme
INSERT INTO Category (CategoryName, Channel)
VALUES ('Electronics', 'Online');

-- Tedarikçi ekleme
INSERT INTO Supplier (SupplierName, AddressID, ContactNumber)
VALUES ('Tech Supplies Inc.', 100, '+1-555-1234');

-- Ürün ekleme
INSERT INTO Product (ProductName, Price, Brand, CategoryID, SupplierID)
VALUES ('Smartphone X', 999.99, 'TechBrand', 200, 300);
```

### 1.2 Veri Güncelleme (UPDATE)
Mevcut kayıtları değiştirmek için kullanılan işlem.

```sql
-- Ürün fiyatını güncelleme
UPDATE Product 
SET Price = 899.99 
WHERE ProductID = 400;

-- Stok miktarını güncelleme
UPDATE Stock 
SET Quantity = Quantity + 10 
WHERE ProductID = 400;

-- Sipariş durumunu güncelleme
UPDATE Orders 
SET Status = 'Shipped' 
WHERE OrderID = 900;
```

### 1.3 Veri Silme (DELETE)
Kayıtları veritabanından kaldırmak için kullanılan işlem.

```sql
-- Sipariş ürünlerini silme
DELETE FROM OrderProduct 
WHERE OrderID = 900;

-- Siparişi silme
DELETE FROM Orders 
WHERE OrderID = 900;

-- Ürünü silme
DELETE FROM Product 
WHERE ProductID = 400;
```

## 2. TETİKLEYİCİLER (TRIGGERS)

### 2.1 Tetikleyici Nedir?
Tetikleyiciler, veritabanında belirli bir olay (INSERT, UPDATE, DELETE) gerçekleştiğinde otomatik olarak çalışan özel prosedürlerdir.

### 2.2 Tetikleyici Tipleri
1. **BEFORE Tetikleyicileri**: Olay gerçekleşmeden önce çalışır
2. **AFTER Tetikleyicileri**: Olay gerçekleştikten sonra çalışır
3. **INSTEAD OF Tetikleyicileri**: Olayın yerine çalışır

### 2.3 Örnek Tetikleyiciler

#### 2.3.1 Sipariş Toplamı Hesaplama
```sql
CREATE TRIGGER update_order_total_after_insert
AFTER INSERT ON OrderProduct
FOR EACH ROW
BEGIN
    UPDATE Orders
    SET TotalAmount = (
        SELECT SUM(Quantity * UnitPrice)
        FROM OrderProduct
        WHERE OrderID = NEW.OrderID
    )
    WHERE OrderID = NEW.OrderID;
END;
```

#### 2.3.2 Stok Kontrolü
```sql
CREATE TRIGGER update_stock_after_order
AFTER INSERT ON OrderProduct
FOR EACH ROW
BEGIN
    UPDATE Stock
    SET Quantity = Quantity - NEW.Quantity
    WHERE ProductID = NEW.ProductID;
END;
```

## 3. İNDEKSLER (INDEXES)

### 3.1 İndeks Nedir?
İndeksler, veritabanında arama yaparken performansı artırmak için kullanılan özel yapılardır.

### 3.2 İndeks Türleri

#### 3.2.1 Tek Sütunlu İndeksler
```sql
-- Ürün adı için indeks
CREATE INDEX idx_product_name ON Product(ProductName);

-- Kategori adı için indeks
CREATE INDEX idx_category_name ON Category(CategoryName);
```

#### 3.2.2 Bileşik İndeksler
```sql
-- Ürün kategorisi ve fiyat için bileşik indeks
CREATE INDEX idx_product_category_price ON Product(CategoryID, Price);

-- Sipariş tarihi ve durumu için bileşik indeks
CREATE INDEX idx_order_date_status ON Orders(OrderDate, Status);
```

#### 3.2.3 Benzersiz İndeksler
```sql
-- Müşteri e-posta adresi için benzersiz indeks
CREATE UNIQUE INDEX idx_unique_customer_email ON Customer(Mail);
```

## 4. KISITLAMALAR (CONSTRAINTS)

### 4.1 Birincil Anahtar (Primary Key)
```sql
-- Product tablosu için birincil anahtar
ALTER TABLE Product
ADD PRIMARY KEY (ProductID);
```

### 4.2 Yabancı Anahtar (Foreign Key)
```sql
-- Product tablosu için yabancı anahtarlar
ALTER TABLE Product
ADD FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID);
```

### 4.3 Kontrol Kısıtlamaları (Check Constraints)
```sql
-- Fiyat kontrolü
ALTER TABLE Product
ADD CONSTRAINT chk_price CHECK (Price >= 0);
```

## 5. GELİŞMİŞ SORGULAR

### 5.1 Birleştirme (JOIN) Sorguları
```sql
-- Ürün ve kategorileri birleştirme
SELECT p.ProductName, c.CategoryName, p.Price
FROM Product p
JOIN Category c ON p.CategoryID = c.CategoryID;
```

### 5.2 Alt Sorgular (Subqueries)
```sql
-- Belirli bir kategorideki en pahalı ürünleri bulma
SELECT ProductName, Price
FROM Product
WHERE (CategoryID, Price) IN (
    SELECT CategoryID, MAX(Price)
    FROM Product
    GROUP BY CategoryID
);
```

### 5.3 Gruplama ve Toplama Fonksiyonları
```sql
-- Kategori bazında ortalama fiyatları hesaplama
SELECT c.CategoryName, AVG(p.Price) as AvgPrice
FROM Product p
JOIN Category c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName;
```

## 6. VERİTABANI BAKIMI

### 6.1 Yedekleme
```sql
-- Veritabanı yedekleme komutu
mysqldump -u username -p shopping_database > backup.sql
```

### 6.2 Performans İyileştirme
```sql
-- Tablo optimizasyonu
OPTIMIZE TABLE Product, Orders, Customer;
```

### 6.3 Veri Temizliği
```sql
-- 1 yıldan eski tamamlanmış siparişleri arşivleme
INSERT INTO OrdersArchive
SELECT * FROM Orders
WHERE Status = 'Delivered'
AND OrderDate < DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR);
```

---

## 📌 ÖNEMLİ NOTLAR

1. **Veri Bütünlüğü**
   - İlişkisel veritabanında veri bütünlüğü çok önemlidir
   - Kısıtlamalar ve tetikleyiciler kullanarak veri tutarlılığını sağlayın

2. **Performans**
   - Büyük tablolarda indeks kullanımı performansı önemli ölçüde artırır
   - Gereksiz indekslerden kaçının

3. **Bakım**
   - Veritabanını düzenli olarak yedekleyin
   - Performans sorunlarını izleyin ve optimize edin

4. **Güvenlik**
   - Hassas verileri şifreleyin
   - Kullanıcı yetkilerini sınırlayın 
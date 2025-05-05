# Alışveriş Veritabanı Projesi

## Proje Genel Bakış
Bu proje, bir e-ticaret platformunun çeşitli yönlerini yöneten kapsamlı bir veritabanı sistemini uygulamaktadır. Veritabanı, ürün envanteri, müşteri siparişleri, alışveriş sepetleri ve promosyon faaliyetlerini verimli bir şekilde yönetmek üzere tasarlanmıştır.

## Veritabanı Yapısı
Veritabanı, e-ticaret ekosisteminde belirli bir amaca hizmet eden 14 birbirine bağlı tablodan oluşmaktadır:

### Temel Tablolar
1. **Address (100-199)**
   - Müşteriler, üyeler ve tedarikçiler için konum bilgilerini saklar
   - Mahalle, şehir ve ülke detaylarını içerir
   - Konum bazlı aramalar için indekslerle optimize edilmiştir

2. **Category (200-299)**
   - Ürün kategorilendirmesini yönetir
   - Birden fazla satış kanalını destekler (Online, Mağaza, Her İkisi)
   - Verimli ürün organizasyonu ve filtreleme sağlar

3. **Supplier (300-399)**
   - Tedarikçi bilgilerini takip eder
   - Tedarikçi konumlarını ve iletişim detaylarını yönetir
   - Uydu dağıtım merkezlerini destekler

4. **Product (400-499)**
   - Detaylı ürün bilgilerini saklar
   - Renk, beden, malzeme ve cinsiyet gibi özellikleri içerir
   - Kategoriler ve tedarikçilerle bağlantı kurar
   - Fiyat bilgilerini doğrulama ile korur

5. **Stock (500-599)**
   - Envanter seviyelerini yönetir
   - Ürün miktarlarını takip eder
   - Zaman damgalarıyla otomatik güncellenir

### Müşteri Yönetimi
6. **Customer (600-699)**
   - Müşteri bilgilerini saklar
   - Adres detaylarıyla bağlantı kurar
   - Kayıt tarihlerini takip eder

7. **Member (700-799)**
   - Kayıtlı kullanıcı hesaplarını yönetir
   - Giriş bilgilerini saklar
   - Üyelik detaylarını takip eder

### Sipariş İşleme
8. **Orders (900-999)**
   - Sipariş yaşam döngüsünü yönetir
   - Sipariş durumunu takip eder (Beklemede, İşleniyor, Kargoda, Teslim Edildi, İptal Edildi)
   - Toplam tutarları otomatik hesaplar

9. **OrderProduct**
   - Sipariş-ürün ilişkilerini yönetir
   - Ara toplamları otomatik hesaplar
   - Miktar ve birim fiyatları yönetir

10. **Bill (1000-1099)**
    - Faturaları oluşturur
    - Ödeme yöntemlerini takip eder
    - Fatura geçmişini saklar

### Alışveriş Deneyimi
11. **Cart (1100-1199)**
    - Alışveriş sepetlerini yönetir
    - Müşteriler ve üyelerle bağlantı kurar
    - Sepet oluşturma ve güncellemeleri takip eder

12. **CartItem**
    - Sepet içeriğini saklar
    - Ürün miktarlarını yönetir
    - Ürünleri sepetlerle bağlar

### Promosyon Özellikleri
13. **DiscountCoupon (800-899)**
    - Promosyon kodlarını yönetir
    - İndirim tutarlarını takip eder
    - Kupon geçerlilik sürelerini kontrol eder

14. **MemberCoupon**
    - Üyeleri kuponlarla eşleştirir
    - Kupon kullanımını takip eder
    - Promosyon kampanyalarını yönetir

## Temel Özellikler

### Veri Bütünlüğü
- Belirli aralıklarda otomatik ID oluşturma
- Kaskat güncellemeli yabancı anahtar kısıtlamaları
- Sayısal değerler için kontrol kısıtlamaları
- E-posta adresleri ve kupon kodları için benzersiz kısıtlamalar

### Performans Optimizasyonu
- Sık aranan sütunlarda stratejik indeksleme
- Optimize edilmiş tablo ilişkileri
- Verimli veri alma desenleri

### İş Mantığı
- Otomatik sipariş toplamı hesaplama
- Envanter takibi
- Promosyon kampanyası yönetimi
- Çoklu satış kanalı desteği

## Teknik Uygulama

### Tetikleyiciler
1. **Sipariş Toplamı Güncellemeleri**
   - Aşağıdaki durumlarda otomatik olarak sipariş toplamlarını günceller:
     - Yeni ürünler eklendiğinde
     - Mevcut ürünler değiştirildiğinde
     - Ürünler kaldırıldığında

### İndeksler
- Yaygın arama desenleri için optimize edilmiş
- Sık sorgulanan sütunlarda uygulanmış
- Verimli veri alma desteği

### Kısıtlamalar
- Fiyat doğrulama (negatif olmayan değerler)
- Miktar doğrulama (pozitif değerler)
- Kupon tarih aralığı doğrulama
- Benzersiz e-posta ve kullanıcı adı zorunluluğu

## Kullanım Örnekleri

### Ürün Yönetimi
```sql
-- Yeni ürün ekleme
INSERT INTO Product (ProductName, Price, Brand, CategoryID, SupplierID)
VALUES ('Yeni Ürün', 99.99, 'MarkaAdı', 200, 300);

-- Stok güncelleme
UPDATE Stock SET Quantity = Quantity - 1 WHERE ProductID = 400;
```

### Sipariş İşleme
```sql
-- Yeni sipariş oluşturma
INSERT INTO Orders (CustomerID, MemberID)
VALUES (600, 700);

-- Siparişe ürün ekleme
INSERT INTO OrderProduct (OrderID, ProductID, Quantity, UnitPrice)
VALUES (900, 400, 1, 999.99);
```

### Müşteri Yönetimi
```sql
-- Yeni üye kaydı
INSERT INTO Member (Username, Name, Mail, AddressID)
VALUES ('yenikullanici', 'Yeni Kullanıcı', 'yeni@email.com', 100);

-- Kupon atama
INSERT INTO MemberCoupon (MemberID, CouponID)
VALUES (700, 800);
```

## Faydalar
1. **Ölçeklenebilirlik**
   - Büyüyen ürün kataloglarını yönetebilme
   - Artan müşteri tabanını destekleme
   - Büyük sipariş hacimlerini yönetebilme

2. **Güvenilirlik**
   - Veri tutarlılığını sağlama
   - Referans bütünlüğünü koruma
   - Geçersiz veri girişini önleme

3. **Performans**
   - Hızlı veri alma için optimize edilmiş
   - Verimli sorgu çalıştırma
   - Azaltılmış veritabanı yükü

4. **Esneklik**
   - Çoklu satış kanallarını destekleme
   - Farklı iş modellerine uyarlanabilme
   - Yeni özelliklerle kolay genişletilebilme

## Gelecek Geliştirmeler
1. Gelişmiş analitik entegrasyonu
2. Gerçek zamanlı envanter takibi
3. Otomatik yeniden sipariş sistemi
4. Müşteri davranış analizi
5. Kişiselleştirilmiş öneri motoru 
# Alışveriş Veritabanı Projesi

## Veritabanı Yapısı

Bu proje, aşağıdaki tablolar ve ilişkilerle bir alışveriş veritabanı sistemini uygulamaktadır:

### Tablolar ve ID'leri

1. **Address (Adres)**
   - Primary key: AddressID (100-199 arası)
   - Müşteriler, üyeler ve tedarikçiler için adres bilgilerini saklar
   - Şehir ve Ülke üzerinde indeksler hızlı arama için

2. **Category (Kategori)**
   - Primary key: CategoryID (200-299 arası)
   - Ürün kategorilerini saklar
   - Kategori adı üzerinde indeks hızlı arama için

3. **Supplier (Tedarikçi)**
   - Primary key: SupplierID (300-399 arası)
   - Foreign key: AddressID (Address tablosuna referans)
   - İsim ve E-posta üzerinde indeksler hızlı arama için

4. **Product (Ürün)**
   - Primary key: ProductID (400-499 arası)
   - Foreign keys: CategoryID (Category'e referans), SupplierID (Supplier'e referans)
   - Ürün adı, Marka ve Fiyat üzerinde indeksler hızlı arama için
   - Fiyat üzerinde kontrol kısıtlaması (>= 0 olmalı)

5. **Stock (Stok)**
   - Primary key: StockID (500-599 arası)
   - Foreign key: ProductID (Product'e referans)
   - Miktar üzerinde kontrol kısıtlaması (>= 0 olmalı)

6. **Customer (Müşteri)**
   - Primary key: CustomerID (600-699 arası)
   - Foreign key: AddressID (Address'e referans)
   - Müşteri adı üzerinde indeks hızlı arama için

7. **Member (Üye)**
   - Primary key: MemberID (700-799 arası)
   - Foreign key: AddressID (Address'e referans)
   - Kullanıcı adı ve E-posta üzerinde indeksler hızlı arama için

8. **DiscountCoupon (İndirim Kuponu)**
   - Primary key: CouponID (800-899 arası)
   - Kupon kodu ve tarihler üzerinde indeksler hızlı arama için
   - İndirim miktarı ve tarihler üzerinde kontrol kısıtlamaları

9. **Orders (Sipariş)**
   - Primary key: OrderID (900-999 arası)
   - Foreign keys: CustomerID (Customer'e referans), MemberID (Member'e referans)
   - Sipariş tarihi ve Durum üzerinde indeksler hızlı arama için

10. **Bill (Fatura)**
    - Primary key: BillID (1000-1099 arası)
    - Foreign key: OrderID (Orders'a referans)
    - Fatura numarası ve Fatura tarihi üzerinde indeksler hızlı arama için
    - Toplam tutar üzerinde kontrol kısıtlaması

11. **OrderProduct (Sipariş Ürünü)**
    - Composite primary key: (OrderID, ProductID)
    - Foreign keys: OrderID (Orders'a referans), ProductID (Product'e referans)
    - Miktar ve Birim fiyat üzerinde kontrol kısıtlamaları
    - Ara toplam hesaplaması için oluşturulmuş sütun

12. **Cart (Sepet)**
    - Primary key: CartID (1100-1199 arası)
    - Foreign keys: CustomerID (Customer'e referans), MemberID (Member'e referans)

13. **CartItem (Sepet Öğesi)**
    - Composite primary key: (CartID, ProductID)
    - Foreign keys: CartID (Cart'e referans), ProductID (Product'e referans)
    - Miktar üzerinde kontrol kısıtlaması

14. **MemberCoupon (Üye Kuponu)**
    - Composite primary key: (MemberID, CouponID)
    - Foreign keys: MemberID (Member'e referans), CouponID (DiscountCoupon'a referans)

### İndeksler

Sık aranan sütunlar üzerinde sorgu performansını artırmak için indeksler oluşturulmuştur:
- Address: Şehir, Ülke
- Category: Kategori adı
- Supplier: İsim, E-posta
- Product: Ürün adı, Marka, Fiyat
- Customer: Müşteri adı
- Member: Kullanıcı adı, E-posta
- DiscountCoupon: Kupon kodu, tarihler
- Orders: Sipariş tarihi, Durum
- Bill: Fatura numarası, Fatura tarihi

### Tetikleyiciler

Veri tutarlılığını korumak için üç tetikleyici uygulanmıştır:

1. **update_order_total**
   - OrderProduct tablosuna ekleme yapıldıktan sonra tetiklenir
   - Orders tablosundaki toplam tutarı günceller

2. **update_order_total_after_update**
   - OrderProduct tablosunda güncelleme yapıldıktan sonra tetiklenir
   - Orders tablosundaki toplam tutarı günceller

3. **update_order_total_after_delete**
   - OrderProduct tablosundan silme yapıldıktan sonra tetiklenir
   - Orders tablosundaki toplam tutarı günceller

### Kısıtlamalar

Veri bütünlüğünü sağlamak için çeşitli kısıtlamalar uygulanmıştır:
- ON UPDATE CASCADE ile yabancı anahtar kısıtlamaları
- Sayısal değerler üzerinde kontrol kısıtlamaları
- E-posta adresleri ve kupon kodları üzerinde benzersiz kısıtlamalar
- Zaman damgaları ve durum alanları için varsayılan değerler 
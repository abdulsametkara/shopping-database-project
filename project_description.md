# Shopping Database Project

## Project Overview
This project implements a comprehensive e-commerce database system that manages various aspects of an online shopping platform. The database is designed to handle product inventory, customer orders, shopping carts, and promotional activities efficiently.

## Database Structure
The database consists of 14 interconnected tables, each serving a specific purpose in the e-commerce ecosystem:

### Core Tables
1. **Address (100-199)**
   - Stores location information for customers, members, and suppliers
   - Includes neighborhood, city, and country details
   - Optimized with indexes for quick location-based searches

2. **Category (200-299)**
   - Manages product categorization
   - Supports multiple sales channels (Online, Store, Both)
   - Enables efficient product organization and filtering

3. **Supplier (300-399)**
   - Tracks vendor information
   - Manages supplier locations and contact details
   - Supports satellite distribution centers

4. **Product (400-499)**
   - Stores detailed product information
   - Includes specifications like color, size, material, and gender
   - Links to categories and suppliers
   - Maintains price information with validation

5. **Stock (500-599)**
   - Manages inventory levels
   - Tracks product quantities
   - Updates automatically with timestamps

### Customer Management
6. **Customer (600-699)**
   - Stores customer information
   - Links to address details
   - Tracks registration dates

7. **Member (700-799)**
   - Manages registered user accounts
   - Stores login credentials
   - Tracks membership details

### Order Processing
8. **Orders (900-999)**
   - Manages order lifecycle
   - Tracks order status (Pending, Processing, Shipped, Delivered, Cancelled)
   - Calculates total amounts automatically

9. **OrderProduct**
   - Handles order-item relationships
   - Calculates subtotals automatically
   - Manages quantities and unit prices

10. **Bill (1000-1099)**
    - Generates invoices
    - Tracks payment methods
    - Maintains billing history

### Shopping Experience
11. **Cart (1100-1199)**
    - Manages shopping carts
    - Links to customers and members
    - Tracks cart creation and updates

12. **CartItem**
    - Stores cart contents
    - Manages product quantities
    - Links products to carts

### Promotional Features
13. **DiscountCoupon (800-899)**
    - Manages promotional codes
    - Tracks discount amounts
    - Controls coupon validity periods

14. **MemberCoupon**
    - Links members to coupons
    - Tracks coupon usage
    - Manages promotional campaigns

## Key Features

### Data Integrity
- Automatic ID generation within specific ranges
- Foreign key constraints with cascade updates
- Check constraints for numerical values
- Unique constraints for email addresses and coupon codes

### Performance Optimization
- Strategic indexing on frequently searched columns
- Optimized table relationships
- Efficient data retrieval patterns

### Business Logic
- Automatic order total calculation
- Inventory tracking
- Promotional campaign management
- Multi-channel sales support

## Technical Implementation

### Triggers
1. **Order Total Updates**
   - Automatically updates order totals when:
     - New items are added
     - Existing items are modified
     - Items are removed

### Indexes
- Optimized for common search patterns
- Implemented on frequently queried columns
- Supports efficient data retrieval

### Constraints
- Price validation (non-negative values)
- Quantity validation (positive values)
- Date range validation for coupons
- Unique email and username enforcement

## Usage Examples

### Product Management
```sql
-- Add new product
INSERT INTO Product (ProductName, Price, Brand, CategoryID, SupplierID)
VALUES ('New Product', 99.99, 'BrandName', 200, 300);

-- Update stock
UPDATE Stock SET Quantity = Quantity - 1 WHERE ProductID = 400;
```

### Order Processing
```sql
-- Create new order
INSERT INTO Orders (CustomerID, MemberID)
VALUES (600, 700);

-- Add items to order
INSERT INTO OrderProduct (OrderID, ProductID, Quantity, UnitPrice)
VALUES (900, 400, 1, 999.99);
```

### Customer Management
```sql
-- Register new member
INSERT INTO Member (Username, Name, Mail, AddressID)
VALUES ('newuser', 'New User', 'new@email.com', 100);

-- Assign coupon
INSERT INTO MemberCoupon (MemberID, CouponID)
VALUES (700, 800);
```

## Benefits
1. **Scalability**
   - Designed to handle growing product catalogs
   - Supports increasing customer base
   - Manages large order volumes

2. **Reliability**
   - Ensures data consistency
   - Maintains referential integrity
   - Prevents invalid data entry

3. **Performance**
   - Optimized for quick data retrieval
   - Efficient query execution
   - Reduced database load

4. **Flexibility**
   - Supports multiple sales channels
   - Adaptable to different business models
   - Easy to extend with new features

## Future Enhancements
1. Advanced analytics integration
2. Real-time inventory tracking
3. Automated reordering system
4. Customer behavior analysis
5. Personalized recommendation engine 
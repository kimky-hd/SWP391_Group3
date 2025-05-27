-- Create Orders table
CREATE TABLE Orders (
    orderId INT PRIMARY KEY AUTO_INCREMENT,
    fullName VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    district VARCHAR(100) NOT NULL,
    ward VARCHAR(100) NOT NULL,
    paymentMethod VARCHAR(50) NOT NULL,
    totalAmount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    orderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create OrderDetails table
CREATE TABLE OrderDetails (
    orderDetailId INT PRIMARY KEY AUTO_INCREMENT,
    orderId INT NOT NULL,
    productId INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (orderId) REFERENCES Orders(orderId),
    FOREIGN KEY (productId) REFERENCES Product(productID)
);

-- Create indexes for better performance
CREATE INDEX idx_orders_status ON Orders(status);
CREATE INDEX idx_orders_email ON Orders(email);
CREATE INDEX idx_orderdetails_orderid ON OrderDetails(orderId);
CREATE INDEX idx_orderdetails_productid ON OrderDetails(productId);
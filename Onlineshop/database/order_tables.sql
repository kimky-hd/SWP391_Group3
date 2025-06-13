-- Create Orders table
CREATE TABLE Orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    account_id INT NOT NULL,
    order_date DATETIME NOT NULL,
    full_name NVARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    address NVARCHAR(255) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (account_id) REFERENCES Account(account_id)
);

-- Create index for Orders table
CREATE INDEX idx_orders_account ON Orders(account_id);
CREATE INDEX idx_orders_date ON Orders(order_date);
CREATE INDEX idx_orders_status ON Orders(status);

-- Create OrderDetails table
CREATE TABLE OrderDetails (
    order_detail_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Create index for OrderDetails table
CREATE INDEX idx_orderdetails_order ON OrderDetails(order_id);
CREATE INDEX idx_orderdetails_product ON OrderDetails(product_id);
CREATE database ecommerce;
USE ecommerce;
                
CREATE TABLE client(
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Full_name VARCHAR(45) not null,
    CPF CHAR(11),
    CNPJ CHAR(14),
    date_of_birth DATE,
    customer_type ENUM('PF','PJ') not null,
    state CHAR(20),
    city VARCHAR(30) not null,
    district VARCHAR(30) not null,
    CEP CHAR(8) not null,
    street VARCHAR(30),
    number VARCHAR(5) not null,
    complement VARCHAR(30),

    CONSTRAINT unique_cpf_client UNIQUE (CPF),
    CONSTRAINT unique_cnpj_client UNIQUE (CNPJ),

    CONSTRAINT chk_tipo_cliente 
    CHECK (
        (customer_type = 'PF' AND CPF IS NOT NULL AND CNPJ IS NULL)
        OR
        (customer_type = 'PJ' AND CNPJ IS NOT NULL AND CPF IS NULL)
    )
);

CREATE TABLE product(
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(15) not null,
    classification_kids boolean default false,
    category enum('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') not null,
    rating float default 0,
    size varchar(10)
);

CREATE TABLE payment_method(
    idPaymentMethod INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL
);

INSERT INTO payment_method (name) VALUES
('Boleto'),
('Cartão de Crédito'),
('Cartão de Débito'),
('PIX');

CREATE TABLE orders(
   idOrder int auto_increment primary key,
   idOrderClient int not null,
   orderStatus enum('Cancelado', 'Confirmado', 'Em processamento') default 'Em processamento',
   orderDescription varchar(255),
   Minimum_Freight float default 10,
   paymentCash boolean default false,
   constraint fk_order_client foreign key (idOrderClient) references client(idClient)
              on update cascade
);

CREATE TABLE payments(
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT NOT NULL,
    idPaymentMethod INT NOT NULL,
    value DECIMAL(10,2) NOT NULL,

    CONSTRAINT chk_value_positive 
    CHECK (value > 0),

    CONSTRAINT fk_payment_order 
    FOREIGN KEY (idOrder) REFERENCES orders(idOrder),

    CONSTRAINT fk_payment_method 
    FOREIGN KEY (idPaymentMethod) REFERENCES payment_method(idPaymentMethod)
);

CREATE TABLE delivery(
    idDelivery INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT NOT NULL UNIQUE,
    trackingCode VARCHAR(50),
    status ENUM('Pendente', 'Enviado', 'Em trânsito', 'Entregue', 'Atrasado') DEFAULT 'Pendente',
    shippingDate DATE,
    deliveryDate DATE,

    CONSTRAINT fk_delivery_order FOREIGN KEY (idOrder) REFERENCES orders(idOrder)
);

CREATE TABLE productStorage(
   idProdStorage int auto_increment primary key,
   storageLocation varchar(255),
   quantity INT DEFAULT 0 CHECK (quantity >= 0)
);

CREATE TABLE supplier(
   idSupplier int auto_increment primary key,
   SocialName varchar(255) not null,
   CNPJ char(14) not null,
   contact char(12) not null,
   constraint unique_supplier unique (CNPJ)
);

CREATE TABLE productSupplier(
    idPsSupplier INT,
    idPsProduct INT,
    PRIMARY KEY (idPsSupplier, idPsProduct),
    CONSTRAINT fk_product_supplier_supplier 
        FOREIGN KEY (idPsSupplier) REFERENCES supplier(idSupplier),
    CONSTRAINT fk_product_supplier_product 
        FOREIGN KEY (idPsProduct) REFERENCES product(idProduct)
);

INSERT INTO productSupplier (idPsSupplier, idPsProduct)
VALUES
(3,1),
(1,2),
(1,3),
(1,4),
(1,5),
(2,6);

CREATE TABLE seller(
   idSeller INT AUTO_INCREMENT PRIMARY KEY,
   SocialName VARCHAR(255) NOT NULL,
   TradeName VARCHAR(255),
   CNPJ CHAR(14),
   CPF CHAR(11),
   seller_type ENUM('PF','PJ') NOT NULL,
   location VARCHAR(255),
   contact CHAR(12) NOT NULL,

   CONSTRAINT unique_cnpj_seller UNIQUE (CNPJ),
   CONSTRAINT unique_cpf_seller UNIQUE (CPF),

   CONSTRAINT chk_tipo_seller
   CHECK (
        (seller_type = 'PF' AND CPF IS NOT NULL AND CNPJ IS NULL)
        OR
        (seller_type = 'PJ' AND CNPJ IS NOT NULL AND CPF IS NULL)
   )
);
   
CREATE TABLE productSeller(
	idPseller int,
    idProduct int,
    prodQuantity int default 1,
    primary key (idPseller, idProduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idProduct) references product(idProduct)
 );  
 
CREATE TABLE productOrder(
    idPOproduct INT,
    idPOorder INT,
    poQuantity INT DEFAULT 1,
    poStatus ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível',
    PRIMARY KEY (idPOproduct, idPOorder),
    CONSTRAINT fk_productorder_product FOREIGN KEY (idPOproduct) REFERENCES product(idProduct),
    CONSTRAINT fk_productorder_order FOREIGN KEY (idPOorder) REFERENCES orders(idOrder)
);
 
CREATE TABLE storageLocation(
    idLproduct INT,
    idLstorage INT,
    location VARCHAR(255) NOT NULL,
    PRIMARY KEY (idLproduct, idLstorage),
    CONSTRAINT fk_storage_location_product FOREIGN KEY (idLproduct) REFERENCES product(idProduct),
    CONSTRAINT fk_storage_location_storage FOREIGN KEY (idLstorage) REFERENCES productStorage(idProdStorage)
);
 
-- Relação de clientes e pedidos

SELECT
    c.idClient,
    c.Full_name AS cliente,
    o.idOrder,
    o.orderStatus AS status_pedido,
    o.orderDescription AS descricao_pedido,
    o.Minimum_Freight AS frete_minimo
FROM client c
INNER JOIN orders o
    ON c.idClient = o.idOrderClient
ORDER BY c.Full_name, o.idOrder;

-- Relação de produtos, fornecedores e estoques

SELECT 
    p.Pname AS produto,
    s.SocialName AS fornecedor,
    ps.storageLocation AS estoque,
    ps.quantity AS quantidade
FROM product p
JOIN productSupplier psp 
    ON p.idProduct = psp.idPsProduct
JOIN supplier s 
    ON s.idSupplier = psp.idPsSupplier
LEFT JOIN storageLocation sl 
    ON p.idProduct = sl.idLproduct
LEFT JOIN productStorage ps 
    ON sl.idLstorage = ps.idProdStorage
ORDER BY p.Pname;

-- Relação de nomes dos fornecedores e nomes dos produtos

SELECT 
    s.SocialName AS fornecedor,
    p.Pname AS produto
FROM supplier s
JOIN productSupplier ps 
    ON s.idSupplier = ps.idPsSupplier
JOIN product p 
    ON p.idProduct = ps.idPsProduct
ORDER BY s.SocialName, p.Pname;

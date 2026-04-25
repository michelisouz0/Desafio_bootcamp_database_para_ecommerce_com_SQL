USE ecommerce;

SHOW TABLES;

-- CLIENT
INSERT INTO client
(Full_name, CPF, CNPJ, date_of_birth, customer_type, state, city, district, CEP, street, number, complement)
VALUES
('Maria Silva Flor', '12345678910', NULL, '2002-05-15', 'PF', 'SP', 'São Paulo', 'Taubaté', '12345678', 'Rua Silva de Prata', '154', 'Av. Brasil'),
('José Neto Sebastião', '45236879123', NULL, '1998-04-03', 'PF', 'RJ', 'Rio de Janeiro', 'Liberdade', '25639874', 'Rua Carioca', '45', 'Praia da Tijuca'),
('Roberto Justus', NULL, '12364875210258', '1955-01-20', 'PJ', 'SP', 'São Paulo', 'Alphaville', '25687495', 'Rua Times Square', '254', NULL),
('Ana Hickmann', NULL, '15824965235124', '1985-07-23', 'PJ', 'SP', 'São Paulo', 'Alphaville', '25687496', 'Rua Times Square', '1202', NULL);

SELECT * FROM client;

-- PRODUCT
INSERT INTO product 
(Pname, classification_kids, category, rating, size)
VALUES
('Fone de Ouvido', FALSE, 'Eletrônico', 4, NULL),
('Boneca Barbie', TRUE, 'Brinquedos', 3, NULL),
('Sofá Retrátil', FALSE, 'Móveis', 4, '3x57x80'),
('Farinha Arroz', FALSE, 'Alimentos', 5, NULL),
('Body Carters', TRUE, 'Vestimenta', 4, NULL),
('Microfone Vedo', FALSE, 'Eletrônico', 4, NULL);

SELECT * FROM product;

-- ORDERS
INSERT INTO orders 
(idOrderClient, orderStatus, orderDescription, Minimum_Freight, paymentCash)
VALUES
(1, DEFAULT, 'Compra via aplicativo', DEFAULT, FALSE),
(2, DEFAULT, 'Compra via aplicativo', 50.00, FALSE),
(3, 'Confirmado','Compra via web site' , DEFAULT, FALSE),
(4, DEFAULT, 'Compra via web site', 150.00, FALSE);

SELECT * FROM orders;

-- PRODUCT ORDER
INSERT INTO productOrder 
(idPOproduct, idPOorder, poQuantity, poStatus) 
VALUES
(1, 1, 2, DEFAULT),
(2, 1, 1, DEFAULT),
(3, 2, 1, DEFAULT);

SELECT * FROM productOrder;

-- PAYMENTS
INSERT INTO payments 
(idOrder, idPaymentMethod, value)
VALUES
(1, 4, 199.90),   -- PIX
(2, 3, 250.00),   -- Cartão de Débito
(3, 2, 150.00),   -- Cartão de Crédito
(4, 1, 450.00);   -- Boleto

SELECT * FROM payments;

-- DELIVERY
INSERT INTO delivery 
(idOrder, trackingCode, status, shippingDate, deliveryDate)
VALUES
(1, 'BR123456789SP', 'Pendente', NULL, NULL),
(2, 'BR987654321SP', 'Pendente', NULL, NULL),
(3, 'BR111222333SP', 'Pendente', NULL, NULL),
(4, 'BR111222344SP', 'Pendente', NULL, NULL);

SELECT * FROM delivery;

-- PRODUCT STORAGE
INSERT INTO productStorage 
(storageLocation, quantity) 
VALUES
('Rio de Janeiro', 1000),
('Rio de Janeiro', 500),
('São Paulo', 10),
('São Paulo', 100),
('São Paulo', 10),
('Rio de Janeiro', 60);

SELECT * FROM productStorage;

-- STORAGE LOCATION
INSERT INTO storageLocation 
(idLproduct, idLstorage, location)
VALUES
(1, 2, 'RJ'),
(2, 6, 'RJ'),
(3, 1, 'RJ'),
(4, 3, 'SP'),
(5, 4, 'SP'),
(6, 5, 'SP');

update storageLocation set location = 'RJ' Where idLproduct  = '2';

SELECT * FROM storageLocation;

-- SUPPLIER
INSERT INTO supplier 
(SocialName, CNPJ, contact)
VALUES
('Almeida e Filhos', '14256859745214', '11941256849'),
('Eletrônicos Silva', '52684785698452', '11915246856'),
('Eletrônicos Valma', '25684593254841', '21948563248');

SELECT * FROM supplier;

-- SELLER
INSERT INTO seller 
(SocialName, TradeName, CNPJ, CPF, seller_type, location, contact)
VALUES
('Tech Eletronics', NULL, '14523658974523', NULL, 'PJ', 'São Paulo', '11925489657'),
('Boutique Show', NULL, NULL, '45245236589', 'PF', 'Rio de Janeiro', '21945896523'),
('Kids World', NULL, '14562365895641', NULL, 'PJ', 'São Paulo', '11945698745');

SELECT * FROM seller;

-- PRODUCT SELLER
INSERT INTO productSeller 
(idPseller, idProduct, prodQuantity)
VALUES
(1, 1, 500),
(1, 2, 400),
(2, 4, 633),
(3, 3, 5),
(2, 5, 10);

SELECT * FROM productSeller;



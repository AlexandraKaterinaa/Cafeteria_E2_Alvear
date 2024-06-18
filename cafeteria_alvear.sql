USE starbucks;

insert into clientes (first_name, last_name, mail, phone_number, age) values 
('alexandra','urra','alexandra.urra@gmail.com', 999813309, 29),
('ana','natera','anatera@gmail.com', 992345677, 34),
('julia','balart','jbalart@gmail.com', 998234734, 30),
('alejandro','drago','adrago@gmail.com', 994574568, 30),
('jorge','rojas','jorge.rojas@gmail.com', 988764457, 24),
('sofia','gonzales','sgonzales@gmail.com', 99284439, 26),
('alejandro','díaz','adiaz@gmail.com', 99374467, 24),
('lorena','urra','lore.urra@gmail.com', 99872246, 28),
('manuel','quezada','urra1957@gmail.com', 992240147, 62),
('angelica','arenas','aarenas@gmail.com', 99233356, 28)
;

insert into productos (product_name, product_category, due_date, description) values 
('nombre 1','categoria 1','2024-08-13','descripcion 1'),
('nombre 2','categoria 2','2024-09-13','descripcion 2'),
('nombre 3','categoria 5','2024-09-23','descripcion 3'),
('nombre 4','categoria 1','2024-08-03','descripcion 4'),
('nombre 5','categoria 6','2024-09-01','descripcion 5'),
('nombre 6','categoria 3','2024-10-13','descripcion 6'),
('nombre 7','categoria 3','2024-11-13','descripcion 7'),
('nombre 8','categoria 2','2024-12-13','descripcion 8'),
('nombre 9','categoria 5','2024-09-12','descripcion 9'),
('nombre 10','categoria 6','2024-11-13','descripcion 10'),
('nombre 11','categoria 4','2024-10-20','descripcion 11')
;

insert into proveedores (first_name, phone_number, mail, id_input, category_supplier) values 
('nombre P1', 99999991, 'nombrep1@gmail.com', 1111, 'ci1'),
('nombre P2', 99999992, 'nombrep2@gmail.com', 1112, 'ci2'),
('nombre P3', 99999993, 'nombrep3@gmail.com', 1113, 'ci3'),
('nombre P4', 99999994, 'nombrep4@gmail.com', 1114, 'ci4'),
('nombre P5', 99999995, 'nombrep5@gmail.com', 1115, 'ci5'),
('nombre P6', 99999996, 'nombrep6@gmail.com', 1116, 'ci6'),
('nombre P7', 99999997, 'nombrep7@gmail.com', 1117, 'ci7'),
('nombre P8', 99999998, 'nombrep8@gmail.com', 1118, 'ci8'),
('nombre P9', 99999999, 'nombrep9@gmail.com', 1119, 'ci9'),
('nombre P10', 99999911, 'nombrep10@gmail.com', 1120, 'ci10')
;

insert into ventas (price, total_price, product_quantity, sku, id_customer, id_store, product_category, product_name, fecha_venta) values

( 2000, 6000, 3, 1, 1, 1, 'categoria 1', 'nombre 1', '2024-06-14'),
( 1000, 4000, 4, 2, 2, 1, 'categoria 2', 'nombre 2','2024-06-10'),
( 2000, 2000, 1, 1, 1, 2, 'categoria 1', 'nombre 1','2024-06-14'),
( 4000, 8000, 2, 3, 4, 2, 'categoria 3', 'nombre 3', '2024-06-08'),
( 5000, 5000, 1, 4, 6, 2, 'categoria 4', 'nombre 4','2024-06-09'),
( 6000, 6000, 1, 5, 3, 1, 'categoria 5', 'nombre 5','2024-06-04'),
( 7000, 14000, 2, 6, 7, 2, 'categoria 6', 'nombre 6','2024-06-20'),
( 3000, 9000, 3, 7, 7, 1, 'categoria 7', 'nombre 7','2024-06-12'),
( 2000, 6000, 3, 1, 7, 2, 'categoria 1', 'nombre 1','2024-06-12'),
( 1000, 6000, 6, 2, 9, 1, 'categoria 2', 'nombre 2','2024-06-10')
;


insert into sucursales (location, transaction_id, id_workers, product_name, supplies, promotion) values 

('ciudad 1', 1, 1, 'nombre 1', 'insumo 1', 2),
('ciudad 2', 3, 2, 'nombre 3', 'insumo 2', 1),
('ciudad 1', 5, 1, 'nombre 2', 'insumo 3', 2),
('ciudad 2', 2, 2, 'nombre 4', 'insumo 4', 3)
;

SELECT *
FROM sucursales
;

select *
from ventas
;

-- Aquí encontramos las vistas -- 
create or replace view view_most_selled_product as 
select product_name, product_quantity , fecha_venta
from ventas
where product_quantity = (select max(product_quantity) from ventas)
;


select *
from view_most_selled_product
;

create or replace view sales_by_product_category as
select count(transaction_id), product_category
from ventas
group by product_category
;

select *
from sales_by_product_category
;

create or replace view store_most_sales as
select transaction_id, id_store
from sucursales
where transaction_id = (select max(transaction_id)from sucursales)
;


select *
from store_most_sales
;

-- Aquí vienen las funciones -- 

DELIMITER //
CREATE FUNCTION `total_ventas`() RETURNS INT
DETERMINISTIC
BEGIN 
     DECLARE totalventas INT;
     SELECT sum(total_price) INTO totalventas FROM ventas;
     RETURN totalventas;
END//

select total_ventas ();


DELIMITER //
CREATE FUNCTION `sucursal_por_ciudad`(ciudad varchar (20)) RETURNS INT
DETERMINISTIC
BEGIN 
     DECLARE sucursalesporciudad INT;
     SELECT count(id_store) INTO sucursalesporciudad FROM sucursales
     where location = ciudad;
     RETURN sucursalesporciudad;
END//

select sucursal_por_ciudad('ciudad 1');

-- Aquí se encuentran las SP -- 

drop procedure sp_obtenerproductos
DELIMITER //
CREATE PROCEDURE `sp_obtenerproductos` ()
BEGIN
SELECT * FROM productos
order by due_date asc;
END //

call sp_obtenerproductos ();


drop procedure sp_borrarsucursal;
DELIMITER //
CREATE PROCEDURE `sp_borrarproveedores` (in idproveedor INT)
BEGIN
delete from proveedores where id_proveedor = idproveedor;
END //


call sp_borrarproveedores (1);

select * from proveedores

-- Aquí encontramos los triggers -- 


DROP TRIGGER `insertar_sucursales`;


CREATE TRIGGER `insertar_sucursales`
AFTER INSERT ON `sucursales`
FOR EACH ROW
INSERT INTO `sucursales` (id_store, location, transaction_id, id_workers, product_name, supplies, promotion)
VALUES (new.id_store, new.location, new.transaction_id, new.id_workers, new.product_name, new.supplies, new.promotion)


drop trigger `borrar_sucursales`;

CREATE TRIGGER `borrar_sucursales`
AFTER DELETE ON `sucursales`
FOR EACH ROW
INSERT INTO `sucursales` (id_store, location, transaction_id, id_workers, product_name, supplies, promotion)
VALUES (old.id_store, old.location, old.transaction_id, old.id_workers, old.product_name, old.supplies, old.promotion)


insert into sucursales (location, transaction_id, id_workers, product_name, supplies, promotion) values 

('ciudad 5', 1, 1, 'nombre 1', 'insumo 1', 2);

SELECT *
FROM sucursales
;


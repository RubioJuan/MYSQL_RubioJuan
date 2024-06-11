-- ###################
-- ### EJERCICIO 1 ###
-- ###################

-- Creación de la base de datos "tienda"
CREATE DATABASE tienda;

-- Usar base de datos "tienda"
USE tienda;

-- Crear tabla fabricante
CREATE TABLE fabricante(
id int auto_increment primary key,
nombre varchar(100)
);

-- Mostrar tablas
show tables;

-- Crear tabla "producto"
CREATE TABLE producto(
id int auto_increment primary key,
nombre varchar(100),
precio decimal(10,2),
id_fabricante int,
foreign key (id_fabricante) references fabricante(id)
);

-- Insertar información a fabricante
insert into fabricante values(1, "Nike");
insert into fabricante values(2, "Adidas");
insert into fabricante values(3, "Puma");
insert into fabricante values(4, "Reebok");
insert into fabricante values(5, "New balance");
insert into fabricante values(6, "Converse");
insert into fabricante values(7, "Vans");
insert into fabricante values(8, "Under Armour");
insert into fabricante values(9, "ASICS");
insert into fabricante values(10, "Skechers");

-- insertar productos a la tabla
insert into producto values (11, "Nike Air Force 1", 90, 1);
insert into producto values (12, "Adidas Ultraboost", 180, 2);
insert into producto values (13, "Puma Suede Classic", 65, 3);
insert into producto values (14, "Reebok Classic Leather", 75, 4);
insert into producto values (15, "New Balance 574", 80, 5);
insert into producto values (16, "Converse Chuck Taylor All Star", 55, 6);
insert into producto values (17, "Vans Old Skool", 60, 7);
insert into producto values (18, "Under Armour Charged Assert 8", 70, 8);
insert into producto values (19, "ASICS Gel-Kayano 27 ", 160, 9);
insert into producto values (20, "Skechers Go Walk Evolution", 60, 10);

-- revisar datos creados de x tabla
select * from fabricante;

-- revisar datos creados de x tabla con dato especifico
select * from fabricante where id=2;

-- revisar x columna de los datos creados de y tabla
select nombre from producto;

-- revisar x & y columna de los datos creados de z tabla
select id, nombre from producto;

-- Actualizar dato de x columna
update producto set nombre="Campuslands" where id=10;

select * from producto;

-- Actualizar todas las filas a un nuevo nombre (No funciona en workbench)
update producto set nombre="Campuslands";

-- Eliminar todos los datos de una tabla 
delete from producto;

truncate producto;

select * from producto;

-- Desarrollado por Juan Felipe Rubio Sanabria / ID.1.146.334.004
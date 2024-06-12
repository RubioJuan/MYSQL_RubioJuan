-- #####################
-- ###   DÍA  # 3    ###
-- #####################

create database dia3;

use dia3;

-- Creando tanla de Gama Producto
create table gama_producto(
	gama VARCHAR(50) primary key,
    descripcion_texto TEXT,
    descripcion_html TEXT,
    imagen VARCHAR(256)
);

drop table gama_producto;

-- Crear tabla de producto
create table producto (
	codigo_producto varchar(15) primary key,
    nombre varchar(70) not null,
    gama varchar(50) not null,
    dimensiones varchar(25),
    proveedor varchar(50),
    descripcion TEXT,
    cantidad_en_stock SMALLINT(6) not null,
    precio_venta DECIMAL(15,2) not null,
    precio_proveedor DECIMAL(15,2),
    foreign key(gama) references gama_producto(gama)
);

-- alter table producto modify column precio_venta DECIMAL(15,2) not null;
-- alter table producto modify column precio_proveedor DECIMAL(15,2) not null;

show tables;

-- Crear tabla de detalle pedido
create table detalle_pedido(
	codigo_pedido int(11),
    codigo_producto varchar(15),
    cantidad int(11) not null,
    precio_unidad DECIMAL(15,2) not null,
    numero_linea SMALLINT(6) not null,
    foreign key (codigo_producto) references producto (codigo_producto),
    foreign key(codigo_pedido) references pedido (codigo_pedido)
);

-- alter table detalle_pedido modify column precio_unidad DECIMAL(15,2) not null;

drop table detalle_pedido;
drop table producto;

create table pedido (
	codigo_pedido int(11) primary key,
    fecha_pedido DATE not null,
    fecha_esparada DATE not null,
    fecha_entrega DATE,
    estado VARCHAR(15) not null,
    comentarios TEXT,
    codigo_cliente int(11) not null,
    foreign key(codigo_cliente) references cliente(codigo_cliente)
);

create table cliente(
	codigo_cliente int(11) primary key,
    nombre_cliente VARCHAR(50) not null,
    nombre_contacto VARCHAR(30),
    apellido_contacto VARCHAR(30),
    telefono VARCHAR(15) not null,
    fax VARCHAR(15) not null,
    linea_direccion1 VARCHAR(50) not null,
    linea_direccion2 VARCHAR(50),
    ciudad VARCHAR(50) not null,
    region VARCHAR(50),
    pais VARCHAR(50),
    codigo_postal VARCHAR(10),
    codigo_empleado_rep_ventas INT(11),
    limite_credito DECIMAL (15,2),
    foreign key(codigo_empleado_rep_ventas) references empleado(codigo_empleado)
);

-- alter table cliente modify column limite_credito DECIMAL(15,2);

-- Creando tabla de empleado
create table empleado(
	codigo_empleado INT(11) primary key,
    nombre VARCHAR(50) not null,
    apellido1 VARCHAR(50) not null,
    apellido2 VARCHAR(50),
    extension VARCHAR(10) not null,
    email VARCHAR(100) not null,
    codigo_oficina VARCHAR(10) not null,
    codigo_jefe INT(11),
    puesto VARCHAR(50),
    foreign key (codigo_oficina) references oficina(codigo_oficina),
    foreign key (codigo_jefe) references empleado(codigo_empleado)
);

-- alter table empleado modify column email VARCHAR(100);

SELECT * FROM gama_producto;

-- Crear tabla de oficina
create table oficina(
	codigo_oficina VARCHAR(10) primary key,
    ciudad VARCHAR(30) not null,
    pais VARCHAR(50) not null,
    region VARCHAR(50),
    codigo_postal VARCHAR(10) not null,
    telefono VARCHAR(20) not null,
    linea_direccion1 VARCHAR(50) not null,
    linea_direccion2 VARCHAR(50)
);

-- Crear tabla de pago
create table pago(
	codigo_cliente INT(11),
    forma_pago VARCHAR(40) not null,
    id_transaccion VARCHAR(50) primary key,
    fecha_pago DATE not null,
    total DECIMAL (15,2) not null,
    foreign key (codigo_cliente) references cliente(codigo_cliente)
);
-- alter table pago modify column total DECIMAL(15,2) not null;

show tables;

select codigo_cliente from pago;
select nombre from producto where nombre = 'peral';

-- Desarrollado por Juan Felipe Rubio Sanabria / ID.1.146.334.004
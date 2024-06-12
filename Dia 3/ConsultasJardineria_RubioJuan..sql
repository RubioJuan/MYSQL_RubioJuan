use dia3;

-- Consultas

-- **************************************
-- *******    Sobre una tabla  **********
-- **************************************

-- 1. Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.
SELECT codigo_oficina, ciudad FROM oficina;

-- 2. Devuelve un listado con la ciudad y el teléfono de las oficinas de España.
SELECT ciudad, telefono FROM oficina WHERE pais = 'España';

-- 3. Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un código de jefe igual a 7.
SELECT nombre, apellido1, apellido2, email FROM empleado WHERE codigo_jefe = 7;

-- 4. Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa.
SELECT puesto, nombre, apellido1, apellido2, email FROM empleado WHERE codigo_jefe IS NULL;

-- 5. Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean representantes de ventas.
SELECT nombre, apellido1, apellido2, puesto FROM empleado WHERE puesto != 'Representante de Ventas';

-- 6. Devuelve un listado con el nombre de los todos los clientes españoles.
SELECT nombre_cliente FROM cliente WHERE pais = 'España';

-- 7. Devuelve un listado con los distintos estados por los que puede pasar un pedido.
SELECT DISTINCT estado FROM pedido;

-- 8. Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago en 2008.
	-- Utilizando la función YEAR de MySQL:
		SELECT DISTINCT codigo_cliente FROM pago WHERE YEAR(fecha_pago) = 2008;

	-- Utilizando la función DATE_FORMAT de MySQL:
		SELECT DISTINCT codigo_cliente FROM pago WHERE DATE_FORMAT(fecha_pago, '%Y') = '2008';

	-- Sin utilizar ninguna de las funciones anteriores:
		SELECT DISTINCT codigo_cliente FROM pago WHERE fecha_pago BETWEEN '2008-01-01' AND '2008-12-31';

-- 9. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos que no han sido entregados a tiempo.
SELECT codigo_pedido, codigo_cliente, fecha_esparada, fecha_entrega FROM pedido WHERE fecha_entrega > fecha_esparada;

-- 10. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha esperada.

	-- Utilizando la función ADDDATE de MySQL.
		SELECT codigo_pedido, codigo_cliente, fecha_esparada, fecha_entrega FROM pedido WHERE fecha_entrega <= ADDDATE(fecha_esparada, INTERVAL -2 DAY);

	-- Utilizando la función DATEDIFF de MySQL.
		SELECT codigo_pedido, codigo_cliente, fecha_esparada, fecha_entrega FROM pedido WHERE DATEDIFF(fecha_esparada, fecha_entrega) >= 2;

	-- Usando el operador de suma o resta.
		SELECT codigo_pedido, codigo_cliente, fecha_esparada, fecha_entrega FROM pedido WHERE fecha_entrega <= (fecha_esparada - INTERVAL 2 DAY);

-- 11. Devuelve un listado de todos los pedidos que fueron en 2009.
SELECT * FROM pedido WHERE YEAR(fecha_pedido) = 2009;

-- 12. Devuelve un listado de todos los pedidos que han sido  en el mes de enero de cualquier año.
SELECT * FROM pedido WHERE MONTH(fecha_pedido) = 1;

-- 13. Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal. Ordene el resultado de mayor a menor.
SELECT * FROM pago WHERE YEAR(fecha_pago) = 2008 AND forma_pago = 'Paypal' ORDER BY total DESC;

-- 14. Devuelve un listado con todas las formas de pago que aparecen en la tabla pago. Tenga en cuenta que no deben aparecer formas de pago repetidas.
SELECT DISTINCT forma_pago FROM pago;

-- 15. Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales y que tienen más de 100 unidades en stock. El listado deberá estar ordenado por su precio de venta, mostrando en primer lugar los de mayor precio.
SELECT * FROM producto WHERE gama = 'Ornamentales' AND cantidad_en_stock > 100 ORDER BY precio_venta DESC;

-- 16. Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y cuyo representante de ventas tenga el código de empleado 11 o 30.
SELECT * FROM cliente WHERE ciudad = 'Madrid' AND codigo_empleado_rep_ventas IN (11, 30);



-- **************************************
-- ********    Multi tablas    **********
-- **************************************

-- 17. Obtén un listado con el nombre de cada cliente y el nombre y apellido de su representante de ventas.

-- Usando INNER JOIN:
SELECT cliente.nombre_cliente, empleado.nombre, empleado.apellido1, empleado.apellido2 FROM cliente INNER JOIN empleado ON cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado;

-- Usando NATURAL JOIN:
-- (Esto requiere que las tablas cliente y empleado compartan una columna con el mismo nombre y estructura, como codigo_empleado_rep_ventas y codigo_empleado)
SELECT nombre_cliente, nombre, apellido1, apellido2 FROM cliente NATURAL JOIN empleado;

-- 18. Nombre de los clientes que hayan realizado pagos junto con el nombre de sus representantes de ventas
-- Usando INNER JOIN:
SELECT cliente.nombre_cliente, empleado.nombre, empleado.apellido1, empleado.apellido2 FROM pago INNER JOIN cliente ON pago.codigo_cliente = cliente.codigo_cliente INNER JOIN empleado ON cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado;

-- Usando NATURAL JOIN:
SELECT nombre_cliente, nombre, apellido1, apellido2 FROM pago NATURAL JOIN cliente NATURAL JOIN empleado;

-- 19. Nombre de los clientes que han hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante
-- Usando INNER JOIN:
SELECT cliente.nombre_cliente, empleado.nombre, empleado.apellido1, empleado.apellido2, oficina.ciudad FROM pago
INNER JOIN cliente ON pago.codigo_cliente = cliente.codigo_cliente
INNER JOIN empleado ON cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado
INNER JOIN oficina ON empleado.codigo_oficina = oficina.codigo_oficina;

-- Usando NATURAL JOIN:
SELECT nombre_cliente, nombre, apellido1, apellido2, ciudad FROM pago
NATURAL JOIN cliente
NATURAL JOIN empleado
NATURAL JOIN oficina;

-- 20. Lista la dirección de las oficinas que tengan clientes en Fuenlabrada
-- Usando INNER JOIN:
SELECT DISTINCT oficina.linea_direccion1, oficina.linea_direccion2 FROM cliente
INNER JOIN oficina ON cliente.codigo_empleado_rep_ventas = oficina.codigo_oficina WHERE cliente.ciudad = 'Fuenlabrada';

-- Usando NATURAL JOIN:
SELECT DISTINCT linea_direccion1, linea_direccion2 FROM cliente NATURAL JOIN oficina WHERE ciudad = 'Fuenlabrada';


-- 21. Nombre de los clientes y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante
-- Usando INNER JOIN:
SELECT cliente.nombre_cliente, empleado.nombre, empleado.apellido1, empleado.apellido2, oficina.ciudad FROM cliente
INNER JOIN empleado ON cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado
INNER JOIN oficina ON empleado.codigo_oficina = oficina.codigo_oficina;

-- Usando NATURAL JOIN:
SELECT nombre_cliente, nombre, apellido1, apellido2, ciudad FROM cliente
NATURAL JOIN empleado
NATURAL JOIN oficina;

-- 22. Listado con el nombre de los empleados junto con el nombre de sus jefes
-- Usando INNER JOIN:
SELECT e1.nombre AS empleado_nombre, e1.apellido1 AS empleado_apellido1, e1.apellido2 AS empleado_apellido2, e2.nombre AS jefe_nombre, e2.apellido1 AS jefe_apellido1, e2.apellido2 AS jefe_apellido2
FROM empleado e1
INNER JOIN empleado e2 ON e1.codigo_jefe = e2.codigo_empleado;

-- Usando NATURAL JOIN:
SELECT e1.nombre AS empleado_nombre, e1.apellido1 AS empleado_apellido1, e1.apellido2 AS empleado_apellido2, e2.nombre AS jefe_nombre, e2.apellido1 AS jefe_apellido1, e2.apellido2 AS jefe_apellido2
FROM empleado e1
NATURAL JOIN empleado e2 WHERE e1.codigo_jefe = e2.codigo_empleado;

-- 23. Listado que muestre el nombre de cada empleado, el nombre de su jefe y el nombre del jefe de sus jefe
-- Usando INNER JOIN:

SELECT e1.nombre AS empleado_nombre, e1.apellido1 AS empleado_apellido1, e1.apellido2 AS empleado_apellido2,
       e2.nombre AS jefe_nombre, e2.apellido1 AS jefe_apellido1, e2.apellido2 AS jefe_apellido2,
       e3.nombre AS jefe_de_jefe_nombre, e3.apellido1 AS jefe_de_jefe_apellido1, e3.apellido2 AS jefe_de_jefe_apellido2
FROM empleado e1
INNER JOIN empleado e2 ON e1.codigo_jefe = e2.codigo_empleado
INNER JOIN empleado e3 ON e2.codigo_jefe = e3.codigo_empleado;
-- AS es un alias 

-- Usando NATURAL JOIN:

SELECT e1.nombre AS empleado_nombre, e1.apellido1 AS empleado_apellido1, e1.apellido2 AS empleado_apellido2,
       e2.nombre AS jefe_nombre, e2.apellido1 AS jefe_apellido1, e2.apellido2 AS jefe_apellido2,
       e3.nombre AS jefe_de_jefe_nombre, e3.apellido1 AS jefe_de_jefe_apellido1, e3.apellido2 AS jefe_de_jefe_apellido2
FROM empleado e1
NATURAL JOIN empleado e2
NATURAL JOIN empleado e3
WHERE e1.codigo_jefe = e2.codigo_empleado
  AND e2.codigo_jefe = e3.codigo_empleado;


-- 24. Nombre de los clientes a los que no se les ha entregado a tiempo un pedido
-- Usando INNER JOIN:
SELECT DISTINCT cliente.nombre_cliente FROM pedido INNER JOIN cliente ON pedido.codigo_cliente = cliente.codigo_cliente
WHERE pedido.fecha_entrega > pedido.fecha_esparada;

-- Usando NATURAL JOIN:
SELECT DISTINCT nombre_cliente FROM pedido NATURAL JOIN cliente WHERE fecha_entrega > fecha_esparada;
-- 25  Listado de las diferentes gamas de producto que ha comprado cada cliente
-- Usando INNER JOIN:
SELECT DISTINCT cliente.nombre_cliente, gama_producto.gama FROM cliente
INNER JOIN pedido ON cliente.codigo_cliente = pedido.codigo_cliente
INNER JOIN detalle_pedido ON pedido.codigo_pedido = detalle_pedido.codigo_pedido
INNER JOIN producto ON detalle_pedido.codigo_producto = producto.codigo_producto
INNER JOIN gama_producto ON producto.gama = gama_producto.gama;

-- Usando NATURAL JOIN:
SELECT DISTINCT nombre_cliente, gama FROM cliente
NATURAL JOIN pedido
NATURAL JOIN detalle_pedido
NATURAL JOIN producto
NATURAL JOIN gama_producto;


-- #####################
-- ###   DÍA  # 5   Consultas ###
-- #####################

use dia5;

-- ********************
-- ***** Consultas ****
-- ********************

-- 1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.

select c.codigo_cliente, c.nombre_cliente
from cliente c
left join pago p on c.codigo_cliente = p.codigo_cliente
where p.codigo_cliente is null;

-- 2. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pedido.

select c.codigo_cliente, c.nombre_cliente
from cliente c
left join pedido p on c.codigo_cliente = p.codigo_cliente
where p.codigo_pedido is null;

-- 3. Devuelve un listado que muestre los clientes que no han realizado ningún pago y los que no han realizado ningún pedido.

select c.codigo_cliente, c.nombre_cliente, 'Sin pd ni Sin pago' as tipo 
from cliente c
left join pago p on c.codigo_cliente = p.codigo_cliente
left join pedido pd on c.codigo_cliente = pd.codigo_cliente
where p.codigo_cliente is null and  pd.codigo_pedido is null;

-- 4. Devuelve un listado que muestre solamente los empleados que no tienen una oficina asociada.

select e.codigo_empleado, e.nombre, e.apellido1, e.apellido2
from empleado e
left join oficina o on o.codigo_oficina = e.codigo_oficina
where o.codigo_oficina is null;

-- 5. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado.

select e.codigo_empleado, e.nombre, e.apellido1, e.apellido2
from empleado e
left join cliente c on c.codigo_empleado_rep_ventas = e.codigo_empleado
where c.codigo_empleado_rep_ventas is null;

-- 6. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado junto con los datos de la oficina donde trabajan.

select e.codigo_empleado, e.nombre, e.apellido1, e.apellido2, o.codigo_oficina,
o.ciudad, o.pais, o.region, o.codigo_postal,
o.telefono, o.linea_direccion1, o.linea_direccion2
from empleado e
left join cliente c on c.codigo_empleado_rep_ventas = e.codigo_empleado
left join oficina o on e.codigo_oficina = o.codigo_oficina
where c.codigo_empleado_rep_ventas is null;

-- 7. Devuelve un listado que muestre los empleados que no tienen una oficina asociada y los que no tienen un cliente asociado.

-- Esta es de una forma mas corta, no se le pone null a oficina porque todos los empleados tiene una oficina
select e.codigo_empleado, e.nombre, e.apellido1, e.apellido2, 'Sin Oficina ni Cliente' AS tipo
from empleado e
left join  oficina o on e.codigo_oficina = o.codigo_oficina
left join cliente c on c.codigo_empleado_rep_ventas = e.codigo_empleado
where c.codigo_empleado_rep_ventas is null;

-- FORMA LARGA:
-- Listado de empleados que no tienen una oficina asociada
select 
    e.codigo_empleado, 
    e.nombre, 
    e.apellido1, 
    e.apellido2, 
    'Sin Oficina' as tipo
from empleado e
left join oficina o on e.codigo_oficina = o.codigo_oficina
where e.codigo_oficina is null

union

-- Listado de empleados que no tienen un cliente asociado
select 
    e.codigo_empleado, 
    e.nombre, 
    e.apellido1, 
    e.apellido2, 
    'Sin Cliente' as tipo
from empleado e
left join cliente c on c.codigo_empleado_rep_ventas = e.codigo_empleado
where c.codigo_empleado_rep_ventas is null;


-- 8. Devuelve un listado de los productos que nunca han aparecido en un pedido.

select p.codigo_producto, p.nombre, p.gama, p.dimensiones, p.proveedor, p.descripcion, p.cantidad_en_stock, p.precio_venta, p.precio_proveedor
from producto p
left join detalle_pedido dp on dp.codigo_producto = p.codigo_producto
where dp.codigo_producto is null;

-- 9. Devuelve un listado de los productos que nunca han aparecido en un pedido. El resultado debe mostrar el nombre, la descripción y la imagen del producto.

select p.nombre, p.descripcion, g.imagen
from producto p
left join detalle_pedido dp on dp.codigo_producto = p.codigo_producto
left join gama_producto g on p.gama = g.gama
where dp.codigo_producto is null;


-- 10. Devuelve las oficinas donde ninguno de los empleados que hayan sido los 
-- representantes de ventas de algún cliente que haya realizado la compra de algún producto de la gama Frutales.

select o.* -- Selecciona todas las columnas de la tabla oficina aliased como 'o'.
from oficina o
where not exists ( -- Utiliza un subquery en la cláusula WHERE NOT EXISTS para filtrar las oficinas que cumplen con la condición.
    select 1
    from empleado e
    inner join cliente c on e.codigo_empleado = c.codigo_empleado_rep_ventas
    inner join pedido p on c.codigo_cliente = p.codigo_cliente
    inner join detalle_pedido dp on p.codigo_pedido = dp.codigo_pedido
    inner join producto pr on dp.codigo_producto = pr.codigo_producto
    and e.codigo_oficina = o.codigo_oficina
    where pr.gama = 'Frutales'
);

-- 11. Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.

select c.codigo_cliente, c.nombre_cliente, c.nombre_contacto, c.apellido_contacto, c.telefono
from cliente c
inner join pedido p on p.codigo_cliente = c.codigo_cliente
left join pago pa on p.codigo_cliente = c.codigo_cliente
where pa.codigo_cliente is null;

-- 12. Devuelve un listado con los datos de los empleados que no tienen clientes asociados y el nombre de su jefe asociado.

select e.codigo_empleado, e.nombre, e.apellido1, e.apellido2, j.nombre as nombre_jefe, j.apellido1 as apellido_jefe
from empleado e
left join cliente c on e.codigo_empleado = c.codigo_empleado_rep_ventas
left join empleado j on e.codigo_jefe = j.codigo_empleado
where c.codigo_empleado_rep_ventas is null;	

-- ****************************
-- **** Consultas Resumen *****
-- ****************************

-- 13.¿Cuántos empleados hay en la compañía?

select count(*) as total_empleados -- El count(*) es para contar todos los registros en la tabla de empleado
from empleado;

-- 14. ¿Cuántos clientes tiene cada país?

select pais, count(*) as total_clientes
from cliente group by pais; -- group by => agrupa los resultados por el campo 'pais'

-- 15. ¿Cuál fue el pago medio en 2009?

select avg(total) as pago_medio_2009 -- AVG selecciona la media del campo total de la tabla pago
from pago
where year(fecha_pago) = 2009;

-- 16. ¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma descendente por el número de pedidos.

select estado, count(*) as total_pedidos
from pedido group by estado order by total_pedidos desc;

-- 17. Calcula el precio de venta del producto más caro y más barato en una misma consulta.

select
    max(precio_venta) as precio_maximo,
    min(precio_venta) as precio_minimo
from producto;

-- 18. Calcula el número de clientes que tiene la empresa.

select count(*) as total_clientes
from cliente;

-- 19. ¿Cuántos clientes existen con domicilio en la ciudad de Madrid?

select COUNT(*) as total_clientes_madrid
from cliente
where ciudad = 'Madrid';

-- 20. ¿Calcula cuántos clientes tiene cada una de las ciudades que empiezan por M?

select ciudad, COUNT(*) as total_clientes
from cliente where ciudad like 'M%' group by ciudad;

-- 21. Devuelve el nombre de los representantes de ventas y el número de clientes al que atiende cada uno.

select 
    e.nombre as nombre_representante,
    e.apellido1 as apellido1_representante,
    e.apellido2 as apellido2_representante,
    COUNT(c.codigo_cliente) as total_clientes
from 
    empleado e
inner join 
    cliente c on e.codigo_empleado = c.codigo_empleado_rep_ventas
group by 
    e.codigo_empleado, e.nombre, e.apellido1, e.apellido2
order by 
    total_clientes desc;
    
-- 22. Calcula el número de clientes que no tiene asignado representante de ventas.

select count(*) as total_clientes_sin_representante
from cliente
where codigo_empleado_rep_ventas is null;

-- 23. Calcula la fecha del primer y último pago realizado por cada uno de los clientes. 
-- El listado deberá mostrar el nombre y los apellidos de cada cliente.

select 
    c.nombre_cliente, 
    c.nombre_contacto, 
    c.apellido_contacto,
    (
		select min(fecha_pago)
        from pago pa
        where pa.codigo_cliente = c.codigo_cliente
    ) as primera_fecha_pago,
    (
        select max(fecha_pago)
        from pago pa
        where pa.codigo_cliente = c.codigo_cliente
    ) as ultima_fecha_pago
from cliente c;

-- 24. Calcula el número de productos diferentes que hay en cada uno de los pedidos.

select codigo_pedido, count(distinct codigo_producto) as num_productos_diferentes -- count es contar
from detalle_pedido
group by  codigo_pedido;

-- 25. Calcula la suma de la cantidad total de todos los productos que aparecen en cada uno de los pedidos.

select codigo_pedido, SUM(cantidad) as cantidad_total
from detalle_pedido
group by codigo_pedido;

-- 26. Devuelve un listado de los 20 productos más vendidos y el número total de unidades que se han vendido de cada uno.
-- El listado deberá estar ordenado por el número total de unidades vendidas.

select 
    dp.codigo_producto,
    p.nombre as nombre_producto,
    SUM(dp.cantidad) as total_unidades_vendidas
from detalle_pedido dp
inner join producto p on dp.codigo_producto = p.codigo_producto
group by dp.codigo_producto, p.nombre
order by total_unidades_vendidas desc
limit 20;

-- 27. La facturación que ha tenido la empresa en toda la historia,
-- indicando la base imponible, el IVA y el total facturado. La base imponible se calcula sumando el coste del producto por el número de unidades vendidas 
-- de la tabla detalle_pedido. El IVA es el 21 % de la base imponible, y el total la suma de los dos campos anteriores.

select 
    sum(dp.cantidad * p.precio_venta) as base_imponible,
    sum(dp.cantidad * p.precio_venta) * 0.21 as iva,
    sum(dp.cantidad * p.precio_venta) * 1.21 as total_facturado
from detalle_pedido dp	
inner join producto p on dp.codigo_producto = p.codigo_producto;

-- 28. La misma información que en la pregunta anterior, pero agrupada por código de producto.

select 
    dp.codigo_producto,
    p.nombre as nombre_producto,
    SUM(dp.cantidad * p.precio_venta) as base_imponible,
    SUM(dp.cantidad * p.precio_venta) * 0.21 as iva,
    SUM(dp.cantidad * p.precio_venta) * 1.21 as total_facturado
FROM detalle_pedido dp
inner join producto p on dp.codigo_producto = p.codigo_producto
group by dp.codigo_producto, p.nombre
order by total_facturado desc;

-- 29. La misma información que en la pregunta anterior, pero 
-- agrupada por código de producto filtrada por los códigos
-- que empiecen por OR.

select 
    dp.codigo_producto,
    p.nombre as nombre_producto,
    SUM(dp.cantidad * p.precio_venta) as base_imponible,
    SUM(dp.cantidad * p.precio_venta) * 0.21 as iva,
    SUM(dp.cantidad * p.precio_venta) * 1.21 as total_facturado
from detalle_pedido dp
inner join producto p on dp.codigo_producto = p.codigo_producto
where dp.codigo_producto like 'OR%'
group by dp.codigo_producto, p.nombre
order by total_facturado desc;

-- 30. Lista las ventas totales de los productos que hayan facturado más de 3000 euros. Se mostrará el nombre,
-- unidades vendidas, total facturado y total facturado con impuestos (21% IVA).

select 
    p.nombre as nombre_producto,
    SUM(dp.cantidad) as unidades_vendidas,
    SUM(dp.cantidad * p.precio_venta) as total_facturado,
    SUM(dp.cantidad * p.precio_venta * 1.21) as total_facturado_con_iva
from detalle_pedido dp
join producto p on dp.codigo_producto = p.codigo_producto
group by p.nombre
having total_facturado > 3000 -- el HAVING se utiliza para filtrar grupos de registros creados por la cláusula GROUP BY
order by total_facturado desc;

-- 31. Muestre la suma total de todos los pagos que se realizaron para cada uno de los años que aparecen en la tabla pagos.

select year(fecha_pago) as anio, sum(total) as suma_total_pagos
from pago
group by year(fecha_pago)
order by anio;


-- ***********************
-- **** SubConsultas *****
-- ***********************

-- 32.Devuelve el nombre del cliente con mayor límite de crédito.

select nombre_cliente
from cliente
where limite_credito = (
    select max(limite_credito)
    from cliente
);

-- 33.Devuelve el nombre del producto que tenga el precio de venta más caro.

select nombre
from producto
where precio_venta = (
    select max(precio_venta)
    from producto
);

-- 34. Devuelve el nombre del producto del que se han vendido más unidades. (Tenga en cuenta que tendrá que calcular
-- cuál es el número total de unidades que se han vendido de cada producto a partir de los datos de la
-- tabla detalle_pedido)

select p.nombre as nombre_producto
from producto p
inner join (
    select codigo_producto, sum(cantidad) as total_unidades_vendidas
    from detalle_pedido
    group by codigo_producto
    order by total_unidades_vendidas desc
    limit 1
) as unidades_maximas on p.codigo_producto = unidades_maximas.codigo_producto;

-- 35. Los clientes cuyo límite de crédito sea mayor que los pagos que haya realizado. (Sin utilizar INNER JOIN).

select nombre_cliente
from cliente
where limite_credito > (
    select coalesce(sum(total), 0) -- COALESCE se utiliza para manejar casos donde no hay pagos registrados para un cliente, devolviendo 0 en lugar de NULL.
    from pago
    where pago.codigo_cliente = cliente.codigo_cliente
);

-- 36. Devuelve el producto que más unidades tiene en stock.

select nombre
from producto
where cantidad_en_stock = (
    select max(cantidad_en_stock)
    from producto
);

-- 37. Devuelve el producto que menos unidades tiene en stock.

select nombre
from producto
where cantidad_en_stock = (
    select min(cantidad_en_stock)
    from producto
);

-- 38. Devuelve el nombre, los apellidos y el email de los empleados que están a cargo de Alberto Soria.

select e.nombre, e.apellido1, e.apellido2, e.email
from empleado e
where e.codigo_jefe = (
    select codigo_empleado
    from empleado
    where nombre = 'Alberto' and apellido1 = 'Soria'
);

-- ************************************
-- *** Sub consultas con ALL y ANY ****
-- ************************************

-- 39. Devuelve el nombre del cliente con mayor límite de crédito.

select nombre_cliente
from cliente
where limite_credito >= all (
    select limite_credito
    from cliente
);

-- ALL es el valor predeterminado, especifica que el conjunto de resultados puede incluir filas duplicadas. Por regla general nunca se utiliza. 
-- Especifica que el conjunto de resultados sólo puede incluir filas únicas.
-- El operador ANY compara un valor con cada valor de una tabla y evalúa si el resultado de una consulta interna contiene al menos una fila.
-- "Any" es un pronombre que se puede traducir como "alguno", y "all" es un adjetivo que se puede traducir como "todo".


-- 40. Devuelve el nombre del producto que tenga el precio deventa más caro.

select nombre
from producto
where precio_venta = any (
    select max(precio_venta)
    from producto
    where precio_venta is not null
);

-- 41. Devuelve el producto que menos unidades tiene en stock.

SELECT nombre
FROM producto
WHERE cantidad_en_stock = any (
    SELECT MIN(cantidad_en_stock)
    FROM producto
);

select nombre
from producto p1
where cantidad_en_stock <= all (
    select cantidad_en_stock
    from producto p2
    where p1.codigo_producto <> p2.codigo_producto -- <> significa no igual, esto hace que compare si 2 valores son iguales entre si
);


-- **************************************
-- *** Sub consultas con IN y NOT IN ****
-- **************************************

-- El operador IN se utiliza para verificar si un valor determinado coincide con cualquiera de 
-- los valores especificados en una lista o resultado de una subconsulta. La sintaxis básica es la siguiente:

-- El operador NOT IN, como su nombre indica, se utiliza para verificar si un valor específico no coincide con ninguno de 
-- los valores especificados en una lista o resultado de una subconsulta.
-- La sintaxis es similar al IN pero se utiliza NOT IN en lugar de IN:

-- 42. Devuelve el nombre, apellido1 y cargo de los empleados que no representen a ningún cliente.

select nombre, apellido1, puesto
from empleado
where codigo_empleado not in (
    select distinct codigo_empleado_rep_ventas
    from cliente
    where codigo_empleado_rep_ventas is not null
);

-- 43. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.

select *
from cliente
where codigo_cliente not in (
    select distinct codigo_cliente
    from pago
);

-- 44. Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago.

select *
from cliente
where codigo_cliente in (
    select distinct codigo_cliente
    from pago
);

-- 45. Devuelve un listado de los productos que nunca han aparecido en un pedido.

select *
from producto
where codigo_producto not in (
    select distinct codigo_producto
    from detalle_pedido
);

-- 46. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados 
-- que no sean representante de ventas de ningún cliente.

select nombre, apellido1, puesto, telefono
from empleado
where codigo_empleado not in (
    select distinct codigo_empleado_rep_ventas
    from cliente
    where codigo_empleado_rep_ventas is not null
);


-- 47. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas de
-- algún cliente que haya realizado la compra de algún producto de la gama Frutales.

-- Identificar los empleados que son representantes de ventas de clientes que han comprado productos de la gama Frutales:
select distinct e.codigo_empleado
from empleado e
inner join cliente c on e.codigo_empleado = c.codigo_empleado_rep_ventas
inner join pedido p on c.codigo_cliente = p.codigo_cliente
inner join detalle_pedido dp on p.codigo_pedido = dp.codigo_pedido
inner join producto pr on dp.codigo_producto = pr.codigo_producto
where pr.gama = 'Frutales';

-- Seleccionar las oficinas donde no trabajan estos empleados:

select codigo_oficina, ciudad, pais, region, codigo_postal, telefono, linea_direccion1, linea_direccion2
from oficina
where codigo_oficina not in (
    select distinct o.codigo_oficina
    from oficina o
    inner join empleado e on o.codigo_oficina = e.codigo_oficina
    inner join cliente c on e.codigo_empleado = c.codigo_empleado_rep_ventas
    inner join pedido p on c.codigo_cliente = p.codigo_cliente
    inner join detalle_pedido dp on p.codigo_pedido = dp.codigo_pedido
    inner join producto pr on dp.codigo_producto = pr.codigo_producto
    where pr.gama = 'Frutales'
);


-- 48. Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.

select *
from cliente
where codigo_cliente in (
    select distinct codigo_cliente
    from pedido
    where codigo_cliente not in (
        select distinct codigo_cliente
        from pago
    )
);

-- ********************************************
-- *** Subconsultas con EXISTS y NOT EXISTS ***
-- ********************************************

-- 49. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.

select *
from cliente c
where not exists (
    select *
    from pago p
    where p.codigo_cliente = c.codigo_cliente
);

-- 50. Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago.

select * -- e utiliza para seleccionar todas las columnas de una tabla específica.
from cliente c
where exists (
    select *
    from pago p
    where p.codigo_cliente = c.codigo_cliente
);

-- 51. Devuelve un listado de los productos que nunca han aparecido en un pedido.

select *
from producto p
where not exists (
    select *
    from detalle_pedido dp
    where dp.codigo_producto = p.codigo_producto
);

-- 52. Devuelve un listado de los productos que han aparecido en un pedido alguna vez.

select distinct p.*
from producto p
where exists (
    select *
    from detalle_pedido dp
    where dp.codigo_producto = p.codigo_producto
);

-- ************************************
-- *** Subconsultas correlacionadas ***
-- ************************************

-- Consultas variadas:

-- 53. Devuelve el listado de clientes indicando el nombre del cliente y cuántos pedidos ha realizado. Tenga en cuenta
-- que pueden existir clientes que no han realizado ningún pedido.

select c.nombre_cliente, count(p.codigo_pedido) as pedidos_realizados
from cliente c
left join pedido p on c.codigo_cliente = p.codigo_cliente
group by c.nombre_cliente
order by c.nombre_cliente;

-- 54. Devuelve un listado con los nombres de los clientes y el total pagado por cada uno de ellos. Tenga en cuenta que
-- pueden existir clientes que no han realizado ningún pago.

select c.nombre_cliente, coalesce(sum(p.total), 0) as total_pagado
from cliente c
left join pago p on c.codigo_cliente = p.codigo_cliente
group by c.nombre_cliente
order by c.nombre_cliente;

-- 55. Devuelve el nombre de los clientes que hayan hecho pedidos en 2008 ordenados alfabéticamente de menor a mayor.

select distinct c.nombre_cliente
from cliente c
inner join pedido p on c.codigo_cliente = p.codigo_cliente
where year(p.fecha_pedido) = 2008
order by c.nombre_cliente;

-- 56. Devuelve el nombre del cliente, el nombre y primer apellido de su representante de ventas y el número de teléfono de
-- la oficina del representante de ventas, de aquellos clientes que no hayan realizado ningún pago.

select c.nombre_cliente, e.nombre as nombre_representante, e.apellido1 as apellido_representante, o.telefono
from cliente c
inner join empleado e on c.codigo_empleado_rep_ventas = e.codigo_empleado
inner join oficina o on e.codigo_oficina = o.codigo_oficina
where not exists (
    select *
    from pago p
    where p.codigo_cliente = c.codigo_cliente
);

-- 57. Devuelve el listado de clientes donde aparezca el nombre del cliente, el nombre y primer apellido de su representante
-- de ventas y la ciudad donde está su oficina.

select c.nombre_cliente, e.nombre as nombre_representante, e.apellido1 as apellido_representante, o.ciudad as ciudad_oficina
from cliente c
inner join empleado e on c.codigo_empleado_rep_ventas = e.codigo_empleado
inner join oficina o on e.codigo_oficina = o.codigo_oficina;

-- 58. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no sean representante
-- de ventas de ningún cliente.

select e.nombre, e.apellido1, e.puesto, o.telefono
from empleado e
inner join oficina o on e.codigo_oficina = o.codigo_oficina
where e.codigo_empleado not in (
    select distinct codigo_empleado_rep_ventas
    from cliente
    where codigo_empleado_rep_ventas is not null
);

-- 59. Devuelve un listado indicando todas las ciudades donde hay oficinas y el número de empleados que tiene.

select o.ciudad, count(e.codigo_empleado) as num_empleados
from oficina o
left join empleado e on o.codigo_oficina = e.codigo_oficina
group by o.ciudad
order by o.ciudad;

-- Desarrollado por Juan Felipe Rubio Sanabria / ID.1.146.334.004
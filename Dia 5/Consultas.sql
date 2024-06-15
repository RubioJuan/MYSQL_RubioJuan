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


-- Desarrollado por Juan Felipe Rubio Sanabria / ID.1.146.334.004mem
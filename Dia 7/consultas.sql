-- *******************
-- ***  Consultas  ***
-- *******************

use examen;

-- 1. Devuelve un listado con el primer apellido, segundo apellido y el nombre de todos los alumnos.
-- El listado deberá estar ordenado alfabéticamente de menor a mayor por el primer apellido, segundo apellido y nombre.

select apellido1, apellido2, nombre
from alumno;

-- 2. Averigua el nombre y los dos apellidos de los alumnos que no han dado de alta su número de teléfono en la base de datos.

select a.nombre, a.apellido1, a.apellido2
from alumno a
where telefono is not null;

-- 3. Devuelve el listado de los alumnos que nacieron en 1999.

select a.id, a.nombre
from alumno a
where fecha_nacimiento like '1999%';

-- 4. Devuelve el listado de profesores que no han dado de alta su número de teléfono en la base de datos y además su nif termina en K.

select p.id, p.nombre, p.apellido1, 'No han retirado su número de teléfono' as tipo
from profesor p
where telefono is not null

union

select p.id, p.nombre, p.apellido1, 'Nif termina en K' as tipo
from profesor p
where nif like '%K' ;

-- 5. Devuelve el listado de las asignaturas que se imparten en el primer cuatrimestre, en el tercer curso del grado que tiene el identificador 7.

select a.id, a.nombre
from asignatura a
where cuatrimestre = 1 and curso = 3;

-- ****************************
-- *** Consultas multitabla ***
-- ****************************

-- 1. Devuelve un listado con los datos de todas las alumnos que se han matriculado alguna vez en el Grado en Ingeniería Informática (Plan 2015).

select distinct a.id, a.nif, a.nombre, a.apellido1, a.apellido2, a.ciudad, a.direccion, a.telefono, a.fecha_nacimiento, a.sexo
from alumno a
inner join alumno_se_matricula_asignatura asm on a.id = asm.id_alumno
inner join asignatura asig on asm.id_asignatura = asig.id
inner join grado g on asig.id_grado = g.id
where g.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

-- 2. Devuelve un listado con todas las asignaturas ofertadas en el Grado en Ingeniería Informática (Plan 2015).

select a.id, a.nombre, a.creditos, a.tipo, a.curso, a.cuatrimestre
from asignatura a
inner join grado g on a.id_grado = g.id
where g.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

-- 3. Devuelve un listado de los profesores junto con el nombre del departamento al que están vinculados.
-- El listado debe devolver cuatro columnas, primer apellido, segundo apellido, nombre y nombre del departamento.
-- El resultado estará ordenado alfabéticamente de menor a mayor por los apellidos y el nombre.

select p.apellido1, p.apellido2, p.nombre, d.nombre AS nombre_departamento
from profesor p
inner join departamento d on p.id_departamento = d.id
order by p.apellido1, p.apellido2, p.nombre;

-- 4. Devuelve un listado con el nombre de las asignaturas, año de inicio y año de fin del curso escolar del alumno con nif 26902806M.

select asig.nombre, ce.anyo_inicio, ce.anyo_fin
from alumno a
inner join alumno_se_matricula_asignatura ama on a.id = ama.id_alumno
inner join asignatura asig on ama.id_asignatura = asig.id
inner join curso_escolar ce on ama.id_curso_escolar = ce.id
where a.nif = '26902806M';

-- 5. Devuelve un listado con el nombre de todos los departamentos que tienen profesores que imparten alguna asignatura en 
-- el Grado en Ingeniería Informática (Plan 2015).

select distinct d.nombre as departamento
from departamento d
inner join profesor p on d.id = p.id_departamento
inner join asignatura a on p.id = a.id_profesor
inner join grado g on a.id_grado = g.id
where g.nombre = 'Grado en Ingeniería Informática (Plan 2015)';


-- 6. Devuelve un listado con todos los alumnos que se han matriculado en alguna asignatura durante el curso escolar 2018/2019.

select distinct a.id, a.nif, a.nombre, a.apellido1, a.apellido2, a.ciudad, a.direccion, a.telefono, a.fecha_nacimiento, a.sexo
from alumno a
inner join alumno_se_matricula_asignatura ama on a.id = ama.id_alumno
inner join  curso_escolar ce on ama.id_curso_escolar = ce.id
where ce.anyo_inicio = 2018 and ce.anyo_fin = 2019;

-- ****************************************************
-- *** Consultas multitabla (Composición externa)  ****
-- *****************************************************

-- 1. Devuelve un listado con los nombres de todos los profesores y los departamentos que tienen vinculados.
-- El listado también debe mostrar aquellos profesores que no tienen ningún departamento asociado.
-- El listado debe devolver cuatro columnas, nombre del departamento, primer apellido, segundo apellido y nombre del profesor. 
-- El resultado estará ordenado alfabéticamente de menor a mayor por el nombre del departamento, apellidos y el nombre.

select coalesce(d.nombre, 'Sin Departamento') as departamento, p.apellido1, p.apellido2, p.nombre as profesor
from profesor p
left join departamento d on p.id_departamento = d.id
order by departamento, p.apellido1, p.apellido2, p.nombre;

-- 2. Devuelve un listado con los profesores que no están asociados a un departamento.

select p.id, p.nif, p.nombre, p.apellido1, p.apellido2, p.ciudad, p.direccion, p.telefono, p.fecha_nacimiento, p.sexo
from profesor p
left join departamento d on p.id_departamento = d.id
where p.id_departamento is null;


-- 3. Devuelve un listado con los departamentos que no tienen profesores asociados.

select d.id, d.nombre
from departamento d
left join profesor p on d.id = p.id_departamento
where p.id is null;


-- 4. Devuelve un listado con los profesores que no imparten ninguna asignatura.

select p.id, p.nif, p.nombre, p.apellido1, p.apellido2
from profesor p
left join asignatura a on p.id =  a.id_profesor
where p.id is null;

-- 5. Devuelve un listado con las asignaturas que no tienen un profesor asignado.

select a.id, a.nombre
from asignatura a
left join profesor p on a.id_profesor = p.id
where a.id_profesor is null;

-- 6. Devuelve un listado con todos los departamentos que tienen alguna asignatura que no se haya impartido en ningún curso escolar.
--  El resultado debe mostrar el nombre del departamento y el nombre de la asignatura que no se haya impartido nunca.

select d.nombre as departamento, a.nombre as asignatura
from departamento d
inner join profesor p on d.id = p.id_departamento
inner join asignatura a on p.id = a.id_profesor
left join alumno_se_matricula_asignatura asm on a.id = asm.id_asignatura
where asm.id_asignatura is null;


-- ***************************
-- ***  Consultas resúmen ****
-- ***************************

-- 1. Devuelve el número total de alumnos que hay.
select count(*) as Numero_total_alumnos
from alumno;

-- 2. Calcula cuántos alumnos nacieron en 1999.

select count(*) as Numero_de_alumnos_nacieron_en_1999
from alumno 
where fecha_nacimiento like '1999%';

-- 3. Calcula cuántos profesores hay en cada departamento. El resultado sólo debe mostrar dos columnas, 
-- una con el nombre del departamento y otra con el número de profesores que hay en ese departamento.
--  El resultado sólo debe incluir los departamentos que tienen profesores asociados y deberá estar ordenado de mayor a menor por el número de profesores.

select d.nombre as departamento, count(p.id) as numero_profesores
from departamento d
inner join profesor p on d.id = p.id_departamento
group by d.id, d.nombre
having count(p.id) > 0
order by numero_profesores desc;
-- La cláusula HAVING en Access especifica qué registros agrupados se muestran en una
-- instrucción SELECT con una cláusula GROUP BY. Después de que 
-- GROUP BY combine los registros, HAVING muestra cualquier registro agrupado por la 
-- cláusula GROUP BY que satisfaga las condiciones de la cláusula HAVING.


-- 4. Devuelve un listado con todos los departamentos y el número de profesores que hay en cada uno de ellos. 
-- Tenga en cuenta que pueden existir departamentos que no tienen profesores asociados. Estos departamentos también tienen que aparecer en el listado.

select d.nombre as departamento, count(p.id) as numero_profesores
from departamento d
left join profesor p on d.id = p.id_departamento
group by d.id, d.nombre;

-- 5. Devuelve un listado con el nombre de todos los grados existentes en la base de datos y el número de asignaturas que tiene cada uno. 
-- Tenga en cuenta que pueden existir grados que no tienen asignaturas asociadas. Estos grados también tienen que aparecer en el listado.
-- El resultado deberá estar ordenado de mayor a menor por el número de asignaturas.

select g.nombre as grado, count(a.id) as numero_asignaturas
from grado g
left join asignatura a on g.id = a.id_grado
group by g.id, g.nombre
order by numero_asignaturas desc;

-- 6. Devuelve un listado con el nombre de todos los grados existentes en la base de datos y el número de asignaturas que tiene cada uno,
--  de los grados que tengan más de 40 asignaturas asociadas.

select g.nombre as grado, count(a.id) as numero_asignaturas
from grado g
left join asignatura a on g.id = a.id_grado
group by g.id, g.nombre
having COUNT(a.id) > 40;

-- 7. Devuelve un listado que muestre el nombre de los grados y la suma del número total de créditos que hay para cada tipo de asignatura.
-- El resultado debe tener tres columnas: nombre del grado, tipo de asignatura y la suma de los créditos de todas las asignaturas que hay de ese tipo.
-- Ordene el resultado de mayor a menor por el número total de crédidos.

select g.nombre as grado, a.tipo, sum(a.creditos) as total_creditos
from grado g
inner join asignatura a on g.id = a.id_grado
group by g.id, g.nombre, a.tipo
order by total_creditos desc;

-- 8. Devuelve un listado que muestre cuántos alumnos se han matriculado de alguna asignatura en cada uno de los cursos escolares. 
-- El resultado deberá mostrar dos columnas, una columna con el año de inicio del curso escolar y otra con el número de alumnos matriculados.

select ce.anyo_inicio, count(distinct asm.id_alumno) as numero_alumnos
from curso_escolar ce
left join alumno_se_matricula_asignatura asm on ce.id = asm.id_curso_escolar
group by ce.anyo_inicio
order by ce.anyo_inicio;


-- 9. Devuelve un listado con el número de asignaturas que imparte cada profesor. 
-- El listado debe tener en cuenta aquellos profesores que no imparten ninguna asignatura. 
-- El resultado mostrará cinco columnas: id, nombre, primer apellido, segundo apellido y número de asignaturas. 
-- El resultado estará ordenado de mayor a menor por el número de asignaturas.

select p.id, p.nombre, p.apellido1, p.apellido2, COUNT(a.id) AS numero_asignaturas
from profesor p
left join asignatura a on p.id = a.id_profesor
group by p.id, p.nombre, p.apellido1, p.apellido2
order by numero_asignaturas desc;


-- Desarrollado por Juan Felipe Rubio Sanabria / ID.1.146.334.004
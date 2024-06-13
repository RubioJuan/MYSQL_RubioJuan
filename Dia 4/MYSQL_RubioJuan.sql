-- #####################
-- ###   DÍA  # 4   RELACIONAMIENTO DE CONSULTAS ###
-- #####################

-- Crear base de datos del dia4
create database dia4;

-- Utilizar BBDD dia4
use dia4;

-- Creando tabla de pais
create table pais(
	id INT primary key,
    nombre VARCHAR(20),
    continente VARCHAR(50),
    poblacion INT
);

-- Creando tabla de ciudad
create table ciudad(
	id INT primary key not null,
	nombre VARCHAR(20),
    id_pais INT,
    foreign key(id_pais)references pais(id)
);

-- Creando tabla de idioma de pais
create table idioma_pais(
	id_idioma INT not null,
    id_pais INT not null,
    es_oficial TINYINT(1),
    foreign key(id_pais)references pais(id),
    foreign key(id_idioma)references idioma(id)
);

-- Creando tabla de idioma
create table idioma(
	id INT primary key not null,
    idioma VARCHAR(50)
);

show tables;

INSERT INTO pais (id, nombre, continente, poblacion) VALUES 
(1, 'España', 'Europa', 47000000),
(2, 'México', 'América', 126000000),
(3, 'Japón', 'Asia', 126300000);

INSERT INTO ciudad (id, nombre, id_pais) VALUES 
(1, 'Madrid', 1),
(2, 'Barcelona', 1),
(3, 'Ciudad de México', 2),
(4, 'Guadalajara', 2),
(5, 'Tokio', 3),
(6, 'Osaka', 3);

INSERT INTO idioma (id, idioma) VALUES 
(1, 'Español'),
(2, 'Catalán'),
(3, 'Inglés'),
(4, 'Japonés');


INSERT INTO idioma_pais (id_idioma, id_pais, es_oficial) VALUES 
(1, 1, 1), -- Español es oficial en España
(2, 1, 1), -- Catalán es oficial en España
(1, 2, 1), -- Español es oficial en México
(4, 3, 1), -- Japonés es oficial en Japón
(3, 1, 0), -- Inglés no es oficial en España
(3, 2, 0), -- Inglés no es oficial en México
(3, 3, 0); -- Inglés no es oficial en Japón

-- ##### INSERCIONES ADICIONALES ####
INSERT INTO pais (id, nombre, continente, poblacion) VALUES 
(6, 'Italia', 'Europa', 60000000); -- Pais sin ciudades

INSERT INTO ciudad (id, nombre, id_pais) VALUES 
(11, 'Ciudad Desconocida', NULL); 

-- Listar todos los pares de nombres de paises y sus
-- ciudades correspondientes que están relacionadas
-- en la base de datos (INNER JOIN)

select pais.nombre as País, ciudad.nombre as Ciudad
from pais
inner join ciudad on pais.id = ciudad.id_pais; 

-- Listar todas las ciudades con el nombre de su país.
-- si alguna ciudad no tiene un país aignado,
-- aún aparece en la lista con el nombrePais como NULL.

select pais.nombre as País, ciudad.nombre as Ciudad
from pais
left join ciudad on pais.id=ciudad.id_pais;


-- Mostrar todos los paises y,
--  si tiene ciudades asociadas, estan se mostraran
-- junto al nombre del pais. Si no hay ciudades asociadas a un pais,
-- el nombreCiudad aparecera como NULL.

select pais.nombre as Pais, ciudad.nombre as Ciudad
from pais
right join ciudad on ciudad.id_pais = pais.id;

-- Desarrollado por Juan Felipe Rubio Sanabria / ID.1.146.334.004
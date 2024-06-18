-- #####################
-- ###   EXAMEN      ###
-- #####################

create database examen;

use examen;

create table departamento(
	id INT(10) primary key not null,
    nombre VARCHAR(50) not null
);

create table profesor(
	id INT(10) primary key not null,
    nif VARCHAR(9),
    nombre VARCHAR(25) not null,
    apellido1 VARCHAR(50) not null,
    apellido2 VARCHAR(50),
    ciudad VARCHAR(25) not null,
    direccion VARCHAR(50) not null,
    telefono VARCHAR(9),
    fecha_nacimiento DATE not null,
    sexo ENUM('H','M') not null,
    id_departamento INT(10) not null,
    foreign key(id_departamento)references departamento(id)
);

create table asignatura(
	id INT(10) primary key not null,
    nombre VARCHAR(100) not null,
    creditos FLOAT not null,
	tipo ENUM('básica', 'obligatoria', 'optativa') not null,
    curso TINYINT(3) not null,
    cuatrimestre TINYINT(3)not null,
    id_profesor INT(10),
    id_grado INT(10),
    foreign key(id_profesor)references profesor(id),
    foreign key(id_grado)references grado(id)
);

create table grado(
	id INT(10) primary key not null,
    nombre VARCHAR(100)
);

show tables;

create table alumno_se_matricula_asignatura(
	id_alumno INT(10),
    id_asignatura INT(10),
    id_curso_escolar INT(10),
    foreign key(id_alumno)references alumno(id),
	foreign key(id_asignatura)references asignatura(id),
	foreign key(id_curso_escolar)references curso_escolar(id)
);

create table alumno(
	id INT(10) primary key not null,
    nif VARCHAR(9),
    nombre VARCHAR(25) not null,
    apellido1 VARCHAR(50) not null,
    apellido2 VARCHAR(50),
    ciudad VARCHAR(25) not null,
    direccion VARCHAR(50) not null,
    telefono VARCHAR(9),
    fecha_nacimiento DATE not null,
    sexo ENUM('H','M') not null
);

create table curso_escolar(
	id INT(10) primary key not null,
    anyo_inicio YEAR(4) not null,
    anyo_fin YEAR(4) not null
);


-- Desarrollado por Juan Felipe Rubio Sanabria / ID.1.146.334.004
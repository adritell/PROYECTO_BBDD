drop database if exists gimnasio_proyecto;
create database gimnasio_proyecto;
use gimnasio_proyecto;

create table productos_nutricion (
	id_producto int auto_increment primary key,
	nombre_producto varchar(50),
	descripcion varchar(50),
	precio decimal (2,2),
	stock varchar(10),
	fecha_vencimiento date,
	tipo_producto varchar(20)
);

create table usuario (
	id_usuario int auto_increment primary key,
	nombre varchar(50),
	apellidos varchar(50),
	telefono varchar(20),
	email varchar(40),
	genero varchar(5),
	fecha_inscripcion date,
	peso decimal(2,2),
	altura decimal(2,2),
	objetivo varchar(30)
);

create table monitor (
	id_monitor int auto_increment primary key,
	nombre varchar(50),
	apellidos varchar(50),
	titulacion varchar(30),
	especialidad varchar(40),
	fecha_contratacion date,
	telefono varchar(30)
);

create table actividades_especiales(
	id_actividad int auto_increment primary key,
	id_monitor int,
	nombre_actividad varchar(20),
	descripcion varchar(20),
	fecha date,
	duracion int,
	aforo_maximo int,
	foreign key (id_monitor) references monitor(id_monitor)
);

create table horario (
	id_usuario int,
	id_actividad int,
	dia int,
	mes int,
	hora varchar(20),
	primary key(id_usuario,id_actividad),
	foreign key (id_usuario) references usuario(id_usuario),
	foreign key (id_actividad) references actividades_especiales(id_actividad)
	

);

create table reserva (
	id_reserva int auto_increment primary key,
	id_usuario int,
	id_actividad int,
	fecha_reserva date,
	foreign key (id_usuario) references usuario(id_usuario),
	foreign key (id_actividad) references horario(id_actividad)
);



create table compra (
	id_compra int auto_increment primary key,
	id_producto int,
	id_usuario int,
	cantidad int,
	foreign key (id_producto) references productos_nutricion(id_producto),
	foreign key (id_usuario) references usuario(id_usuario)
);

create table rutina (
	id_rutina int auto_increment primary key,
	id_monitor int,
	nombre_rutina varchar(20),
	descripcion varchar(60),
	foreign key (id_monitor) references monitor(id_monitor)
);

create table usuarios_rutina (
	id_usuario int,
	id_rutina int,
	fecha_inicio date,
	fecha_fin date,
	primary key (id_usuario, id_rutina),
	foreign key (id_usuario) references usuario(id_usuario),
	foreign key (id_rutina) references rutina(id_rutina)
);

create table ejercicios_gym(
	id_ejercicio int auto_increment primary key,
	nombre varchar(50),
	descripcion varchar(120),
	tipo varchar(20),
	parte_cuerpo varchar(20),
	equipo_necesario varchar(10),
	nivel varchar(15),
	video varchar(10)
);

create table rutina_ejercicio(
	id_rutina int,
	id_ejercicio int,
	series int,
	repeticiones int,
	peso int,
	primary key(id_rutina,id_ejercicio),
	foreign key (id_rutina) references rutina(id_rutina),
	foreign key (id_ejercicio) references ejercicios_gym(id_ejercicio)
);

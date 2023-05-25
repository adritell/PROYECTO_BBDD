drop database if exists gimnasio_proyecto;
create database gimnasio_proyecto;
use gimnasio_proyecto;

create table productos_nutricion (
	id_producto int auto_increment primary key,
	nombre_producto varchar(200),
	descripcion varchar(200),
	precio decimal (5,2),
	stock varchar(20),
	fecha_vencimiento date,
	tipo_producto varchar(200)
);

create table usuario (
	id_usuario int auto_increment primary key,
	nombre varchar(200),
	apellidos varchar(200),
	telefono varchar(200),
	email varchar(100),
	genero varchar(20),
	fecha_inscripcion date,
	peso decimal(5,2),
	altura decimal(5,2),
	objetivo varchar(200),
	edad int
);

create table monitor (
	id_monitor int auto_increment primary key,
	nombre varchar(200),
	apellidos varchar(200),
	titulacion varchar(200),
	especialidad varchar(200),
	fecha_contratacion date,
	telefono varchar(50)
);

create table actividades_especiales(
	id_actividad int auto_increment primary key,
	id_monitor int,
	nombre_actividad varchar(50),
	descripcion varchar(200),
	duracion int,
	aforo_maximo int,
	foreign key (id_monitor) references monitor(id_monitor)
);

create table horario (
	id_horario int auto_increment primary key,
	id_actividad int,
	dia int,
	hora varchar(50),
	foreign key (id_actividad) references actividades_especiales(id_actividad)
	

);

create table reserva (
	id_reserva int auto_increment primary key,
	id_usuario int,
	id_horario int,
	fecha_reserva date,
	foreign key (id_usuario) references usuario(id_usuario),
	foreign key (id_horario) references horario(id_horario)
);


create table rutina (
	id_rutina int auto_increment primary key,
	id_monitor int,
	nombre_rutina varchar(100),
	descripcion varchar(200),
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
	nombre varchar(100),
	descripcion varchar(1000),
	tipo varchar(50),
	parte_cuerpo varchar(50),
	equipo_necesario varchar(50),
	nivel varchar(50),
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

create table pedidos(
	id_pedido int auto_increment primary key,
	id_usuario int,
	fecha_pedido date,
	fecha_esperada date,
	fecha_entrega date,
	estado varchar(200),
	foreign key (id_usuario) references usuario (id_usuario)
);

create table lineas_pedido(
	id_pedido int,
	cod_producto int,
	cantidad int,
	precio_unidad decimal(5,2),
	num_linea int,
	primary key(id_pedido,cod_producto),
	foreign key(id_pedido) references pedidos(id_pedido),
	foreign key(cod_producto) references productos_nutricion(id_producto)
	
);

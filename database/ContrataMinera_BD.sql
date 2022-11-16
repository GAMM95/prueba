/* 
+
 * Database		:  ContrataMinera
 * Description	:  Base de Datos para la gestion administrativa
 * Author		:  Jhonatan Mantilla Miñano
 * Email		:  jhonatanmm.1995@gmail.com
 * Date			:  02-febrero-2022
 *
*/

use sys;
drop database if exists ContrataMinera;
create database ContrataMinera;
use ContrataMinera;

-- Counter table creation
create table contador (
 Tabla varchar (30) not null,
 Cantidad int not null,
 constraint PK_Contador primary key (Tabla)
);
-- Data dump for counter table
insert into contador values ('Cargos', 0);
insert into contador values ('Trabajadores', 0);
insert into contador Values ('Perfiles', 0);
insert into contador Values ('Licencias', 0);

-- Role table creation (user privileges)
create table rol(
 idRol int auto_increment not null,
 nombreRol varchar (30) not null,
 constraint pk_rol primary key (idRol)
);
insert into rol (nombreRol) values ('Administrador'),('Usuario'); -- volcado de roles o privilegios

-- Creacion de la tabla de usuarios 
create table usuario(
 idUsuario int auto_increment not null,
 username varchar (20) not null,
 password varchar (50) not null,
 nombre varchar (80) not null,
 email varchar (100) not null,
 lastSesion datetime null default '0000-00-00 00:00:00',
 idRol int not null,
 foto longblob,
 constraint pk_usuario primary key (idUsuario),
 constraint uq_usuario unique (username),
 constraint uq_nombre unique (nombre),
 constraint fk_usuario_rol foreign key (idRol)
 references rol (idRol)
 on delete restrict
 on update cascade
);

create view listar_usuarios as
select username, nombre, email, lastSesion, nombreRol from usuario u
inner join rol r on r.idRol = u.idRol;

truncate table usuario;
select * from usuario;
alter table usuario auto_increment = 1;

-- Creacion de la tabla empresa
create table empresa(
   codEmpresa int auto_increment not null,
   ruc char (11) not null,
   razonSocial varchar (60) not null,
   ciiu char (5) null,
   telefono char (9) null,
   celular char (9) null,
   direccionLegal varchar (80) null,
   email varchar (50) null,
   paginaWeb varchar (30) null,
   logo longblob null,
   ruta varchar (100) null,
   constraint pk_codEmpresa primary key (codEmpresa)
);

insert into empresa (ruc, razonSocial, ciiu, telefono, celular, direccionLegal, email, paginaWeb)
values ('###########','########','#####','#########','#########','#################','#################','###########');

select * from empresa;
-- Procedimiento almacenado para registrar datos de la empresa
begin;
delimiter $$
create procedure usp_registrarEmpresa(
 p_ruc char (11),
 p_razonSocial varchar (60),
 p_ciiu char (5),
 p_telefono char (9),
 p_celular char (9),
 p_direccionLegal varchar (80),
 p_email	varchar (50),
 p_paginaWeb	varchar (30),
 p_logo longblob,
 p_ruta varchar (100)
)
begin 
  insert into empresa (ruc, razonSocial, ciiu, telefono, celular, direccionLegal, email, paginaWeb, logo, ruta)
  values (p_ruc, p_razonSocial, p_ciiu, p_telefono, p_celular, p_direccionLegal, p_email, p_paginaWeb, p_logo, p_ruta);
end$$
delimiter ;
call usp_registrarEmpresa ('','','','','','','','','','');

-- Creacion de la tabla cargo
create table cargo(
	codCargo	int  auto_increment not null,
	nombreCargo	varchar		(30)	not null,
	categoria	varchar		(10)	not null,
	constraint pk_cargo primary key (codCargo),
	constraint uq_nombreCargo unique (nombreCargo)
);
select * from cargo;
-- Creacion de vistas para mostrar cargos
create view listar_cargos as
select codCargo, nombreCargo, categoria from cargo;

create view listar_cargos_dialog as
select codCargo, nombreCargo from cargo;

-- Worker table creation
create table trabajador(
  idTrabajador int auto_increment not null,
  dni char (8) not null,
  apePaterno varchar (15) not null,
  apeMaterno varchar (15) not null,
  nombres varchar (30) not null,
  sexo varchar (10) not null,
  estadoCivil varchar (15) not null,
  fechaNacimiento date not null,
  direccion varchar (50) not null,
  telefono char (9) not null,
  gradoInstruccion varchar (20) not null,
  profesion varchar (35) null,
  foto longblob null,
  estado varchar (20) null default 'Activo',
  codCargo int not null,
  constraint pk_trabajador primary key (idTrabajador),
  constraint uq_dni unique (dni),
  constraint uq_telefono unique (telefono),
  constraint fk_cargo_trabajador foreign key (codCargo) references cargo(codCargo)
  on delete restrict
  on update cascade
);

-- Creacion de vistas relacionadas al trabajador
create view listar_trabajador as
select idTrabajador, dni, concat(apePaterno,' ',apeMaterno,' ', nombres) as Trabajador, direccion, telefono, nombreCargo, estado from trabajador t 
inner join cargo c on c.codCargo = t.codCargo;

create view listar_trabajador_dialog as
select idTrabajador, dni, concat(apePaterno,' ',apeMaterno,' ', nombres) as Trabajador from trabajador; 


create view listar_cargo_trabajador as
select  nombreCargo, categoria ,concat(apePaterno,' ', apeMaterno,' ',nombres) as Trabajador, estado from cargo c 
inner join trabajador t on t.codCargo = c.codCargo;

create table perfilLaboral(
	codPerfil int auto_increment not null,
	fechaIngreso date not null,
	area varchar (20) not null,		
	sueldo decimal (8,2) not null,
	fechaCese date null,	
	motivoCese varchar (60) null,
	idTrabajador int not null,	
	CONSTRAINT pk_perfil PRIMARY KEY (codPerfil),
	CONSTRAINT fk_trabajador_contrato FOREIGN KEY (idTrabajador)
	REFERENCES trabajador(idTrabajador)
	on delete restrict
	on update cascade
);

create table licencia(
  codLicencia int auto_increment not null,
  numLicencia char (9) not null,
  categoria varchar (5) not null,
  fechaExpedicion	date not null,				
  fechaRevalidacion date not null,			
  idTrabajador int not null,			
  CONSTRAINT pk_licencia PRIMARY KEY (codLicencia),
  CONSTRAINT uq_licencia UNIQUE (numLicencia),
  CONSTRAINT fk_trabajador_licencia FOREIGN KEY (idTrabajador)
  REFERENCES trabajador(idTrabajador)
  on delete restrict
  on update cascade
);



create table tipo_vehiculo(
	codTipo		int  auto_increment not null,
	nombreTipo		varchar		(20)	NOT NULL,
	CONSTRAINT pk_tipo PRIMARY KEY (codTipo),
	CONSTRAINT uq_nombreTipo UNIQUE (nombreTipo)
);

create table vehiculo(
	codVehiculo		int  auto_increment not null,
	idVehiculo		VARCHAR(5)	NOT NULL,
	placa			VARCHAR(7)	NOT NULL,
	modelo			VARCHAR(15) NOT NULL,
	marca			VARCHAR(15)	NOT NULL,
	fechaIngreso	DATE		NOT NULL,
	año				CHAR(4)		NULL,
	codTipo			int not null,
	CONSTRAINT pk_vehiculo PRIMARY KEY (codVehiculo),
	CONSTRAINT uq_placa UNIQUE (placa),
	CONSTRAINT fk_tipoVehiculo_vehiculo FOREIGN KEY (codTipo)
	REFERENCES tipo_vehiculo(codTipo)
	on delete restrict
	on update cascade
);


## -------------------------------------------------------------------------------------------------------------------- ##
## PROCEDIMIENTOS ALMACENADOS ##
-- Procedimiento para registrar usuario
begin;
drop procedure if exists usp_registrar_usuario$$
delimiter $$
create procedure usp_registrar_usuario (
	in p_username 	varchar	(20), 
	in p_password	varchar (50),
    in p_nombre	  	varchar	(80),
    in p_email	  	varchar	(100),
    in p_idRol		int,
    in p_foto		longblob
)
begin 
	INSERT INTO usuario(username, password, nombre, email, idRol, foto)
	VALUES(p_username,p_password,p_nombre,p_email, p_idRol, p_foto);
end$$
delimiter ;

## Procedimiento para cambiar de contraseña
BEGIN;
DROP PROCEDURE IF EXISTS usp_cambiarPass$$
DELIMITER $$
CREATE PROCEDURE usp_cambiarPass (
	IN p_username VARCHAR(20),  
    IN p_password VARCHAR(50)
)
BEGIN 
	-- Actualizar cargo registrado
	UPDATE usuario SET password = p_password
	WHERE username = p_username;
END$$
DELIMITER ;

## Procedimiento para actualizar cuenta del usuario
begin;
drop procedure if exists usp_actualizar_cuenta$$
delimiter $$
create procedure usp_actualizar_cuenta (
	in p_username 	varchar	(20),
    in p_password	varchar	(50), 
	in p_nombre 	varchar (80), 
    in p_email 		varchar	(100)
)
begin 
	-- Actualizar cuenta de usuario
	UPDATE usuario SET password = p_password, p_nombre = p_nombre, email = p_email
	WHERE username = p_username;
end$$
delimiter ;

 ## Procedimiento para registrar cargo
begin;
drop procedure if exists usp_registrar_cargo$$
delimiter $$
create procedure usp_registrar_cargo (
	in p_nombreCargo 	varchar		(50),  
	in p_categoria 		varchar 	(50) 
)
begin 
	declare contador int; 
    declare exit handler for sqlexception, sqlwarning, not found
    begin
		rollback; -- Cancela la transacción
		resignal; -- Propaga el error    
	end;
	start transaction; -- Iniciar Transacción
    -- Actualizar la tabla contador
	update contador set Cantidad = Cantidad + 1
    where Tabla = 'Cargos';
    SELECT contador = Cantidad
	FROM contador WHERE Tabla='Cargos';
    -- Insertar nuevo cargo
	INSERT INTO cargo(nombreCargo,categoria)
	VALUES(p_nombreCargo,p_categoria);
  commit;
end$$
delimiter ;

select * from cargo;
truncate table cargo;
alter table cargo auto_increment =1;
create view listar_cargos as
select codCargo, nombreCargo, categoria from cargo;

select * from trabajador;
-- Procedimiento para registrar trabajador
begin;
drop procedure if exists usp_registrar_trabajador$$
delimiter $$
create procedure usp_registrar_trabajador (
	IN p_dni 			CHAR	(8),  -- dni del trabajador
	IN p_apePaterno		VARCHAR	(15), -- apellido Paterno del trabajador
    IN p_apeMaterno		VARCHAR	(15), -- apellido Materno del trabajador
	IN p_nombres		VARCHAR (50), -- nombres del trabajador
    IN p_sexo			VARCHAR	(10), -- genero del trabajador
	IN p_estadoCivil	VARCHAR	(15), -- estado civil del trabajador
	IN p_fechaNacimiento		DATE, -- fecha de nacimiento
	IN p_direccion		VARCHAR	(80), -- direccion domiciliaria
	IN p_telefono		CHAR	(9),  -- telefono del trabajador
	IN p_instruccion	VARCHAR (30), -- grado de instruccion
	IN p_profesion		VARCHAR	(50), -- profesion
    IN p_foto			longblob,	  -- foto del trabajador
	IN p_cargo			INT			  -- codigo del cargo del trabajador
)
begin 
	declare contador int; 
    declare exit handler for sqlexception, sqlwarning, not found
    begin
		rollback; -- Cancela la transacción
		resignal; -- Propaga el error    
	end;
	start transaction; -- Iniciar Transacción
    -- Actualizar la tabla contador
	update contador set Cantidad = Cantidad + 1
    where Tabla = 'Trabajadores';
    SELECT contador = Cantidad
	FROM contador WHERE Tabla='Trabajadores';
    -- Insertar nuevo cargo
		INSERT INTO trabajador(dni, apePaterno, apeMaterno, nombres, sexo, estadoCivil,fechaNacimiento, direccion, telefono, gradoInstruccion, profesion, foto, codCargo)
		VALUES(p_dni,p_apePaterno, p_apeMaterno, p_nombres, p_sexo, p_estadoCivil, p_fechaNacimiento, p_direccion, p_telefono, p_instruccion, p_profesion, p_foto, p_cargo);
  commit;
end$$
delimiter ;

create view listar_trabajadores as
select dni, concat(apePaterno, ' ', apeMaterno, ' ', nombres) Trabajador, direccion, telefono, nombreCargo from trabajador t 
inner join cargo c on c.codCargo = t.codCargo;


begin;
delimiter $$
create procedure usp_registrarEmpresa(
	p_ruc			char	(11),
    p_razonSocial 	varchar (60),
    p_ciiu			char(5),
    p_telefono		char(9),
    p_celular		char(9),
    p_direccionLegal 	varchar(80),
    p_email			varchar(50),
    p_paginaWeb		varchar(30),
    p_logo			longblob
)
begin 
	insert into empresa (ruc, razonSocial, ciiu, telefono, celular, direccionLegal, email, paginaWeb, logo)
    values (p_ruc, p_razonSocial, p_ciiu, p_telefono, p_celular, p_direccionLegal, p_email, p_paginaWeb, p_logo);
end$$
delimiter ;

 -- Procedimiento para registrar perfiles laborales
BEGIN;
DROP PROCEDURE IF EXISTS usp_registrar_perfil$$
DELIMITER $$
CREATE PROCEDURE usp_registrar_perfil (
    IN p_fechaIngreso 	DATE , 			-- fecha de ingreso del trabajador
	IN p_area			VARCHAR	(20), 	-- area del trabajador
	IN p_sueldo			DECIMAL (8,2),  -- sueldo del trabajador
    IN p_fechaCese		DATE,	 		-- fecha de cese de labores del trabajador
	IN p_motivoCese		VARCHAR	(60), 	-- motivo de cese de labores del trabajador
	IN p_idTrabajador	INT			  	-- id del trabajador
)
BEGIN 
	declare contador int;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING, NOT FOUND
	BEGIN
		-- Cancela la transacción
		rollback;
		-- Propaga el error    
    RESIGNAL;
	END;
	-- Iniciar Transacción
	start transaction;
    -- Actualizar la tabla contador
	update contador
    set Cantidad  = Cantidad + 1
    where Tabla = 'Perfiles';
    SELECT contador = Cantidad
	FROM contador WHERE Tabla='Perfiles';
    -- Insertar nuevo contrato
	INSERT INTO perfilLaboral
    (fechaIngreso, area, sueldo, fechaCese, motivoCese, idTrabajador)
	VALUES(p_fechaIngreso,p_area, p_sueldo, p_fechaCese, p_motivoCese, p_idTrabajador);
  COMMIT;
END$$
DELIMITER ;

create view listar_perfiles as
select concat(apePaterno,' ', apeMaterno,' ',nombres) as Trabajador, fechaIngreso, area, sueldo, fechaCese, motivoCese from perfillaboral p
inner join trabajador t  on t.idTrabajador = p.idTrabajador;

SELECT numLicencia, l.categoria, CONCAT(apellidos, ' ', nombres) as Trabajador, nombre,fechaExpedicion, fechaRevalidacion
	FROM licencia l 
	inner join trabajador t on t.idTrabajador = l.idTrabajador
    inner join cargo car on car.codCargo = t.codCargo
	order by codLicencia;
    
## PROCEDIMIENTO ALMACENADO PARA REGISTRAR LICENCIAS DE CONDUCIR
begin;
drop procedure if exists usp_registrar_licencia$$
DELIMITER $$
create procedure usp_registrar_licencia (
    in p_numLicencia		CHAR(9) , 	-- numero de licencia
	in p_categoria			VARCHAR(5),	-- categoria de la licencia
	in p_fechaExpedicion	DATE,  		-- sueldo del trabajador
    in p_fechaRevalidacion	DATE,	 	-- fecha de cese de labores del trabajador
	in p_idTrabajador		INT			-- id del trabajador
)
begin 
	declare contador int;
	declare exit handler for sqlexception, sqlwarning, not found 
    begin
		rollback; -- Cancela la transacción
		resignal;-- Propaga el error   
	end;
	start transaction;-- Iniciar Transacción
    -- Actualizar la tabla contador
	update contador
    set Cantidad  = Cantidad + 1
    where Tabla = 'Licencias';
    select contador = Cantidad
	FROM contador WHERE Tabla='Licencias';
    -- Insertar nueva licencia
	insert into licencia (numLicencia,categoria,fechaExpedicion,fechaRevalidacion,idTrabajador)
    values  (p_numLicencia,p_categoria,p_fechaExpedicion,p_fechaRevalidacion,p_idTrabajador);
    commit;
end$$
DELIMITER ;

select username,password,nombre,email from usuario where username='admin';

select * from cargo;
select * from trabajador	;
truncate table trabajador;
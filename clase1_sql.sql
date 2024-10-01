














-- linea de comentario

/* este es
un comentario*/

-- optimizar el código
IF DB_ID('Cibernarium') IS NULL
BEGIN	
	-- si es nulo significa que no existe
	CREATE DATABASE Cibernarium
	PRINT('Se creó LA BBDD Cibernarium con éxito')
END;
GO

--- vamos a eliminar la bbdd
USE master
DROP DATABASE Cibernarium
GO
-- eliminar
IF DB_ID('Cibernarium') IS NOT NULL
BEGIN
	USE master
	DROP DATABASE Cibernarium
	PRINT('Se ha borrado la BBDD Cibernarium')
END;
GO


-- crear un bbdd con configuarición personalizada

IF DB_ID('Cibernarium') IS NULL
BEGIN
	CREATE DATABASE Cibernarium
	ON PRIMARY (
		NAME = Cibernarium,
		FILENAME = 'C:\temp\SQL\Cibernarium.mdf', 
		SIZE = 10MB, --tamaño inicial
		MAXSIZE = 100MB, --tamaño máximo de la BBDD
		FILEGROWTH = 10% -- INCREMENTO AL ALCANZAR EL MÁXIMO

	)
	LOG ON (
	NAME = Cibernarium_log,
		FILENAME = 'C:\temp\SQL\Cibernarium_log.ldf', 
		SIZE = 5MB, --tamaño inicial
		MAXSIZE = 50MB, --tamaño máximo de la BBDD
		FILEGROWTH = 10% -- INCREMENTO AL ALCANZAR EL MÁXIMO
	)
END;
GO

-- modificar el incremento de la BBDD con alter
ALTER DATABASE Cibernarium
MODIFY FILE (
	NAME = N'Cibernarium', 
	FILEGROWTH = 15%
);
GO

-- crear una tabla en la BBDD Cibernarium
USE Cibernarium;  -- para activar una base de datos 

CREATE TABLE Productos(
	idproducto INT PRIMARY KEY IDENTITY(1,1),
	nombre VARCHAR(50) NOT NULL,
	descripcion VARCHAR(100), 
	codigo CHAR(10) NOT NULL, --CHAR RESERVA UN NUMERO DE CARACTERES
	precio_ud DECIMAL(10,2) DEFAULT 0, -- POR DEFECTO SI NO HAY VALOR, COLOCA UN 0
	fecha_alta DATE 
	) 
PRINT('Tabla productos creada con éxito');

-- como añadir un campo a la tabla productos
USE Cibernarium
--
ALTER TABLE Productos
ADD stock DECIMAL(10,3);

-- MODIFICAR UN CAMPO
USE Cibernarium
ALTER TABLE Productos
ALTER COLUMN nombre VARCHAR(75);

-- COMO ELIMINAR UNA COLUMNA
USE Cibernarium
ALTER TABLE Productos
DROP COLUMN fecha_alta;

--cambiar el nombre de un campo
--store procedures (procedimientos almacenados)
-- un procedimineto de sistema se llama EXEC
USE Cibernarium
EXEC sp_rename 'Productos.nombre', 'nombre_productos', 'COLUMN';

--como eliminar una tabla con comprobacion
IF OBJECT_ID('Productos', 'U') IS NOT NULL --esa U?
BEGIN
	DROP TABLE Productos
		PRINT('conseguido')
END;

--DESCARGAR UNA BASE DE DATOS EN ACCESS E IMPORTAR 

/** CREAR UN STORE PROCEDURE QUE INCREMENTE EL VALOR DEL 
IMPORTE DE LA TABLA FACTURAS SEGUN UNA VARIABLE, 
Y QUE LO EJECUTE EN FUNCIÓN DEL IdFactura INDICADO Y
DEL VALOR DEL IMPORTE A INCREMENTAR

EXEC spnombre
     @IdFactura = 5,
     @Incremento = 15

VER EL REGISTRO QUE SE HA MODIFICADO.**/
USE Neptuno;
go

CREATE PROCEDURE modificarfactura
	@IdFactura INT,
	@Incremento DECIMAL(18,2)
AS
BEGIN 
	UPDATE Facturas
	SET Importe = Importe + @Incremento
	WHERE IdFactura = @IdFactura;
	-- MOSTRAR EL REGISTRO
	SELECT * FROM Facturas WHERE IdFactura = @IdFactura;
END;
GO

EXEC modificarfactura 9, 50
-- DESACTIVAR UN TRIGGER
DISABLE TRIGGER MFacturas ON Facturas;

/** CREAR UN STORE PROCEDURE QUE INCREMENTE EL VALOR DEL 
IMPORTE DE LA TABLA FACTURAS SEGUN UNA VARIABLE, 
Y QUE LO EJECUTE EN FUNCIÓN DEL IdFactura INDICADO Y
DEL VALOR DEL IMPORTE A INCREMENTAR

EXEC spnombre
     @IdFactura = 5,
     @Incremento = 15

VER EL REGISTRO QUE SE HA MODIFICADO.**/
CREATE PROCEDURE sp_addregistro
	@Fecha DATE,
	@Descripcion VARCHAR(100),
	@Usuario VARCHAR(10)
AS
BEGIN
	INSERT INTO Registro(Fecha, Descripcion, Usuario)
	VALUES (@Fecha, @Descripcion, @Usuario)
	-- OPCIONALMENTE DEVOLVER EN LA VARIABLE
	RETURN SCOPE_IDENTITY()
END;
GO
-- CREAR EL PROCEDIMIENTO PRINCIPAL
CREATE PROCEDURE sp_registraracumulado
	@Cliente VARCHAR(100),
	@Importe DECIMAL(18,2)
AS
BEGIN
	INSERT INTO Facturas(Cliente, Importe)
	VALUES (@Cliente, @Importe)
	-- Insertar el registro con el acumulado
	DECLARE @Acumulado DECIMAL(18,2)
	SET @Acumulado = (SELECT SUM(Importe) FROM Facturas)
	-- LLAMARE AL OTRO PROCEDIMIENTO QUE ES addREGISTRO
	INSERT INTO Registro(Fecha, Descripcion, Usuario)
	VALUES (GETDATE(), CONCAT('LA SUMA ES',@Acumulado), USER)
	-- MOSTRARE EL REGISTRO
	SELECT TOP(1) * FROM Registro ORDER BY IdRegistro DESC;
END;
GO
-- LLAMAR AL PROCEDIMIENTO
EXEC sp_registraracumulado 'Cliente 101', 2000

-- VARIANTE LLAMANDO PRIMERO A OTRO STORE PROCEDURE
-- CREAR EL PROCEDIMIENTO PRINCIPAL
CREATE PROCEDURE sp_registraracumulado2
	@Cliente VARCHAR(100),
	@Importe DECIMAL(18,2)
AS
BEGIN
	INSERT INTO Facturas(Cliente, Importe)
	VALUES (@Cliente, @Importe)
	-- Insertar el registro con el acumulado
	DECLARE @Acumulado DECIMAL(18,2)
	SET @Acumulado = (SELECT SUM(Importe) FROM Facturas)
	-- LLAMARE AL OTRO PROCEDIMIENTO QUE ES addREGISTRO
	DECLARE @Fecha DATE
	SET @Fecha = GETDATE()
	DECLARE @Descripcion VARCHAR(100)
	SET @Descripcion = CONCAT('Importe total acumulado',@Acumulado)
	DECLARE @Usuario VARCHAR(20)
	SET @Usuario = USER
	-- LLAMAR AL PROCEDIMIENTO DE AÑADIR REGISTRO
	EXEC sp_addregistro @Fecha,@Descripcion,@Usuario
END;
GO

-- LLAMAR AL PROCEDIMIENTO
EXEC sp_registraracumulado2 'Cliente 110', 5000
	-- MOSTRARE EL REGISTRO
	SELECT TOP(1) * FROM Registro ORDER BY IdRegistro DESC;



/**Mediante la tablas Pedidos y Detalles de Pedidos, CREAR
UN STORE PROCEDURE QUE NOS CREE UNA TABLA LLAMADA 
Resumen de Ventas CON 2 CAMPOS Pais e Importe Y LA TENDREMOS
QUE RELLENAR CON LOS IMPORTES = PRECIO * CANTIDAD AGRUPADO
POR PAIS

WARNING VIGILAR SI LA TABLA YA EXISTE 
IF OBJECT_ID(TABLA, 'U') IS NOT NULL - QUE SI EXISTE
ADEMAS VACIAR LA TABLA ANTES DE LLENARLA 
QUE NO TIENE PARAMETROS**/
ALTER PROCEDURE sp_resumenventas
AS
BEGIN
-- COMPROBAR SI LA TABLA EXISTE
IF OBJECT_ID('RESUMEN_VENTAS', 'U') IS NULL
BEGIN
	-- COMO NO ESTA Y POR ESO LA CREO
	CREATE TABLE RESUMEN_VENTAS (
	Pais VARCHAR(30),
	Importe DECIMAL(18,2)
	);
END;
	-- VACIAR LA TABLA PRIMERO
	DELETE FROM RESUMEN_VENTAS
	-- INSERTAR LOS VALORES
	INSERT INTO RESUMEN_VENTAS(Pais, Importe)
	SELECT P.PaísDestinatario, SUM(DP.PrecioUnidad*DP.Cantidad) AS Importe
	FROM Pedidos P, [Detalles de pedidos] DP
	WHERE P.IdPedido = DP.IdPedido
	GROUP BY P.PaísDestinatario
	-- MOSTRAR LA TABLA RESULTANTE
	SELECT * FROM RESUMEN_VENTAS ORDER BY Pais
END;
GO

EXEC sp_resumenventas


-- CREAR UNA VISTA
CREATE VIEW Pedidos_Alemania AS
SELECT
	P.FechaPedido,
	p.PaísDestinatario,
	P.IdCliente
FROM	
	Pedidos P
WHERE
	P.PaísDestinatario = 'Alemania';

	SELECT * FROM Pedidos_Alemania

	CREATE VIEW Pedidos_Alemania AS
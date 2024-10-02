-- SELECT selecciona registros y muestra las columnas indicadas con * todas las columnas
USE neptuno;
GO

-- seleccionar todo de una tabla
SELECT *
FROM Pedidos;
GO

--- algun campo
SELECT IdCliente,
	   Cargo,
	   FechaPedido
FROM Pedidos;
GO

-- alias de campo
SELECT FechaPedido AS Fecha
FROM Pedidos; 

-- en el predicado c�mo ordenar los datos
SELECT *
FROM Pedidos
ORDER BY FechaPedido DESC;  --ASC(por defecto) o DESC
GO

-- ordenar por mas de un campo, 
SELECT *
FROM Pedidos
ORDER BY FechaPedido DESC, IdCliente ASC; 
GO

--sujeto, quiero ver los �ltimos 20 pedidos seg�n la fecha, usar TOP
SELECT TOP(20) *
FROM Pedidos
ORDER BY FechaPedido DESC;
GO

--sujeto, quiero ver los 20 PRIMEROS pedidos seg�n la fecha, usar TOP
SELECT TOP(20) *
FROM Pedidos
ORDER BY FechaPedido ASC;
GO

-- en el sujeto puedo concatenar campos e incluso poner texto de manera manual
-- quiero ver junto el c�digo postal y la ciudad

SELECT ('C�digo ' + C�dPostalDestinatario+' '+CiudadDestinatario) AS Codigo
FROM Pedidos;
GO 

-- operaciones aritm�ticas en el sujeto nunca en el predicado
SELECT PrecioUnidad, Cantidad, (PrecioUnidad * Cantidad) AS importe
FROM [Detalles de pedidos];
GO 

-- la clausula WHERE sirve para 2 cosas o para filtar o para vinculas 2 tablas (join implicito)
-- el WHERE no se puede repetir , solo se pone una vez, si necesito
-- +1 de una condicion de filtrado o el AND o el OR 
SELECT *
FROM Pedidos
WHERE Pa�sDestinatario = 'Alemania';
GO 

-- queremos ver los registros de Alemania o Francia
SELECT *
FROM Pedidos
WHERE Pa�sDestinatario = 'Alemania' OR Pa�sDestinatario = 'Francia';
GO

-- ver los registros que son de Alemania y la forma de envio es igual a 3
SELECT *
FROM Pedidos
WHERE Pa�sDestinatario = 'Alemania'
	AND FormaEnv�o = 3;
GO

-- la primera funci�n de agregado, COUNT, nos devuelve el n�mero de registros
SELECT COUNT(*)
FROM Pedidos;

-- n�meros de pedidos en alemania
SELECT COUNT(*)
FROM Pedidos
WHERE Pa�sDestinatario = 'Alemania';
GO

-- una clausula que no hace falta que sea igual si no parecido, LIKE,
-- necesita un comodin en el caso de SQL server %

-- muestrame los paises cuyo nombre empiece por 'A'
SELECT *
FROM Pedidos
WHERE Pa�sDestinatario LIKE 'A%';
GO

-- ver los paises que terminan por 'A'
SELECT *
FROM Pedidos
WHERE Pa�sDestinatario LIKE '%A';
GO

-- ver paises cuyo nombre contiene una 'r'
SELECT *
FROM Pedidos
WHERE Pa�sDestinatario LIKE '%r%';
GO



-- poner funciones en el sujeto, quiero ver el a�o de la FechaPedido con YEAR
SELECT *, 
		YEAR(FechaPedido) AS a�o
FROM Pedidos;

-- si quiero ver el MES de la columna FechaPedido
SELECT *, 
		MONTH(FechaPedido) AS mes
FROM Pedidos;

-- obtener el mes y el a�o
-- convertir numero a texto con CAST
SELECT  ('MES ' + CAST(MONTH(FechaPedido) AS VARCHAR(2))) AS mes
FROM Pedidos;

-- funciones de texto LOWER Y UPPER (MINUS O MAYUS)
SELECT UPPER(Pa�sDestinatario) AS pais
FROM Pedidos;

-- vincular 2 tablas mediante un campo clave
-- sera clave principal y en otra clave secundaria
-- join implicito
SELECT *
FROM Pedidos,
[Detalles de pedidos]
WHERE Pedidos.IdPedido = [Detalles de pedidos].IdPedido
	AND Pedidos.Pa�sDestinatario = 'Alemania';

-- mediante las clausulas join inner join = devuleve las filas
-- que tienen coincidencia en ambas filas

SELECT *
FROM 
	Pedidos
INNER JOIN 
	[Detalles de pedidos]
ON Pedidos.IdPedido = [Detalles de pedidos].IdPedido


SELECT *
FROM 
	Pedidos AS p
INNER JOIN 
	[Detalles de pedidos] AS dp
ON p.IdPedido = dp.IdPedido

SELECT p.Destinatario,
	   p.PaisDestinatario,

FROM 
	Pedidos AS p
INNER JOIN 
	[Detalles de pedidos] AS dp
ON p.IdPedido = dp.IdPedido

-- crear la tabla maestro y la tabla detalle 

SELECT *
FROM Maestro AS m
INNER JOIN Detalle AS d
ON m.IdMaestro = d.IdMaestro;

-- LEFT JOIN devulve todas las filas de la izquierda 
-- y las filas coincidentes de la derecha (abajo)

SELECT *
FROM 
	Maestro AS m
LEFT JOIN 
	Detalle AS d
ON m.IdMaestro = d.IdMaestro;

-- LEFT JOIN devulve todas las filas de la derecha (abajo) 
-- y las filas coincidentes de la izquirda (arriba)
SELECT *
FROM 
	Maestro AS m
RIGHT JOIN 
	Detalle AS d
ON m.IdMaestro = d.IdMaestro;

-- FULL OUTER JOIN devulve todas las filas (registros) cuando hay una coincidencia en las tablas
-- y si no hay coincidencias mostrar� nulo

SELECT *
FROM 
	Maestro AS m
FULL OUTER JOIN 
	Detalle AS d
ON m.IdMaestro = d.IdMaestro;

-- LEFT OUTER JOIN, registros que est�n en la tabla de la izq
-- pero no en la tabla de la derecha
SELECT *
FROM 
	Maestro AS m
LEFT JOIN 
	Detalle AS d
ON m.IdMaestro = d.IdMaestro
WHERE m.IdMaestro = IS NULL;

-- como insertar valores a una tabla
INSERT INTO Maestro(IdMaestro,Valor1)
VALUES (8, 'Lleno');

-- como insertar varios valores a una tabla 
INSERT INTO Maestro(IdMaestro, Valor1)
VALUES (9, 'lleno'),
	   (10, 'lleno'),
	   (11, 'lleno');

-- como insertar valores a una tabla desde otra tabla
INSERT INTO MaestroBis(IdMaestro, Valor1)
SELECT IdMaestro, Valor1
FROM Maestro;

-- vaciar o elimnar las filas de la tabla MaestroBis
DELETE FROM MaestroBis; -- borra los registros 


-- como insertar valores a una tabla desde otra tabla
INSERT INTO MaestroBis(IdMaestro, Valor1)
SELECT IdMaestro, Valor1
FROM Maestro
WHERE IdMaestro >4;

-- funciones de resumen o de agregado, COUNT(cuenta filas)
-- SUM(suma los valores de una columna, siempre que sea n�mero)
-- AVERAGE (promedio de valores), MAX(valor m�s grande)
-- MIN (valor m�s peque�o)

SELECT p.Pa�sDestinatario,
	   p.CiudadDestinatario,
	   SUM(dp.PrecioUnidad * dp.Cantidad) AS importe,
	   SUM(dp.Cantidad) AS cantidad_total,
	   MAX(dp.cantidad) AS cantidad_mayor
	   
FROM	
	Pedidos AS p
INNER JOIN 
	[Detalles de pedidos] AS dp
ON 
p.IdPedido = dp.IdPedido
GROUP BY p.Pa�sDestinatario, p.CiudadDestinatario;

-- Clausula HAVING para filtrar las funciones de agregaci�n


SELECT p.Pa�sDestinatario,
	   p.CiudadDestinatario,
	   SUM(dp.PrecioUnidad * dp.Cantidad) AS importe,
	   SUM(dp.Cantidad) AS cantidad_total,
	   MAX(dp.cantidad) AS cantidad_mayor
	   
FROM	
	Pedidos AS p
INNER JOIN 
	[Detalles de pedidos] AS dp
ON 
p.IdPedido = dp.IdPedido
GROUP BY p.Pa�sDestinatario, p.CiudadDestinatario
HAVING p.Pa�sDestinatario <> 'Alemania';


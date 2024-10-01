-- la sentencia SELECT
-- tiene dos partes, sujeto y predicado
--  el sujeto está antes del FROM y el predicado depués del FROM

USE neptuno
SELECT * 
FROM Pedidos;

-- En el sujeto el (*) significa todos los campos 

SELECT IdCliente, 
	   FechaPedido,
	   Cargo
FROM Pedidos;

--como trabajar con el alias para simplificar el codigo
SELECT p.IdCliente
FROM Pedidos AS p;

-- alias de campo o columna 
SELECT Destinatario AS Cliente
FROM Pedidos;
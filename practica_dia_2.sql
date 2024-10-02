-- práctica 1

-- ver la cantidad de registros de la tabla Pedidos cuyo nombre de ciudad contenga 
-- la letra s
SELECT COUNT(*) registros_ciudad_s
FROM Pedidos
WHERE CiudadDestinatario LIKE '%s%';
GO


-- ver en mayusculas el nombre del destinatario de la tabla pedidos cuya forma de envio sea
-- 1 o 3
SELECT *,
		UPPER(Destinatario) AS nombre_mayus
FROM Pedidos
WHERE FormaEnvío  = 1 
	OR FormaEnvío = 3;
GO


-- ver los registros de la tabla detalles de pedidos con el campo calcuado importe(precio * cantidad)
-- siempre que la cantidad sea mayor a 20 
SELECT *, 
	(PrecioUnidad * Cantidad) AS importe_total
FROM [Detalles de pedidos]
WHERE Cantidad > 20;
GO


-- ver un campo calculado que nos de el dia y mes de la fecha pedido separado por un guión 
-- mas el campo destinatario de los destinatarios cuyo nombre acabe en A y la forma de envio 
-- igual a 1

SELECT Destinatario,
		CAST(DAY(FechaPedido) AS VARCHAR (2))+'-'+
		CAST(MONTH(FechaPedido)AS VARCHAR (2)) AS 'dia-mes'
		
FROM Pedidos
WHERE Destinatario LIKE '%A'
	AND FormaEnvío = 1;
GO



-- aprovechando pedidos y detalle de pedidos
-- ver el promedio de importe (preciounidad * cantidad)
-- por ciudaddestinatario, siempre que la suma de la cantidad sea menor de 30

SELECT  p.CiudadDestinatario,
		AVG(dp.PrecioUnidad * dp.Cantidad) AS importe_promedio_ciudad

FROM 
	Pedidos AS p
LEFT JOIN 
	[Detalles de pedidos] AS dp
ON p.IdPedido = dp.IdPedido
GROUP BY p.CiudadDestinatario
HAVING 
	SUM(dp.Cantidad)< 30;


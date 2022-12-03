CREATE DATABASE Northwind
USE Northwind

--Primer ejemplo

CREATE PROCEDURE customerslist
AS 
BEGIN --OPCIONAL PERO ES UNA BUENA PRACTICA 
	SELECT CompanyName, ContactName
	FROM Customers ORDER BY CompanyName
END;

--ejecutar procedimiento
EXECUTE customerslist;
EXEC customerslist --forma corta 

--Modificar procedimiento
ALTER PROCEDURE customerslist
@city NVARCHAR (5),
@cName NVARCHAR (5) = '' --parametro opcional
AS 
BEGIN	
	SELECT CompanyName, ContactName, City
	FROM Customers 
	WHERE City LIKE @city+'%' 
	AND CompanyName LIKE @cName+'%'
	ORDER BY CompanyName
END;

EXEC customerslist @city='M'
EXEC customerslist 'M', 'A'

--INSERTAR REGISTROS A TRAVES DE UN PROCEDIMIENTO
CREATE PROCEDURE saceCostumer (
@cID NVARCHAR (5), @cName NVARCHAR(40)
)
AS 
	IF(SELECT COUNT(*) FROM Customers
	WHERE CustomerID=@cID OR CompanyName=@cName)=0
	--SI EL RESULTADO DA 0 GUARDARA EL REGISTRO
	INSERT INTO Customers(CustomerID,CompanyName)
		VALUES(@cID,@cName)
	ELSE 
		PRINT 'El cliente ya esta registrado'

EXEC saceCostumer'C01N', 'Customer 1';
EXEC saceCostumer 'ANTON','Customer 2';
EXEC saceCostumer 'C02N', 'Around the Horn';

--Primer ejercicio: Crear un procedimiento que guardo un nuevo registro en la tabla region
CREATE PROCEDURE guardarregion (
@rID INT, @dRE NVARCHAR(50)
)
AS 
	IF(SELECT COUNT(*) FROM Region
	WHERE RegionID=@rID OR RegionDescription=@dRE)=0
	INSERT INTO Region(RegionID,RegionDescription)
		VALUES(@rID,@dRE)
	ELSE
		PRINT 'Esta region esta registrada'

EXEC guardarregion'1','Eastern'
EXEC guardarregion'3','Northern'
EXEC guardarregion'6','Southern'

--obtener parametro de salida 
CREATE PROCEDURE getProducts(
@nProduct AS NVARCHAR(10),
@totalP INT OUTPUT --Parametro de salida
)
AS 
	SELECT ProductName, UnitPrice FROM Products
	WHERE ProductName LIKE @nProduct+'%'
	SELECT @totalP = @@ROWCOUNT

--Definir una variable para almacenar el valor de retorno
DECLARE @total INT;
EXEC getProducts 'a',@total OUTPUT;
SELECT @total AS 'Cantidad de Productos'

--Segundo Ejercicio: Mostrar a traves de un parametro de salida cuantos empleados viven en Londo
CREATE PROCEDURE emLondon( 
@eL AS NVARCHAR (10),
@totalE INT OUTPUT
)
AS 
	SELECT EmployeeID, FirstName, LastName FROM Employees --
	WHERE City = @eL
	SELECT @totalE=@@ROWCOUNT

DECLARE @totalEL INT;
EXEC emLondon'London', @totalEL OUTPUT;
SELECT @totalEL AS 'Empleados que viven en London'

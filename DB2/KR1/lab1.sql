CREATE DATABASE DB2
GO
use DB2
CREATE TABLE Studio(
	ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
	Country char(2) NOT NULL,
	Name varchar(40) NOT NULL
)
CREATE TABLE VHS(
	ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
	Inventory_Number int NOT NULL UNIQUE,
	Director varchar(40),
	StudioID int FOREIGN KEY REFERENCES Studio(ID)
)
CREATE TABLE Client(
	ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
	LastName varchar(40),
	Adress varchar(100)
)
CREATE TABLE Rent(
	ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
	StartDate DateTime NOT NULL,
	ReturnDate DateTime DEFAULT(NULL),
	VHS_ID int NOT NULL FOREIGN KEY REFERENCES VHS(ID),
	ClientID int NOT NULL FOREIGN KEY REFERENCES Client(ID)
)

GO

CREATE PROCEDURE dbo.GetDirectorRents @Director varchar(40)
AS
SELECT 
CASE COUNT(*)
WHEN 0 THEN 'No'
ELSE 'Yes'
END
FROM Rent
JOIN VHS ON Rent.VHS_ID = VHS.ID
WHERE Director = @Director

GO

DROP PROCEDURE dbo.StudioCurrentRented
GO

CREATE PROCEDURE dbo.StudioCurrentRented @StudioName varchar(40)
AS
SELECT COUNT(Rent.ID) FROM Rent
JOIN VHS ON Rent.VHS_ID = VHS.ID
JOIN Studio ON VHS.StudioID = Studio.ID
WHERE Studio.Name LIKE @StudioName AND Rent.ReturnDate IS NULL

GO
DROP PROCEDURE dbo.MostActiveClients
GO

CREATE PROCEDURE dbo.MostActiveClients
AS
SELECT LastName,COUNT(Rent.ID) FROM Client
JOIN Rent ON Rent.ClientID = Client.ID
GROUP BY Client.ID, LastName
ORDER BY COUNT(Rent.ID) DESC

GO
DROP PROCEDURE dbo.GetUnusedVHS
GO

CREATE PROCEDURE dbo.GetUnusedVHS
AS
SELECT * FROM VHS
WHERE ID NOT IN
(SELECT VHS_ID FROM Rent)
GO
DROP PROCEDURE dbo.VHSByCountry
GO
CREATE PROCEDURE dbo.VHSByCountry
AS
SELECT Country, Count(VHS.ID) FROM Studio
LEFT JOIN VHS ON VHS.StudioID = Studio.ID
GROUP BY Country

GO
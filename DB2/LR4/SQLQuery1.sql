USE master
GO
DROP DATABASE LR4
GO
CREATE DATABASE LR4
GO
USE LR4
GO

-- task 1.1
-- Запит з PIVOT з використанням однієї агрегатної функції та 3-5 стовпчиками
-- Виводить кількість касет кожного режисера

CREATE TABLE VHS(
	ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
	Director varchar(40),
	Name varchar(40)
)

INSERT INTO VHS VALUES
	('Martin Scorsese','The Wolf of Wall Street'),
	('Martin Scorsese','Goodfellas'),
	('Martin Scorsese','Shutter Island'),
	('Martin Scorsese','The Departed'),
	('Alfred Hitchcock','Psycho'),
	('Alfred Hitchcock','Vertigo'),
	('Alfred Hitchcock','Rear Window'),
	('Steven Spielberg','Saving Private Ryan'),
	('Steven Spielberg','Schindlers List'),
	('Roman Polanski','The Pianist'),
	('Roman Polanski','Rosemarys Baby'),
	('Roman Polanski','Chinatown')

SELECT * FROM
(
	SELECT Director, ID
	FROM VHS
) AS Original
PIVOT
(
	COUNT(ID)
	FOR Director 
	IN ([Martin Scorsese],[Alfred Hitchcock],[Steven Spielberg],[Roman Polanski])
) AS Pivoted

-- task 1.2
-- Запит з PIVOT з використанням двох агрегатних функцій та 3-5 стовпчика
-- Виводить середню кількість прокатів касет кожного режисера

CREATE TABLE Rent(
	ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
	StartDate DateTime NOT NULL,
	ReturnDate DateTime DEFAULT(NULL),
	VHS_ID int NOT NULL FOREIGN KEY REFERENCES VHS(ID)
)

INSERT INTO Rent VALUES
	('2017-09-15 00:00:00.000',  '2017-09-20 00:00:00.000',  8 ),
	('2016-10-17 00:00:00.000',  '2016-10-27 00:00:00.000',  1 ),
	('2017-10-12 00:00:00.000',  '2017-10-21 00:00:00.000',  4 ),
	('2017-10-22 00:00:00.000',  NULL,                       6 ),
	('2017-10-20 00:00:00.000',  NULL,                       4 ),
	('2016-10-11 00:00:00.000',  '2017-10-11 00:00:00.000',  3 ),
	('2017-07-12 00:00:00.000',  '2017-08-02 00:00:00.000',  12),
	('2017-10-13 00:00:00.000',  NULL,                       1 ),
	('2016-10-14 00:00:00.000',  NULL,                       6 ),
	('2017-10-15 00:00:00.000',  '2017-10-22 00:00:00.000',  3 ),
	('2016-10-16 00:00:00.000',  '2016-10-17 00:00:00.000',  10)

SELECT * FROM
(
	SELECT Director, 1.0*COUNT(Rent.ID) AS [VHS Rents]
	FROM VHS
	LEFT JOIN Rent ON VHS.ID = Rent.VHS_ID
	GROUP BY VHS.ID, Director
) AS Original
PIVOT
(
	SUM([VHS Rents]),
	AVG([VHS Rents])
	FOR Director 
	IN ([Martin Scorsese],[Alfred Hitchcock],[Steven Spielberg],[Roman Polanski])
) AS Pivoted

-- task 1.3
-- Запит з UNPIVOT.
-- Розбиття рядку з данними на декілька

SELECT 
	COUNT(CASE WHEN Year(ReturnDate) = 2016 THEN 1 ELSE NULL END) AS [2016], 
	COUNT(CASE WHEN Year(ReturnDate) = 2017 THEN 1 ELSE NULL END) AS [2017], 
	COUNT(CASE WHEN Year(ReturnDate) IS NULL THEN 1 ELSE NULL END) AS [NULL]
INTO ReturnsByYear
FROM Rent

SELECT Year, Returns FROM
(
	SELECT *
	FROM ReturnsByYear
) AS Original
UNPIVOT
(
	[Returns] FOR [Year] IN ([2016],[2017],[NULL])
) AS Unpivoted

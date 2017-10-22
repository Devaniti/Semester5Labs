USE master
GO
DROP DATABASE LR1
GO
CREATE DATABASE LR1
GO
USE LR1;

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
	Adress varchar(100),
	Birthday varchar(100),
	RegDate datetime DEFAULT(GetDate())
)

CREATE TABLE Rent(
	ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
	StartDate DateTime NOT NULL,
	ReturnDate DateTime DEFAULT(NULL),
	VHS_ID int NOT NULL FOREIGN KEY REFERENCES VHS(ID),
	ClientID int NOT NULL
)

INSERT INTO [dbo].[Client]
           (LastName,Adress,Birthday)
     VALUES
           ('Pupkin Vitalii'   ,'Kiev'  ,'30 June'     ),
           ('Petia Andrusuchn' ,'Moscow','15 July'     ),
           ('Russel Gogh'      ,'Kiev'  ,'10 August'   ),
           ('Andrew Laurence'  ,'Odessa','23 September'),
		   ('Petia Lait'       ,'Kiev'  ,'12 December' )


INSERT INTO [dbo].[Studio]
           ([Country]
           ,[Name])
     VALUES
           ('UA','UAFilms'    ),
           ('RU','RUFilms'    ),
           ('US','USFilms'    ),
           ('US','USFilms2'   ),
           ('LT','LithuaFilms')
USE [LR1]
GO

INSERT INTO [dbo].[VHS]
           ([Inventory_Number]
           ,[Director]
           ,[StudioID])
     VALUES
		(0         ,'Some Guy',            1),
		(12376123  ,'Some Other Guy',      1),
		(123761823 ,'Some Other Guy',      1),
		(27612823  ,'Russia Guy',          2),
		(27623823  ,'Russia Guy',          2),
		(27622873  ,'Bad Director',        2),
		(2321873   ,'Cool director',       3),
		(23323813  ,'Cool director',       3),
		(23323378  ,'Cool director',       3),
		(23323323  ,'Cool director',       3),
		(948323    ,'Other cool director', 4),
		(94832323  ,'Third cool director', 4)

USE [LR1]
GO

INSERT INTO [dbo].[Rent]
           ([StartDate]
           ,[ReturnDate]
           ,[VHS_ID]
           ,[ClientID])
     VALUES
		('2017-09-15 00:00:00.000',  '2017-09-20 00:00:00.000',  8 ,1  ),
		('2016-10-17 00:00:00.000',  '2016-10-27 00:00:00.000',  1 ,3  ),
		('2017-10-12 00:00:00.000',  '2017-10-21 00:00:00.000',  4 ,1  ),
		('2017-10-22 00:00:00.000',  NULL,                       6 ,1  ),
		('2017-10-20 00:00:00.000',  NULL,                       8 ,3  ),
		('2016-10-11 00:00:00.000',  '2017-10-11 00:00:00.000',  3 ,1  ),
		('2017-07-12 00:00:00.000',  '2017-08-02 00:00:00.000',  12,2  ),
		('2017-10-13 00:00:00.000',  NULL,                       1 ,3  ),
		('2016-10-14 00:00:00.000',  NULL,                       6 ,3  ),
		('2017-10-15 00:00:00.000',  '2017-10-22 00:00:00.000',  3 ,3  ),
		('2016-10-16 00:00:00.000',  '2016-10-17 00:00:00.000',  10,4  )



-- 1.1 �������������� count() (��� ����-��� ���� ��������� �������), partition
-- by, order by �� �����, �� ����� ����� ����� ���������, ��� ��
-- ������������ �������� �������.

-- ϳ������� ������� ����� ����� ������������

SELECT DISTINCT Adress, COUNT(*) OVER (PARTITION BY Adress) AS 'Adress count' 
FROM Client
ORDER BY 'Adress count' DESC

SELECT Adress, COUNT(Adress) AS 'Adress count' 
FROM Client
GROUP BY Adress
ORDER BY 'Adress count' DESC

-- 1.2 �������������� rank() ��� dense_rank(), partition by, order by �� �����, ��
-- ����� ����� ����� ���������, ��� �� ������������ �������� �������.

-- ϳ������� ���� ������� ��������� �볺��� �� ������

SELECT Client.LastName, COUNT(VHS.ID) AS 'VHS count', RANK() OVER (PARTITION BY VHS.StudioID ORDER BY COUNT(VHS.ID) DESC) AS 'Rank', Studio.Name AS 'Studio Name'
FROM Client 
JOIN Rent ON Rent.ClientID = Client.ID
JOIN VHS ON VHS.ID = Rent.VHS_ID
JOIN Studio ON Studio.ID = VHS.StudioID 
GROUP BY Client.ID, Client.LastName, VHS.StudioID, Studio.Name
ORDER BY VHS.StudioID,'VHS count' DESC

SELECT C.LastName, COUNT(V.ID) AS 'VHS count', 
(SELECT COUNT(*)+1 FROM 
(SELECT COUNT(V.ID) q 
FROM Client 
JOIN Rent ON Rent.ClientID = Client.ID
JOIN VHS ON VHS.ID = Rent.VHS_ID
WHERE VHS.StudioID = V.StudioID  GROUP BY ClientID HAVING COUNT(V.ID)<COUNT(VHS.ID)  )
e) AS 'Rank',
S.Name AS 'Studio Name'
FROM Client AS C
JOIN Rent AS R ON R.ClientID = C.ID 
JOIN VHS AS V ON V.ID = R.VHS_ID
JOIN Studio AS S ON S.ID = V.StudioID 
GROUP BY C.ID, C.LastName, V.StudioID, S.Name
ORDER BY V.StudioID,'VHS count' DESC

-- 1.3 �������������� sliding window (rows), partition by, order by �� �����, �� ����� ����� ����� ���������, ��� �� ������������ �������� �������.

-- �������� ������� ���������� ����� � ������� ����������� �볺���

SELECT 
    ClientID,VHS_ID,StartDate,ReturnDate,COUNT(ReturnDate) OVER (PARTITION BY ClientID ORDER BY StartDate ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS 'Close orders returned'
FROM Rent
ORDER BY ClientID, StartDate

SELECT 
    ClientID,VHS_ID,StartDate,ReturnDate,
	(SELECT COUNT(ReturnDate) FROM
	((SELECT TOP 1 ReturnDate FROM Rent WHERE StartDate>R.StartDate AND ClientID=R.ClientID  ORDER BY StartDate ASC)
	UNION ALL
	(SELECT ReturnDate)
	UNION ALL
	(SELECT TOP 1 ReturnDate FROM Rent WHERE StartDate<R.StartDate AND ClientID=R.ClientID  ORDER BY StartDate DESC))
	AS T)
	 AS 'Close orders returned'
FROM Rent AS R
ORDER BY ClientID, StartDate
-- 1.4 �������������� sliding window (range) , partition by, order by �� �����, �� ����� ����� ����� ���������, ��� �� ������������ �������� �������.

-- �������� ������� ��� ���������� ��� ������� ����� ���������� ������������

SELECT 
    ClientID, VHS_ID, StartDate, ReturnDate,  
	CASE 
		WHEN ReturnDate IS NULL THEN NULL
		ELSE (AVG(DATEDIFF(d,StartDate,ReturnDate)*1.0) OVER (PARTITION BY ClientID ORDER BY ReturnDate RANGE UNBOUNDED PRECEDING))
	END  AS 'Awaiting VHS'
FROM Rent
ORDER BY ClientID,ISNULL(ReturnDate,GetDate())

SELECT 
    ClientID, VHS_ID, StartDate, ReturnDate,  
	CASE 
		WHEN ReturnDate IS NULL THEN NULL
		ELSE (SELECT AVG(DATEDIFF(d,StartDate,ReturnDate)*1.0) FROM Rent WHERE Rent.ClientID = R.ClientID AND Rent.ReturnDate <= R.ReturnDate)
	END  AS 'Awaiting VHS'
FROM Rent AS R
ORDER BY ClientID,ISNULL(ReturnDate,GetDate())

-- 1.5 ��������� ����������, �� ������������� ������� lag(). �������������� lag(), partition by, order by �� �����, �� ����� ����� ����� ���������, ��� �� ������������ �������� �������.

-- �������� ������ ��� ������� � ������������ ������� ������ �볺����

SELECT ClientID, Rent.StartDate, DATEDIFF(d,LAG(Rent.StartDate) OVER(PARTITION BY ClientID ORDER BY Rent.StartDate ASC),Rent.StartDate) AS 'Days from previous rent'
FROM Rent
ORDER BY ClientID,Rent.StartDate ASC

SELECT ClientID, R.StartDate, DATEDIFF(d,
(SELECT TOP(1) Rent.StartDate 
FROM Rent
WHERE Rent.StartDate<R.StartDate AND Rent.ClientID = R.ClientID ORDER BY Rent.StartDate DESC)
,R.StartDate) AS 'Days from previous rent'
FROM Rent AS R
ORDER BY ClientID,R.StartDate ASC

-- 1.6 ��������� ����������, �� ������������� ������� lead(). �������������� lead(), partition by, order by �� �����, �� ����� ����� ����� ���������, ��� �� ������������ �������� �������.

-- �������� ����� ����� ��� �볺�� ��������� �������� ������

SELECT Rent.ClientID, Rent.StartDate, DATEDIFF(d,Rent.StartDate,LEAD(Rent.StartDate) OVER(PARTITION BY ClientID ORDER BY Rent.StartDate ASC)) AS 'Days to next rent'
FROM Rent
ORDER BY Rent.ClientID, Rent.StartDate ASC

SELECT R.ClientID, R.StartDate, DATEDIFF(d,R.StartDate,
(SELECT TOP(1) Rent.StartDate 
FROM Rent
WHERE Rent.StartDate>R.StartDate AND Rent.ClientID = R.ClientID ORDER BY Rent.StartDate ASC)
) AS 'Days to next rent'
FROM Rent AS R
ORDER BY R.ClientID, R.StartDate ASC

-- 2.1 ������ ������� ���, ��� ���� �� ���� � ������ ��������� ����, ������� �� ������� � ����������� ������. ���� �������, �� ���� ����� �������, ��� ���� ��������� ������ ��������� ����, ������� �� ������� � ����������� ������.

UPDATE Client
SET Adress = Adress + ' Boryspil'
-- ����� � ������� �볺��� (�����) ������� 2 ������

SELECT * FROM Client Order BY ID;
-- ����� ��� ���������� ����� 1 ���������� �� �����

UPDATE Client
SET Adress = REPLACE(Adress,' Boryspil','')
-- ����� ������� ����� ������� 1 ������

SELECT * FROM Client Order BY ID;

-- 2.2 �������, �� ���� ����� �������, ��� ������� ��������� ����� ��������� ����, ������� �� ������� � ����������� ������.
-- ����� ������ ���� ������� ��� ���� ������ �� ������(���� ���� ���� ������� ��� 1�� �볺���) � ������� ID �볺��� �� �������� ������� Adress � ������� Client

SELECT (ID+0) AS ID, Adress
INTO Adresses
FROM Client

INSERT INTO Adresses 
SELECT ID, 'Boryspil'
FROM Client

ALTER TABLE Client
DROP COLUMN Adress
-- ����� ���� ��� ������ �� ������ ������������� ����������� � ������ �������

SELECT * 
FROM Client 
Order BY ID

SELECT * 
FROM Adresses
Order BY ID

-- 2.3 �������, �� ���� ����� �������, ��� ������� ��������� ����� ��������� ����, ������� �� ������� � ����������� ������.
-- ����� ������� �� ������� �� �������� �� ����� �� ���������� ����� � ����� �������

SELECT LastName, Birthday
INTO ClientBirthdays
FROM Client

ALTER TABLE Client
DROP COLUMN Birthday
-- ����� ���� ������� �� �������� �� ����� �� ���������� �����

SELECT * 
FROM Client 
Order BY ID

SELECT * 
FROM Adresses
Order BY ID

SELECT * 
FROM ClientBirthdays
Order BY LastName

-- 2.4 �������, �� ���� ����� �������, ��� ������� ��������� ��������� ���� �����-����, ������� �� ������� � ����������� ������.
-- ������� ��� ������� ��������� ���� �����-���� ��� �� � �� �� ���������� �������������� ����������� �� ��������� � ������ �������

SELECT * 
FROM Client 
Order BY ID

SELECT * 
FROM Adresses
Order BY ID

SELECT * 
FROM ClientBirthdays
Order BY LastName

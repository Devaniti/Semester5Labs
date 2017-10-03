SELECT Client.ID, Count(Rent.ID) AS 'Rented'
FROM Client
JOIN Rent ON Rent.ClientID = Client.ID
GROUP BY Client.ID
HAVING Count(Rent.ID) > 0
GO

SELECT Client.ID, Count(Rent.ID) AS 'Rented', 
CASE Count(Rent.ID)
WHEN 0 THEN 'Never rented anything'
WHEN 1 THEN 'Ordered once'
WHEN 2 THEN 'Ordered twice'
ELSE 'Regular customer'
END AS 'Customer status'
FROM Client
JOIN Rent ON Rent.ClientID = Client.ID
GROUP BY Client.ID
HAVING Count(Rent.ID) > 0
GO

SELECT * FROM Client
WHERE Client.LastName LIKE 'P%'
GO

INSERT INTO Rent(ClientID,VHS_ID,StartDate,ReturnDate) 
SELECT ClientID,VHS_ID,StartDate,
CASE ReturnDate
WHEN NULL THEN GETDATE()
ELSE ReturnDate
END
FROM Rent
WHERE VHS_ID = 1
GO


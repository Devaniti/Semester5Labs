SELECT Studio.Name, SUM(SUM(1)) OVER (PARTITION BY Studio.ID) AS Studio__Rented,VHS.ID AS 'VHS ID' , SUM(1) AS Times_rented, RANK() OVER (PARTITION BY Studio.ID ORDER BY SUM(1) DESC) AS Rent_rank
FROM Studio
JOIN VHS ON VHS.StudioID = Studio.ID
JOIN Rent ON Rent.VHS_ID = VHS.ID
GROUP BY VHS.ID, Studio.Name, Studio.ID
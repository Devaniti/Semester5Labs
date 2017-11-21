USE master
GO
DROP DATABASE LR3
GO
CREATE DATABASE LR3
GO
USE LR3
GO

CREATE TABLE Directors(
	ID int PRIMARY KEY
)

CREATE TABLE Director_mentors(
	ID int PRIMARY KEY,
	mentor_id int FOREIGN KEY REFERENCES Directors(ID), -- наставник
	mentee_id int FOREIGN KEY REFERENCES Directors(ID), -- ученик
)

-- task 1
INSERT INTO Directors VALUES
	(1),
	(2),
	(3),
	(4),
	(5),
	(6),
	(7),
	(8),
	(9),
	(10)

INSERT INTO Director_mentors VALUES
	(1, NULL, 3   ),
	(2, NULL, 5   ),
	(3, 1   , 6   ),
	(4, 1   , 9   ),
	(5, 2   , NULL),
	(6, 4   , NULL),
	(7, NULL, 8   ),
	(8, 7   , NULL),
	(9, 5   , NULL),
	(10, 2  , NULL)

-- task 2.1
-- Вивести список всіх «нащадків» вказаного «предка».

GO

CREATE PROCEDURE listMentees
    @ID INT
AS 
   WITH subquery(mentee_ids) AS 
   (
		SELECT ID
		FROM Director_mentors
		WHERE mentor_id = @ID
		UNION ALL
		SELECT T.ID
		FROM subquery
		INNER JOIN Director_mentors AS T ON 
		T.mentor_id = subquery.mentee_ids
   )

   SELECT distinct mentee_ids
   FROM subquery
GO

EXEC listMentees 1 
EXEC listMentees 2 
GO

-- task 2.2
-- Вивести список всіх «предків» вказаного «нащадка»

CREATE PROCEDURE listMentors
    @ID INT
AS 
   WITH subquery(mentor_ids) AS 
   (
		SELECT mentor_id
		FROM Director_mentors
		WHERE ID = @ID
		UNION ALL
		SELECT T.mentor_id
		FROM subquery
		INNER JOIN Director_mentors AS T ON 
		T.ID = subquery.mentor_ids
		WHERE T.mentor_id IS NOT NULL
   )

   SELECT distinct mentor_ids
   FROM subquery
GO

EXEC listMentors 6 
EXEC listMentors 9 
GO

-- task 2.3
-- Вивести список, другий полем якого є «рівень» ( аналог псевдостовпчика level в connect by)

CREATE PROCEDURE listMenteesWithLevel
    @ID INT
AS 
   WITH subquery(mentee_ids,lvl) AS 
   (
		SELECT ID, 1
		FROM Director_mentors
		WHERE mentor_id = @ID
		UNION ALL
		SELECT T.ID, lvl+1
		FROM subquery
		INNER JOIN Director_mentors AS T ON 
		T.mentor_id = subquery.mentee_ids
   )

   SELECT distinct mentee_ids, lvl
   FROM subquery
GO

EXEC listMenteesWithLevel 1 
EXEC listMenteesWithLevel 2 
GO

-- task 2.4
-- Змінити дані в доданій таблиці так, щоб утворився цикл. 

UPDATE Director_mentors
SET mentor_id = 4
WHERE ID = 1

-- task 2.4.1
-- Написати запит, що видає помилку при зациклюванні.

EXEC listMentees 1

-- task 2.4.2
-- Змінити цей запит так, щоб помилки не було

GO

CREATE PROCEDURE listMenteesWithCycles
    @ID INT
AS 
   WITH subquery(mentee_ids, lvl, iscycle) AS 
   (
		SELECT ID, 1, 0
		FROM Director_mentors
		WHERE mentor_id = @ID
		UNION ALL
		SELECT T.ID, lvl+1, (CASE WHEN T.mentor_id = subquery.mentee_ids THEN 1 ELSE 0 END)
		FROM subquery
		INNER JOIN Director_mentors AS T ON 
		T.mentor_id = subquery.mentee_ids
		WHERE iscycle = 0
   )

   SELECT distinct mentee_ids, lvl
   FROM subquery
GO

EXEC listMenteesWithCycles 1

-- task 2.5
-- Для всіх «нащадків» (це перше поле: Іванов ) вивести список «предків» через «/», 
-- де останнім в ланцюгу є цей «нащадок» ( це друге поле: Іваненко/Іванченко/Іванчук/Іванов)


GO

CREATE PROCEDURE listMenteesWithHistory
    @ID INT
AS 
   WITH subquery(mentee_ids, history, iscycle) AS 
   (
		SELECT ID, 
			CAST(CONCAT(@ID,'\',CAST(ID AS nvarchar(256))) AS nvarchar(256)), 0
		FROM Director_mentors
		WHERE mentor_id = @ID
		UNION ALL
		SELECT 
			T.ID,
			CAST(CONCAT(subquery.history,'\',CAST(T.ID AS nvarchar(256))) AS nvarchar(256)),
			(CASE WHEN T.mentor_id = subquery.mentee_ids THEN 1 ELSE 0 END)
		FROM subquery
		INNER JOIN Director_mentors AS T ON 
		T.mentor_id = subquery.mentee_ids
		WHERE iscycle = 0
   )

   SELECT mentee_ids, history
   FROM subquery
GO

EXEC listMenteesWithHistory 1
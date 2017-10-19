USE master
GO
DROP DATABASE LR1
GO
CREATE DATABASE LR1
GO
USE LR1;

CREATE TABLE Accounts(
	EmailAdress varchar(40) NOT NULL PRIMARY KEY
)

CREATE TABLE Emails(
	EmailText varchar(200) NOT NULL,
	EmailAdress varchar(40) NOT NULL FOREIGN KEY REFERENCES Accounts(EmailAdress),
	IsSpam BIT NOT NULL
)

INSERT INTO Accounts VALUES ('admin@gmail.com'),('vasya@gmail.com'),('petia@gmail.com'),('mycoolemail@gmail.com');
INSERT INTO Emails(EmailText,EmailAdress,IsSpam) VALUES 
('Hi','admin@gmail.com',1),('Bye','admin@gmail.com',1),('I am Petya','admin@gmail.com',0),
('Petya is bad','vasya@gmail.com',0),('Hi','admin@gmail.com',1),('Wow. Much Email. Very Text','mycoolemail@gmail.com',0),
('You are bad','petia@gmail.com',0),('Covfefe','petia@gmail.com',1),('Not spam','admin@gmail.com',0),('Empty email','vasya@gmail.com',0),
('Hi google','admin@gmail.com',0), ('You are good','vasya@gmail.com',0)

-- 1.1 Використовуючи count() (або будь-яку іншу агрегатну функцію), partition
-- by, order by та запит, що дасть такий самий результат, але не
-- застосовуючи аналітичні функції.

-- Запити підраховують кількість емейлів користувачів

SELECT DISTINCT EmailAdress, COUNT(*) OVER (PARTITION BY EmailAdress) AS 'Email count' FROM Emails
ORDER BY 'Email count' DESC

SELECT EmailAdress, COUNT(EmailText) AS 'Email count' FROM Emails
GROUP BY EmailAdress
ORDER BY 'Email count' DESC

-- 1.2 Використовуючи rank() або dense_rank(), partition by, order by та запит, що
-- дасть такий самий результат, але не застосовуючи аналітичні функції.

-- Підраховує ранк кількості емейлів для емейлів які являються спамом та ні

SELECT COUNT(EmailAdress) AS 'Emails count',IsSpam,RANK() OVER (PARTITION BY IsSpam ORDER BY COUNT(EmailAdress) DESC) AS 'Rank', EmailAdress FROM Emails
GROUP BY EmailAdress,IsSpam
ORDER BY IsSpam,COUNT(EmailAdress) DESC

SELECT COUNT(T.EmailText) AS 'Emails count',T.IsSpam,(SELECT COUNT(*)+1 FROM (SELECT COUNT(EmailText) q FROM Emails WHERE IsSpam = T.IsSpam GROUP BY EmailAdress HAVING COUNT(T.EmailText)<COUNT(EmailText)  ) e) AS 'Rank', EmailAdress FROM Emails AS T
GROUP BY T.EmailAdress,T.IsSpam
ORDER BY T.IsSpam,COUNT(T.EmailText) DESC

-- Ствроюю нову таблицю

CREATE TABLE Users(
	ID int NOT NULL PRIMARY KEY
)

CREATE TABLE Apps(
	ID int NOT NULL PRIMARY KEY
)

CREATE TABLE Ratings(
	UserID int NOT NULL FOREIGN KEY REFERENCES Users(ID),
	AppID int NOT NULL FOREIGN KEY REFERENCES Apps(ID),
	UIMark int NOT NULL,
	UsabilityMark int NOT NULL,
	RecomendMark int NOT NULL
)

INSERT INTO Users VALUES (1),(2),(3),(4),(5)
INSERT INTO Apps VALUES (1),(2),(3),(4),(5)
INSERT INTO Ratings VALUES (1,1,2,3,4),(1,2,4,4,5),(1,4,5,5,5),(1,5,3,1,5),(2,3,3,4,4),(3,2,2,3,4),(3,4,5,5,1),(4,1,4,4,3),(4,3,2,3,4),(5,2,5,4,3),(5,5,5,5,5)

-- 1.3 Використовуючи sliding window (rows), partition by, order by та запит, що дасть такий самий результат, але не застосовуючи аналітичні функції.

-- Виводить середню оцінку серед сусідніх оцінок

SELECT 
    AppID,UserID,(UIMark+UsabilityMark+RecomendMark)/3.0 AS 'User AVG Mark',AVG((UIMark+UsabilityMark+RecomendMark)/3.0) OVER (PARTITION BY Ratings.AppID ORDER BY (UIMark+UsabilityMark+RecomendMark) ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS 'Close AVG Mark'
FROM Ratings
ORDER BY AppID,UserID

SELECT 
    A.AppID,A.UserID,(A.UIMark+A.UsabilityMark+A.RecomendMark)/3.0 AS 'User AVG Mark',
	(SELECT AVG(Mark) FROM
	((SELECT TOP 1 (T.UIMark+T.UsabilityMark+T.RecomendMark)/3.0 AS Mark FROM Ratings AS T WHERE (T.UIMark+T.UsabilityMark+T.RecomendMark)>(A.UIMark+A.UsabilityMark+A.RecomendMark) AND T.AppID=A.AppID  ORDER BY (T.UIMark+T.UsabilityMark+T.RecomendMark) ASC)
	UNION ALL
	(SELECT (A.UIMark+A.UsabilityMark+A.RecomendMark)/3.0)
	UNION ALL
	(SELECT TOP 1 (T.UIMark+T.UsabilityMark+T.RecomendMark)/3.0 FROM Ratings AS T WHERE (T.UIMark+T.UsabilityMark+T.RecomendMark)<(A.UIMark+A.UsabilityMark+A.RecomendMark) AND T.AppID=A.AppID  ORDER BY (T.UIMark+T.UsabilityMark+T.RecomendMark) DESC))
	AS T)
	AS 'Close AVG Mark'
FROM Ratings AS A
ORDER BY AppID,UserID

-- 1.4 Використовуючи sliding window (range) , partition by, order by та запит, що дасть такий самий результат, але не застосовуючи аналітичні функції.

-- Виводить кількість людей у яких середня оцінка меньша

SELECT 
    AppID,UserID,(UIMark+UsabilityMark+RecomendMark)/3.0 AS 'User AVG Mark',(COUNT(*) OVER (PARTITION BY Ratings.AppID ORDER BY (UIMark+UsabilityMark+RecomendMark) RANGE UNBOUNDED PRECEDING))-1 AS 'Lower Mark Count'
FROM Ratings
ORDER BY AppID,UserID


SELECT 
    T.AppID,T.UserID,(T.UIMark+T.UsabilityMark+T.RecomendMark)/3.0 AS 'User AVG Mark',(SELECT COUNT(*) FROM Ratings AS A WHERE (T.AppID = A.AppID AND (T.UIMark+T.UsabilityMark+T.RecomendMark)>(A.UIMark+A.UsabilityMark+A.RecomendMark))) AS 'Lower Mark Count'
FROM Ratings AS T
ORDER BY AppID,UserID

-- Створю нову таблицю

CREATE TABLE Playlist(
	ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
	SongName varchar(40) NOT NULL
)

INSERT INTO Playlist VALUES
	('I ll Face Myself -Battle-'),
	('Triple Baka'),
	('God knows'),
	('The Battle for Everyone s Souls'),
	('More Than One Heart'),
	('Over My Head (Better Off Dead)'),
	('No More'),
	('Clair De Lune'),
	('Through The Fire And Flames'),
	('We are Number One'),
	('Discord (The Living Tombstone Remix)')


-- 1.5 Самостійно розібратися, як застосовується функція lag(). Використовуючи lag(), partition by, order by та запит, що дасть такий самий результат, але не застосовуючи аналітичні функції.

SELECT SongName, LAG(SongName) OVER(ORDER BY ID) AS PreviousSong
FROM Playlist
ORDER BY ID

SELECT SongName, (SELECT TOP(1) SongName FROM Playlist AS A WHERE A.ID<T.ID ORDER BY A.ID DESC) AS PreviousSong
FROM Playlist AS T
ORDER BY ID

-- 1.6 Самостійно розібратися, як застосовується функція lead(). Використовуючи lead(), partition by, order by та запит, що дасть такий самий результат, але не застосовуючи аналітичні функції.

SELECT SongName, LEAD(SongName) OVER(ORDER BY ID) AS NextSong
FROM Playlist
ORDER BY ID

SELECT SongName, (SELECT TOP(1) SongName FROM Playlist AS A WHERE A.ID>T.ID ORDER BY A.ID ASC) AS NextSong
FROM Playlist AS T
ORDER BY ID

-- 2.1 Змінити таблицю так, щоб вона не була у першій нормальній формі, навести цю таблицю у наповненому вигляді. Потім описати, які зміни треба зробити, щоб вона відповідала першій нормальній формі, навести цю таблицю у наповненому вигляді.

CREATE TABLE 
CREATE TABLE Studio(
	ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
	Country char(2),
	Name varchar(40)
)
CREATE TABLE Client(
	ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
	LastName varchar(40),
	Adresses varchar(100)
)
CREATE TABLE VHS(
	ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
	Inventory_Number int NOT NULL UNIQUE,
	Director varchar(40),
	StudioID int NOT NULL FOREIGN KEY REFERENCES Studio(ID)
)
CREATE TABLE Rent(
	StartDate DateTime NOT NULL,
	ReturnDate DateTime DEFAULT(NULL),
	Inventory_Number int NOT NULL FOREIGN KEY REFERENCES VHS(Inventory_Number),
	ClientID int NOT NULL FOREIGN KEY REFERENCES Client(ID)
)
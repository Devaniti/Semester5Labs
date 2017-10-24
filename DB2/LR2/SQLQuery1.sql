
CREATE TABLE Client(
	ID int NOT NULL,
	LastName varchar(40),
	FirstName varchar(40),
	MiddleName varchar(40)
)
CREATE INDEX ID_Index ON Client(ID);

CREATE TABLE Rent(
	ID int NOT NULL,
	StartDate DateTime DEFAULT(GetDate()),
	ReturnDate DateTime DEFAULT(NULL),
	ClientID int NOT NULL
)


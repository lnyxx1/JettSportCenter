CREATE DATABASE JettSportsCenter
DROP DATABASE JettSportsCenter


CREATE TABLE Staff(
	StaffID CHAR(5) PRIMARY KEY CHECK (StaffID LIKE 'ST[0-9][0-9][0-9]'),
	StaffName VARCHAR(64) NOT NULL CHECK (LEN(StaffName) > 4),
	StaffGender VARCHAR(16) NOT NULL CHECK (StaffGender IN ('Male', 'Female')),
	StaffSalary INT NOT NULL CHECK (StaffSalary >= 1000000)
)

CREATE TABLE Customer(
	CustomerID CHAR(5) PRIMARY KEY CHECK (CustomerID LIKE 'CU[0-9][0-9][0-9]'),
	CustomerName VARCHAR(64) NOT NULL CHECK(CustomerName LIKE '% %'),
	CustomerAge INT NOT NULL CHECK (CustomerAge >= 6),
	CustomerPhoneNumber VARCHAR(16) NOT NULL CHECK (LEN(CustomerPhoneNumber) >= 10)
)

CREATE TABLE Product(
	ProductID CHAR(5) PRIMARY KEY CHECK (ProductID LIKE 'PR[0-9][0-9][0-9]'),
	ProductName VARCHAR(64) NOT NULL CHECK (LEN(ProductName) >= 4),
	ProductPrice INT NOT NULL CHECK (ProductPrice BETWEEN 10000 AND 1000000)
)



CREATE TABLE ProductTransactionHeader(
	ProductTransactionID CHAR(5) PRIMARY KEY CHECK (ProductTransactionID LIKE 'PT[0-9][0-9][0-9]'),
	StaffID CHAR(5) NOT NULL CHECK (StaffID LIKE 'ST[0-9][0-9][0-9]'),
	CustomerID CHAR(5) NOT NULL CHECK (CustomerID LIKE 'CU[0-9][0-9][0-9]'),
	ProductTransactionDate DATE NOT NULL CHECK (YEAR(ProductTransactionDate) = 2022)

	FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
	FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)

)

CREATE TABLE ProductTransactionDetail(
	ProductTransactionID CHAR(5) NOT NULL CHECK (ProductTransactionID LIKE 'PT[0-9][0-9][0-9]'),
	ProductID CHAR(5) NOT NULL CHECK (ProductID LIKE 'PR[0-9][0-9][0-9]'),
	Quantity INT NOT NULL CHECK(Quantity > 0)

	FOREIGN KEY (ProductTransactionID) REFERENCES ProductTransactionHeader(ProductTransactionID),
	FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
)

CREATE TABLE SportField (
	SportFieldID CHAR(5) PRIMARY KEY CHECK (SportFieldID LIKE 'SF[0-9][0-9][0-9]'),
	SportFieldName VARCHAR(64) NOT NULL CHECK (SportFieldName LIKE '% Field'),
	SportFieldAddress VARCHAR(255) NOT NULL CHECK (SportFieldAddress LIKE '% Street'),
	SportFieldRentFee INT NOT NULL CHECK (SportFieldRentFee BETWEEN 10000 AND 1000000)

)

CREATE TABLE RentalTransactionHeader(
	RentalTransactionID CHAR(5) PRIMARY KEY CHECK (RentalTransactionID LIKE 'RT[0-9][0-9][0-9]'),
	CustomerID CHAR(5) NOT NULL CHECK (CustomerID LIKE 'CU[0-9][0-9][0-9]'), 
	StaffID CHAR(5) NOT NULL CHECK (StaffID LIKE 'ST[0-9][0-9][0-9]'),
	RentalTransactionDate DATE NOT NULL CHECK(YEAR(RentalTransactionDate) = 2022)

	FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
	FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
)

CREATE TABLE RentalTransactionDetail(
	RentalTransactionID CHAR(5) NOT NULL CHECK (RentalTransactionID LIKE 'RT[0-9][0-9][0-9]'),
	SportFieldID CHAR(5) CHECK (SportFieldID LIKE 'SF[0-9][0-9][0-9]'),
	RentalLength INT NOT NULL CHECK (RentalLength > 0)

	FOREIGN KEY (SportFieldID) REFERENCES SportField(SportFieldID)

)
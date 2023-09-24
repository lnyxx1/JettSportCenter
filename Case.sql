-- 1
SELECT REPLACE(p.ProductID, 'PR', 'Product Id ') AS [Product], CONCAT(SUM(pdt.Quantity), ' pcs') AS [Total Item Sold]
FROM Product p JOIN ProductTransactionDetail pdt ON pdt.ProductID = p.ProductID JOIN ProductTransactionHeader pht ON pht.ProductTransactionID = pdt.ProductTransactionID JOIN Staff s ON pht.StaffID = s.StaffID
WHERE s.StaffGender = 'Female' AND s.StaffSalary > 4000000
GROUP BY p.ProductID

-- 2
SELECT pht.ProductTransactionID, COUNT(DISTINCT pdt.ProductID) AS [Total Product Type]
FROM ProductTransactionHeader pht JOIN ProductTransactionDetail pdt ON pht.ProductTransactionID = pdt.ProductTransactionID
WHERE MONTH(pht.ProductTransactionDate) > 6 
GROUP BY pht.ProductTransactionID
HAVING COUNT(pdt.ProductID) > 1

-- 3
SELECT REPLACE(sf.SportFieldID, 'SF', 'Sport Field ') AS [Sport Field Id], REPLACE(sf.SportFieldAddress, 'Street', 'St.') AS [Sport Field Address], CONCAT('Rp. ',MAX(rdt.RentalLength * sf.SportFieldRentFee)) AS [Highest Transaction], CONCAT('Rp. ',MIN(rdt.RentalLength * sf.SportFieldRentFee)) AS [Lowest Transaction]
FROM SportField sf JOIN RentalTransactionDetail rdt ON rdt.SportFieldID = sf.SportFieldID
WHERE sf.SportFieldRentFee < 50000 AND RIGHT(sf.SportFieldID, 3)  % 2 = 1
GROUP BY sf.SportFieldID, sf.SportFieldAddress

-- 4
SELECT sf.SportFieldID, CONCAT('Rp. ' , MAX(s.StaffSalary) - MIN (s.StaffSalary)) AS [Staff Salary Deviation]
FROM SportField sf JOIN RentalTransactionDetail rdt ON sf.SportFieldID = rdt.SportFieldID JOIN RentalTransactionHeader rht ON rht.RentalTransactionID = rdt.RentalTransactionID JOIN Staff s ON rht.StaffID = s.StaffID
WHERE RIGHT(sf.SportFieldID, 3) % 2 = 1 
GROUP BY sf.SportFieldID
HAVING MAX(s.StaffSalary) - MIN (s.StaffSalary) >= 1000000

-- 5
SELECT x.Max,s.StaffSalary, (s.StaffID) AS [Staff Id], UPPER(s.StaffName) AS [Staff Name], LEFT(s.StaffGender, 1) AS [Staff Gender], rht.RentalTransactionID, c.CustomerName
FROM Staff s JOIN RentalTransactionHeader rht ON rht.StaffID = s.StaffID JOIN Customer c ON c.CustomerID = rht.CustomerID,

(
	SELECT MAX(s.StaffSalary) 'Max'
	FROM Staff s
	WHERE s.StaffGender = 'Female'

	
)x
WHERE x.Max = s.StaffSalary 

-- 6
SELECT DISTINCT c.CustomerID, c.CustomerName, CONCAT(c.CustomerAge, ' years old') AS [Customer Age], STUFF(c.CustomerPhoneNumber, 1, 2, '+62') AS [CustomerPhone]
FROM Customer c JOIN ProductTransactionHeader pht ON pht.CustomerID = c.CustomerID JOIN ProductTransactionDetail pdt ON pdt.ProductTransactionID = pht.ProductTransactionID,

(
	SELECT MIN(c.CustomerAge)'Min'
	FROM Customer c


)x
WHERE x.Min = c.CustomerAge AND pdt.Quantity < 50

-- 7
SELECT 'Most Expensive Product' AS [Category], UPPER(p.ProductName) AS [ProductName], CONCAT('Rp. ', p.ProductPrice) AS [Product Price]
FROM Product p,
(
	SELECT MAX(p.ProductPrice) 'Max'
	FROM Product p 
	WHERE RIGHT(p.ProductID, 3) % 2 = 1

)x
WHERE x.Max = p.ProductPrice 
UNION
SELECT 'Most Affordable Product' AS [Category], UPPER(p.ProductName) AS [ProductName], CONCAT('Rp. ', p.ProductPrice) AS [Product Price]
FROM Product p,
(
	SELECT Min(p.ProductPrice) 'Min'
	FROM Product p 
	WHERE RIGHT(p.ProductID, 3) % 2 = 0

)x
WHERE x.Min = p.ProductPrice 

-- 8
SELECT REPLACE(pht.ProductTransactionID, 'PT', 'Product Transaction Id') AS [ProductTransactionId], CONVERT(varchar, pht.ProductTransactionDate, 107) AS [Date], c.CustomerID, UPPER(c.CustomerName) AS [CustomerName], s.StaffID, LEFT(s.StaffGender, 1) AS [StaffGender]
FROM ProductTransactionHeader pht JOIN Customer c ON c.CustomerID = pht.CustomerID JOIN Staff s ON s.StaffID = pht.StaffID,

(
	SELECT MAX(c.CustomerAge) 'Oldest'
	FROM Customer c 
)x,
(

	SELECT AVG(s.StaffSalary) 'Average'
	FROM Staff s

)y
WHERE c.CustomerAge = x.Oldest AND s.StaffSalary > y.Average

-- 9
CREATE VIEW annualMonthlyRentalReport
AS
SELECT SUM(rdt.RentalLength * sf.SportFieldRentFee) AS [Yearly Rental Revenue], AVG(rdt.RentalLength * sf.SportFieldRentFee) AS [Average Rental Revenue]
FROM RentalTransactionDetail rdt JOIN SportField sf ON sf.SportFieldID = rdt.SportFieldID JOIN RentalTransactionHeader rht ON rht.RentalTransactionID = rdt.RentalTransactionID
WHERE MONTH(rht.RentalTransactionDate) = 12 AND sf.SportFieldRentFee > 60000

-- 10
CREATE VIEW annualMonthlyProductReport
AS 
SELECT SUM(pdt.Quantity * p.ProductPrice) AS [Yearly Product Revenue], AVG(p.ProductPrice * pdt.Quantity) AS [Average Product Revenue]
FROM ProductTransactionDetail pdt JOIN Product p ON p.ProductID = pdt.ProductID JOIN ProductTransactionHeader pht ON pht.ProductTransactionID = pdt.ProductTransactionID
WHERE MONTH(pht.ProductTransactionDate) = 1 AND p.ProductPrice > 30000


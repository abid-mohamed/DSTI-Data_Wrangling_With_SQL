-------------------------------------------------------------------------
--	Q2.
--Q2. For the CustomerId = 1060 (CustomerName = 'Anand Mudaliyar')
--Identify the first InvoiceLine of his first Invoice, where "first" means the lowest respective IDs, 
--and write an update query increasing the UnitPrice of this InvoiceLine by 20.
--A re-run of the query in Q1 gives the resultset in Q2-Resultset_Corrected.csv 
--(corrected on 15th April 2018 - Summed values in columns OrdersTotalValue & InvoicesTotalValue were incorrect) .

--If you haven't managed to answer Q1, add the following selection query to the previous update query: 
--CustomerId, CustomerName, InvoiceTotal. The latter is the sum of all invoice lines for the target invoice. 
--The target InvoiceID is purposefully not shown, but the resultset post-update is given in Q2-Alternative-Resultset.csv 


-------------------------------------------------------------------------
USE	WideWorldImporters

--Identify the first InvoiceLine of his first Invoice, where "first" means the lowest respective IDs, 
SELECT	TOP(1)	
		I.CustomerID
	,	C.CustomerName
	,	I.InvoiceID
	,	IL.InvoiceLineID
	,	IL.UnitPrice
FROM	Sales.InvoiceLines	AS IL
	,	Sales.Invoices		AS I
	,	Sales.Customers		AS C
WHERE	I.InvoiceID = IL.InvoiceID
	AND	I.CustomerID = C.CustomerID
	AND	I.CustomerID = 1060
ORDER BY	IL.InvoiceID		ASC
		,	IL.InvoiceLineID	ASC;


--update query increasing the UnitPrice of this InvoiceLine by 20.
UPDATE	Sales.InvoiceLines
SET		UnitPrice = UnitPrice + 20
WHERE	InvoiceLineID = 
		(	SELECT	TOP(1)	IL.InvoiceLineID
			FROM	Sales.InvoiceLines	AS IL
				,	Sales.Invoices		AS I
			WHERE	I.InvoiceID = IL.InvoiceID
				AND	I.CustomerID = 1060
			ORDER BY	IL.InvoiceID		ASC
					,	IL.InvoiceLineID	ASC
		);

--
SELECT	C.CustomerID
	,	C.CustomerName
	,	SUM(IL.Quantity * IL.UnitPrice)	AS InvoiceTotal
FROM	Sales.Customers		AS C
	,	Sales.Invoices		AS I
	,	Sales.InvoiceLines	AS IL
WHERE	C.CustomerID = I.CustomerID
	AND	I.InvoiceID = IL.InvoiceID
	AND	C.CustomerID = 1060
	AND	I.InvoiceID = 69627
GROUP BY	C.CustomerID
		,	C.CustomerName




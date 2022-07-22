-------------------------------------------------------------------------
--	Q1.
--Using the database WideWorldImporters, write a SQL query which reports the consistency between orders and their attached invoices.
--The resultset should report for each (CustomerID, CustomerName)
-- a. the total number of orders: TotalNBOrders
-- b. the number of invoices converted from an order: TotalNBInvoices
-- c. the total value of orders: OrdersTotalValue
-- d. the total value of invoices: InvoicesTotalValue
-- f. the absolute value of the difference between c - d: AbsoluteValueDifference
 
-- The resultset must be sorted by highest values of AbsoluteValueDifference, then by smallest to highest values of TotalNBOrders and CustomerName is that order.
 
-- Please note that all values in a & b must be identical by definition of the query, as we are observing orders converted into invoices.
--We are looking for potential differences between c & d.
--BUT, you must find them consistent as the data is clean in WideWorldImporters.
--Resultset enclosed in Q1-Resultset_Corrected.csv
-------------------------------------------------------------------------
USE	WideWorldImporters
SELECT	SQ.*
	,	ABS(SQ.OrdersTotalValue - SQ.InvoicesTotalValue) AS AbsoluteValueDifference
FROM	
	(	SELECT	C.CustomerID
			,	C.CustomerName
			,	(	SELECT	COUNT(*)
					FROM	Sales.Orders	AS O
						,	Sales.Invoices	AS I
					WHERE	O.CustomerID = C.CustomerID
						AND	I.OrderID = O.OrderID
				) AS TotalNBOrders
			,	(	SELECT	COUNT(*)
					FROM	Sales.Invoices	AS I
					WHERE	I.CustomerID = C.CustomerID
				) AS TotalNBInvoices
			,	(	SELECT	SUM(OL.Quantity * OL.UnitPrice)
					FROM	Sales.OrderLines	AS OL
						,	Sales.Orders		AS O
						,	Sales.Invoices		AS I
					WHERE	OL.OrderID = O.OrderID
						AND	O.CustomerID = C.CustomerID
						AND	O.OrderID = I.OrderID
					GROUP BY	O.CustomerID
				) AS OrdersTotalValue
			,	(	SELECT	SUM(IL.Quantity * IL.UnitPrice)
					FROM	Sales.InvoiceLines	AS IL
						,	Sales.Invoices		AS I
					WHERE	IL.InvoiceID = I.InvoiceID
						AND	I.CustomerID = C.CustomerID
					GROUP BY	I.CustomerID
				) AS InvoicesTotalValue
		FROM	Sales.Customers	AS C
	) AS SQ
ORDER BY	AbsoluteValueDifference	DESC
		,	TotalNBOrders
		,	CustomerName

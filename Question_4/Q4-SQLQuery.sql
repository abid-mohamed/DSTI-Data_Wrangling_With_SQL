-------------------------------------------------------------------------
--Q4. In the database WideWorldImporters, write a SQL query which reports the highest loss of money from orders 
--not being converted into invoices, by customer category. The name and id of the customer who generated this highest loss 
--must also be identified. The resultset is ordered by highest loss.
--You should be able to write it in pure SQL, but if too challenging, you may use T-SQL and cursors.
--Resultset enclosed in Q4-Resultset.csv
-------------------------------------------------------------------------
USE	WideWorldImporters

SELECT	SQ2.CustomerCategoryID
	,	SQ2.CustomerCategoryName
	,	SQ2.Highest_loss
	,	SQ2.CustomerID
	,	SQ2.CustomerName
FROM	
	(	SELECT	SQ1.CustomerID
			,	SQ1.CustomerName
			,	SQ1.CustomerCategoryID
			,	SQ1.CustomerCategoryName
			,	SQ1.Highest_loss
			,	RANK() OVER(PARTITION BY SQ1.CustomerCategoryID ORDER BY Highest_loss DESC) AS Ranking
		FROM
			(	SELECT	C.CustomerID
					,	C.CustomerName
					,	C.CustomerCategoryID
					,	CC.CustomerCategoryName
					,	SUM(OL.Quantity * OL.UnitPrice) AS Highest_loss
				FROM	Sales.Orders AS O
					,	Sales.Customers AS	C
					,	Sales.OrderLines AS OL
					,	Sales.CustomerCategories AS CC
				WHERE	C.CustomerID = O.CustomerID
					AND	O.OrderID = OL.OrderID
					AND	C.CustomerCategoryID = CC.CustomerCategoryID
					AND NOT EXISTS
					(
						SELECT	*
						FROM	Sales.Invoices AS I
						WHERE	O.OrderID = I.OrderID
					)
				GROUP BY	C.CustomerID
						,	C.CustomerName
						,	C.CustomerCategoryID
						,	CC.CustomerCategoryName
			) AS SQ1
	) AS SQ2
WHERE	SQ2.Ranking = 1

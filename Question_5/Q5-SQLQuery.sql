-------------------------------------------------------------------------
--Q5. In the database SQLPlayground, write a SQL query selecting all the customers' data 
--who have purchased all the products AND have bought more than 50 products in total (sum of all purchases).
--Resultset enclosed in Q5-Resultset.csv
-------------------------------------------------------------------------
USE	SQLPlayground

SELECT	SQ2.CustomerId
	,	SQ2.CustomerName
	,	SQ1.sumOfAllPurchases
FROM
	(	SELECT	CustomerId
			,	SUM(Qty)	AS	sumOfAllPurchases
		FROM	Purchase AS P
		GROUP BY	CustomerId 
	) AS SQ1

	,(	SELECT	*
		FROM	Customer AS C
		WHERE	NOT EXISTS 
			(	SELECT	*
				FROM	Product	AS P
				WHERE	NOT EXISTS 
					(	SELECT	*
						FROM	Purchase AS Pu
						WHERE	Pu.CustomerId = C.CustomerId
							AND	Pu.ProductId = P.ProductId 
					)
			)
	) AS SQ2
WHERE	SQ1.sumOfAllPurchases > 50
	AND	SQ1.CustomerId = SQ2.CustomerId
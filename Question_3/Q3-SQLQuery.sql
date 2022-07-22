-------------------------------------------------------------------------
--Q3.
--Using the database WideWorldImporters, write a T-SQL stored procedure called ReportCustomerTurnover.
--This procedure takes two parameters: Choice and Year, both integers.

--When Choice = 1 and Year = <aYear>, ReportCustomerTurnover selects all the customer names and their total monthly turnover (invoiced value) for the year <aYear>.

--When Choice = 2 and Year = <aYear>, ReportCustomerTurnover  selects all the customer names and their total quarterly (3 months) turnover (invoiced value) for the year <aYear>.

--When Choice = 3, the value of Year is ignored and ReportCustomerTurnover  selects all the customer names and their total yearly turnover (invoiced value).

--When no value is provided for the parameter Choice, the default value of Choice must be 1.
--When no value is provided for the parameter Year, the default value is 2013. This doesn't impact Choice = 3.

--For Choice = 3, the years can be hard-coded within the range of [2013-2016].

--NULL values in the resultsets are not acceptable and must be substituted to 0.

--All output resultsets are ordered by customer names alphabetically.

--Example datasets are provided for the following calls:
--EXEC dbo.ReportCustomerTurnover;
--EXEC dbo.ReportCustomerTurnover 1, 2014;
--EXEC dbo.ReportCustomerTurnover 2, 2015;
--EXEC dbo.ReportCustomerTurnover 3;
-------------------------------------------------------------------------
USE	WideWorldImporters

-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--SELECT	C.CustomerName
--	,	COALESCE((
--			SELECT	SUM(IL.Quantity * IL.UnitPrice)
--			FROM	Sales.InvoiceLines	AS IL
--				,	Sales.Invoices		AS I
--			WHERE	IL.InvoiceID = I.InvoiceID
--				AND	DATEPART(YEAR, I.InvoiceDate) = 2014
--				AND	DATEPART(MONTH, I.InvoiceDate) = 1
--				AND	I.CustomerID = C.CustomerID
--		) , 0) AS Sales_2014M1
--	,	COALESCE((
--			SELECT	SUM(IL.Quantity * IL.UnitPrice)
--			FROM	Sales.InvoiceLines	AS IL
--				,	Sales.Invoices		AS I
--			WHERE	IL.InvoiceID = I.InvoiceID
--				AND	DATEPART(YEAR, I.InvoiceDate) = 2014
--				AND	DATEPART(MONTH, I.InvoiceDate) = 2
--				AND	I.CustomerID = C.CustomerID
--		) , 0) AS Sales_2014M2
--FROM	Sales.Customers	AS C
--ORDER BY C.CustomerName




CREATE PROCEDURE ReportCustomerTurnover
	-- Add the parameters for the stored procedure here
	
		@Choice int = 1
	,	@Year int = 2013

AS

BEGIN
	SET NOCOUNT ON;
	DECLARE	@strQueryTempAllColumns nvarchar(max);
	DECLARE	@strQueryTempColumn nvarchar(max);
	DECLARE	@QuarterOrMonth int;
	DECLARE	@QueryYear int;
	DECLARE	@tempColumn nvarchar(max);
	DECLARE	@tempAllColumn nvarchar(max);

	SET	@strQueryTempAllColumns = '
		SELECT	C.CustomerName
			,	<DYNAMIC_Y_Q_M>
		FROM	Sales.Customers	AS C
		ORDER BY C.CustomerName	';

	IF	@Choice = 1
		BEGIN
			SET	@tempColumn = '';

			SET	@strQueryTempColumn = '
				COALESCE((
					SELECT	SUM(IL.Quantity * IL.UnitPrice)
					FROM	Sales.InvoiceLines	AS IL
						,	Sales.Invoices		AS I
					WHERE	IL.InvoiceID = I.InvoiceID
						AND	DATEPART(YEAR, I.InvoiceDate) = <aYear>
						AND	DATEPART(MONTH, I.InvoiceDate) = <nbrQuarterOrMonth>
						AND	I.CustomerID = C.CustomerID
				) , 0) AS Sales_<aYear>M<nbrQuarterOrMonth>	';

			DECLARE	YearOrQuarterOrMonthCursor	CURSOR FOR	
				SELECT DISTINCT	MONTH(InvoiceDate)	FROM	Sales.Invoices	WHERE	YEAR(InvoiceDate) = @Year;
			OPEN	YearOrQuarterOrMonthCursor;
			FETCH NEXT	FROM YearOrQuarterOrMonthCursor	INTO @QuarterOrMonth;

			WHILE	@@FETCH_STATUS = 0
				BEGIN
					SET	@tempColumn = @tempColumn + REPLACE(@strQueryTempColumn, '<aYear>', @Year);
					SET	@tempColumn = REPLACE(@tempColumn, '<nbrQuarterOrMonth>', @QuarterOrMonth);

					FETCH NEXT	FROM YearOrQuarterOrMonthCursor	INTO @QuarterOrMonth;

					IF	@@FETCH_STATUS = 0
						BEGIN
							SET	@tempColumn = @tempColumn + ' , ';
						END;
				END;

			CLOSE	YearOrQuarterOrMonthCursor;
			DEALLOCATE	YearOrQuarterOrMonthCursor;

			SET	@tempAllColumn =  REPLACE(@strQueryTempAllColumns, '<DYNAMIC_Y_Q_M>', @tempColumn);
		END;

		IF	@Choice = 2
		BEGIN
			SET	@tempColumn = '';

			SET	@strQueryTempColumn = '
				COALESCE((
					SELECT	SUM(IL.Quantity * IL.UnitPrice)
					FROM	Sales.InvoiceLines	AS IL
						,	Sales.Invoices		AS I
					WHERE	IL.InvoiceID = I.InvoiceID
						AND	DATEPART(YEAR, I.InvoiceDate) = <aYear>
						AND	DATEPART(QUARTER, I.InvoiceDate) = <nbrQuarterOrMonth>
						AND	I.CustomerID = C.CustomerID
				) , 0) AS Sales_<aYear>Q<nbrQuarterOrMonth>	';

			DECLARE	YearOrQuarterOrMonthCursor	CURSOR FOR	
				SELECT DISTINCT	DATEPART(QUARTER, InvoiceDate)	FROM	Sales.Invoices	WHERE	YEAR(InvoiceDate) = @Year;
			OPEN	YearOrQuarterOrMonthCursor;
			FETCH NEXT	FROM YearOrQuarterOrMonthCursor	INTO @QuarterOrMonth;

			WHILE	@@FETCH_STATUS = 0
				BEGIN
					SET	@tempColumn = @tempColumn + REPLACE(@strQueryTempColumn, '<aYear>', @Year);
					SET	@tempColumn = REPLACE(@tempColumn, '<nbrQuarterOrMonth>', @QuarterOrMonth);

					FETCH NEXT	FROM YearOrQuarterOrMonthCursor	INTO @QuarterOrMonth;

					IF	@@FETCH_STATUS = 0
						BEGIN
							SET	@tempColumn = @tempColumn + ' , ';
						END;
				END;

			CLOSE	YearOrQuarterOrMonthCursor;
			DEALLOCATE	YearOrQuarterOrMonthCursor;

			SET	@tempAllColumn =  REPLACE(@strQueryTempAllColumns, '<DYNAMIC_Y_Q_M>', @tempColumn);
		END;

		IF	@Choice = 3
		BEGIN
			SET	@tempColumn = '';

			SET	@strQueryTempColumn = '
				COALESCE((
					SELECT	SUM(IL.Quantity * IL.UnitPrice)
					FROM	Sales.InvoiceLines	AS IL
						,	Sales.Invoices		AS I
					WHERE	IL.InvoiceID = I.InvoiceID
						AND	DATEPART(YEAR, I.InvoiceDate) = <aYear>
						AND	I.CustomerID = C.CustomerID
				) , 0) AS Sales_<aYear>	';

			DECLARE	YearOrQuarterOrMonthCursor	CURSOR FOR	
				SELECT DISTINCT	DATEPART(YEAR, InvoiceDate)	FROM	Sales.Invoices;
			OPEN	YearOrQuarterOrMonthCursor;
			FETCH NEXT	FROM YearOrQuarterOrMonthCursor	INTO @QueryYear;

			WHILE	@@FETCH_STATUS = 0
				BEGIN
					SET	@Year = @QueryYear;
					SET	@tempColumn = @tempColumn + REPLACE(@strQueryTempColumn, '<aYear>', @Year);

					FETCH NEXT	FROM YearOrQuarterOrMonthCursor	INTO @QueryYear;

					IF	@@FETCH_STATUS = 0
						BEGIN
							SET	@tempColumn = @tempColumn + ' , ';
						END;
				END;

			CLOSE	YearOrQuarterOrMonthCursor;
			DEALLOCATE	YearOrQuarterOrMonthCursor;

			SET	@tempAllColumn =  REPLACE(@strQueryTempAllColumns, '<DYNAMIC_Y_Q_M>', @tempColumn);
		END;

	--SELECT @tempAllColumn;
	EXEC sp_executesql @tempAllColumn;
END
GO
			


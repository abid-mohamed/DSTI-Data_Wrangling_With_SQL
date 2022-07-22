
## Question 3 :
Using the database WideWorldImporters, write a T-SQL stored procedure called ReportCustomerTurnover. <br />
This procedure takes two parameters: Choice and Year, both integers. 

When Choice = 1 and Year = <aYear>, ReportCustomerTurnover selects all the customer names and their total monthly turnover (invoiced value) for the year <aYear>. 

When Choice = 2 and Year = <aYear>, ReportCustomerTurnover selects all the customer names and their total quarterly (3 months) turnover (invoiced value) for the year <aYear>. 

When Choice = 3, the value of Year is ignored and ReportCustomerTurnover selects all the customer names and their total yearly turnover (invoiced value). 

When no value is provided for the parameter Choice, the default value of Choice must be 1. <br />
When no value is provided for the parameter Year, the default value is 2013. This doesn't impact Choice = 3. 

For Choice = 3, the years can be hard-coded within the range of [2013-2016]. 

NULL values in the resultsets are not acceptable and must be substituted to 0. 

All output resultsets are ordered by customer names alphabetically. 

Example datasets are provided for the following calls: <br />
EXEC dbo.ReportCustomerTurnover; <br />
EXEC dbo.ReportCustomerTurnover 1, 2014; <br />
EXEC dbo.ReportCustomerTurnover 2, 2015; <br />
EXEC dbo.ReportCustomerTurnover 3; <br />
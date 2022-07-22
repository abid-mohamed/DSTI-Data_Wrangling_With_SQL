## Question 1 :
Using the database WideWorldImporters, write a SQL query which reports the consistency between orders and their attached invoices. 
The resultset should report for each (CustomerID, CustomerName) 

a. the total number of orders: TotalNBOrders 
b. the number of invoices converted from an order: TotalNBInvoices 
c. the total value of orders: OrdersTotalValue 
d. the total value of invoices: InvoicesTotalValue 
f. the absolute value of the dixerence between c - d: AbsoluteValueDixerence 

The resultset must be sorted by highest values of AbsoluteValueDixerence, then by smallest to highest values of TotalNBOrders and CustomerName is that order. 

Please note that all values in a & b must be identical by definition of the query, as we are observing orders converted into invoices. 
We are looking for potential dixerences between c & d. 
BUT, you must {nd them consistent as the data is clean in WideWorldImporters. 
Resultset enclosed in Q1-Resultset_Corrected.csv

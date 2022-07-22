
## Question 2 :
For the CustomerId = 1060 (CustomerName = 'Anand Mudaliyar') <br />
Identify the {rst InvoiceLine of his {rst Invoice, where "{rst" means the lowest respective IDs, and write an update query increasing the UnitPrice of this InvoiceLine by 20. <br />
A re-run of the query in Q1 gives the resultset in Q2-Resultset_Corrected.csv (corrected on 15th April 2018 - Summed values in columns OrdersTotalValue & InvoicesTotalValue were incorrect) . 

If you haven't managed to answer Q1, add the following selection query to the previous update query: CustomerId, CustomerName, InvoiceTotal. The latter is the sum of all invoice lines for the target invoice. <br />
The target InvoiceID is purposefully not shown, but the resultset post-update is given in Q2-Alternative- Resultset.csv <br />
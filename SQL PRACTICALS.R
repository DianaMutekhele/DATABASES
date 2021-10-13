###############################################################################
################## SQL Practicals################### ##########################
###############################################################################
install.packages(c('DBI','RSQLite'))

#Load the required libraries
library(DBI)
library(RSQLite)

#################################################################
# Initializing an RSQLite database connection
con <- dbConnect(RSQLite::SQLite(), dbname = "test1.sqlite")
dbListTables(con)
#Read at least 3 csv files into  R 

dbRemoveTable(con, "Athletes") 
dbExistsTable(con, "Athletes")


Athletes<- read.csv('Athletes.csv')
View(Athletes)

Medals_csv<- read.csv('Medals.csv')
View(Medals_csv)

Teams_csv<- read.csv('Teams.csv')
View(Teams_csv)

Athletes_csv<- write.csv('Athletes.csv')
write.csv('Athletes.csv')

#Create a connection to a database
con <- dbConnect(RSQLite::SQLite(), dbname = "test1.sqlite")
dbListTables(con)

#Insert tables into the created database
dbExistsTable(con, "Athletes")


dbWriteTable(con, "Athletes_csv", Athletes_csv, row.names = FALSE, overwrite = TRUE, append = FALSE )
dbWriteTable(con, "Teams_csv", Teams_csv, row.names = FALSE, overwrite = TRUE, append = FALSE )
dbWriteTable(con, "Medals_csv", Medals_csv, row.names = FALSE, overwrite = TRUE, append = FALSE )

#Read data from the database tables into R

Athletes_csv = dbReadTable(con, "Athletes_csv")
Teams_csv = dbReadTable(con, 'Teams_csv')
Medals_csv = dbReadTable(con, "Medals_csv")


#Perform SELECT operations on the database tables.

dbGetQuery(con, "SELECT * FROM Athletes_csv")
dbGetQuery(con, "SELECT * FROM Teams_csv")
dbGetQuery(con, "SELECT * FROM Medals_csv")

dbGetQuery(con, 'SELECT * FROM  Athletes_csv LIMIT 10')
dbGetQuery(con, 'SELECT  Discipline FROM Athletes_csv LIMIT 3')

dbGetQuery(con, 'SELECT * FROM Medals_csv WHERE "Bronze" > 10')

###############################################################################
################## Huru School SQL Database Exercise ##########################
###############################################################################
#Install the libraries
install.packages(c('DBI','RSQLite'))
#If you are using other database types, you may need to install them e.g
#install.packages(c('RMySQL','RPostgresQL','ROracle'))
#install.packages('devtools')
#devtools::install_github('imanuelcostigan/RSQLServer')

#Load the required libraries
library(DBI)
library(RSQLite)

#################################################################
# Initializing an RSQLite database connection
con <- dbConnect(RSQLite::SQLite(), dbname = "test.sqlite")
dbListTables(con)

##################################################################
# Creating tables in the database

#a)Using dbCreateTable
#Let's prepare mtcars & USArrests for analysis

mtcars = cbind(data.frame(model = row.names(mtcars)), mtcars)
row.names(mtcars) <- 1:nrow(mtcars)
View(mtcars)

USArrests = cbind(data.frame(state = row.names(USArrests)), USArrests)
row.names(USArrests) <- 1:nrow(USArrests)
View(USArrests)

dbCreateTable(con, "mtcars",mtcars)
dbCreateTable(con, "iris",iris)
dbCreateTable(con, "USArrests",USArrests)d

#b) Using dbWriteTable (Writes, overwrites or appends a data frame to a database table)
data(mtcars)
dbWriteTable(con, "mtcars", mtcars, row.names = FALSE, overwrite = TRUE, append = FALSE )
dbWriteTable(con, "iris", iris, row.names = FALSE, overwrite = TRUE, append = FALSE )
dbWriteTable(con, "usarrests", USArrests, row.names = FALSE, overwrite = TRUE, append = FALSE )

dbListTables(con)

#List the fields/columns of the tables
dbListFields(con, "mtcars")
dbListFields(con, "iris")
dbListFields(con,"usarrests")

# Reading data from a database table
#a) using the DBI function 'dbReadTable'

mtcars = dbReadTable(con, "mtcars")
iris = dbReadTable(con, 'iris')
USArrests = dbReadTable(con, "usarrests")

#b) Using verb 'SELECT' and 'LIMIT'
dbGetQuery(con, "SELECT * FROM mtcars")
dbGetQuery(con, 'SELECT * FROM mtcars LIMIT 5')
dbGetQuery(con, 'SELECT * FROM iris LIMIT 2')
dbGetQuery(con, 'SELECT * FROM  usarrests LIMIT 10')


# Selecting specific columns

dbGetQuery(con, 'SELECT model,mpg,hp,drat FROM mtcars LIMIT 3')
dbGetQuery(con, 'SELECT state FROM usarrests LIMIT 2')

#Select from database cars with more than 4 cylinders - filtering columns

dbGetQuery(con, 'SELECT * FROM mtcars WHERE "cyl" > 4')
dbGetQuery(con, 'SELECT * FROM usarrests WHERE "Murder" > 10')

# Write to tables
students = data.frame(name = c("Todani","Farhiya","Kudzai","Ebuka"),
                      country = c("South Africa", "Kenya", "Zimbabwe","Nigeria"))
dbWriteTable(con,"students", students)
dbExecute(con,
          "INSERT INTO students (name, country) VALUES ('Michael', 'Tanzania'), ('Jean', 'Rwanda');")
dbReadTable(con, "students")   # there are now 6 rows

# Update tables

dbExecute(
  con,
  "INSERT INTO students (name, country) VALUES (?, ?)",
  params = list(c("Agbenya","Josephine","Raleche"), c("Nigeria","Kenya", "Mozambiqque")) # Here we pass values using the param argument:
)
dbReadTable(con, "students")   # there are now 9 rows

#Update table on condition
dbExecute(con,
"UPDATE students
SET country = 'Mozambique'
WHERE country = 'Mozambiqque'")

dbReadTable(con,'students')

#Wild cards
#This are used to query data on specific patterns, used in conjuction with LIKE operator

dbGetQuery(con, "SELECT * FROM students WHERE country LIKE 'K%'")#country starts with letter K
dbGetQuery(con, "SELECT * FROM students WHERE country LIKE '%a'")#country ends in letter a
dbGetQuery(con, "SELECT * FROM students WHERE country LIKE '%ri%'")#country that has pattern 'ri' anywhere
# Deleting tables

dbExistsTable(con, "students") #check if it exists
dbRemoveTable(con, "students") #delete it
dbExistsTable(con, "students") #check again if it exists



Sys.setenv(PGGSSENCMODE="disable")


con <- dbConnect(RPostgres::Postgres(), dbname = 'bitdotio', 
                 host = 'db.bit.io',
                 port = 5432,
                 user = 'bitdotio',
                 password = rstudioapi::askForPassword('Database Password'))

# Construct the update query by looping over the data fields
query <- 'INSERT INTO "nouraazeem/baking_recipes"."ingredients_needed" 
  (recipe_name, amount_1, ingredient_1, amount_2, ingredient_2, amount_3, ingredient_3, 
  amount_4, ingredient_4, amount_5, ingredient_5, amount_6, ingredient_6, amount_7,
  ingredient_7) VALUES (1,2,3,1,1,1,1,1,1,1,1,1,1,1,1)'

ex <- dbGetQuery(con, query)

#("Palestinian Knafe","1 Package", "Shredded Phyllo Dough", "16 ounces", 
 #"Fresh Mozzarella Slices", "1/2 - 1 Cup", "Ricotta Cheese", "2 Sticks", "Butter", "1 Cup",
 #"Sugar", "1", "Lemon") 

query <- 'SELECT * FROM "nouraazeem/baking_recipes"."ingredients_needed"'






saveData <- function(data) {
  # Connect to the database
  db <- dbConnect(MySQL(), dbname = databaseName, host = options()$mysql$host, 
                  port = options()$mysql$port, user = options()$mysql$user, 
                  password = options()$mysql$password)
  # Construct the update query by looping over the data fields
  query <- sprintf(
    "INSERT INTO %s (%s) VALUES ('%s')",
    table, 
    paste(names(data), collapse = ", "),
    paste(data, collapse = "', '")
  )
  # Submit the update query and disconnect
  dbGetQuery(db, query)
  dbDisconnect(db)
}

load_data_mysql <- function() {
  db <- dbConnect(MySQL(), dbname = DB_NAME, host = options()$mysql$host, 
                  port = options()$mysql$port, user = options()$mysql$user, 
                  password = options()$mysql$password)
  query <- sprintf("SELECT * FROM %s", TABLE_NAME)
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  data
}

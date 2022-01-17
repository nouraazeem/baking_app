save_data_mysql <- function(data) {
  db <- dbConnect(MySQL(), dbname = "bitdotio", host = "db.bit.io", 
                  port = 5432, user = "nouraazeem_demo_db_connection", 
                  password = "auwT_GGE2VKYG7LhBkj63XbK6wEU"
  query <- sprintf("INSERT INTO %s (%s) VALUES ('%s')", TABLE_NAME, 
                   paste(names(data), collapse = ", "), paste(data, collapse = "', '"))
  dbGetQuery(db, query)
  dbDisconnect(db)
}
######





options(mysql = list(
  "host" = "db.bit.io",
  "port" = 5432,
  "user" = "nouraazeem_demo_db_connection",
  "password" = "auwT_GGE2VKYG7LhBkj63XbK6wEU"
))
databaseName <- "bitdotio"
table <- "ingredients_needed"

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
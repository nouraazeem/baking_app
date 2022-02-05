#' The global script is where we load in all of the libraries that we are going to use, create
#' template/shell dataframes that we can use to initalitize our dataframes (but then fill in with
#' actual data later). The script also connects to the database and pulls in the current recipes
#' to be ready when the user loads up the baking app.
#' 
#'
#' @submitter_details template/shell dataframe that holds the recipe submitter's name (recipe_submitter),
#' recipe_name(name of the recipe), recipe_type (type of recipe such as cake, cake pop, etc.), 
#' sweetie_scale (the level of sweetness that the recipe is), servings_total (the total amount of people
#' the recipe fits)
#' @ingredients_df template/shell dataframe that holds the recipe's ingredients + the amounts of the ingredients
#' that are needed to make the submitted recipe
#' @step_details template/shell dataframe that holds the recipe's step number + step details that details the 
#' instructions for how to make the recipe
#' @ingredients_table this table is loaded from the db and will pull out any recipes (recipe_submitter, ingredient,
#' recipe_name, current_date_bake, recipe_type, sweetie_scale, servings_total)
#' @steps_table this table is loaded from the db and will pull out the recipe's info to make the recipe
#' (recipe_name, recipe_submitter, step_number, recipe_step_details, current_date_bake, recipe_type)
#' @recipe_submitter_names this is the recipe submitter's information for each recipe and does some basic data
#' cleaning to ensure that data matches formats throughout the app

# load in libraries needed to run the app. If you are trying to run this you may have to first install the
# packages locally by using install.packages("package_name_here")----
require(DBI)
require(dbplyr)
require(dplyr)
require(bslib)
require(DT)
require(formattable)
require(ggplot2)
require(odbc)
require(plotly)
require(rhandsontable)
require(rmarkdown)
require(RMySQL)
require(RPostgres)
require(rstudioapi)
require(shiny)
require(shinydashboard)
require(shinyjs)
require(shinyWidgets)
require(stringr)

############## CREATE TEMPLATE/SHELL DATAFRAMES ----
# The name of the recipe submitter
recipe_submitter = "Enter your name"
# The name of the recipe
recipe_name = "Enter recipe name"
# The type of recipe (cake, cake pop, pie, etc.)
recipe_type = "Select recipe type"
# The level of sweetness of the dessert
sweetie_scale = "Select sweetness"
# The time to make the dessert in minutes
servings_total = "How many servings?"
# Date recipe was submitted
current_date = Sys.Date()

# Take all of the aforementioned columns and create a dataframe
submitter_details = data.frame(
  recipe_submitter = recipe_submitter,
  recipe_name = recipe_name,
  recipe_type = recipe_type,
  sweetie_scale = sweetie_scale,
  servings_total = servings_total,
  current_date =
    current_date,
  stringsAsFactors = FALSE
)

# Create another template/shell dataframe for the Submit New Recipe tab
# This dataframe will be loaded into that tab to allow for users to
# overwrite the data with their actual recipe
Amount = c("1 cup", "2 cups", "1 package", "2 tbspns", "1 stick",
           "1 tspn")
# Enter the name of the ingredient needed
Ingredient = c("Sugar",
               "Flour",
               "Almonds",
               "Vanilla Extract",
               "Butter",
               "Cinnamon")
# Create a dataframe with the two columns
ingredients_df = data.frame(Amount = Amount,
                            Ingredient = Ingredient,
                            stringsAsFactors = FALSE)

# Create a template dataframe for the Submit New Recipe tab. This
# dataframe will hold the steps needed to be taken to create the recipe

# Step number from 1:5
step_number = 1:5
# Template Recipe Steps to be overwritten
recipe_step_details = c(
  "Mix all the dry ingredients",
  "Mix all the wet ingredients",
  "Preheat the oven to 350",
  "Mix all ingredients",
  "Put into a greased pan and keep in oven until a toothpick comes out clean"
)
# Bind above columns into a template/shell that shows the Step Number + Step Details
# to make the recipe
step_details = data.frame(
  step_number = step_number,
  recipe_step_details = recipe_step_details,
  stringsAsFactors = FALSE
)


########## SOURCE MODULES USED THROUGHOUT APP  ----
# Sourcing these apps tells the app that these are the scripts
# that need to be loaded in for us to be able to access the code
# in the different modules

# Recipe Side Panel - this tab shows all the options a user can filter the recipes by
source('./modules/recipe_side_panel.R')

# Recipe Options - The tab that lists all of the recipes and the ingredients needed for recipe 
source('./modules/ingredients_needed.R')

# Submit New Recipe - This tab will allow users to add a new recipe 
source('./modules/submit_new_recipe.R')

###### CONNECT TO DB ----
Sys.setenv(PGGSSENCMODE = "disable")

# Connect to the db -- ask for password as a safety measure - may
# look into other ways to connect to the db
con <-
  dbConnect(
    RPostgres::Postgres(),
    dbname = 'bitdotio',
    host = 'db.bit.io',
    port = 5432,
    user = 'bitdotio',
    password = rstudioapi::askForPassword('Please Enter Password')
  )

##### Load in data ----
# Load in the table with all of the ingredients needed to make the recipe
ingredients_table <-
  '"nouraazeem/baking_recipes"."ingredients_needed"'
ins_query <- sprintf("SELECT * FROM %s", ingredients_table)
ingredients_data <- dbGetQuery(con, ins_query)

# Load in the steps needed to make a recipe
steps_table <-
  '"nouraazeem/baking_recipes"."steps_needed"'
steps_query <- sprintf("SELECT * FROM %s", steps_table)
steps_data <- dbGetQuery(con, steps_query)

# People to select from -- a little data cleaning so the data matches throughout the app
recipe_submitter_names <- ingredients_data %>%
  dplyr::select(recipe_submitter) %>%
  dplyr::mutate(recipe_submitter = stringr::str_to_title(gsub("_", " ", recipe_submitter))) %>%
  dplyr::rename(`Recipe Submitter` = recipe_submitter) %>%
  add_row(`Recipe Submitter` = "All") %>%
  unique()

# convert to a string
recipe_submitter_names <- as.vector(recipe_submitter_names)

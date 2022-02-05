# Scratch

# ingredients data frame
# primary key -> recipe name

# cheese


# recipe data frame
# primary key -> recipe name




# story data frame
# primary key -> recipe name

### Building a web application all things baking. Probably should have scoped this out before starting,
# but alas, here we are!

# load in libraries ----
require(dplyr)
require(shiny)
require(ggplot2)
# get shiny, DBI, dplyr and dbplyr from CRAN
require(DBI)
require(dplyr)
require(dbplyr)
require(RMySQL)
require(odbc)
#install.packages("RPostgres")
require(RPostgres)
require(ggplot2)
require(rstudioapi)
require(rhandsontable)
require(stringr)
require(DT)
require(bslib)
require(rmarkdown)
require(formattable)
require(shinydashboard)
require(plotly)

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

# Create a template df for steps of the recipe

# Step number 1:5
step_number = 1:5
# Recipe Steps
recipe_step_details = c(
  "Mix all the dry ingredients",
  "Mix all the wet ingredients",
  "Preheat the oven to 350",
  "Mix all ingredients",
  "Put into a greased pan and keep in oven until a toothpick comes out clean"
)
# Bind above columns into a df
step_details = data.frame(
  step_number = step_number,
  recipe_step_details = recipe_step_details,
  stringsAsFactors = FALSE
)


# source different modules ----

# Recipe options - tab 1
source('./modules/recipe_side_panel.R')

# Ingredients needed for recipe - tab 2
source('./modules/ingredients_needed.R')

# Story behind recipe - tab 3
#source('recipe_story.R')

# This tab will allow users to add a new recipe
source('./modules/submit_new_recipe.R')

# Side Panel with inputs for picking a recipe - side panel
#source('recipe_side_panel.R')


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
    password = rstudioapi::askForPassword('Database Password')
  )


ingredients_table <-
  '"nouraazeem/baking_recipes"."ingredients_needed"'
ins_query <- sprintf("SELECT * FROM %s", ingredients_table)
ingredients_data <- dbGetQuery(con, ins_query)

steps_table <-
  '"nouraazeem/baking_recipes"."steps_needed"'
steps_query <- sprintf("SELECT * FROM %s", steps_table)
steps_data <- dbGetQuery(con, steps_query)

# People to select from
recipe_submitter_names <- ingredients_data %>%
  dplyr::select(recipe_submitter) %>%
  dplyr::mutate(recipe_submitter = stringr::str_to_title(gsub("_", " ", recipe_submitter))) %>%
  dplyr::rename(`Recipe Submitter` = recipe_submitter) %>%
  add_row(`Recipe Submitter` = "All") %>%
  unique()

# convert to a string
recipe_submitter_names <- as.vector(recipe_submitter_names)

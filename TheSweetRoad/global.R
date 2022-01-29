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
# install.packages("bslib")
# install.packages("rmarkdown")
# install.packages("formattable")
#install.packages("DT")

require(DT)
require(bslib)
require(rmarkdown)
require(formattable)

# The name of the recipe submitter
recipe_submitter = "Enter your name"
# The name of the recipe
recipe_name = "Enter recipe name"
# The type of recipe (cake, cake pop, pie, etc.)
recipe_type = "Select recipe type"
# The level of sweetness of the dessert
sweetness_scale = "Select sweetness" 
# The time to make the dessert in minutes
servings_total = "How many servings?"
# Date recipe was submitted
current_date = Sys.Date()

# Take all of the aforementioned columns and create a dataframe
submitter_details = data.frame(recipe_submitter = recipe_submitter,
                               recipe_name = recipe_name, recipe_type = recipe_type,
                               sweetness_scale = sweetness_scale, 
                               servings_total = servings_total, current_date = 
                                 current_date, stringsAsFactors = FALSE)


# source different modules ----

# Recipe options - tab 1 
source('./modules/recipe_side_panel.R')

# Ingredients needed for recipe - tab 2
#source('ingredients_needed.R')

# Story behind recipe - tab 3
#source('recipe_story.R')
 
# This tab will allow users to add a new recipe
source('./modules/submit_new_recipe.R')

# Side Panel with inputs for picking a recipe - side panel
#source('recipe_side_panel.R')




















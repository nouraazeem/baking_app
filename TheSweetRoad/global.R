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


# source different modules ----

# Recipe options - tab 1 
source('./modules/recipe_options.R')

# Ingredients needed for recipe - tab 2
#source('ingredients_needed.R')

# Story behind recipe - tab 3
#source('recipe_story.R')
 
# This tab will allow users to add a new recipe
source('./modules/submit_new_recipe.R')

# Side Panel with inputs for picking a recipe - side panel
#source('recipe_side_panel.R')



















